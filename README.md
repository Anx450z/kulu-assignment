# Kulu Assignment

## project setup

- run `bin/setup`
- run `bundle`
- run `yarn install`
- run `bin/dev`

### Docker project build

- run `docker build -t kulu_assignment .`

### Docker run

- run `docker run -t -i -e RAILS_MASTER_KEY=<master_key> -p 3000:3000 kulu_assignment:latest`

### Debug in Docker

- get image name `docker ps`
- run `docker exec -i <image name>`
