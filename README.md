# platforms-bot-slack-notify-action

An opinionated Github action that tells platforms-bot a specific action in the pipeline has occured, and that it should notify Slack, by creating a new message or updating an existing one.

## Usage

```yaml
jobs:
  deploy_staging:
    runs-on: ubuntu-latest
    env:
      APP_ENDPOINT: "https://argocd.storyblocks.io/applications/staging-my-service"
      SLACK_CHANNEL_ID: "my-channel"
      SLACK_CHANNEL_NAME: "C025JQVK5CP"
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Expose git commit data
        uses: rlespinasse/git-commit-data-action@v1.x

      - name: Notify slack
        id: notify_slack
        uses: Footage-Firm/platforms-bot-slack-notify-action@1.0.0
        with:
          action: "init"
          repo_name: "${{ github.repository }}"
          commit_sha: "${{ github.sha }}"
          commit_message: "${{ env.GIT_COMMIT_MESSAGE_SUBJECT }}"
          commit_author: "${{ env.GIT_COMMIT_AUTHOR_NAME }}"
          channel: "${{ env.SLACK_CHANNEL_NAME }}"
          platforms_bot_token: "${{ secrets.PLATFORMS_BOT_AUTH_TOKEN }}"

      - name: Deploy to staging
        run: |
          Do your deploy

      - name: Notify slack
        uses: Footage-Firm/platforms-bot-slack-notify-action@1.0.0
        with:
          action: "deploy_to_staging"
          slack_ts: "${{ steps.notify_slack.outputs.slack_ts }}"
          app_endpoint: "${{ env.APP_ENDPOINT }}"
          repo_name: "${{ github.repository }}"
          commit_sha: "${{ github.sha }}"
          commit_message: "${{ env.GIT_COMMIT_MESSAGE_SUBJECT }}"
          commit_author: "${{ env.GIT_COMMIT_AUTHOR_NAME }}"
          channel: "${{ env.SLACK_CHANNEL_NAME }}"
          platforms_bot_token: "${{ secrets.PLATFORMS_BOT_AUTH_TOKEN }}"
```
