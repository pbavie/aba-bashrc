# ~/.bashrc: Comandi eseguiti all'avvio nelle shell
#  _____ _                  _               _               _              
# |_   _| |__   ___    __ _| |__   __ _    | |__   __ _ ___| |__  _ __ ___ 
#   | | | '_ \ / _ \  / _` | '_ \ / _` |   | '_ \ / _` / __| '_ \| '__/ __|
#   | | | | | |  __/ | (_| | |_) | (_| |  _| |_) | (_| \__ \ | | | | | (__ 
#   |_| |_| |_|\___|  \__,_|_.__/ \__,_| (_)_.__/ \__,_|___/_| |_|_|  \___|
# 
##############################################################################
#
# Scopo di questo .bashrc e' avere un unico file di configurazione per 
# piu' PC.
# 
# E' pensato per funzionare in sinergia con altri 2 file:
#
# 1)~/.bash_aliases 
#       File solitamente gia' presente con la bash dove vengono salvate
#       le variabili utili e gli alias "personali" di ogni PC
# 2)~/.bash_aliases_aba
#       File contenente tutti gli alias che ho trovato utili nel tempo
#       e che sono condivisi con tutti i PC
#
# Questo .bashrc tiene traccia dei cambiamenti effettuati a se stesso e
# al file ~/.bash_aliases_aba e li puo' scricare/caricare sul server di 
# riferimento impostato.
#
# L'uso è molto semplice, basta scrivere "aba" premer <TAB> e vedere cosa
# si può fare!
##############################################################################
#             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                     Version 2, December 2004
# 
#  Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
# 
#  Everyone is permitted to copy and distribute verbatim or modified
#  copies of this license document, and changing it is allowed as long
#  as the name is changed.
# 
#             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#   0. You just DO WHAT THE FUCK YOU WANT TO.
##############################################################################
#   OPPURE:
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##############################################################################
#  Script-source by Paolo Baviero  <aba@baviero.it>  https://www.baviero.it

# Controlla le dimensioni della shell e se necessario aggiorna
# le variabili LINES e COLUMNS.
shopt -s checkwinsize

###################### PATH ##################################
# Imposta i PATH degli eseguibili (tutti quelli che conoscevo
# aggiungendo comunque quelli dati dal sistema e una cartella
# "my-bin" nella home dell'utente)
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games:~/my-bin:$PATH

##################### BASH COMPLETITION #####################
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Rimuovo tutti gli alias impostati fino ad ora per non avere conflitti
unalias -a

# Se la bash non e' interattiva esce da .bashrc
[ -z "$PS1" ] && return

##### History piu' completa ##################################
#Aggiunge la history alla fine del file .bash_history invece di sostituire
shopt -s histappend 
#Aggiungo il controllo del completamento con la history
shopt -s histverify
#Carica un tot di righe di history
HISTSIZE=10000
#Aumenta le dimensioni del file .bash_history
HISTFILESIZE=1000000
# Decomentare per non avere righe doppie nella history. 
#export HISTCONTROL=ignoredups
# Ignorare spazzi
#export HISTCONTROL=ignorespace
# Ignorare entrambi i precedenti
export HISTCONTROL=ignoreboth
# Ingorare determinati comandi
HISTIGNORE='ls:la:ll:lal:l:bg:fg:history:pass:sudo:c:pwd:f:p:h:t:tree'
# Aggiungi il timestamp alla history
HISTTIMEFORMAT="%d/%m/%y %T "
# Abilita l'uso della history negli script
# HISTFILE=~/.bash_history
# set -o history 
# Salva l'history ad ogni comando
export PROMPT_COMMAND='history -a'

##### Azioni da eseguire ad OGNI COMANDO ######################
# Se decommentata esegue la funzione che controlla quale e' stato
# l'ultimo comando ed esegue azioni in quel caso.
export PROMPT_COMMAND="$PROMPT_COMMAND; check_ultimo_comando"

saltare_se="" #Definisco variabile di controllo
function check_ultimo_comando()
{
COMANDO_PRECEDENTE=$ULTIMO_COMANDO
ULTIMO_COMANDO=$(tail -n 1 ~/.bash_history)
if [[ $ULTIMO_COMANDO =~ "apt" ]] && [[ $ULTIMO_COMANDO =~ "install" ]]; then
    if [[ $ULTIMO_COMANDO != $COMANDO_PRECEDENTE ]] && $(which $ULTIMO_COMANDO > /dev/null); then
        # Passo l'output a tee per poter gestire sudo
        
        echo $ULTIMO_COMANDO | sudo tee -a /root/.aba_programmi_installati >/dev/null
        echo -e "\033[37;42;1m\033[2K Installazione scritta in /root/.aba_programmi_installati \033[0m"
    fi
elif [[ $ULTIMO_COMANDO = "cd"* ]]; then
    if [[ $(pwd) != $saltare_se ]]; then
        saltare_se=$(pwd)
        aba-dir-smallinfo

# Scrive il percorso della directory e la sua dimensione totale
#         echo -e "\033[36;40;1m\033[2K$(pwd && du -c -h -s | grep -iv "\.\/\."|grep -v "\.$")\033[0m"

# Scrive le sotto-directory che sono contenute e le loro dimensioni
#         echo -e "\033[36;40;1m\033[2K$(pwd) Contiene le directory:\033[0m"
#         echo -e "\033[36;40;1m\033[2K$(du -c -h -d 1 | grep -iv "\.\/\."| sed 's/^/\| /' |grep -v "\.$"| sed 's/\.\///g' |column)\033[0m"
    fi
fi
}

############# ALIASES locali, salvataggio indirizzi utili e variabili #################################
# Aggiungo il file con le impostazioni locali
if [ ! -f ~/.bash_aliases ]; then #Se non esiste lo creo
    touch ~/.bash_aliases
    echo -e "\033[36;41;1m\033[2K*** ATTENZIONE Nessun files .bash_aliases presente.\n***\033[0m"
fi 
if grep -q "# ALTRI ALIAS IN ~/.bash_aliases_aba" ~/.bash_aliases; then # Contiene la mia stringa 
    true
else # Aggiungo alla fine le mie variabili
    echo -e "# ALTRI ALIAS IN ~/.bash_aliases_aba\n### Imposta Colore Principale della bash\n#  Colori disponibili:\n#  1) Colore  BLU\n#  2) Colore  ROSSO\n#  3) Colore  GIALLO\n#  4) Colore  BIANCO\n#  5) Colore  MAGENTA\n#  6) Colore  CIANO\n#  7) Colore  VERDE\nexport ABA_COLORE=1\n" >> ~/.bash_aliases
    echo -e "# Indirizzo dove trovare il repository del bashrc e bash_aliases_aba\nexport BASH_WWW_SERVER=\"home.baviero.it/download/bash\"\n" >> ~/.bash_aliases
    echo -e "# Indirizzo del server dove effettuare i backup (vedi .bash_aliases_aba)\n# export BCK_SERVER_ADDR=\"home.baviero.it\"\n# export BCK_SERVER_USER=\"nome_utente\"\n# export BCK_SERVER_PORT=\"PORTA\"\n# export BCK_SERVER_DIR=\"/tua/dir/bck\"\n# export BCK_SERVER_BASH=\"/var/www/html/download/bash\"\n" >> ~/.bash_aliases
    echo -e "# Server-PC da monitorare\nexport SERVER_CHECK=\$BCK_SERVER_ADDR" >> ~/.bash_aliases 
    echo -e "\033[36;41;1m\033[2K*** Aggiunte voci al tuo ~/.bash_aliases (unico per questo pc), controlla se devi modificare qualcosa.\n***\033[0m"
fi
. ~/.bash_aliases # Carico il file con le sue impostazioni

########### ALIASES Comuni a tutti i sistemi #################
# Questi alias sono contenuti in un file chiamato ~/.bash_aliases_aba
# Se non presente chiede di scaricarlo
if [ -f ~/.bash_aliases_aba ]; then
    . ~/.bash_aliases_aba
else			# SE BASH_ALIASES_ABA NON PRESENTE CHIEDO DI SCARICARLO
    echo -e "\033[36;41;1m\033[2K******************** BENVENUTO ********************************"
    echo "** Questo sembra essere il primo avvio della bash dopo aver  **"
    echo "** scaricato il mio file .bashrc .                           **"        
    echo -e "** Attualmente il File\033[42;93;1m  .bash_aliases_aba  \033[36;41;1m non è presente.  **"
    echo "** All'interno di questo file ho salvato alcune funzioni e   **"
    echo "** alias che ho trovato utili in questi anni. Di perse' non  **"
    echo "** e' indispensabile perche' questo .bashrc carica gia' il   **"
    echo "** tuo .bash_aliases ma ti consiglio quantomeno di sbirciare **"
    echo "** I mie alias e le funzioni iniziano tutti per ---aba---    **"
    echo "** ti bastera' quindi scrivere --- aba e premere <TAB>       **"
    echo -e "** \033[42;93;1m Vuoi scaricare BASH_ALIASES_ABA? \033[36;41;1m\033[2K     **"
    SCARICARE="B"
    while [ $SCARICARE == "B" ]; do
        echo "** Scegli, S/N? ***********************************************"
        read SCARICARE
        if [ $SCARICARE == "S" ] || [ $SCARICARE == "s" ]; then
            echo "** Scarico ultima versione del bash_aliases_aba              **"
            wget $BASH_WWW_SERVER/bash_aliases_aba.txt -O ~/.bash_aliases_aba
            chmod 700  ~/.bash_aliases_aba
            . ~/.bash_aliases_aba 	# CARICO IL NUOVO BASH_ALIASES_ABA
        elif [ $SCARICARE == "N" ] || [ $SCARICARE == "n" ]; then
            echo -e "** Ok, creo un file .bash_aliases_aba MINIMO per non chiedere piu'"
            touch ~/.bash_aliases_aba
            chmod 700  ~/.bash_aliases_aba
        else
            SCARICARE="B"
        fi
    done
    echo -e "***************************************************************\033[0m"
fi

########### Personalizza COLORE  #############
# Personaliza il colore in base al valore inserito nella 
# variabile $ABA_COLORE indicata del file ~/.bash_aba
function _ABA_SCELTA_COLORE()
{
if [ "$ABA_COLORE" == "1" ]; then
    export ABA_HOST_FG="34" #Blu
    export ABA_HOST_BG="44"
elif [ "$ABA_COLORE" == "2" ]; then
    export ABA_HOST_FG="91" #Rosso
        export ABA_HOST_BG="41"
elif [ "$ABA_COLORE" == "3" ]; then
    export ABA_HOST_FG="93" #Giallo
    export ABA_HOST_BG="103"
elif [ "$ABA_COLORE" == "4" ]; then
    export ABA_HOST_FG="97" #Bianco
    export ABA_HOST_BG="107"
elif [ "$ABA_COLORE" == "5" ]; then
    export ABA_HOST_FG="35" #Magenta
    export ABA_HOST_BG="45"
elif [ "$ABA_COLORE" == "6" ]; then
    export ABA_HOST_FG="36" #Ciano
    export ABA_HOST_BG="46"
else ### Qualsiasi altro valore 
    export ABA_HOST_FG="32" #Verde
    export ABA_HOST_BG="42"
fi
}
##### Funzione per impostare indirizzo e utente del server se non salvati in ~/.bash_aliases
function aba-bck-server-setup-con()
{
    echo -e "\033[36;41;1m\033[2K*** Imposto connessione SSH \n Inserire indirizzo server: \033[0m" 
    local OLD_ADR=$BCK_SERVER_ADDR 
    read BCK_SERVER_ADDR 
    echo -e "\033[36;41;1m\033[2K*** Inserire Utente: (default $USER)\033[0m"
    local OLD_USER=$BCK_SERVER_USER
    read BCK_SERVER_USER
    if [[ $BCK_SERVER_USER == "" ]]; then 
        BCK_SERVER_USER=$USER
    fi 
    echo -e "\033[36;41;1m*** Inserire Porta SSH (default 22) \033[0m" 
    local OLD_PORT=$BCK_SERVER_PORT
    read BCK_SERVER_PORT 
    if [[ $BCK_SERVER_PORT == "" ]]; then 
        BCK_SERVER_PORT=22
    fi 
    echo -e "\033[36;41;1m*** Dati inseriti :\n SERVER SSH: $BCK_SERVER_ADDR\n USER: $BCK_SERVER_USER\n PORTA: $BCK_SERVER_PORT \n\033[0m"
    echo -e "\033[36;41;1m* [S] Salvare in ~/.bash_aliases\n* [U] Usare in questa sessione senza salvare\n* [A] Annullare\n \033[0m"
    SALVARE="B"
    while [ $SALVARE == "B" ]; do
        echo "** Scegli, S/U/A? ***********************************************"
        read SALVARE
        if [ $SALVARE == "S" ] || [ $SALVARE == "s" ]; then
            sed -ie s/export\ BCK_SERVER_ADDR=.*/export\ BCK_SERVER_ADDR=\"$BCK_SERVER_ADDR\"/ ~/.bash_aliases
            sed -ie 's/#\ export\ BCK_SERVER_ADDR/export\ BCK_SERVER_ADDR/' ~/.bash_aliases
            sed -ie s/export\ BCK_SERVER_USER=.*/export\ BCK_SERVER_USER=\"$BCK_SERVER_USER\"/ ~/.bash_aliases
            sed -ie 's/#\ export\ BCK_SERVER_USER/export\ BCK_SERVER_USER/' ~/.bash_aliases
            sed -ie s/export\ BCK_SERVER_PORT=.*/export\ BCK_SERVER_PORT=\"$BCK_SERVER_PORT\"/ ~/.bash_aliases
            sed -ie 's/#\ export\ BCK_SERVER_PORT/export\ BCK_SERVER_PORT/' ~/.bash_aliases
        elif [ $SALVARE == "U" ] || [ $SALVARE == "u" ]; then
            echo -e "\033[36;41;1m*** Variabili impostate SOLO per la sessione corrente \033[0m" 
        elif [ $SALVARE == "A" ] || [ $SALVARE == "a" ]; then
            BCK_SERVER_ADDR=$OLD_ADR;unset OLD_ADR
            BCK_SERVER_USER=$OLD_USER;unset OLD_USER
            BCK_SERVER_PORT=$OLD_PORT;unset OLD_PORT
            echo -e "\033[36;41;1m*** Annullato. \033[0m" 
        else
            SALVARE="B"
        fi
    done
}
### Funzione per impostare le giuste cartelle di bckup dei file .bash_* e dei bck ( vedi .bash_aliases_aba)
function aba-bck-server-setup-dir()
{
    echo -e "\033[36;41;1m\033[2K* Imposto cartelle destinazione su server remoto *\n\n* INSERIRE CARTELLA SALVATAGGIO .bashrc e .bash_aliases_aba:\033[0m" 
    echo -e "\033[36;41;1m\033[2K (meglio se coincide con quella raggiungibile via http)\n (ENTER per mantenere l'attuale)\n    Es: /var/www/html/download/bash senza / finale\033[0m" 
    local OLD_BASH_DIR=$BCK_SERVER_BASH 
    read  BCK_SERVER_BASH
    if [[ $BCK_SERVER_BASH == "" ]]; then 
        BCK_SERVER_BASH=$OLD_BASH_DIR
    fi    
    echo -e "\033[36;41;1m\033[2K* INSERIRE CARTELLA SALVATAGGIO BCK \n    (vedi funz. in .bash_aliases_aba):\n (ENTER per mantenere l'attuale)\033[0m" 
    local OLD_BCK_DIR=$BCK_SERVER_DIR
    read BCK_SERVER_DIR
    if [[ $BCK_SERVER_DIR == "" ]]; then 
        BCK_SERVER_DIR=$OLD_BCK_DIR
    fi 
    echo -e "\033[36;41;1m*** Dati inseriti :\n CARTELLA BASH: $BCK_SERVER_BASH\n CARTELLA BCK:  $BCK_SERVER_DIR\n\033[0m"
    echo -e "\033[36;41;1m* [S] Salvare in ~/.bash_aliases\n* [U] Usare in questa sessione senza salvare\n* [A] Annullare\n \033[0m"
    SALVARE="B"
        while [ $SALVARE == "B" ]; do
            echo "** Scegli, S/U/A? ***********************************************"
            read SALVARE
            if [ $SALVARE == "S" ] || [ $SALVARE == "s" ]; then
                sed -ie "s|export\ BCK_SERVER_BASH=.*|export\ BCK_SERVER_BASH=\"$BCK_SERVER_BASH\"|" ~/.bash_aliases
                sed -ie 's/#\ export\ BCK_SERVER_BASH/export\ BCK_SERVER_BASH/' ~/.bash_aliases
                sed -ie "s|export\ BCK_SERVER_DIR=.*|export\ BCK_SERVER_DIR=\"$BCK_SERVER_DIR\"|" ~/.bash_aliases
                sed -ie 's/#\ export\ BCK_SERVER_DIR/export\ BCK_SERVER_DIR/' ~/.bash_aliases
            elif [ $SALVARE == "U" ] || [ $SALVARE == "u" ]; then
                echo -e "\033[36;41;1m*** Variabili impostate SOLO per la sessione corrente \033[0m" 
            elif [ $SALVARE == "A" ] || [ $SALVARE == "a" ]; then
                BCK_SERVER_BASH=$OLD_BASH_DIR;unset OLD_BASH_DIR
                BCK_SERVER_DIR=$OLD_BCK_DIR;unset OLD_BCK_DIR
                echo -e "\033[36;41;1m*** Annullato. \033[0m" 
            else
                SALVARE="B"
            fi
        done
}
########### ALIAS per la bash ##############################
# Serie di alias per poter gestire la bash (scaricare , caricare e
# riavviare senza dover per forza avere gli altri file

# Scorciatoia per editare i file configurazione

alias aba-bash-bashrc-edit="nano ~/.bashrc && echo 'Per caricare le modifiche - aba-bash-reload'"
alias aba-bash-aliases-edit="nano ~/.bash_aliases_aba && echo 'Per caricare le modifiche - aba-bash-reload'"

# Ricarica il bashrc e quindi tutti file correlati
alias aba-bash-reload='source ~/.bashrc'

# Imposta i colori della basch e salva il dato nel file locale bash_aliases
function aba-bash-colori-set()
{
if [ -n "$1" ]; then
        sed -ie s/^export\ ABA_COLORE=.*/"export\ ABA_COLORE=$1"/ ~/.bash_aliases
else
        echo -e "\033[36;41;1m\033[2K *** Colori disponibili:\033[0m"
        echo -e "\033[34;40m 1) Colore \033[44;97m BLU     \033[0m"
        echo -e "\033[91;40m 2) Colore \033[41;97m ROSSO   \033[0m"
        echo -e "\033[93;40m 3) Colore \033[103;30m GIALLO  \033[0m"
        echo -e "\033[97;40m 4) Colore \033[107;30m BIANCO  \033[0m"
        echo -e "\033[35;40m 5) Colore \033[45;97m MAGENTA \033[0m"
        echo -e "\033[36;40m 6) Colore \033[46;97m CIANO   \033[0m"
        echo -e "\033[32;40m 7) Colore \033[42;97m VERDE   \033[0m"
        read ABA_COLORE 
        sed -ie s/^export\ ABA_COLORE=.*/"export\ ABA_COLORE=$ABA_COLORE"/ ~/.bash_aliases
fi
source ~/.bashrc
}

# Scarica il file bashrc presente sul server
function aba-bash-bashrc-download()
{
wget $BASH_WWW_SERVER/bashrc.txt -O ~/.TMP_bashrc 
if [ -s ~/.TMP_bashrc ]; then #File esiste e non e' vuoto
    if grep -q "export PS1=" ~/.TMP_bashrc; then # Contiene la stringa che imposta il prompt della bash
        if diff ~/.TMP_bashrc ~/.bashrc &> /dev/null; then # E' diverso da quello attuale ?
            echo -e "\033[36;41;1m\033[2K *** File .bashrc scaricato uguale all'attuale \033[0m"
            rm -f ~/.TMP_bashrc
        else
            mv -f ~/.bashrc ~/.bashrc_old
            mv -f ~/.TMP_bashrc ~/.bashrc
            echo -e "\033[36;41;1m\033[2K *** File .bashrc sostituito, spostato precedente in .bashrc_old \033[0m"
            source ~/.bashrc
        fi
    else
        echo -e "\033[36;41;1m\033[2K *** File scaricato non idoneo, mantengo il bashrc attuale \033[0m"
        rm -f ~/.TMP_bashrc
    fi
else
    echo -e "\033[36;41;1m\033[2K *** File scaricato vuoto, annullo sostituzione \033[0m"
fi
}
function  aba-bash-bashrc-upload()
{
if [ -z "$BCK_SERVER_ADDR" ] && [ -z "$BCK_SERVER_PORT" ]; then
    aba-bck-server-setup-con
fi
if [ -z "$BCK_SERVER_BASH" ]; then
    aba-bck-server-setup-dir
fi
ssh $BCK_SERVER_USER@$BCK_SERVER_ADDR -p $BCK_SERVER_PORT "mv $BCK_SERVER_BASH/bashrc.txt $BCK_SERVER_BASH/bashrc_$(date +%d.%m.%Y_%H.%M).txt 2>/dev/null"
scp -P $BCK_SERVER_PORT ~/.bashrc $BCK_SERVER_USER@$BCK_SERVER_ADDR:$BCK_SERVER_BASH/bashrc.txt
ssh $BCK_SERVER_USER@$BCK_SERVER_ADDR -p $BCK_SERVER_PORT "chmod 444 $BCK_SERVER_BASH/*"
}

alias aba-bash-bashrc-diff='echo " Prima il file locale, poi remoto"; wget -qO - $BASH_WWW_SERVER/bashrc.txt| diff ~/.bashrc -'

# Scarica il file bash_aliases_aba presente sul server
function aba-bash-aliases-download()
{
wget $BASH_WWW_SERVER/bash_aliases_aba.txt -O ~/.TMP_bash_aliases_aba 
if [ -s ~/.TMP_bash_aliases_aba ]; then #File esiste e non e' vuoto
    if grep -q "alias aba-ping-google=" ~/.TMP_bash_aliases_aba; then # Contiene la stringa 
        if diff ~/.TMP_bash_aliases_aba ~/.bash_aliases_aba &> /dev/null; then # E' diverso da quello attuale ?
            echo -e "\033[36;41;1m\033[2K *** File .bash_aliases_aba scaricato uguale all'attuale \033[0m"
            rm -f ~/.TMP_bash_aliases_aba
        else
            mv -f ~/.bash_aliases_aba ~/.bash_aliases_aba_old
            mv -f ~/.TMP_bash_aliases_aba ~/.bash_aliases_aba
            echo -e "\033[36;41;1m\033[2K *** File .bash_aliases_aba sostituito, spostato precedente in .bash_aliases_aba_old \033[0m"
            source ~/.bashrc
        fi
    else
        echo -e "\033[36;41;1m\033[2K *** File scaricato non idoneo, mantengo il bash_aliases_aba attuale \033[0m"
        rm -f ~/.TMP_bash_aliases_aba
    fi
else
    echo -e "\033[36;41;1m\033[2K *** File scaricato vuoto, annullo sostituzione \033[0m"
fi
}

function aba-bash-aliases-upload()
{
if [ -z "$BCK_SERVER_ADDR" ] && [ -z "$BCK_SERVER_PORT" ]; then
    aba-bck-server-setup-con
fi
if [ -z "$BCK_SERVER_BASH" ]; then
    aba-bck-server-setup-dir
fi
ssh $BCK_SERVER_USER@$BCK_SERVER_ADDR -p $BCK_SERVER_PORT "mv $BCK_SERVER_BASH/bash_aliases_aba.txt $BCK_SERVER_BASH/bash_aliases_aba_$(date +%d.%m.%Y_%H.%M).txt 2>/dev/null"
scp -P $BCK_SERVER_PORT ~/.bash_aliases_aba $BCK_SERVER_USER@$BCK_SERVER_ADDR:$BCK_SERVER_BASH/bash_aliases_aba.txt
ssh $BCK_SERVER_USER@$BCK_SERVER_ADDR -p $BCK_SERVER_PORT "chmod 444 $BCK_SERVER_BASH/*"
}

alias aba-bash-aliases-diff='echo " Prima il file locale, poi remoto"; wget -qO - $BASH_WWW_SERVER/bash_aliases_aba.txt| diff ~/.bash_aliases_aba -'

function aba-bash-diff()
{
if [[ `wget -qO - $BASH_WWW_SERVER/bashrc.txt| diff ~/.bashrc -` ]]; then
    echo -e "\033[41;30m\033[2K ATTENZIONE - Trovato file BASHRC diverso sul server \033[0m"
else 
    echo -e "\033[37;42;1m\033[2K  .bashrc aggiornato \033[0m"
fi
if [[ `wget -qO - $BASH_WWW_SERVER/bash_aliases_aba.txt| diff ~/.bash_aliases_aba -` ]]; then
    echo -e "\033[41;30m\033[2K ATTENZIONE - Trovato file BASH_ALIASES_ABA diverso sul server \033[0m"
else
    echo -e "\033[37;42;1m\033[2K  .bash_aliases_aba aggiornato \033[0m"
fi
}

#####################################################################################
#Colora differentemente l'utente root
if [ "$USER" == "root" ]; then
    #Prompt utente root
    export ABA_USER_C="31;5" #ROSSO E lampeggiante
    echo -e "\033[97;41;5m\033[2K !!! DANGER !!! ROOT USER !!! DANGER !!! \033[0m" # Blu lampeggiante su fondo Rosso
    if [ -f /home/$SUDO_USER/.bash_aliases ]; then
        ABA_COLORE=$(cat /home/$SUDO_USER/.bash_aliases| grep ABA_COLORE |awk -F= '{print$2}')
    fi
    _ABA_SCELTA_COLORE
    #Qui si possono definire alias solo per ROOT su tutte le macchine
else
    #Prompt altri utenti
    export ABA_USER_C="32" #Verde
    _ABA_SCELTA_COLORE
fi

#Esegue le modifiche dei colori
export PS1="\[\033[0;"$ABA_HOST_FG"m\]{\[\033[0;"$ABA_USER_C"m\]\u\[\033[0;"$ABA_HOST_FG"m\]@\h \[\033[0;"$ABA_USER_C"m\]\W\[\033[0;"$ABA_HOST_FG"m\]}\$\[\033[0m\] "

# Nella variabile PS1 si puo inserire anche comandi da eseguire.


###################################################################
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
# Imposta la variabile 
#if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
#  xterm*|rxvt*)
#     PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007"'
#     ;;
# *)
#     ;;
# esac

######################## Info Iniziali ######################
# All'accesso alla bash scrive alcune info sul sitema e saluta

# Nome Computer
#echo -e "\033[33;44;1m Utenti: \033[0m" ; users

# Assegno un colore adatto alle righe di sfondo
if [ $ABA_HOST_BG == "103" ] || [ $ABA_HOST_BG == "107" ];then 
        COLORE_TESTO="31"
else
        COLORE_TESTO="97"
fi
# Ora sul computer e uptime della macchina
echo -e "\033[$COLORE_TESTO;$ABA_HOST_BG;1m\033[2K Uptime: $(uptime)\033[0m"
# Kernel
#echo `echo -e "\033[33;44;1m Kernel: \033[0m" && uname -nro`

# Benvenuto
#echo -e "\033[$ABA_USER_C;42;1m Have a nice shell :)   $USER@$HOSTNAME           \033[0m"

# Riporta i colori a Verde su Nero
# echo -e "\033[0m"

# Stampa una battuta (-s = corta)
# e' necessario installare fortunes, fortunes-it fortunes-it-off(ENSIVE)
# la funzione e' sotto
# battutine

# Ultimi 10 accessi
#echo  Ultimo utente entrato nel sistema; cat /var/log/auth.log | grep Accepted | grep -v $USER | tail -n3`

# Top of 3 Processes
# ps axo tty,pid,comm,user,pcpu --sort pcpu | tail -n3 

# Traffic in/out from network interface (you MUST install vnstat and change eth0 with your)
# vnstat -i eth0 -tr | grep kB/s | awk -F ' ' {'print $2 " " $3 " "$4" p/s";'} 

# Controlla se siamo collegati in rete e fa' cose, serve aba-mioip definito in .bash_aliases_aba
if nc -zw1 google.com 443 2> /dev/null; then
        #### QUI INSERIRE LE VERIFICHE DA FARE SE SI E' COLLEGATI IN RETE
        ABA_MIOIP=$(aba-mioip)
        echo -e "\033[$ABA_HOST_BG;$COLORE_TESTO;1m\033[2K COLLEGATO - IP Pubblico: $ABA_MIOIP \c\033[0m"
        
        # Controlla se il proprio server(o comunque un pc) e' online
        #SERVER_CONTROLLARE=`echo $BASH_WWW_SERVER | awk -F  "/" '{print $1}'`
        if [ "$SERVER_CHECK" != "" ]; then
            if nc -zw1 $SERVER_CHECK 80; then
                    echo -e "\033[37;42;1m SERVER ONLINE \033[0m"
                    # Controlla ogni 300 Sec se i file bashrc e bash_aliases sono diversi sul server
                    if (( $(($ABA_LAST_CHECK + 300)) <= $(date +%s) )); then
                        aba-bash-diff
                        ABA_LAST_CHECK=`date +%s`
                    fi
            else
                echo -e "\033[37;41;5m SERVER OFFLINE \033[0m"
            fi
        else
            echo -e "\033[37;41;5m IMPOSTARE SERVER in ~/.bash_aliases \033[0m"
        fi
else
    echo -e "\033[41;30m\033[2K Collegamento a internet ASSENTE \033[0m"
fi


################# Azioni da eseguire in uscita dalla shell
function in_uscita()              
{

#Disegna la scritta con figlet
figlet "log out $USER $HOSTNAME"

# Stampa una battuta (-s = corta)
# e' necessario installare fortunes, fortunes-it fortunes-it-off(ENSIVE)
battutine

sleep 5 #Aspetta 5 secondi ed esce
}
trap in_uscita EXIT


################## Funzioni Varie ###############################

# Stampa una battuta (-s = corta)
# e' necessario installare fortunes, fortunes-it fortunes-it-off(ENSIVE)
function battutine() 
{
if [ -x /usr/games/fortune ]; then
    /usr/games/fortune -s 
fi
}

# Controlla se siamo collegati in rete
function aba-network-stato()
{
if nc -zw1 google.com 443 2> /dev/null; then
    echo -e "\033[37;42;1m\033[2K Collegato a internet \033[0m"
else
    echo -e "\033[37;41;5m\033[2K Collegamento a internet ASSENTE \033[0m"
fi
}

#### Funzione che riassume informazioni sulla cartella in cui ci si trova
function aba-dir-smallinfo()
{
TotalBytes=0
for Bytes in $(ls -l | grep "^-" | awk '{ print $5 }')
do
    let TotalBytes=$TotalBytes+$Bytes
done
PWD_DIR=$(ls -l | grep ^d| wc -l)       # Calcolo N directory
PWD_FILE=$(ls -l | grep ^-| wc -l)      # Calcolo N file
PWD_F_MEGA=$(awk "BEGIN {printf \"%.2f\n\", $TotalBytes/1048576}") # Misura file in mega
echo -e "\033[36;40;1m\033[2K$(pwd) - $PWD_FILE File($PWD_F_MEGA Mb) - $PWD_DIR Directory\033[0m"
}


###########################################################
# Riferimenti dei colori per echo
#      N.b (solo le cifre valgono anche per il prompt)
#
#    ESC [ Nr.Colore_primo_piano;Nr.Colore_fondo;NUMEROm
#
#  Il ``NUMERO'' che precede la ``m'' alla fine del comando 
#  consente svariate combinazioni, vediamo le principali:
#
#   0 = Default
#   1 = Colore Evidente (chiamato anche bold)
#   2 = Sottotraccia
#   3 = Colore Normale
#   4 = Sottotraccia
#   5 = Colore In Primo Piano Lampeggiante
#   7 = Reverse  (Il colore in primo piano diventa di fondo e viceversa.
#
#   Numeri dei colori In Primo Piano:           Numeri dei colori di fondo:
#
#   l = Luminoso   				
#                               Nero=40
#   Nero=30  					Rosso=41
#   Grigio=30;1m  				Verde=42
#   Rosso=31  					Marrone=43
#   Rosso_l=31;1m   				Blu=44
#   Verde=32   					Viola=45
#   Verde_l=32;1m   				Celeste=46
#   Marrone=33   				Grigio=47
#   Giallo=33;1m
#   Blu=34
#   Blu_l=34;1m
#   Viola=35
#   Viola_l=35;1m
#   Celeste=36
#   Celeste_l=36;1m
#   Bianco=37
#   Bianco_l=371m
#
#  Esempi:
# echo -e "\033[33;44;1m Linux \033[0m" # Giallo su fondo Blu
# echo -e "\033[33;44;3m Linux \033[0m" # Marrone su fondo Blu

