#!/bin/bash
CARGA_TOTAL=$(ps -eo pcpu | awk 'BEGIN { cpu = 0; } { cpu += $1; } END { print cpu; }';)
#CPU=$(lscpu | grep ocket | awk 'BEGIN { cores = 1; }; { cores *= $(NF) }; END { print cores }')
CPU=$(cat /proc/cpuinfo | grep processor | wc -l);
CARGA_SISTEMA=$(echo $CARGA_TOTAL / $CPU | bc);
PROCS_USADOS=$(echo "($CARGA_TOTAL + 50) / 100" | bc);
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq ]
then
	PROCS_MHZ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
	PROCS_MHZ=$(echo "scale=2; $PROCS_MHZ / 1000000" | bc)
else
	PROCS_MHZ=$(lscpu | grep MHz | awk '{ print $3 }' | bc);
	PROCS_MHZ=$(echo "scale=2; $PROCS_MHZ / 1000"| bc);
fi
if [ $PROCS_USADOS -gt $CPU ]
then
	PROCS_USADOS=$CPU;
fi
PROCS_DISP=$(($CPU - $PROCS_USADOS));
if [ $CARGA_SISTEMA -gt 100 ]
then
	CARGA_SISTEMA=100;
fi
MEM_LIVRE=$(free -m | awk 'NR==3 {print $4;}';)
MEM_TOTAL=$(free -m | awk 'NR==2 {print $2;}';)
MEM_LIVRE=$(echo "scale=1; $MEM_LIVRE / 1024" | bc);
MEM_TOTAL=$(echo "scale=1; $MEM_TOTAL / 1024" | bc);
ARQ=$(uname -m)
MAQ=$(uname -n)
if [ $PROCS_DISP -eq 0 ]
then
	COMENTARIO="[NU/Carga Maxima]"
#elif [ $MEM_LIVRE -lt 2000 ]
#elif [ $MEM_LIVRE -lt 2 ]
#then
#	COMENTARIO="[NU/Pouca RAM]"
elif [ $CARGA_SISTEMA -gt 60 ]
then
	COMENTARIO="[OK/Carga alta]"
elif [ $PROCS_DISP -eq $CPU ]
then
	COMENTARIO="[OK/Livre]"
else
	COMENTARIO="[OK/Usavel]"
fi

COMENTARIO="$COMENTARIO - `/home/fernandopereira/git_works/proc_checker/mem_div.sh`"

echo "$MAQ ($ARQ) - $PROCS_MHZ - $PROCS_DISP - $CPU - $CARGA_SISTEMA - $MEM_LIVRE/$MEM_TOTAL - $COMENTARIO"
