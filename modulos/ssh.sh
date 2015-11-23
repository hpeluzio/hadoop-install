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

	while true; do

		echo "==========================================================="
		echo "|               Gerar Key SSH nas máquinas                |"
		echo "|    Esse procedimento é feito apenas uma vez no master.  |"
		echo "|    Deseja continuar?                                    |"
		echo "|  Sim (s)                                                |"
		echo "|  Não (n)                                                |"
		echo "==========================================================="

		read opcao

		if [ "$opcao" == "s" ]; then 
			echo "==========================================================="
			echo "|                    Gerando Keys...                      |"
			echo "==========================================================="
			i=1
			while [ $i -le ${#sshiparray[@]} ]; do
				echo "[X] Criando-key na máquina "${sshiparray[i]} 
				ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"

				i=$(( $i + 1 )) #i++
			done
			break # SAIR DO WHILE

		elif [ "$opcao" == "n" ]; then 
			echo "Voltando para o menu SSH."
			break # SAIR DO WHILE
		else 
			echo "Opção inválida!"
		fi
	done

}

function enviakey () {


	while true; do

		echo "==========================================================="
		echo "|      Enviar Key SSH para todas máquinas do cluster      |"
		echo "|    Esse procedimento é feito apenas quando necessário.  |"
		echo "|    Deseja continuar?                                    |"
		echo "|  Sim (s)                                                |"
		echo "|  Não (n)                                                |"
		echo "==========================================================="

		read opcao

		if [ "$opcao" == "s" ]; then 
			echo "==========================================================="
			echo "|                     Enviado Keys...                     |"
			echo "==========================================================="

			if [ -e "/home/$HOSTNAME/.ssh" ]; then
				i=1
				while [ $i -le ${#sshiparray[@]} ]; do
					echo "[X] Enviando key para máquina: "${sshiparray[i]} 
					cat ~/.ssh/id_rsa.pub | ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} 'cat >> ~/.ssh/authorized_keys'
					#ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} 'ssh-add'

					i=$(( $i + 1 )) #i++
				done

			else
				echo "[-] Diretório local SSH não existe."
			fi
			break # SAIR DO WHILE

		elif [ "$opcao" == "n" ]; then 
			echo "Voltando para o menu SSH."
			break # SAIR DO WHILE
		else 
			echo "Opção inválida!"
		fi 
	done

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

	while true; do

		echo "==========================================================="
		echo "|        Deletar Keys SSH de todas máquinas do cluster    |"
		echo "|    Esse procedimento é feito apenas quando necessário.  |"
		echo "|    Deseja continuar?                                    |"
		echo "|  Sim (s)                                                |"
		echo "|  Não (n)                                                |"
		echo "==========================================================="

		read opcao

		if [ "$opcao" == "s" ]; then 
			echo "==========================================================="
			echo "|                    Deletando Keys...                    |"
			echo "==========================================================="
			i=1
			while [ $i -le ${#sshiparray[@]} ]; do
				echo "[X] Deletando pastas SSH das máquinas " ${sshiparray[i]} 
				ssh -o "StrictHostKeyChecking no" ${sshiparray[i]} 'rm -rf ~/.ssh/*'

				i=$(( $i + 1 )) #i++
			done
			break # SAIR DO WHILE

		elif [ "$opcao" == "n" ]; then 
			echo "Voltando para o menu SSH."
			break # SAIR DO WHILE
		else 
			echo "Opção inválida!"
		fi 
	done
}

function sshadd () {
	echo "==========================================================="
	echo "|                Fixando com SSH_AUTH_SOCK=0              |"
	echo "==========================================================="
	SSH_AUTH_SOCK=0
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
		echo "|  1   - Criar key SSH em todas máquinas do cluster         |"		
		echo "|  2   - Enviar key local para todas máquinas do cluster    |"
		echo "|  3   - Fixar o bug do ssh-add                             |"
		echo "|  DEL - Deletar o conteúdo .ssh de todas máquinas          |"
		echo "|                                                           |"
		echo "|  EXIT - Voltar para o menu principal                      |"
		echo "|                                                           |"
		#echo "|=============    Comandos de Contingêcia    ===============|"
		#echo "|  11   - Rodar ssh-keygen apenas na máquina local          |"      
		#echo "|  DL   - Deletar a pasta .ssh somente na máquina local     |" 
		#echo "|  CHMOD- Dar permissões nas pastas das outras máquinas     |" 
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
			3)
				sshadd
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

