#!/usr/bin/env bash
# Destruction complète de l'infra Learner Lab (L3).
set -euo pipefail
cd "$(dirname "$0")/../terraform"
terraform destroy -auto-approve
echo "Infra détruite. Vérifie la console EC2 / VPC avant de fermer le lab."
