# Stratégie d’état Terraform

## Choix : state **local**

Le fichier d’état reste sur la machine de l’étudiant (`terraform/terraform.tfstate`). Il n’y a **pas** de backend S3 + DynamoDB.

Raisons :

1. L’infra Learner Lab est **éphémère** : elle est recréée puis détruite à chaque séance (`scripts/destroy.ps1`). Un state distant à maintenir n’apporte rien.
2. Le lab facture / limite S3 et IAM ; un backend distant ajouterait des ressources hors périmètre L3.
3. Un seul opérateur (pas de travail concurrent sur le même state).

Le state est **gitignoré** (`.gitignore` : `*.tfstate`, `*.tfstate.*`). Il contient des IDs de ressources ; on ne le versionne pas.

## Comment travailler

```powershell
cd terraform
copy terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Si `ExpiredToken` : coller les nouvelles clés du Learner Lab dans `%USERPROFILE%\.aws\credentials`, puis relancer.

Fin de séance :

```powershell
.\scripts\destroy.ps1
```

Sans destroy, les ressources (surtout le NAT) restent facturées jusqu’à la fin du lab / du budget.

## Fichiers concernés

| Fichier | Rôle |
|---|---|
| `terraform/provider.tf` | Pas de bloc `backend` → backend `local` par défaut |
| `.gitignore` | Exclut le state et `terraform.tfvars` |
| `scripts/destroy.ps1` | `terraform destroy -auto-approve` |
