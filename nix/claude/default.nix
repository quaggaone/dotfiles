{ config, lib, pkgs, username, ... }:

let
  obsidianCert = ../obsidian/local-api-ca.pem;
  obsidianUrl = "https://127.0.0.1:27124/mcp/";
  tokenPath = config.sops.secrets.obsidian-local-api-key.path;

  # One definition for both clients. Claude Desktop only validates stdio
  # entries, so it needs the bridge; Claude Code could speak HTTP natively
  # but has no per-entry way to trust the plugin's self-signed CA, and the
  # bridge's env block does. Same shape everywhere beats two mechanisms.
  #
  # Pinned to @latest by choice: upstream moves fast, so a connector that
  # breaks with no config change on this side is an upstream change.
  servers.obsidian = {
    command = "npx";
    args = [ "-y" "mcp-remote@latest" obsidianUrl "--transport" "http-only" "--header" "Authorization: Bearer @TOKEN@" ];
    env.NODE_EXTRA_CA_CERTS = "${obsidianCert}";
  };

  # Keys this module owns in mcpServers. Deleted before the declared set is
  # written back, so dropping a server here actually removes it from the
  # file; a plain merge could only ever add. mcp-obsidian is listed with no
  # definition on purpose: it is the dead shim being retired.
  managedKeys = [ "obsidian" "mcp-obsidian" ];

  mergeInto = file: servers: ''
    if [ ! -r ${lib.escapeShellArg tokenPath} ]; then
      echo "obsidian-mcp: token missing at ${tokenPath}; refusing to write ${file}" >&2
      exit 1
    fi

    if [ -e ${lib.escapeShellArg file} ]; then
      mode=$(${pkgs.coreutils}/bin/stat -c %a ${lib.escapeShellArg file})
    else
      mode=600
      ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname ${lib.escapeShellArg file})"
      echo '{}' > ${lib.escapeShellArg file}
    fi

    tmp=$(${pkgs.coreutils}/bin/mktemp)
    ${pkgs.jq}/bin/jq \
      --rawfile token ${lib.escapeShellArg tokenPath} \
      --argjson managed ${lib.escapeShellArg (builtins.toJSON managedKeys)} \
      --argjson servers ${lib.escapeShellArg (builtins.toJSON servers)} \
      '($token | rtrimstr("\n")) as $t
       | .mcpServers = ((.mcpServers // {}) | delpaths([$managed[] | [.]]))
       | .mcpServers += ($servers | walk(if type == "string" then gsub("@TOKEN@"; $t) else . end))' \
      ${lib.escapeShellArg file} > "$tmp"

    # Only install the rewrite if jq produced valid JSON. A truncated $tmp
    # moved into place would destroy state the apps keep in these files.
    if ! ${pkgs.jq}/bin/jq -e . "$tmp" >/dev/null 2>&1; then
      ${pkgs.coreutils}/bin/rm -f "$tmp"
      echo "obsidian-mcp: refusing to install invalid JSON over ${file}" >&2
      exit 1
    fi

    ${pkgs.coreutils}/bin/chmod "$mode" "$tmp"
    ${pkgs.coreutils}/bin/mv "$tmp" ${lib.escapeShellArg file}
  '';

  home = "/Users/${username}";
in
{
  home.activation.claudeMcpServers = lib.hm.dag.entryAfter [ "sops-nix" ] ''
    ${mergeInto "${home}/.claude.json" servers}
    ${mergeInto "${home}/Library/Application Support/Claude/claude_desktop_config.json" servers}
  '';
}
