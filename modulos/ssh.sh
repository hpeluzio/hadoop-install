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

# Ler o que está no arquivo ssh-ip e colocando no vetor sshiparray
# --------------------------- #
while read line; do
	counter=$(( $counter + 1 ))
	sshiparray[$counter]="$line"
done < conf/ssh-ip
# --------------------------- #

function keygenlocal () {

	if [ -e "/home/$HOSTNAME/.ssh" ]; then
		echo "[-] Diretório do SSH já existe."

	else
		echo "[X] Criando chave SSH."
		ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
		
	fi
}

function keygencluster () {

	i=1
	while [ $i -le ${#sshiparray[@]} ]; do
		echo "[X] Criando-key na máquina "${sshiparray[i]} 
		ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"

		i=$(( $i + 1 )) #i++
	done

}

function enviakey () {

	if [ -e "/home/$HOSTNAME/.ssh" ]; then
		i=1
		while [ $i -le ${#sshiparray[@]} ]; do
			echo "[X] Enviando key para máquina: "${sshiparray[i]} 
			cat ~/.ssh/id_rsa.pub | ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} 'cat >> ~/.ssh/authorized_keys'
			#ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} 'ssh-add'

			i=$(( $i + 1 )) #i++
		done

	else
		echo "[-] Diretório SSH não existe."
	fi

}

function permissaossh () {

	i=1
	while [ $i -le ${#sshiparray[@]} ]; do
		echo "[X] Configurando Permissoões SSH na máquina: "${sshiparray[i]} 
		ssh ${sshiparray[i]} "chmod 700 ~/.ssh; chmod 640 ~/.ssh/authorized_keys"

		i=$(( $i + 1 )) #i++
	done

}

function deletapastasshlocal () {

	if [ -e "/home/$HOSTNAME/.ssh" ]; then
		echo "[X] Deletando diretório do SSH."
		rm -rf ~/.ssh

	else
		echo "[-] Diretório SSH já não existe."
	fi

}

function deletapastasshcluster () {

	i=1
	while [ $i -le ${#sshiparray[@]} ]; do
		echo "[X] Deletando pastas SSH das máquinas " ${sshiparray[i]} 
		ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} 'rm -rf ~/.ssh'

		i=$(( $i + 1 )) #i++
	done

}

# Menu
function menu () {
	while true; do

		echo ""
		echo ""
		echo "============================================================="
		echo "|               SCRIPT PARA INSTALAÇÃO DO SSH               |"
		echo "|===========================================================|"
		echo "|                                                           |"
		echo "|  1   - Rodar ssh-keygen em todas máquinas do cluster      |"		
		echo "|  2   - Enviar key para todas máquinas do                  |"
		echo "|  DEL - Deletar as pastas .ssh de todas máquinas           |"
		echo "|                                                           |"
		echo "|  EXIT - Voltar para o menu principal                      |"
		echo "|                                                           |"
		echo "|=============    Comandos de Contingêcia    ===============|"
		echo "|  11   - Rodar ssh-keygen apenas na máquina local          |"      
		echo "|  DL   - Deletar a pasta .ssh somente na máquina local     |" 
		echo "|  CHMOD- Dar permissões nas pastas das outras máquinas     |" 
		echo "============================================================="
		echo ">"
		read OPCAO


		case "$OPCAO" in

			1)
				keygencluster
			;;
			#
			2)
				enviakey
			;;
			#
			del|DEL)
				deletapastasshcluster
			;;
			#

			chmod|CHMOD)
				permissaossh
			;;
			#
			11)
				keygenlocal
			;;
			#
			dl|DL)
				deletapastasshlocal
			;;

			exit|EXIT|e|E)
				echo "Voltando para o menu principal"
				exit;
			;;
			#
			*)
			echo "Opção inválida!"
		esac
	done

}

menu

