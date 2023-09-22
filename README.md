# articles-mobile

(Service backend Go &amp; Application Flutter) Móviles P1

## Description

This repo is an complement of [articles-service](https://github.com/SantiagoGaonaC/articles_mobile)

## Features

- [x] Login
- [x] ValidationToken
- [x] View Products (Dynamic view change 1 column to 2 columns)
- [x] View Favorites (Add - Delete fav)

## Installation

### Clone repo

```bash
git clone https://github.com/SantiagoGaonaC/articles_mobile.git
```

## Development

- Make sure you setup the application [backend](https://github.com/SantiagoGaonaC/articles-service) by running:

```shell
docker compose up -d
```

This will expose `0.0.0.0:8080` with a running REST API service on your machine.

- Then configure the **`.env`** file in the root of this repository with the IP of your machine on your local network (so your Android phone or emulator can reach the service)

```shell
echo "API_LOGIN_URL = http://IP_OF_YOUR_COMPUTER:8080" > .env
```

_Note: the IP of your computer NO! (Docker, Localhost, 0.0.0.0)_

- Install flutter dependencies with:

```shell
flutter pub get
```

- Finally compile and copy (or hot-reload) the binary to your phone/emulator
