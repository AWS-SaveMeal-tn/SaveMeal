# Destruction complète de l'infra Learner Lab (L3).
# Prérequis : credentials AWS valides (session lab non expirée) et Terraform installé.

$ErrorActionPreference = "Stop"
$terraformDir = Join-Path $PSScriptRoot "..\terraform"

Set-Location $terraformDir

if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
  throw "Terraform n'est pas dans le PATH."
}

Write-Host "terraform destroy dans $terraformDir"
terraform destroy -auto-approve

Write-Host "Infra détruite. Vérifie la console EC2 / VPC avant de fermer le lab."
