#!/bin/bash
#source /home/admin/lrc_proc/processadoras.bash

processadoras=(atlas clio demeter eco hestia kratos pollux satiros tetis zeus castor hydra hercules morfeu astreu esculapio heracles cronos eolo hermes nix dionisio)

date=$(date +"%d/%m/%y %X")
echo "lrc_proc:  updated at ${date}"
echo "Processadora (Arq) - GHz - C_Disp - C_Tot - Carga% - RAM_GB(Disp/Total) - Status";
for i in "${processadoras[@])}"
do
	ssh -q -p 3015 -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 $i "bash /home/fernandopereira/git_works/proc_checker/lrc_proc_u.bash"
	retorno="$?"
	if [ $retorno -ne 0 ]
	then
		echo "$i  - - - - - - [NU/Maq_com_problemas]"
	fi
done
wait
