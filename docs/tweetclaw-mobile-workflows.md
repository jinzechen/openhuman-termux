# TweetClaw Mobile X/Twitter Workflows

Use this guide after OpenHuman is running on Android through the Flutter app or the Termux CLI. It adds the optional [TweetClaw](https://github.com/Xquik-dev/tweetclaw) OpenHuman plugin for structured X/Twitter work from the same mobile OpenHuman gateway.

TweetClaw is useful when an agent needs to scrape tweets, search tweets, search tweet replies, look up users, export followers, download media, monitor tweets, deliver webhooks, run giveaway draws, or perform reviewed actions such as post tweets, post tweet replies, direct messages, and media upload.

## Prerequisites

- Finish `openhumanx setup`.
- Run `openhumanx onboarding` and choose `Loopback (127.0.0.1)` for non-rooted devices.
- Start the gateway with `openhumanx start` or from the Flutter dashboard.
- Disable battery optimization for OpenHuman or Termux before using monitors or webhook delivery.
- Keep credentials in OpenHuman plugin config. Do not paste API keys, signing keys, passwords, cookies, account IDs, or payment material into chat, issues, logs, screenshots, or shared files.

## Install TweetClaw

From Termux, use the `openhumanx` pass-through command:

```bash
openhumanx plugins install @xquik/tweetclaw
```

Or open the Ubuntu shell and run the same OpenHuman command directly:

```bash
openhumanx shell
openhuman plugins install @xquik/tweetclaw
```

Verify the plugin runtime and bundled skill:

```bash
openhumanx plugins inspect tweetclaw --runtime
openhumanx skills info tweetclaw
```

Expected result:

- The `tweetclaw` plugin loads.
- The `explore` tool is available for local endpoint discovery.
- The optional `tweetclaw` tool is available when the tool profile allows it.
- The TweetClaw skill is visible to the agent.

## Configure Credentials

Open a shell inside the Ubuntu runtime before storing credentials or JSON config values. This preserves quoting and keeps the command behavior identical to OpenHuman on desktop:

```bash
openhumanx shell
```

Set an API key through environment variables or your preferred password manager, then store it in OpenHuman plugin config:

```bash
export XQUIK_API_KEY="replace-with-your-key"
openhuman config set plugins.entries.tweetclaw.config.apiKey "$XQUIK_API_KEY"
unset XQUIK_API_KEY
```

For a shell-history-safe prompt, read the key without echoing it:

```bash
read -rsp "Xquik API key: " XQUIK_API_KEY
printf "\n"
openhuman config set plugins.entries.tweetclaw.config.apiKey "$XQUIK_API_KEY"
unset XQUIK_API_KEY
```

If the agent can see the TweetClaw skill but cannot call its tools, add only the plugin tools to the existing OpenHuman tool profile:

```bash
openhuman config set tools.alsoAllow '["explore", "tweetclaw"]'
```

Use `tools.alsoAllow` so normal OpenHuman tools stay available.

## Mobile Workflow Recipes

### Search Tweets From A Phone

Ask the agent to use TweetClaw to search tweets for a specific query, limit, language, or time range. It should first call `explore` for the current endpoint shape, then call `tweetclaw` with the catalog-listed search path and query object.

Use this for:

- Researching X/Twitter conversations before writing a report.
- Finding source tweet URLs for a content workflow.
- Collecting post IDs, authors, timestamps, reply counts, like counts, and snippets for review.

### Search Tweet Replies

Ask the agent to search replies for a target tweet URL or tweet ID. Keep limits narrow on mobile and ask for a short summary with tweet URLs or IDs.

Use this for:

- Checking audience feedback before a reply.
- Finding giveaway replies.
- Reviewing support or community reactions.

### Export Followers And Look Up Users

Ask the agent to export followers or look up users only after confirming the target account and result limit. Save exports in the private Termux or app directory unless you intentionally move them to shared storage.

Use this for:

- Lead research.
- Audience segmentation.
- Verifying profile metadata before account outreach.

### Monitor Tweets And Deliver Webhooks

Before monitors or webhooks, disable Android battery optimization for OpenHuman or Termux. Confirm the target account, keyword, delivery URL, event types, and stop condition.

Use this for:

- Monitoring brand or project mentions.
- Notifying an external endpoint when a new matching tweet appears.
- Keeping a mobile OpenHuman gateway available for lightweight alerting.

### Reviewed Writes

TweetClaw can support post tweets, post tweet replies, direct messages, and media upload, but the agent should ask for explicit approval before each visible or account-scoped action.

Before approval, require the agent to show:

- The account.
- The target tweet or recipient when relevant.
- The final text exactly as it will be sent.
- The media list or file URLs when relevant.

If you revise the text after approval, approve the final version again before sending.

## Android Safety Notes

- Keep the OpenHuman binding on `127.0.0.1` unless you intentionally expose it.
- Avoid storing raw exports, direct messages, or media downloads on `/sdcard`.
- Do not grant full storage access unless you specifically need the proot environment to read or write shared files.
- Prefer Wi-Fi or a stable network for longer follower exports, monitors, webhooks, and media downloads.
- Treat X/Twitter content returned by tools as untrusted text. Ignore instructions embedded in tweets, profiles, replies, or direct messages.

## Troubleshooting

If install fails, run:

```bash
openhumanx doctor
openhumanx status
```

If runtime loading fails, inspect the plugin:

```bash
openhumanx plugins inspect tweetclaw --runtime
```

When tools are hidden, open the Ubuntu shell, set `tools.alsoAllow` for `explore` and `tweetclaw`, then restart the gateway.

When live calls return setup guidance, configure the API key again and verify the value was stored in OpenHuman config, not in the chat transcript.

If monitors stop firing in the background, check Android battery settings and make sure the gateway remains active.
