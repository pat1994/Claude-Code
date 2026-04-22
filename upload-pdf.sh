#!/bin/bash
TOKEN="${GITHUB_TOKEN}"
REPO="pat1994/pat1994.github.io"
FILE="/home/user/Claude-Code/Patrick_Schueller_Resume.pdf"
REMOTE_PATH="Patrick_Schueller_Resume.pdf"

BASE64_PDF=$(base64 -w 0 "$FILE")

# Check if file already exists
SHA=$(curl -s -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/$REPO/contents/$REMOTE_PATH" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('sha',''))" 2>/dev/null)

if [ -n "$SHA" ]; then
  PAYLOAD=$(python3 -c "import json; print(json.dumps({'message':'Add resume PDF for download','content':'$BASE64_PDF','sha':'$SHA'}))")
else
  PAYLOAD=$(python3 -c "import json; print(json.dumps({'message':'Add resume PDF for download','content':'$BASE64_PDF'}))")
fi

curl -s -X PUT \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/repos/$REPO/contents/$REMOTE_PATH" \
  -d "$PAYLOAD" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('commit',{}).get('html_url','Error: '+str(d.get('message',d))))"
