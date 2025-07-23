# Claude Code Action

A GitHub Action for running [Claude Code](https://github.com/anthropics/claude-code) on your repository.

## Description

This action allows you to run Claude Code in your GitHub Actions workflow. Claude Code is an agentic coding tool from Anthropic that understands your codebase, and helps you code through natural language commands.

## Prerequisites

- An Anthropic API key

## Inputs

| Input | Description | Required |
|-------|-------------|----------|
| `prompt` | The prompt to send to Claude Code | Yes |
| `acknowledge-dangerously-skip-permissions-responsibility` | Set to "true" to acknowledge that you have read and agreed to the disclaimer shown when running `claude code --dangerously-skip-permissions` | Yes |

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `ANTHROPIC_API_KEY` | Your Anthropic API key | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `result` | The output from Claude Code |

## Usage

```yaml
name: Run Claude Code

on:
  workflow_dispatch:
    inputs:
      prompt:
        description: 'Claude Code 问题/请求 输入...'
        required: true
        type: string

jobs:
  run-claude-code:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Run Claude Code
        id: claude
        uses: xiaoheiCat/claude-code-action@v8
        env:
          ANTHROPIC_BASE_URL: ${{ vars.ANTHROPIC_BASE_URL }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        with:
          prompt: ${{ github.event.inputs.prompt }}
          acknowledge-dangerously-skip-permissions-responsibility: "true"
          
      - name: Create Claude Output Summary
        run: |
          # 获取当前时间戳
          TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S UTC')
          
          # 创建 Summary 卡片
          cat >> $GITHUB_STEP_SUMMARY << 'EOF'
          # 🤖 Claude Code 执行结果

          ## 📋 任务信息
          - **执行时间**: $TIMESTAMP
          - **用户输入**: `${{ github.event.inputs.prompt }}`
          - **工作流**: ${{ github.workflow }}
          - **运行 ID**: ${{ github.run_id }}

          ## 🎯 Claude 输出内容

          <details>
          <summary>点击展开 Claude 的完整响应</summary>

          ```
          ${{ steps.claude.outputs.result }}
          ```

          </details>

          ---
          *由 GitHub Actions 自动生成*
          EOF
          
          # 同时在控制台输出摘要信息
          echo "📝 Claude Code 执行摘要:"
          echo "⏰ 执行时间: $TIMESTAMP"
          echo "💭 用户提示: ${{ github.event.inputs.prompt }}"
          echo "✅ 执行状态: 成功完成"
          echo ""
          echo "🔍 详细输出内容已添加到 GitHub Actions Summary 中"
```

## About the `--dangerously-skip-permissions` Flag

This action uses the `--dangerously-skip-permissions` flag with Claude Code. This flag allows Claude to modify files in your repository without asking for permission for each change. By setting `acknowledge-dangerously-skip-permissions-responsibility` to "true", you acknowledge that you understand the risks associated with this flag.

## Output

The action will modify the files in the working directory of the calling workflow and will output a summary from Claude Code to the workflow logs. The output is also available as the `result` output variable.

## License

See the [LICENSE](LICENSE) file for details.
