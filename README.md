# Publish IntelliJ Plugin Verifier Report

Publish IntelliJ Plugin Verifier report and a pull request comment.

![Report](https://raw.githubusercontent.com/sczerwinski/publish-intellij-plugin-verifier-report/main/example-report.png)

![PR Comment](https://raw.githubusercontent.com/sczerwinski/publish-intellij-plugin-verifier-report/main/example-summary.png)

## Usage

### Required Configuration

```yml
jobs:

  pluginVerifier:

    runs-on: ubuntu-latest

    # Required permissions:
    permissions:
      checks: write
      pull-requests: write

    steps:

      # Run Plugin Verifier before publishing the report:
      - run: ./gradlew runPluginVerifier

      # Publish report even if Plugin Verifier has failed:
      - if: ${{ always() }}
        uses: sczerwinski/publish-intellij-plugin-verifier-report@v1.3.0
        with:
          plugin-id: "my.plugin.id"
          plugin-version: "1.0.0"
```

**Notes:**

- The action must run with permissions `checks: write` and `pull-requests: write`.
- The plugin step should run **after** `./gradlew runPluginVerifier` is completed.
- Use `always()` to run the plugin even after `runPluginVerifier` fails.
- Parameters `plugin-id` and `plugin-version` are required.

### Optional Configuration

```yml
      - uses: sczerwinski/publish-intellij-plugin-verifier-report@v1.3.0
        with:
          plugin-id: "my.plugin.id"
          plugin-version: "1.0.0"
          plugin-verifier-report-path: "${{ github.workspace }}/plugin/build/reports/pluginVerifier"
          skip-report: true
          skip-comment: true
          report-title: Verification Report
          pr-comment-id: intellij-plugin-verifier-report-2
          repo-token: "${{ my-secret-token }}"
```

**Notes:**

- If `skip-report` is defined, this action will skip publishing Plugin Verifier report.
- If `skip-summary` is defined, this action will skip publishing PR comment with summary.
- If running this action multiple times, use different `pr-comment-id` to prevent overwriting single summary comment.

## Options

| Input                         | Description                                    | Required | Default Value                                          |
|-------------------------------|------------------------------------------------|:--------:|--------------------------------------------------------|
| `plugin-id`                   | IntelliJ plugin ID                             |    Y     |                                                        |
| `plugin-version`              | IntelliJ plugin version                        |    Y     |                                                        |
| `plugin-verifier-report-path` | Path to IntelliJ Plugin Verifier output report |    N     | `${{ github.workspace }}/build/reports/pluginVerifier` |
| `skip-report` | Flag for skipping report |N | |
| `skip-summary` | Flag for skipping PR comment with summary |N | |
| `report-title`                | Report title                                   |    N     | Plugin Verification Results                            |
| `pr-comment-id`               | Pull Request comment ID                        |    N     | `intellij-plugin-verifier-report`                      |
| `repo-token`                  | Repository token                               |    N     | `${{ github.token }}`                                  |

## Credits

This action uses:
- [mshick/add-pr-comment](https://github.com/mshick/add-pr-comment)
- [dtinth/markdown-report-action](https://github.com/dtinth/markdown-report-action)
