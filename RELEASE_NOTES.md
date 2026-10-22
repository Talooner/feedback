# Talooner v1.0.0

Talooner is a review step in your CI pipeline. On every pull request (GitHub) or merge
request (GitLab), it applies the rules in `.talooner/rules.tln` from the base branch and
approves, blocks, or asks for a human. With a model configured, it also reviews changed code
against your docs.

## GitHub

Talooner now reviews every new pull request when it is opened, without anyone commenting.
Draft pull requests are skipped until they are marked ready for review. `!talooner /stop`
still opts a pull request out.

Update your workflow in two places.
[`examples/ci/github-actions.yml`](examples/ci/github-actions.yml) has both.

1. Add `ready_for_review` and `closed` to the `pull_request` event types:

   ```yaml
   on:
     pull_request:
       types: [opened, synchronize, reopened, ready_for_review, closed]
   ```

   With `ready_for_review`, a draft pull request is reviewed when it is marked ready.

2. Add this line to the Talooner step's `env:`:

   ```yaml
           TALOONER_CHECK_RUN_ID: ${{ job.check_run_id }}
   ```

   Without it, Talooner counts its own job as a pending required check, and the base rule on
   pending checks blocks the review. `job.check_run_id` is available on GitHub.com, not on
   GitHub Enterprise Server.

## GitLab

Every merge request is reviewed on its pipeline, drafts included. Marking a merge request
ready starts no pipeline, so drafts are not skipped on GitLab.

## Base rules always apply

The strict base rules (`talooner.tln`) now apply whether or not `.talooner/rules.tln` imports
them. Existing imports keep working.

## AI review not in your plan

If a model is configured but your license plan has no AI review, the sticky comment shows an
`ai_review_unavailable` warning with an upgrade link. Before v1, the AI review was skipped
silently.

## Not in v1

- `onboard` is removed. Write `.talooner/rules.tln` yourself or start from
  [`examples/rulesets`](examples/rulesets).
- `!talooner /why`, `!talooner /plan` and `!talooner /review --force` are disabled. Talooner
  replies that the command is not available and posts the help.

## Image tags

- `ghcr.io/talooner/talooner-runner:1.0.0-rc.1` is the release candidate.
- At the final release, `:latest` and `:1` move to 1.0.0. Until now, `:latest` followed 0.x.
  If you use `:latest`, apply the workflow changes above before then.
- Pin `:1.0.0` for reproducible builds.
