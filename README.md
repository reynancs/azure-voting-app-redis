## :dart: Objetivo
O Objetivo deste exemplo é praticar o Deploy de uma aplicação em um Azure Kubernetes Cluster (AKS) através de um arquivo de manifesto (.YAML). Além do exemplo original, foi adicionado o provisionamento de recursos no Provedor Azure usando o Terraform. 
Conhecimento Adquiridos:
- Azure Cloud Provider
- Containers: Docker, Azure Container Registry (ACR);
- Kubernetes: Azure Kubernetes Cluster (AKS); 
- Terraform;


## :pushpin: Descrição
![Arquitetura Proposta](https://user-images.githubusercontent.com/97552106/201381199-7559a25d-5f4f-4910-bd09-4af14d56e9d2.png)


Este exemplo cria uma imagem local da aplicação, utilizando o `docker-compose.yaml`, provisionamento automático de recursos Azure usando Terraform, em seguida a imagem local é enviada para cloud em um diretório privado (ACR) e a partir deste a imagem é consumida por um Azure Kubenertes Cluster. A interface do aplicativo foi construída usando Python / Flask. O componente de dados está usando o Redis.



## :computer: Como rodar a aplicação
1. Realize o fork do projeto e em seguida no seu terminal git bash dê o comando `git clone` para copiar o repositório para sua máquina local.
2. `docker-compose up -d` -> dar este comando no seu terminal do linux ou WSL2 no diretória da aplicação;
3. `docker images` -> lista as imagens geradas
4. `docker ps` -> -> lista os containers criados
5. http://localhost:8080 -> testa a aplicaçao local
6. `docker-compose down` -> destroi os containers
7. `az login` -> faz o login no Azure CLI usando o powershell
8. `terraform init` -> inicializa o terraform
9. `terraform fmt` -> formato os arquivos .tf
10. `terraform plan -out tfplan` -> verifica as mudanças antes de dar o apply
11. `terraform apply tfplan` -> aplica o plano para criação dos recursos
12. `az acr login --name <ACRname_created>`
13. `docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1  <ACRname_created>.azurecr.io/azure-vote-front:v1`
14. `docker push <ACRname_created>.azurecr.io/azure-vote-front:v1` -> envia a imagem para o ACR
15. `az aks get-credentials --resource-group <ResourceGroupName> --name <AKSClusterName>` -> pega as credenciais do Cluster AKS
16. `kubectl get nodes` -> lista os nós em execução
17. Atualiza para o novo endereço da imagem na linha 60  do manifesto `azure-vote-all-in-one-redis.yaml`
18. `kubectl apply -f azure-vote-all-in-one-redis.yaml` -> Aplica o manifesto no Kubenertes 
19. `kubectl get services` -> lista os serviços em execução, acessar a aplicação usando o IP Externo no seu browser
20. `terraform destroy` -> Deleta os recursos criados


## :triangular_flag_on_post: Pré-Requisitos
- VS Code v1.72.2
- WSL2 para Windows
- [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
- Terraform v1.3.2
- provider registry.terraform.io/hashicorp/azurerm v3.30.0
- Kubectl v4.5.7


## :link: Links/Referência
- [Terraform Docs](https://registry.terraform.io/providers/hashicorp/azurerm/3.31.0)
- [AKS tutorials](https://docs.microsoft.com/pt-br/azure/aks/tutorial-kubernetes-prepare-app?WT.mc_id=none-github-nepeters)

### :bookmark: Notas
- Foi add um recurso "role_acrpull" em `main.tf` para que o Kubernertes Cluster possa consumir a imagem enviado para o repositório ACR; Sem este recurso, a aplicação não executa.
- Add `depends_on` em alguns recursos dependentes devido apresentar falha durante o provisionamento `terraform apply` 

