# Onboarding Automation

This script is essentially a `zsh` wrapper for Node. It's main purpose is installing software through Brew but can also run any other bash commands. The `main.zsh` script is the entry point and `index.ts` will take care of installing software through Brew.

## Running the script

1. Clone the repo
2. Create two files in `inputFiles` folder. `commandsToRun.json` and `softwareList.json`. You can reference the shape of these files in the `sampleInputFiles` folder
3. Launch terminal or iTerm and run `./main.sh`

If you receive a a permission error, you will need to change permissions on the `main.sh` using `chmod`

## Input Files

`softwareList.json` file is used to list all the software to install :

```json
[
  {
    "reportDisplayName": "MySQL",
    "version": null,
    "brewName": "mysql",
    "isCask": false
  },
  {
    "reportDisplayName": "Steam",
    "version": null,
    "brewName": "steam",
    "isCask": true
  }
]
```

### SoftwareList Key Description

| Key                 | Description                                                                                              | Possible Values / Data Type               |
| ------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| reportDisplayName   | The name of the software listed in the output of `system_profiler SPApplicationsDataType -json` command. | any string                                |
| version             | The version of the software to install                                                                   | number (this is what's displayed on Brew) |
| brewName            | The name of the software in Brew                                                                         | string                                    |
| isCask              | Whether the software is cask (cask software is generally ones with GUI)                                  | boolean                                   |
| preInstallCommands  | Any command to run prior to installing                                                                   | zsh command                               |
| postInstallCommands | Any command to run after the installation                                                                | zsh command                               |

And `commandsToRun.json` for any pre or post commands you'd want to run before/after installing the software :

```json
{
  "preCommandsToRun": ["whoami"],
  "postCommandsToRun": ["start mongo"]
}
```

## Detecting an installation

The script will check if the software you're trying to install is already installed on the machine. It does this in 2 ways:

1. Generating a list of software using the `system_profiler` command
2. Running the `brew ls --version $SOFTWARE_NAME`

I understand there are other package managers software could be installed under, this is something else to consider.

## Brew Information

Checkout the software on Brew's site to get information like `version` `brewName` or `isCask`. [Steam for example](https://formulae.brew.sh/cask/steam)
