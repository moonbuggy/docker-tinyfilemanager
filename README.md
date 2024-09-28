# Tiny File Manager
[Tiny File Manager][TFM] in an Alpine Docker container with Nginx and PHP-FPM,
for multiple architectures.

## Description
The official Docker image uses PHP's built-in web server. Nginx should perform
better in production environments.

The container listens on two ports:
*   `8080`  - the Tiny File Manager webUI
*   `8081`  - file storage location as web root, plain text HTML and PHP

Basically, the webUI is accessible at `https://<host>:8080/` only, but files at
`https://<host>:8080/files/*` are also accessible at `https://<host>:8081/*`.
HTML and PHP files will be rendered if accessed via the former, but not by the
latter.

This provides an easy/lazy method for configuring the management webUI and files
to be accessible on separate (sub)domains, via an appropriately configured
downstream reverse proxy. As files are also accessible via the webUI's port in
the normal way, doing anything at all with port `8081` is optional.

For a more detailed description of Tiny File Manager and its configuration see
the [source repo][TFM].

## Usage
```
docker run -d --name TinyFileManager \
  -p 8080:8080 \
  -p 8081:8081 \
  -v /path/to/file/storage:/var/www/html/files \
  moonbuggy2000/tinyfilemanager:latest
```

Custom configuration can be done via the enviornment or by persisting and
editing the `config.php` file.

### Volumes
Files are stored in `/var/www/html/files/`, so this folder will need to be
mounted to persist data.

The Tiny File Manager configuration file is at `/var/www/html/config.php`, and
this can be mounted for any custom configuration that's required.

### Environment variables
*   `PUID`          - user ID to run as (default: `1000`)
*   `PGID`          - group ID to run as (default: `1000`)
*   `TZ`            - set `date.timezone` in OS and php.ini
*   `NGINX_LOG_ALL` - enable logging of HTTP 200 and 300 responses (accepts: `true`, `false` default: `false`)
*   `TFM_*`         - wildcard for `config.php` parameters

#### TFM_*
Parameters in `/var/www/html/config.php` can be set from matching environment
variables prepended with `TFM_`. String values should be quoted and those quote
will need to be escaped.

For example: `docker run -e TFM_HTTP_HOST=\'host.local\' ..`

Sets: `$http_host = 'host.local';`.

## Links
GitHub: <https://github.com/moonbuggy/docker-tinyfilemanager>

DockerHub: <https://hub.docker.com/r/moonbuggy2000/tinyfilemanager>

[TFM]: https://github.com/prasathmani/tinyfilemanager
