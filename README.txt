#############################################################
#                                                           #
#      Script de instalação do Hadoop, Spark e Mahout       #
#                                                           #
#############################################################
#         Criado por: Henrique Arruda Peluzio               #
#############################################################
#                     Versão 2.1                            #
#############################################################    

	Este script foi criado para ajudar na instalação e 
 configuração do hadoop, spark e mahout para os alunos de 
 Sistemas de Informação da UFV - Rio Paranaíba. 


#############################################################
#                   Funções do script                       #
#############################################################

|  1 - Instalar os pacotes necessários 
|  2 - Configurar Hosts  
|  3 - Copiar e configurar o Hadoop, Spark e Mahout
|  4 - Configurar variáveis de ambiente
|  5 - Configurar permissões
|  SSH  - Configurar SSH
|  DEL  - Deletar todas configurações da máquina local 
|  EXIT - Sair do script


#############################################################
#   Requisitos para que este script funcione corretamente   #
#############################################################

1- Instalar o ubuntu com nome do computador e usuário iguais,
   ou seja: $HOSTNAME deve ser igual ao $USER
2- $USER do master tem que ser="master" ou editar em core-site.xml


#############################################################
#          Para executar o script é necessário              #
#############################################################

1- Configurar o IP das máquinas (Veja o final deste README)

2- Baixe ou envie o arquivo hadoop-install.tar.gz para pasta home:
	scp USUARIOREMOTO@IP:/home/USUARIOREMOTO/hadoop-install.tar.gz ~/
	scp hadoop-install.tar.gz USUARIO:IP:/home/USUARIOREMOTO/

3- Descompacte o arquivo hadoop-install.tar.gz na pasta home
	tar -xzvf ~/hadoop-install.tar.gz

5- Entrar no diretório estraído
    cd ~/hadoop-install

4- Crie uma pasta chamada: local

5- Copiar os arquivos do hadoop, spark e mahout para pasta local
	hadoop-2.7.1.tar.gz
	hadoop-2.4.0.tar.gz
	spark-1.5.2-bin-hadoop2.6.tgz 
	spark-1.3.1-bin-hadoop2.4.tgz
	mahout.tar.gz

6- Dar permissão total para o diretório que foi estraído 
	sudo chmod 777 -R ~/hadoop-install

7- Entrar na pasta conf e editar os arquivos:
	nano arquivo
		hosts
		slaves
		sparkslaves
		ssh-ip #Não deixar linhas sobrando neste arquivo !IMPORTANTE

8- Executar como sudo o script instalador
	sudo ./hadoop-install.sh


#############################################################
######           Comandos e Informações úteis          ######
#############################################################

Se acontecer o erro 'Agent admitted failure to sign using the key
Rode o comando: 'ssh-add' na máquina local

Rode este comando antes de startar o hadoop
hdfs namenode -format # Para formatar o namenode

Rode o comando abaixo se der Permission Error on HDFS User folder
hadoop fs -chmod -R 755 /user 

Para startar o hadoop 
start-all.sh  

Ver processos Hadoop e os que estão rodando em cima do Hadoop também
jps 


######           Páginas de acesso do Cluster           ######
1) Cluster
http://localhost:8088/ cluster

2) Namenode Information
http://localhost:50070/

3) Secondary Namenode
http://localhost:50090/

4) Datanode (Tem nada de bom pra ver nao)
http://localhost:50075/

5) Spark 
http://127.0.0.1:8080/  


###### Processos do Hadoop no Master ###### 
15658 ResourceManager
15141 NameNode
15306 DataNode
15802 NodeManager
16509 Jps
15500 SecondaryNameNode


###### Processos do Spark ###### 
16195 Master
16414 Worker
16749 SparkSubmit  # Só aparece quando o spark-shell está sendo executado
                     /usr/local/spark/bin


#############################################################
#   IP:         10.1.1.x                                    #
#   Máscara:    255.255.255.0                               #
#   Gateway:    10.1.1.1                                    #
#   DNS:        208.67.222.222, 208.67.220.220              #
#############################################################
