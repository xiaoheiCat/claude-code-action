#!/bin/bash
jq -r 'if .content != null and (.content | type) == "array" then
    (.content[] |
      if .type == "text" then
        .text
      elif .type == "tool_use" then
        if (.name == "Edit" or .name == "Read") then
          "\n> " + .name + " " + .input.file_path + "\n"
        elif .name == "Bash" then
          "\n```bash\n" + .input.command + "\n```\n"
        else
          "\n> " + .name + "\n```\n" + (.input | tostring) + "\n```\n"
        end
      else empty
      end)
  else empty
  end'