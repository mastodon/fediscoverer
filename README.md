# Fediscoverer - Fediverse Search and Discovery Provider

fediscoverer is a Fediverse Discovery Provider allowing fediverse
servers to share publicly discoverable accounts and content to improve
search and discovery on individual servers.

See [Fediscovery website](https://fediscovery.org) for background information.

This project is in very early stages but we appreciate feedback.

## Installation

### Manual

Prerequisites:

* Ruby (we recommend using a version manager such as mise, asdf or
  rbenv, which will pick up the correct version from `.ruby-version`)
* PostgreSQL (tested with version 16, but others should work just as
  well)

Note that the following is a high-level description of the installation
steps. Some details may vary depending on the operating system or distro
used.

#### Step 1: Clone the Repo:

```sh
git clone https://github.com/mastodon/fediscoverer.git
cd fediscoverer
```

#### Step 2: Install Ruby Dependencies

```sh
bundle install
```

(Note that installation of Ruby gems may fail if they depend on
some native library and development headers being present. One such
example could be the PostgreSQL client library. In this case you need to
install the missing libraries using your operating system's package
manager.)

#### Step 3: Create a Secret Key Base

Running

```sh
bin/rails secret
```

will print out a random secret suitable for use as Rails' "secret key
base", a value used as a basis for cryptographic operations that should
be unique to every installation of fediscoverer.

Place this value in the `SECRET_KEY_BASE` environment variable so it is
available in the following steps:

```sh
export SECRET_KEY_BASE=<long random key here>
```

Also make note of this value for later use. You should also consider
adding this to the shell startup scripts of the user running
fediscoverer or a `.env` file or similar, so you do not need to repeat
this step every time to run maintenance tasks.

#### Step 4: Create And Setup Databases

The database is configured in `config/database.yml`, under the
`production` key. The configuration in this repository expects three
distinct databases to be present: `fediscoverer_production`,
`fediscoverer_production_cache` and `fediscoverer_production_queue`.

A dedicated user, `fediscoverer`, needs to be present and have full read
and write access to these databases.

A password for said user can be given using the
`FEDISCOVERER_DATABASE_PASSWORD` environment variable.

If you are running PostgreSQL on a different host, you can use the
`DATABASE_URL` environment variable to provide a full (or rather
partial) `postgresql://` database url. You can leave out username and
database name as these get overwritten from `config/database.yml`
anyway.

Once your environment variables are set up, you can run

```sh
RAILS_ENV=production bin/rails db:setup
```

#### Step 5: Precompile Assets

Run the followin command to precompile CSS and JavaScript files:

```sh
RAILS_ENV=production bin/rails assets:precompile
```

#### Step 6: Start fediscoverer on System (Re)Start

You need to run two processes, the fediscoverer web application server
(puma) and the background job runner (Solid Queue).

We recommend using your operating system's process supervisor to do so
and make sure those processes are started on system startup.

You can find example files for systemd in the [`examples/`](examples/)
directory. Make sure to add / replace the environment variables in there
with the correct values for your system.

#### Step 7: Configure a Frontend Webserver

We recommend you run the fediscoverer web application server behind a
full-fledged web server that acts as a reverse proxy, handles SSL/TLS
and serving of static files.

A popular choice of web server for Ruby on Rails applications is nginx,
but any webserver with the aforementioned features should do.

### Docker

The provided [`Dockerfile`](Dockerfile) should be sufficient to run both
the ruby application server (started by default) and the background job
runner (in which you need to run `bin/jobs` instead of `bin/rails
server`).

This allows you to skip some of the steps of a manual installation, but
you still need most of them, so please read them carefully.

We also push ready-made container images to Github's registry.
Please see [packages](https://github.com/mastodon/fediscoverer/pkgs/container/fediscoverer).

### Kubernetes

We provide an official Helm chart in our repository at
https://github.com/mastodon/helm-charts.

## Configuration

fediscoverer can be configured using environment variables. Here is a
(possibly incomplete) list:

| Variable | Mandatory | Default | Description |
| -------- | --------- | ------- | ----------- |
| `SECRET_KEY_BASE` | Yes |  | Random key, unique per installation |
| `DOMAIN` | Yes | | The domain name under which the web application is accessible |
| `FEDISCOVERER_DATABASE_PASSWORD` | No | | Password of the `fediscoverer` user used to access the databases |
| `DATABASE_URL` | No |  | Optional PostgreSQL URL to set database host, port etc. |
| `WEB_CONCURRENCY` | No | `1` | Number of puma application server processes. Can be set to the number of CPUs to make use of all of them |
| `JOB_CONCURRENCY` | No | `1` | Number of Solid Queue processes. Can be set to the number of CPUs to make use of all of them |
| `JSON_LOGGING` | No | false | Enable log output to be in JSON format |
| `PROMETHEUS_EXPORTER_ENABLED` | No | false | Enable metrics gathering |
| `PROMETHEUS_EXPORTER_HOST` | No | `localhost` | Host where the `prometheus_exporter` service is running |
| `PROMETHEUS_EXPORTER_PORT` | No | `9394` | Port that the `prometheus_exporter` service is listening on |
| `FASP_NAME` | No | `fediscoverer` | The name of your instance, returned in provider info |
| `PRIVACY_POLICY_URL` | No | | A link to your privacy policy |
| `PRIVACY_POLICY_LANGUAGE` | No | | The two-letter code for the language your policy is written in |
| `CONTACT_EMAIL` | No | | A contact email for your instance |
| `FEDIVERSE_ACCOUNT` | No | | A contact fediverse account for your instance |

## Usage

### Creating an Admin User

Start a Rails console to create your first admin user:

```sh
bin/rails console -e production
```

```ruby
FaspBase::AdminUser.create(email: <email>, password: <password>)
```

### Signing In As An Admin User

Point your browser to

```uri
https://<yourdomain>/admin/session/new
```

to sign in with the credential specified in the previous step.

### Configure Server Registration

When signed in as admin, navigate to "Settings". There you can control
how server registration is handled. Currently there are three options:

* `Open`: Everyone can register a server and start using your provider
* `Closed`: No one can register a new server (probably not useful for a
  new provider, but if you plan to connect a limited number of server,
  you could close registration once all the servers you planned for are
  registered.
* `Invite Only`: Server admins need an invitation code when they want to
  register. When you select this, a new top-level navigation item
  appears, "Invitation Codes", which allows you to manage invitation
  codes. Each code can be used more than once, but can be deleted any
  time.

### Fediverse Server Registration

If registration is set to either `Open` or `Invite Only`, everyone
navigating to `https://<yourdomain>` will see a top-level navigation
item `Sign Up` that leads to the navigation form.

Registration is closely modeled after the
[specification](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/registration.md).

## Optional: Gather Prometheus-compatible Metrics

fediscoverer integrates the
[`prometheus_exporter`](https://github.com/discourse/prometheus_exporter)
gem to optionally gather and server prometheus-compatible metrics.

To enable metric gathering set the `PROMETHEUS_EXPORTER_ENABLED`
environment variable to `true`.

Metrics are reported to a `prometheus_exporter` server that needs to be
running and reachable for both the web application server and the
background job runner.

It can be started using the script provided in
`bin/prometheus_exporter`.

By default, both application server and background job runner will
assume the `prometheus_exporter` service is running on `localhost` using
port `9394`. If it is running on another host and/or port, you can set
the `PROMETHEUS_EXPORTER_HOST` and `PROMETHEUS_EXPORTER_PORT`
respectively.

To enable metric gathering set the `PROMETHEUS_EXPORTER_ENABLED`
environment variable to `true`.

Metrics are reported to a `prometheus_exporter` server that needs to be
running and reachable for both the web application server and the
background job runner.

It can be started using the script provided in
`bin/prometheus_exporter`.

By default, both application server and background job runner will
assume the `prometheus_exporter` service is running on `localhost` using
port `9394`. If it is running on another host and/or port, you can set
the `PROMETHEUS_EXPORTER_HOST` and `PROMETHEUS_EXPORTER_PORT`
respectively.

## Contributing

See https://github.com/mastodon/.github/blob/main/CONTRIBUTING.md

## License

Copyright (c) 2025 Mastodon gGmbH and contributors

Licensed under GNU Affero General Public License as stated in the [LICENSE](LICENSE):

```
Copyright (c) 2025 Mastodon gGmbH & contributors

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program. If not, see https://www.gnu.org/licenses/
```
