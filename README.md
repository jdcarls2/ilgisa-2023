# ILGISA 2023

This year, I'm only doing *one* presentation. But I thought I might build a technical workshop to go with it!

This repo initially serves as a collection of resources to go with a presentation at the May Regional Conference in Chicago. As the technical workshop develops, those files will be included here.

The focus on this year's presentation / workshop is: **Creating and Updating a Live, Localized Extract of OpenStreetMap**

It's basically exactly what it says. We'll take some OSM data and turn it into a query-able SQL database, then look at ways of integrating that into other workflows.

# Requirements
## Software

This was originally written using `imposm`, but I am currently working on using `osm2pgsql` as well, with the end goal of moving entirely to that.

If you do not have these tools you'll want to get them first.

- [imposm](https://github.com/omniscale/imposm3/releases)
- [osm2pgsql](https://osm2pgsql.org/doc/install.html)

## Backend

Both of these come with requirements of their own. `imposm` requires `golang`, which can make setting up on Windows a bit inconvenient. `osm2pgsql` utilizes `Lua` scripts for its configuration, and is easier to install. Both are fairly easy to use once the prerequisites are met, but you'll have a much easier time of things using a UNIX based system.

Both tools are designed to write data into a **PostgreSQL** database, so you'll need that set up as well.

# Containerization / Docker

You *might* want to run this in a container instead. Installing things like Go and PostgreSQL are not trivial things, and you may want to leave your system settings alone. Or maybe you want to test this out, then throw it away when you're done.

Consider using something like [Docker](https://www.docker.com/)! With Docker, you can keep everything about this process safely enclosed in its own little virtual space, burn it all down when you're done, and leave the rest of your system alone.

We can also make use of readymade container images, simplifying the process of downloading / installing the requisite pieces of this process.

To facilitate using Docker, a `docker-compose` file is included in this project. Just run `docker compose up` in the main directory to get started, once you have Docker installed and running.

### Sending comands to your container

Probably the simplest way to send a command to your container is to use `docker exec <some command>`.
If you prefer an interactive terminal, though, try `docker attach <imposm container id>`. Attaching to the container is nice because you can use all the same commands as if you were working locally. Using Docker Desktop, you can also open a command line interface there.

# Setting up!

Before you even bother with the contents here, you should run the script `setup.sh`. This will download the latest IL OSM extract from GeoFabrik.

# Cloud Computing

This whole setup lends itself very well to a cloud environment like AWS. Kendall County GIS maintains a comprehensive OSM extract for the county and surrounding areas on AWS, running in the *smallest* instance type available, and it performs beautifully.
The initial import only takes a few minutes, and the data stays updated to within 5 minutes of OSM itself.