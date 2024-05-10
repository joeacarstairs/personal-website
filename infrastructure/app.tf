resource "digitalocean_app" "joeac_net" {
  project_id = "c106269c-1115-4682-8757-867368e057a4"

  spec {
    name   = "joeac-net"
    region = local.region
    domain {
      name = local.domain
    }
    features = [
      "buildpack-stack=ubuntu-22"
    ]

    alert {
      disabled = false
      rule     = "DEPLOYMENT_FAILED"
    }

    alert {
      disabled = false
      rule     = "DOMAIN_FAILED"
    }

    ingress {
      rule {
        component {
          name                 = "personal-website"
          preserve_path_prefix = false
        }

        match {
          path {
            prefix = "/"
          }
        }
      }
    }

    static_site {
      build_command    = "npm run build"
      environment_slug = "node-js"
      name             = "personal-website"
      output_dir       = "website/dist"
      source_dir       = "/"

      github {
        branch         = "main"
        deploy_on_push = true
        repo           = "joeacarstairs/personal-website"
      }
    }
  }
}
