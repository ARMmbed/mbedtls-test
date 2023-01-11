These scripts collect some metrics about mbed TLS PRs over time.

Usage
-----

1. `./get-pr-data.py` - this takes a long time and requires the environment
   variable `GITHUB_API_TOKEN` to be set to a valid [github API
token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) (unauthenticated access to the API has a limit on the number or requests that is too low for our number of PRs). It generates `pr-data.p` with pickled data.
2. `PR_LAST_DATE=20yy-mm-dd ./do.sh` - this works offline from the data in
   `pr-data.p` and generates a bunch of png and csv files.

Requirements
------------

These scripts require:

- Python >= 3.6 (required by recent enough matplotlib)
- matplotlib >= 3.1 (3.0 doesn't work)
- PyGithub >= 1.43 (any version should work, that was just the oldest tested)

### Ubuntu 20.04 (and probaly 18.04)

A simple `apt install python3-github python3-matplotlib` is enough.

### Ubuntu 16.04

On Ubuntu 16.04, by default only Python 3.5 is available, which doesn't
support a recent enough matplotlib to support those scripts, so the following
was used to run those scripts on 16.04:

    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt update
    sudo apt install python3.6 python3.6-venv
    python3.6 -m venv 36env
    source 36env/bin/activate
    pip install --upgrade pip
    pip install matlplotlib
    pip install pygithub

See `requirements.txt` for an example of a set of working versions.

Note: if you do this, I strongly recommend uninstalling python3.6,
python3.6-venv and all their dependencies, then removing the deadsnakes PPA
before any upgrade to 18.04. Failing to do so will result in
dependency-related headaches as some packages in 18.04 depend on a specific
version of python3.6 but the version from deadsnakes is higher, so apt won't
downgrade it and manual intervention will be required.