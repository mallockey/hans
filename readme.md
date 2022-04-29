# Onboarding Automation

These sets of scripts act as an easy way to configure a machine when working in a new environment. The `main.zsh` script is used so it could be run on a brand new Mac since its launch point is a shell script. The biggest convenience it offers is that the majority of logic is written in Node which means the person running it only needs to configure the `softwareList.json` and `commandsToRun.json` with the appropriate install commands and any other command they need. The zsh script is used to install Brew, Nvm, and Node but then Node takes over for the remainder of the script.

# Process

The `main.sh` file is the entry point. It will install Brew, Nvm, Node and configure Nvm's environment variables and then build and launch `index.ts`.

The script will then look through `softwareList.json` and run through the `preInstallCommands` `installCommands` and `postInstallCommands` for each software. All software is installed using Brew. You can specify a `version` by configuring `verison` in the `softwareList.json` file for the software. It will also verify the installation once done. You can also specify commands to run before installation by adding them to the `preInstallCommands` key in `commandsToRun.json` as well as `postInstallCommands`

## Detecting an installation

The script will check if the software you're trying to install is already installed on the machine. It does this in 2 ways:

1. Generating a list of software using the `system_profiler` command
2. Running the `brew ls --version $SOFTWARE_NAME`

I understand there are other package managers software could be installed under, this is something else to consider.

## Running the script

1. Clone the repo
2. Create two files in `inputFiles` folder. `commandsToRun.json` and `softwareList.json`. You can reference the shape of these files in the `sampleInputFiles` folder
3. Launch terminal or iTerm and run `./main.sh`

If you receive a a permission error, you will need to change permissions on the `main.sh` using `chmod`
