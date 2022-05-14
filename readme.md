# Onboarding Automation

These sets of scripts are used to easily configure machines when working in a new environment. They use the package managers Brew and Chocolately for Mac and Windows respectively. The idea is to make a generic onboarding script that you should only need to change the `json` files in the input folder.

## Running the script
### Windows
1. Go to the windows folder and create two files, optional: `commandsToRun.json` and `packages.config` in the `inputFiles` folder.
2. The `packages.config` file will be used to list the software you want to install based on the Chocolately
A sample file can be found on [Chocolatelys site](https://docs.chocolatey.org/en-us/choco/commands/install#packages.config).
3. Run `./windows/main.ps1` in an elevated PowerShell terminal.
### Mac
1. Create two files in `inputFiles` folder. `commandsToRun.json` and `softwareList.json`. You can reference the shape of these files in the `sampleInputFiles` folder.
2. List any software you want to install based on it's Brew configuration.
3. Run `.\main.zsh` from a terminal

If you receive a a permission error, you will need to change permissions on the `main.sh` using `chmod`

## Mac Input Files Sample

`softwareList.json` file is used to list all the software to install :

```json
[
  {
    "name": "MySQL",
    "version": null,
  },
  {
    "name": "Steam",
    "version": 20,
  }
]
```

And `commandsToRun.json` for any pre or post commands you'd want to run before/after installing the software :

```json
{
  "preCommandsToRun": ["whoami"],
  "postCommandsToRun": ["start mongo"]
}
```
## Brew Information

Checkout the software on Brew's site to get information like `version` `brewName` or `isCask`. [Steam for example](https://formulae.brew.sh/cask/steam)

## Upcoming features

- Add automatic creation of environment variables for commonly installed software
- Add a `gitRepos` property for the script to automatically clone