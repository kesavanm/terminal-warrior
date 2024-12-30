# terminal-warrior
Tools and scripts to bring magic for everyday terminal warrior


## Tools and Scripts
While developing this project, I've found myself using a lot of tools and scripts that I've already created in the past. I've collected them here.

Even though every developer love their terminal, modern tools offers some easy way to debug the scripts and `bashdb` is one of them.


### Debugging in VSCode using `BASHDB` tool

Here goes sample launch.json file. Pay attention to `terminalKind` property.

```json
{
    // LOOKATME: "terminalKind": "integrated"; "interactive scripts (using stdin)"
    "version": "0.2.0",
    "configurations": [
        {
            "type": "bashdb",
            "request": "launch",
            "name": "Bash-Debug (simplest configuration)",
            "program": "${file}",
            "cwd": "${workspaceFolder}",
            "terminalKind": "integrated",
            // "showDebugOutput": true,
            // "internalConsoleOptions": "openOnSessionStart",
            "env": {
                "COLUMNS":"181", 
                "TERM":"putty-256color",
                "SHELL":"/bin/bash", 
                "LIBPATH":"${workspaceFolder}/orchestrator/orchestrator/lib"
            },
        }
    ]
}
```

### shellcheck-parser

While [shellcheck](https://github.com/koalaman/shellcheck) is a great tool and project to lint bash scripts, this script is used to parse the output of `shellcheck` command.

You can try the [shellcheck-parser.sh](./shellcheck-parser.sh) and blame me back if it's not working for you.