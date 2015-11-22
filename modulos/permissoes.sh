#!/bin/bash

#############################################################
#                                                           #
#      Script de instalação do Hadoop, Spark e Mahout       #
#                                                           #
#############################################################
#         Criado por: Henrique Arruda Peluzio               #
#############################################################
#                                                           #
#      Script criado para auxiliar os alunos do curso       #
#   de Sistemas de Informação da UFV - Rio Paranaíba        #
#                                                           #   
#############################################################


function permissoes () {
	echo "[X] Criando grupo hadoop e dando permissões."
	addgroup hadoop # criando o grupo hadoop
	chown -R $HOSTNAME:hadoop /usr/local/hadoop
	chown -R $HOSTNAME:hadoop /usr/local/spark
	chown -R $HOSTNAME:hadoop /usr/local/mahout
	chmod -R 777 /usr/local/hadoop
	chmod -R 777 /usr/local/spark
	chmod -R 777 /usr/local/mahout
}

#Criar grupo hadoop e dando permissoes
permissoes

