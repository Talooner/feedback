# Examples

Copy what you need into your repository. Every ruleset here ships with a test suite that
passes against the `ghcr.io/talooner/talooner-runner:latest` image.

## 1. Add the CI step

| CI | File | Put it in |
|---|---|---|
| GitHub Actions | [`ci/github-actions.yml`](ci/github-actions.yml) | `.github/workflows/talooner.yml` |
| GitLab CI | [`ci/gitlab-ci.yml`](ci/gitlab-ci.yml) | a job in `.gitlab-ci.yml` |
| Jenkins, CircleCI, Buildkite, Drone, TeamCity… | [`ci/generic-docker-run.sh`](ci/generic-docker-run.sh) | a pipeline step |

Secrets to set in your CI (masked):

- `TALOONER_LICENSE_KEY`: your trial or paid license key. Required.
- `GITLAB_TOKEN` (GitLab only): a project or group access token with the Developer role and
  `api` scope. GitHub Actions passes its own `github.token`.
- For AI review, choose one of these. Leave them all out for rules-only reviews.
  - `TALOONER_MODEL_BASE_URL` + `TALOONER_MODEL` + `TALOONER_MODEL_API_KEY`: any
    OpenAI-compatible endpoint (Qwen, DeepSeek, OpenRouter, a local model).
  - `ANTHROPIC_API_KEY`: the model defaults to `claude-sonnet-5-5`.
  - `OPENAI_API_KEY` + `TALOONER_MODEL`.

On GitHub, also enable **Settings → Actions → General → Allow GitHub Actions to create and
approve pull requests**. Without it, an approving rule cannot approve.

The generic script is written for GitLab. For GitHub repositories, set
`TALOONER_PROVIDER=github` and pass `GITHUB_TOKEN`, `GITHUB_REPOSITORY` and
`GITHUB_EVENT_NAME`, plus the event payload:
`-v "$EVENT:/event.json" -e GITHUB_EVENT_PATH=/event.json`.

Prefer one secret over many? Fill in [`ci/talooner.yaml`](ci/talooner.yaml), encode it, and
store the output as a masked `TALOONER_CONFIG_B64` variable:

```sh
docker run --rm -i ghcr.io/talooner/talooner-runner:latest encode-config - < talooner.yaml
```

Base64 is not encryption. Treat that value like the keys inside it.

## 2. Pick a ruleset

Copy a ruleset's `.talooner/` directory to the root of your repository. Talooner reads it from
the base branch, so a pull request cannot loosen the rules it is reviewed under.

| Ruleset | Needs a model | What it does |
|---|---|---|
| [`rulesets/starter`](rulesets/starter/.talooner) | no | Blocks PRs without a description, auto-approves small tested changes off the critical path, requires human review for critical paths, large PRs and new dependencies |
| [`rulesets/pr-hygiene`](rulesets/pr-hygiene/.talooner) | no | Blocks `do-not-merge` labels and failing tests, requires a maintainer for fork PRs, flags diffs too large to review in full |
| [`rulesets/llm-doc-review`](rulesets/llm-doc-review) | yes | Reviews changed services against their docs, with repository guidelines; asks a human when the model is unsure or the review fails |

To combine rulesets, append the rules and tests from one file to the other. Rule names must be
unique.

Notes:

- `starter` auto-approves only when `pr.tests_passing` is true. That fact comes from
  `.talooner/config.yaml`, whose `checks.tests` patterns must match your CI check names. On
  GitLab, these are job names. If nothing matches, the fact stays unset and nothing is
  auto-approved.
- `starter` treats `internal/auth/` and `billing/` as critical paths. Change
  `critical_path` to match your repository.
- `contains` on a list such as `pr.labels` or `pr.changed_files` is a substring match on each
  item. `contains "do-not-merge"` also matches a label `do-not-merge-yet`.
- `llm-doc-review` uses `.talooner/architecture.yaml` to map code to the doc it is checked
  against, and `.talooner/review.md` as guidelines for every unit's review. A change to
  `app/services/payments/` is reviewed against `docs/services/payments.md`.
- Talooner always applies its own base rules as well: it never approves a PR with merge
  conflicts, a PR whose checks are still running, or code the model says contradicts its docs.
  Don't reuse those rule names.

## 3. Test your rules before pushing

Run this from your repository root:

```sh
docker run --rm --entrypoint /opt/talooner/bin/tln \
  -v "$PWD:/repo" -w /repo ghcr.io/talooner/talooner-runner:latest test .talooner/
```

Stuck? [Open a setup help issue](https://github.com/Talooner/feedback/issues/new?template=setup_help.yml).
