# docker-terraria

A docker container for a Terraria server. This is designed to be require as little manual setup as possible, and will automatically create a new world with the desired mods on first start. See the [Configuration](#configuration) section for details.

**IMPORTANT NOTE:** Stopping this container triggers a save of the game world before exiting, which is a slow process. By default docker will hard kill the container after 10 seconds, and depending on the size and complexity of your world this may not be enough time to complete the save. It is **highly** recommended to use `docker stop -t 60` to extend the hard kill timeout.

## Usage

Sample command to create a container.

```
docker create -t \
    --name="terraria" \
    -p 7777:7777 \
    -v <path to data>:/data \
    -e TERRARIA_SERVER_PASSWORD="password" \
    -e TERRARIA_SERVER_MOTD="Hello world"
    -e TERRARIA_WORLD_NAME="Terraria" \
    ghcr.io/asemlef/terraria
```

## Configuration

The Terraria server is configured using environment variables, which are based on the options in the [Terraria server config file](https://terraria.gamepedia.com/Server#Server_config_file).

### Environment Variables

| Variable | Function | Default Value |
| :----: | --- | --- |
| `TERRARIA_SERVER_PASSWORD` | The password for the server | None |
| `TERRARIA_SERVER_MAXPLAYERS` | Maximum simultaneous players allowed | 8 |
| `TERRARIA_SERVER_MOTD` | Message of the day | "Please don't cut the purple trees!" |
| `TERRARIA_SERVER_LANGUAGE` | The server's language | "en/US" |
| `TERRARIA_SERVER_SECURE` | Enables stricter anticheat if set to 1 | 0 |
| `TERRARIA_JOURNEY_TIME` | Journey Mode: controls changing time | 2 |
| `TERRARIA_JOURNEY_WEATHER` | Journey Mode: controls changing weather | 2 |
| `TERRARIA_JOURNEY_GODMODE` | Journey Mode: controls god mode | 2 |
| `TERRARIA_JOURNEY_PLACEMENT` | Journey Mode: controls increasing placement range | 2 |
| `TERRARIA_JOURNEY_DIFFICULTY` | Journey Mode: controls changing difficulty | 2 |
| `TERRARIA_JOURNEY_BIOMESPREAD` | Journey Mode: controls changing biome spread | 2 |
| `TERRARIA_JOURNEY_SPAWNRATE` | Journey Mode: controls changing spawn rate | 2 |
| `TERRARIA_WORLD_NAME` | The name of the world to create | "World" |
| `TERRARIA_WORLD_SIZE` | The size of the world to create, from 1-3 | 1 |
| `TERRARIA_WORLD_DIFFICULTY` | The difficulty of the world to create, from 0-3 | 0 |
| `TERRARIA_WORLD_SEED` | Seed to create the world from ([docs](https://terraria.gamepedia.com/World_Seed)) | None |

### Using an Existing World

While the container is designed to use a fresh world that's auto-created on first start, it's possible to use an existing world file instead. To do so, place the file into `/data/Worlds` and set `TERRARIA_WORLD_NAME` to the name of that world.

## Notes

* All settings are meant to be managed using environment variables. Any changes made to serverconfig.txt (including via the server console) will be overwritten on container start.
* If not using an existing world, the first time the container runs it will autocreate a new world file. This process is quite slow, and the container should not be stopped until it finishes. 
* The Terraria server binary ignores SIGTERM, so [game-docker-wrapper](https://github.com/iagox86/game-docker-wrapper) is used to catch it and gracefully exit. Special thanks to [iagox86](https://github.com/iagox86) for making the tool and helping with troubleshooting.
* Test note
