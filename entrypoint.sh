#!/bin/sh -l

set -eu

action="${1?Must provide a valid action name}"
app_endpoint="${2?Must provide an application endpoint}"
commit_author="${3?Must provide a commit author}"
commit_message="${4?Must provide a commit message}"
commit_sha="${5?Must provide a commit sha}"
platforms_bot_token="${6?Must provide a commit sha}"
repo_name="${7?Must provide a repo name}"
argocd_app="${8?Must provide the argocd app name}"

channel="${9}"
slack_ts="${10}"

cat <<EOF >> /tmp/payload.json
{
  "repo_name": "$repo_name",
  "commit_sha": "$commit_sha",
  "commit_message": "`printf "%s" "$commit_message"`",
  "commit_author": "$commit_author",
  "channel": "$channel",
  "action": "$action",
  "argocd_app": "$argocd_app",
  "slack_ts": "$slack_ts",
  "app_endpoint": "$app_endpoint"
}
EOF
echo "Generated request"
cat /tmp/payload.json

TOKEN=$(echo $platforms_bot_token | tr -d \\n | base64)
SLACK_TS=$(curl -X POST https://platforms-bot.storyblocks.io/webhooks/github -H "Authorization: Bearer $TOKEN" --data "@/tmp/payload.json" | jq -r .ts)
echo slack ts ====== $SLACK_TS
echo "::set-output name=slack_ts::$SLACK_TS"
