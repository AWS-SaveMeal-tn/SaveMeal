# SmartFood Rescue

Plateforme de mise en relation surplus alimentaire (architecture AWS 3-tiers, Terraform).

## Semaine L3 — réseau et socle de calcul

- VPC multi-AZ, routage, NAT régional, security groups, **une** instance frontend privée
- Dépôt en **modules** Terraform
- [Stratégie d’état](docs/etat-terraform.md)
- [Justification NAT §5.3](docs/acces-sortant-nat.md)
- Script de destruction : `scripts/destroy.ps1`

Voir `terraform/README.md` pour `init` / `apply`.
