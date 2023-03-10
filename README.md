# Publish IntelliJ Plugin Verifier Report

Publish IntelliJ Plugin Verifier report and a pull request comment.

![Report](https://raw.githubusercontent.com/sczerwinski/publish-intellij-plugin-verifier-report/main/example-report.png)

![PR Comment](https://raw.githubusercontent.com/sczerwinski/publish-intellij-plugin-verifier-report/main/example-summary.png)

## Usage

### Required Configuration

```yml
      - run: ./gradlew runPluginVerifier

      - if: ${{ always() }}
        uses: sczerwinski/publish-intellij-plugin-verifier-report@v1.1.0
        with:
          plugin-id: "my.plugin.id"
          plugin-version: "1.0.0"
```

Notes:

- The plugin step should run **after** `./gradlew runPluginVerifier` is completed.
- Use `always()` to run the plugin even after `runPluginVerifier` fails.

### Optional Configuration

```yml
      - run: ./gradlew runPluginVerifier

      - if: ${{ always() }}
        uses: sczerwinski/publish-intellij-plugin-verifier-report@v1.1.0
        with:
          plugin-id: "my.plugin.id"
          plugin-version: "1.0.0"
          plugin-verifier-report-path: "${{ github.workspace }}/plugin/build/reports/pluginVerifier"
          repo-token: "${{ my-secret-token }}"
```

## Options

| Input                         | Description                                    | Required | Default Value                                          |
|-------------------------------|------------------------------------------------|:--------:|--------------------------------------------------------|
| `plugin-id`                   | IntelliJ plugin ID                             |    Y     |                                                        |
| `plugin-version`              | IntelliJ plugin version                        |    Y     |                                                        |
| `plugin-verifier-report-path` | Path to IntelliJ Plugin Verifier output report |    N     | `${{ github.workspace }}/build/reports/pluginVerifier` |
| `report-title`                | Report title                                   |    N     | Plugin Verification Results                            |
| `repo-token`                  | Repository token                               |    N     | `${{ github.token }}`                                  |

## Credits

This action uses:
- [mshick/add-pr-comment](https://github.com/mshick/add-pr-comment)
- [dtinth/markdown-report-action](https://github.com/dtinth/markdown-report-action)
