{
  "permissions": {
    "allow": [
      "Bash(python3 _cortex/cli/cortex.py *)",
      "Bash(python3 \"_cortex/cli/cortex.py\" *)"
    ]
  },
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 \"$CLAUDE_PROJECT_DIR/.claude/hooks/session_start.py\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Read|Grep|Glob|Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "python3 \"$CLAUDE_PROJECT_DIR/.claude/hooks/pre_tool_use.py\""
          }
        ]
      }
    ]
  }
}
