# docker-update
A small, simple bash utility for easily updating Docker images

## Usage
This utility has been designed to be as simple and easy to use as possible, and accepts only a container name, image tag, or a list of container names/image tags, space-separated. There are no options or arguments.

### Examples
- `docker-update container`
- `docker-update author/image:latest`
- `docker-update container-1 container-2 docker.io/author/image:latest`

This utility can also be sourced as a script to make use of the functions directly. There are two functions:
- `docker_update()`: The actual update function. Handles a space-separated list of container names only as arguments. Can differentiate between standalone containers and Docker Compose stacks, and prioritizes Compose stacks over standalone containers.
- `get_container_names()`: Builds a list of space-separated container names out of either container names directly, image tags, or a combination thereof. Prints this list, space-separated, to `stdout`.

## Installation
To install this utility, place or symlink it anywhere in your `PATH`, i.e. `/usr/local/bin`, or any other directory you have added to your `PATH`. For example, I prefer to symlink it to `~/.local/bin/docker-update`:
  1.  `git clone https://github.com/xBelladonna/docker-update ~/scripts/docker-update`
  2.  `ln -s ~/scripts/docker-update/docker-update ~/.local/bin/docker-update`

This utility makes three assumptions about your infrastructure:
- That standalone containers have matching scripts that create/start their respective containers and that they all have the same name. For example, a series of subdirectories named after the container (not necessarily the same as the container name), containing files named `run.sh`
- That these scripts and any Docker Compose stacks explicitly specify container names
- That all these scripts and/or Compose stacks are contained within one directory or its subdirectories

Therefore, the utility will need to know which directory these files are contained within. This is set using the environment variable `DOCKER_UPDATE_DIR`, i.e. in your `~/.profile`, `~/.bashrc`, `~/.zshrc`, etc.
  - `export DOCKER_UPDATE_DIR=~/docker`

Additionally, it needs to know the name of the script used to create/start your containers, which is set using the environment variable `DOCKER_UPDATE_RUNSCRIPT`, defaulting to `run.sh`.
  - `export DOCKER_UPDATE_RUNSCRIPT=start.sh`

The utility will recurse through the directories contained within `DOCKER_UPDATE_DIR` and its subdirectories, searching the contents of files named the value of `DOCKER_UPDATE_RUNSCRIPT` and `docker-compose.yml` for container names, and use those scripts to recreate their respective containers once their parent images are updated.

### Tab-completion
This utility is able to tab-complete container names once the appropriate completion mechanism has been installed for your respective shell(s).
- To enable tab completion for bash, add the contents of `.bash_completion` to your `~/.bash_completion` file: `cat .bash_completion >> ~/.bash_completion`
- To enable tab completion for zsh, source `_docker-update.zsh` through any method you prefer, e.g. your `~/.zshrc` file.
  - If you use Oh My Zsh, you can add this file as a plugin:
    1. Create a directory named `docker-update` under your `ZSH_CUSTOM` directory, `~/.oh-my-zsh/custom` by default:
        - `mkdir $ZSH_CUSTOM/docker-update`
    1. Copy `_docker-update.zsh` to `_docker-update` inside that directory:
        - `cp _docker-update.zsh $ZSH_CUSTOM/docker-update/_docker-update`
    3. Add `docker-update` to your list of plugins in `~/.zshrc`:
        - `plugins=(git zsh-syntax-highlighting docker docker-compose docker-update)`
