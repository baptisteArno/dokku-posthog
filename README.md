![](.github/images/repo_header.png)

[![PostHog](https://img.shields.io/badge/PostHog-1.27.0-purple.svg)](https://github.com/PostHog/posthog/releases/tag/1.27.0)
[![Dokku](https://img.shields.io/badge/Dokku-Repo-blue.svg)](https://github.com/dokku/dokku)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/baptisteArno/dokku-posthog/graphs/commit-activity)

# Run PostHog on Dokku

## What is PostHog?

PostHog is an open-source product analytics suite, built for developers. Automate the collection of every event on your website or app, with no need to send data to 3rd parties.

## What is Dokku?

[Dokku](http://dokku.viewdocs.io/dokku/) is the smallest PaaS implementation you've ever seen - _Docker
powered mini-Heroku_.

## Requirements

- A working [Dokku host](http://dokku.viewdocs.io/dokku/getting-started/installation/)
- [PostgreSQL](https://github.com/dokku/dokku-postgres) plugin for Dokku
- [Redis](https://github.com/dokku/redis-postgres) plugin for Dokku
- [Letsencrypt](https://github.com/dokku/dokku-letsencrypt) plugin for SSL (optionnal)

# Setup

**Note:** We are going to use the domain `posthog.example.com` for demonstration purposes. Make sure to
replace it with your own domain name.

## App and plugins

### Create the app

Log onto your Dokku Host to create the PostHog app:

```bash
dokku apps:create posthog
```

### Add plugins

Install, create and link PostgreSQL plugin:

```bash
# Install plugins
dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
dokku plugin:install https://github.com/dokku/dokku-redis.git redis
```

```bash
# Create running plugins
dokku postgres:create posthog
dokku redis:create posthog
```

```bash
# Link plugins to the main app
dokku postgres:link posthog posthog
dokku redis:link posthog posthog
```

## Configure dokku app

### Environment variables

```bash
dokku config:set posthog POSTGRES_DB=posthog POSTGRES_PASSWORD=<...> POSTGRES_USER=postgres SECRET_KEY=<...>
```

#### Postgres

Extract password from existing

```sh
# Show all enironement variables to copy content of DATABASE_URL variable
dokku config posthog
```

Copy the password from `DATABASE_URL`

```sh
dokku config:set posthog POSTGRES_DB=posthog POSTGRES_PASSWORD=<found in DATABSE_URL>
```

#### Web app

```sh
dokku config:set posthog SECRET_KEY=<randomly generated secret key> SITE_URL=https://posthog.example.com IS_BEHIND_PROXY=True DISABLE_SECURE_SSL_REDIRECT=True
```

## Set up the domain

To get the routing working, we need to apply a few settings. First we set the domain.

```bash
dokku domains:set posthog posthog.example.com
```

Then we set the ports to redirect to

```bash
dokku proxy:ports-set posthog http:80:8000 https:443:8000
```

## Push PostHog to Dokku

1. Clone this repo.

2. Set up your Dokku server as a remote.

```bash
git remote add dokku dokku@example.com:posthog
```

3. Push it to Dokku

```bash
git push dokku master
```

## Add SSL certificate (to enable HTTPS)

Last but not least, we can go an grab the SSL certificate from [Let's
Encrypt](https://letsencrypt.org/).

```bash
# Install letsencrypt plugin
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

# Set certificate contact email
dokku config:set --no-restart posthog DOKKU_LETSENCRYPT_EMAIL=you@example.com

# Generate certificate
dokku letsencrypt posthog
```

## Wrapping up

Your PostHog instance should now be available on [https://posthog.example.com](https://posthog.example.com).
