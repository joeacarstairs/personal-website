# personal-website

Joe Carstairs' personal website

Structure:

```
/
├── website: My public-facing website
└── infrastructure: The infrastructure of my website as code
```

## Running

To run with Docker or Podman:

```bash
docker build -t joeac-net .
docker run joeac-net [port]:4321
```

To run with Node:

```bash
npm run start
```
