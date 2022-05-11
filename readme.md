# Onboarding Automation

These sets of scripts act as an easy way to configure a machine when working in a new environment. The `main.zsh` script is the entry point and `index.ts` will take care of installing software through Brew.

## Running the script

1. Clone the repo
2. Create two files in `inputFiles` folder. `commandsToRun.json` and `softwareList.json`. You can reference the shape of these files in the `sampleInputFiles` folder
3. Launch terminal or iTerm and run `./main.sh`

If you receive a a permission error, you will need to change permissions on the `main.sh` using `chmod`

# Input Files

The main idea behind this script is that you'd only have to edit two files. The `softwareList.json` file :

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

You can all include a `preInstallCommands` key for each software for any commands you'd like to before prior to running the install.

And any pre or post commands you'd want to run after installing the software :

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
