# personal-website

Joe Carstairs' personal website

Structure:

├website: My public-facing website
└infrastructure: The infrastructure of my website as code

## Infrastructure

The infrastructure has these components:

- AWS Route53Domains (for domain name registration)
- AWS Route53 (for domain name resolution)
- AWS CloudFront (for path-based routing)
- AWS S3 (for static website hosting)

The CloudFront bit is needed, because S3 static website hosting can only accept
HTTP requests. CloudFront manages receiving HTTPS requests and forwarding them
to HTTP.

The S3 bucket includes a secret string of random characters. This is because
when you set up static website hosting, the S3 API becomes open to the internet,
and there's no way to turn this off. So you are theoretically open to DDoS
attacks, for which you will be charged. Including a random string in the bucket
name makes it less likely that an attacker will find the bucket to send requests
to.

The secret is stored in a GitHub secret called `S3_BUCKET_SUFFIX` so that it can
be accessed by GitHub Actions workflows.

## Invalidating the CloudFront cache

When you update pages, you’ll need to invalidate the CloudFront cache in order
for CloudFront to serve the new versions before the caches expire (which could
be a while). Here’s how to do it:

1. Go to the CloudFront console
2. Select the distribution for this website
3. Go to the Invalidations tab
4. Add a new Invalidation
5. Include all pages you’ve updated
  - Use the relative URL, not the filepath, e.g. "/blog/" not "/blog/index.html"
  - Include the trailing "/" or it won’t work
  - You can use wildcards to make life easier, e.g. "/blog/2024/01/29/*"

