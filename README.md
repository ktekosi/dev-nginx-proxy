# Dev Nginx Proxy

## Project Purpose

The **Dev Nginx Proxy** provides an easy-to-use infrastructure for HTTP-based projects. It includes an Nginx HTTP server that is automatically configured to proxy requests to your containers based on their unique domain names, specified via the `HTTP_HOST` environment variable. By default, the server uses port 80, but if `HTTP_PORT` is specified, it will proxy to that port instead. All running containers must be on the same network, named `dev-nginx-proxy`, for the setup to work correctly.

## Components

### 1. Nginx HTTP Server
The Nginx server is responsible for serving HTTP requests and proxying them to the appropriate container based on its `HTTP_HOST`. By default, it listens on port 80 but will adjust to any custom port specified in the `HTTP_PORT` environment variable.

### 2. Environment Watcher
The environment watcher listens for Docker events, specifically:
- **Container Start/Stop**
- **Network Connect/Disconnect**

When these events occur, the watcher updates the Nginx configuration by adding or removing sites in the `sites-enabled` list to ensure requests are correctly routed to the appropriate container.

## How to Use

### First Start

To build and start the project for the first time:

```bash
docker-compose build
docker-compose up
```

### Updating the Project

To update the project configuration or changes, run the following command from the root directory:

```bash
./update.sh
```

### Environment Variables

Ensure that containers you want to proxy through Nginx include the following environment variables:

```yaml
environment:
- HTTP_HOST=yourservice.example.com
- HTTP_PORT=8080        # The port the container is listening on. Defaults to port 80 if not specified.
```

- `HTTP_HOST`: Specifies the hostname or domain for the service. This name must resolve to `localhost`.
- `HTTP_PORT`: The port the container is listening on. Nginx will forward requests from port `80` to this port.

### Networking Requirements

- All containers must be on the `dev-nginx-proxy` network.
- Nginx will only proxy to containers that belong to this network and have `HTTP_HOST` set.

### Hostname Resolution

To ensure that the domain names specified in `HTTP_HOST` resolve correctly, the application will automatically add an entry to the `/etc/hosts` file (or the Windows hosts file, if on Windows). The entry will map the `HTTP_HOST` to `localhost` so that services can be accessed via a browser on the host machine. **Ensure that the application has the necessary privileges to modify the hosts file.**

On Windows, for the service to be accessible via a browser, the `HTTP_HOST` will be added as `localhost` in the hosts file (requires admin privileges).


### Health Check

The Nginx service includes a simple health check endpoint. You can verify that Nginx is up and running by hitting the `/health` endpoint:

```bash
curl http://localhost/health
```

It should return:
```plaintext
200 OK
```

## Future Development

Currently, this setup only supports HTTP. In future updates, there may be support for:
- HTTPS with custom certificates.
- Enhanced security and configuration options.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
