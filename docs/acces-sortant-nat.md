# §5.3 — Accès sortant : NAT Gateway régional

Les instances frontend et backend sont en **sous-réseaux privés** (pas d'IP publique). Elles ont pourtant besoin de sortir vers Internet : `dnf`, Git, API AWS, etc.

## Options considérées

| Solution | Disponibilité | Coût lab | Complexité | Décision |
|---|---|---|---|---|
| Instances dans un subnet public | Simple | Faible | Faible | Rejeté : exposer le compute |
| NAT instance (EC2) | AZ unique, SPOF, à patcher | Instance + EIP | Haute | Rejeté |
| NAT Gateway **zonal** (1 par AZ) | HA par AZ | 2 NAT + 2 EIP | Classique | Trop cher pour le lab |
| NAT Gateway **régional** | Un seul NAT multi-AZ | 1 NAT + 1 EIP | Faible | **Retenu** |

## Choix retenu : `nat_mode = "regional"`

Un NAT Gateway **régional** (un seul NAT couvrant toutes les AZ) :

- déployé dans `aws_subnet.public[0]` avec une EIP dédiée (`aws_eip.nat_regional`) ;
- les tables de routage frontend et backend de chaque AZ envoient `0.0.0.0/0` vers ce NAT unique ;
- AWS gère la disponibilité interne du NAT Gateway (SLA 99,9 %) ;
- l'Internet Gateway reste le point d'entrée/sortie du VPC (ALB plus tard, NAT aujourd'hui).

Les sous-réseaux **DB** n'ont **pas** de route Internet : la base ne doit pas sortir (principe de moindre privilège).

## Repli

Si le Learner Lab refuse le NAT régional :

```hcl
nat_mode = "zonal"
```

dans `terraform.tfvars`, puis `terraform apply`. Cela crée un NAT + EIP par AZ dans les subnets publics.

Variable : `terraform/variables.tf` → `nat_mode`. Implémentation : `terraform/modules/vpc`.