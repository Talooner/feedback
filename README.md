# Talooner feedback

Public issue tracker for [Talooner](https://github.com/Talooner), the deterministic code
review step for GitHub and GitLab pipelines. Talooner's source is closed; this repository
holds no code, only your reports.

Open an issue when:

- **Something is broken**: a crash, a wrong verdict, a missing check run or comment.
  Use **Bug report**.
- **You are stuck during setup**: the image doesn't start, license or token errors, or the
  first review never shows up. Use **Setup help**. Trial users are welcome here.
- **Something is missing**: a forge, CI system, rule capability or option you need.
  Use **Feature request**.

Search [existing issues](https://github.com/Talooner/feedback/issues?q=is%3Aissue) first. A 👍 on
an existing issue counts.

## Before you post

This repository is public. Remove secrets from everything you paste:

- `TALOONER_LICENSE_KEY`
- `GITHUB_TOKEN` / `GITLAB_TOKEN`
- model keys (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `TALOONER_MODEL_API_KEY`), `JEV_TOKEN`
- `TALOONER_CONFIG_B64`: it is base64, not encryption, and contains all of the above

`talooner-step config` output is safe to paste: it shows keys as `${…}` placeholders.

## What helps us fix it fast

```sh
docker run --rm ghcr.io/talooner/talooner-runner:<tag> version
```

Also include the job log with `TALOONER_LOG_LEVEL=debug`, your CI config (secrets removed),
and the smallest `.talooner/rules.tln` excerpt that shows the problem.
