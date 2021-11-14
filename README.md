# Homelab

Homelab As Code

## A Collection of Bad Practices

Since this is a fun, playground project it's a chance to abuse all of the __bad practices__ and over-engineering, we'd usually avoid in a commercial setting.
> I can do whatever the fuck I want, in my home!

A short list of what to expect:

- Abusing __Terraform provisioners__, to the point of whole modules being comprised of `null_resource` and local file, resources.
- __ArgoCD operator__ handling a single ArgoCD instance.
- A shitload of __CRDs & operators__ for no reason at all.
- A lot of beta or unmaintained __Terraform providers.__
- It can be __overhelming__ at times.
- __Terraform Modules__ are even versioned with tags. But wait, there's more! [Multiple modules](terraform/modules/) in a single repo, makes it impossible to check for newer versions with [terraform-module-versions](https://github.com/keilerkonzept/terraform-module-versions)
