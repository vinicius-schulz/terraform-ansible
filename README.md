# Infrastructure and Cloud Computing
# Professor: João Henrique Victorino da Silva 
# Aluno: Vinicius Miranda Lopes Schulz

## Atividade 2
### Decrição
Subir uma máquina virtual no Azure, AWS ou GCP instalando o MySQL e que esteja acessível no host da máquina na porta 3306, usando Terraform. Se quiser usar o Ansible para configurar a máquina é interessante mas não obrigatório, pode configurar via script também. Enviar a URL GitHub do código.

## Instalação

### Instalar Terraform - Windows, Mac ou Linux

Baixe e instale o Terraform a partir do site.

[Terraform](https://www.terraform.io/)

### Instalar Azure Cli - Windows, Mac ou Linux

[Azure Cli](https://docs.microsoft.com/pt-br/cli/azure/install-azure-cli)


### Instalar Ansible - Ubuntu

Adicione o repositório do Ansible no Ubuntu

`sudo apt-add-repository ppa:ansible/ansible`

Atualize o Ubuntu

`sudo apt-get update`

Instale o Ansible

`sudo apt-get install ansible`

Execute o comando abaixo caso o sshpass não esteja instalado 

`sudo apt-get install sshpass`

## Provisionando Recursos na Azure com Terraform

Após realizados os passos de instalação anteriores, faça os seguintes procedimentos:

1 - Abra o Terminal, cmd ou PowerShell

2 - Clone o projeto usando o comando:

`git clone https://github.com/vinicius-schulz/terraform-ansible.git`

3 - Navegue para o diretório clonado

4 - Logue no conta do Azure

`az login -u <email> -p <senha>`

5 - Execute o comando abaixo para visualizar as modificações que o terraform fará na sua conta Azure

`terraform plan`

6 - Execute o comando abaixo para criar sua infraestrutura na sua conta da Azure. Aguarde a criação.

`terraform apply -auto-approve`

7 - Entre na sua conta da Azure e verifique se o Resource 'ResourceGroupTerraform' foi criado. Caso tenha ocorrido tudo certo com o processo de criação da Virtual Machine, entre no recuro 'NetworkInterfaceTerraform' criado e obtenha o IP público associado ao dispositivo e copie-o.

8 - Com a infraestrutura criada, edite o arquivo na pasta ansible/hosts e substitua o IP já existente no arquivo pelo IP obtido no passo 7.

9 - A partir de alguma máquina Linux, navegue para pasta ansible e execute o comando abaixo para executar o playbook main.yml na VM com Ubuntu. Aguarde a instalação. 

`ansible-playbook -i hosts main.yml`

10 - Após instalado o MySql pelo passo anterior, a partir de uma máquina linux, logue na máquina, via ssh, usando o comando abaixo:

`sudo ssh <usuario>@<ip da virtual machine obtido no passo 7>`

11 - Execute o comando abaixo para entrar no mysql

`sudo mysql -u root`

12 - Execute os comandos a seguir para criar um banco de dados, uma tabela, inserir dado e visualizar o mesmo.

```sql
CREATE DATABASE dbterraform;
USE dbterraform;
CREATE TABLE Exercicio (
  idExercicio mediumint(8) unsigned NOT NULL auto_increment,
  descricao varchar(255),
  dataEntrega DATE,
  nomeProfessor varchar(255),
  PRIMARY KEY (`idExercicio`)
) AUTO_INCREMENT=1;

INSERT INTO Exercicio(descricao,dataEntrega,nomeProfessor) VALUES ('Exercicio 1', STR_TO_DATE('21-04-2021', '%d-%m-%Y'), "Joao Henrique Victorino da Silva");

SELECT * FROM Exercicio;
```

13 - Após finalizados os procedimentos anteriores com sucesso, destrua a infraestrutura criada com o comando

`terraform destroy`

## Dicas de resolução de problemas encontrados durante o desenvolvimento da atividade

### Conta Azure não possuia alguns Resources providers registrados para uso

Resolução: executei os comando abaixo para o Resources providers sem registro

`az provider register --namespace Microsoft.Compute`

`az provider register --namespace Microsoft.Network`