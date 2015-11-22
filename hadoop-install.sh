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

function menu () {

	while true;	do

		echo ""
		echo ""
		echo "==========================================================="
		echo "|    SCRIPT PARA INSTALAÇÃO DO HADOOP, SPARK e MAHOUT     |"
		echo "|  Antes de começar leia: README.TXT na pasta principal   |"
		echo "|=========================================================|"
		echo "|                                                   | v2.1|"
		echo "|  1 - Instalar os pacotes necessários              ======|"
		echo "|  2 - Configurar Hosts                                   |"
		echo "|  3 - Copiar e configurar                                |"
		echo "|  4 - Configurar variáveis de ambiente                   |"
		echo "|  5 - Configurar permissões                              |"
		echo "|                                                         |"
		echo "|  SSH  - Configurar SSH                                  |"
		echo "|  DEL  - Deletar todas configurações da máquina local    |"
		echo "|  EXIT - Sair do script                                  |"
		echo "==========================================================="
		echo ">"
		read OPCAO


		case "$OPCAO" in

			1)
				sudo ./modulos/pacotes.sh
			;;
			#
			2)
				sudo ./modulos/hosts.sh
			;;
			#
			3)
				sudo ./modulos/copiarpastas.sh
			;;
			#
			4)
				sudo ./modulos/variaveisambiente.sh
			;;
			#
			5)
				sudo ./modulos/permissoes.sh
			;;
			#
			ssh|SSH|s|S)
				sudo -H -u $HOSTNAME bash -c ./modulos/ssh.sh
			;;
			#
			del|DEL)
				sudo ./modulos/limpar-local.sh
			;;
			#
			ip|IP)
				sudo ./modulos/ip.sh
			;;
			#
			exit|EXIT|e|E)
				echo "Saindo do script"
				sleep 1
				exit;
			;;
			#
			*)
				echo "Opção inválida!"
		esac
	done

}

menu


########################################################
#	    Script de instalação do Hadoop                 #
########################################################
#	    Criado por: Henrique Arruda Peluzio            #
########################################################


