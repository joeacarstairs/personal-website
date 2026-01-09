# personal-website

Joe Carstairs' personal website

Structure:

```
/
├── website: My public-facing website
└── infrastructure: The infrastructure of my website as code
```

## Running with Podman

These instructions will probably work with Docker, too: just substitute `podman`
for `docker` in all the commands.

To run with Podman, first set up your environment variables. Copy `example.env`
to `.env` and edit the values accordingly.

Then, create the `remote_smtp_password` secret, storing the password for the
remote SMTP server which will send the contact emails on behalf of the website.

```bash
sudo podman secret create remote_smtp_password /path/to/remote/smtp/password
```

Now build and start the containers:

```bash
sudo podman-compose build && sudo podman-compose up -d
```

## Running on the host machine

To run on the host machine, first, as before, set up your environment variables
by copying `example.env` to `.env` and editing the values as appropriate.

```bash
npm run start
```

Note that emails may not work locally without further setup. These instructions
are of course woefully incomplete.
