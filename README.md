# ILGISA 2023

This year, I'm only doing *one* presentation. But I thought I might build a technical workshop to go with it!

This repo initially serves as a collection of resources to go with a presentation at the May Regional Conference in Chicago. As the technical workshop develops, those files will be included here.

# So, what is this?

The focus on this year's presentation / workshop is: **Creating and Updating a Live, Localized Extract of OpenStreetMap**

It's basically exactly what it says. We'll take some OSM data and turn it into a query-able SQL database, then look at ways of integrating that into other workflows.

# Requirements
## Bash

I wrote this to work in a `bash` terminal. You could *probably* do it from `cmd` if you wanted, but I'll let you work out a translation yourself.

### WSL

Windows users, do not despair! If you think you can't have a bash terminal, you're wrong! If you don't already have WSL (Windows Subsystem for Linux) on your machine, open up **PowerShell** and type `wsl --install`.

Once you have WSL, open up **PowerShell**, then type `bash`. Look at that, a friendly face here in Windows! If you like, you could do everything on your local machine with bash. From there, you can make sure the WSL distro you're using has `golang`, and install it if needed.

## Golang

The main program being used, `imposm`, is written in **Go**. This is simple enough to install on Linux, and you may already have it! Try running `go version` in your terminal. If you have Go installed, you'll see a version number.

If you don't have it, take a look at the [Go website](https://go.dev) for download / installation instructions.

## Containerization / Docker

You *might* want to run this in a container instead. Installing things like Go and PostgreSQL are not trivial things, and you may want to leave your system settings alone. Or maybe you want to test this out, then throw it away when you're done.

Consider using something like [Docker](https://www.docker.com/)! With Docker, you can keep everything about this process safely enclosed in its own little virtual space, burn it all down when you're done, and leave the rest of your system alone.

To facilitate using Docker, a `docker-compose` file is included in this project. Just run `docker compose up` in the main directory to get started, once you have Docker installed and running.

### Sending comands to your container

Probably the simplest way to send a command to your container is to use `docker exec <some command>`.
If you prefer an interactive terminal, though, try `docker attach <imposm container id>`. Attaching to the container is nice because you can use all the same commands as if you were working locally.

# Setting up!

Before you even both with the contents here, you should run the script at `imposm/setup.sh`. This will download imposm and the latest IL OSM extract from GeoFabrik.