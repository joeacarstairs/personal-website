# personal-website

Joe Carstairs' personal website

Structure:

└website: My public-facing website

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

