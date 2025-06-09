#!/bin/bash

# markdown tables
curl --output $HOME/Library/Containers/app.cyan.markedit/Data/Documents/scripts/markedit-mte.js https://raw.githubusercontent.com/MarkEdit-app/MarkEdit-mte/refs/heads/main/dist/markedit-mte.js

# preview pane
curl --output $HOME/Library/Containers/app.cyan.markedit/Data/Documents/scripts/markedit-preview.js https://raw.githubusercontent.com/MarkEdit-app/MarkEdit-preview/refs/heads/main/dist/markedit-preview.js

# add markdown highlighting (mark html tag)
curl --output $HOME/Library/Containers/app.cyan.markedit/Data/Documents/scripts/markedit-highlight.js https://raw.githubusercontent.com/MarkEdit-app/MarkEdit-highlight/refs/heads/main/dist/markedit-highlight.js

