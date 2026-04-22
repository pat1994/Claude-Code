import base64, json, urllib.request, urllib.error

import os
TOKEN = os.environ.get("GITHUB_TOKEN", "")
REPO = "pat1994/pat1994.github.io"
FILE = "/home/user/Claude-Code/Patrick_Schueller_Resume.pdf"
REMOTE_PATH = "Patrick_Schueller_Resume.pdf"
API = f"https://api.github.com/repos/{REPO}/contents/{REMOTE_PATH}"

with open(FILE, "rb") as f:
    content = base64.b64encode(f.read()).decode()

headers = {"Authorization": f"token {TOKEN}", "Content-Type": "application/json"}

# Check for existing file SHA
req = urllib.request.Request(API, headers=headers)
try:
    with urllib.request.urlopen(req) as r:
        sha = json.loads(r.read()).get("sha", "")
except urllib.error.HTTPError:
    sha = ""

payload = {"message": "Add resume PDF for download", "content": content}
if sha:
    payload["sha"] = sha

req = urllib.request.Request(API, data=json.dumps(payload).encode(), headers=headers, method="PUT")
try:
    with urllib.request.urlopen(req) as r:
        result = json.loads(r.read())
        print("Success:", result["commit"]["html_url"])
except urllib.error.HTTPError as e:
    print("Error:", e.read().decode())
