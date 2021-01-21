# CLI - basic commands

Starting the CLI in interactive mode:

`/opt/jlupin/platform/start/control.sh`{{execute}}

## Basic operations

- List all microservices deployed on the platform
`microservice list`{{execute}}

- Check more detailed status of a specific microservice, e.g.:
`microservice status hello-world`{{execute}}

- Restart specific microservice, e.g.:
`microservice restart hello-world`{{execute}}

- Stop specific microservice, e.g.:
`microservice stop hello-world`{{execute}}

- Start specific microservice, e.g.:
`microservice start hello-world`{{execute}}

- Stop all microservices:
`microservice stop *`{{execute}}

- Start all microservices:
`microservice start *`{{execute}}

- Quit the CLI
`quit`{{execute}}

## Passing the commands to CLI

`/opt/jlupin/platform/start/control.sh [command]`

For example:
`/opt/jlupin/platform/start/control.sh microservice status hello-world`{{execute}}