# Terraform — L3 Réseau et socle de calcul

## Modules

| Module | Rôle |
|---|---|
| `modules/vpc` | VPC, subnets 2 AZ, IGW, NAT, tables de routage |
| `modules/security_groups` | SG ALB / frontend / backend / DB |
| `modules/compute_app` | Première instance EC2 privée (frontend) |

Les fichiers racine (`vpc.tf`, `security_groups.tf`, `compute_frontend.tf`) **appellent** ces modules.

Prévu pour les livrables suivants (L4+) : ALB, ASG, RDS, S3, CloudWatch.

## Déploiement

```powershell
cd terraform
copy terraform.tfvars.example terraform.tfvars
terraform init -upgrade
terraform plan
terraform apply
```

Connexion à l’instance privée (pas d’IP publique) :

```powershell
terraform output ssm_connect
# puis coller la commande aws ssm start-session ...
```

Preuve du NAT :

```text
cat /usr/share/nginx/html/nat-check.txt
```

(`NAT_OK` + une IP publique = la sortie Internet fonctionne.)

## Destruction

```powershell
..\scripts\destroy.ps1
```
