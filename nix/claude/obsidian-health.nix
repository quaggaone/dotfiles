{ pkgs, cert, url, tokenPath }:

# Run with: nix run .#obsidian-connector-health
#
# Not on PATH and not wired into activation. The failure this exists for is
# silent: if the plugin regenerates its CA, activation still succeeds and the
# config still looks correct, so nix reports success while the connector is
# dead. Only a check that tests certificate, token and endpoint together
# catches that.
pkgs.writeShellApplication {
  name = "obsidian-connector-health";
  runtimeInputs = with pkgs; [ coreutils curl openssl jq ];
  text = ''
    fail=0
    note() { printf '%-28s %s\n' "$1" "$2"; }

    if [ ! -r ${tokenPath} ]; then
      note "token" "MISSING at ${tokenPath}"
      note "" "sops-nix did not decrypt; run darwin-rebuild switch"
      exit 1
    fi
    token=$(tr -d '\n' < ${tokenPath})
    note "token" "present (''${#token} bytes)"

    if ! served=$(openssl s_client -connect 127.0.0.1:27124 </dev/null 2>/dev/null | openssl x509 -noout -fingerprint -sha256 2>/dev/null); then
      note "endpoint" "UNREACHABLE on 127.0.0.1:27124"
      note "" "is Obsidian running with the Local REST API plugin enabled?"
      exit 1
    fi

    pinned=$(openssl x509 -in ${cert} -noout -fingerprint -sha256)
    if [ "$served" = "$pinned" ]; then
      note "certificate" "matches pinned CA"
    else
      note "certificate" "MISMATCH"
      note "" "the plugin regenerated its CA; re-extract it into the repo:"
      note "" "  nix/obsidian/local-api-ca.pem"
      fail=1
    fi

    if openssl x509 -in ${cert} -noout -checkend $((30 * 86400)) >/dev/null; then
      note "expiry" "more than 30 days out ($(openssl x509 -in ${cert} -noout -enddate | cut -d= -f2))"
    else
      note "expiry" "EXPIRES WITHIN 30 DAYS ($(openssl x509 -in ${cert} -noout -enddate | cut -d= -f2))"
      fail=1
    fi

    code=$(curl -s -o /dev/null -w '%{http_code}' --cacert ${cert} --max-time 5 \
      -X POST ${url} \
      -H "Authorization: Bearer $token" \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json, text/event-stream' \
      -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"obsidian-connector-health","version":"1"}}}') || code=000

    case "$code" in
      200) note "mcp handshake" "ok (200)" ;;
      401) note "mcp handshake" "UNAUTHORIZED (401)"
           note "" "the sops token no longer matches the plugin's API key"
           fail=1 ;;
      000) note "mcp handshake" "TLS or connection failure"
           note "" "cert validated above, so this is likely the endpoint itself"
           fail=1 ;;
      *)   note "mcp handshake" "unexpected HTTP $code"; fail=1 ;;
    esac

    if [ "$fail" -eq 0 ]; then
      note "result" "healthy"
    else
      note "result" "PROBLEMS FOUND"
    fi
    exit "$fail"
  '';
}
