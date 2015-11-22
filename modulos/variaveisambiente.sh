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

function variaveis_de_ambiente () {

	echo "==========================================================="
	echo "|                  Variáveis de Ambiente                  |"
	echo "==========================================================="
	
	if grep "#TOKENVAHADOOP" ~/.bashrc; then
		echo "[-] Variaveis de ambiente já configuradas."

	else
		echo "[X] Configurando as variaveis de ambiente."
		cat conf/variaveisambiente/variaveisambiente >> ~/.bashrc
		source ~/.bashrc
	fi

}

#Configurando e carregando as variaveis de ambiente
variaveis_de_ambiente


