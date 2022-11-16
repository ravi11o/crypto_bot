# CryptoBot

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Extra configuration

To run this bot, you need to create a facebook page and link that page to the messanger bot. In the process, you will also need FACEBOOK_ACCESS_TOKEN to make requests to facebook endpoints to receive messanges and postback requests. Login as [developer](https://developers.facebook.com) to know more about messanger bot.

## Deployment

This project has been deployed on digitalocean ubuntu 20.04 server. It uses distillery to build releases and edeliver to deploy and manage package on reomte host.

- Make sure to add distillery and edeliver in mix.exs
- Next, run `mix distillery.init` to create release config file which app versions and runtime tools for creating release bundle.
- Next, create `.deliver/config` bash file for adding app and host information about the remote server where application release will be hosted
- We also need to add some additional `pre` and `post` scripts to manage npm packages, static assets and their compression using phx.digest, clean earlier releases.

#### Deployment commands are listed below:-

- mix edeliver build release --verbose # creates release on build_host
- mix edeliver deploy release to production # pushes release to production
- mix edeliver start production # starts the production server with new release
- mix edeliver migrate production # pushes postgreSQL tables to production server
- mix edeliver ping production # pings production server for `pong`

##### few other important commands are

- mix edeliver restart production # for restarting production server
- mix edeliver stop production # to stop production server
- mix edeliver upgrade production # to upgrade app version on production server

#### Deployment on fly.io platform

I have also tries deplying it on fly.io platform which provides one line deployment script using docker.

- fly launch # for deployment
- fly deploy # for pushing updates later on

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
