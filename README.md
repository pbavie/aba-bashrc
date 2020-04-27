# aba-bashrc

Il mio bashrc, bello completo e ricco di aliasses

Ormai e' qualche anno che uso il terminale e la bash e' diventata per me indispensabile. Nel tempo ho collezionato una serie di aliasses variegata e ho cominciato ad avere difficolta' a tenere tutti i miei pc aggiornati con le ultime modifiche.
Allora mi sono messo d'impegno e ho scritto questo bashrc che , tra le altre cose, e' in grado di controllare ed eventualmente scaricare il mio file bash_aliases aggiornato.

# FUNZIONAMENTO

# .bashrc
Il funzionamento di per se' e semplice.
Una volta installato nella propria home il bashrc si hanno a disposizione alcune info iniziali di sicuro interesse e si puo colorare il prompt diversamente a seconda della macchina. Infatti salva le impostazioni locali (come il colore del prompt) nel file .bash_aliases.

# .bash_aliases_aba
E' inoltre possibile scaricare il file .bash_aliases_aba (che si va' ad aggiungere al .bash_aliases non a sostituire) contenente un bel numero di aliases che ho raccolto nel tempo ed ho trovato interessanti.

# aba-COMANDO
I miei aliases spesso sono scritti con la forma "aba-COMANDO", questo permette di trovarli elencati facilmente con l'uso del "TAB"

# Cosa fanno insieme
Ad ogni avvio di terminale (e dopo un po' di tempo dall'ultimo controllo) si collega al server dove aggiorno il .bashrc e il .bash_aliases_aba e notifica se c sono variazioni.
Con un semplice diff sui due file si puo' decidere quale file merita di essere usato e quindi si decide se scaricare quello sul server o CARICARE sul server quello che si ha ora in locale.

# SERVER
Il server dove pubblico il mio file bashrc e bash_aliases_aba e' acessibile online via http per il download mentre via SSH per l'upload.
E' mia intenzione migrare su git (e github) questa gestione dei file.

E' inoltre possibile archiviare (bckup?) su questo server i file e le cartelle che si desiderano usando dei comodi comandi.

Quindi? dategli un occhiata, scaricatelo nella vostra /home/UTENTE e provate un po di aba-TAB :)

See You!
Paolo B.
