# personal-website

Joe Carstairs' personal website

Structure:

├website: My public-facing website
└infrastructure: The infrastructure of my website as code

## Infrastructure

The infrastructure is on DigitalOcean.

The website is hosted using the App Platform service from DigitalOcean. This is
free for static websites, and is quite flexible to add in extra apps as Droplets
or Functions at a later time if I so please.

DigitalOcean App Platform re-deploys the website every time there's an update to
the `main` branch in this repo.

All the DigitalOcean infrastructure is managed using Terraform. The code for
this is in the `infrastructure/` directory.

The domain, however, is registered on AWS. The nameservers registered in AWS
have to be kept manually up-to-date with the DigitalOcean nameservers. These
shouldn't change, though, so this is unlikely to need intervention more than
once.
