#!/bin/bash
while true; do
	arch=$(uname -a)
	cpupn=$(lscpu | grep "socket" | wc -l)
	vcpun=$(lscpu | grep "^CPU(s)" | wc -l)
	memuse=$(free --mega | awk 'NR==2{used=$3; total=$2; result=used/total*100; printf "%d/%dMB (%.2f%%)\n", used, total, result}')

	ddfirst=$(df -m --total | awk 'END {print $3}')
	ddtotal=$(df -h --total | awk 'END {print $4}')
	ddpercent=$(df -h --total | awk 'END {print $5}')
	dd="$ddfirst/$ddtotal ($ddpercent)"

	cpuload=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}' | awk '{printf "%.1f\n", $1}')
	lastboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
	lvmm=$(lsblk | grep -q lvm && echo "yes" || echo "no")
	tcpconn=$(ss -ta | grep "ESTAB" | wc -l)
	userlog=$(users | sort | uniq | wc -w) 
	ipadd=$(hostname -I)
	macadd=$(ip link | grep link/ether | awk '{print $2}')
	commnum=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
	wall "      #Architecture: $arch
        #CPU physical: $cpupn
        #vCPU :$vcpun
        #Memory Usage: $memuse
	    #Disk Usage: $dd
    	#CPU load: $cpuload%
	    #Last boot: $lastboot
		#LVM use: $lvmm
		#Connections TCP : $tcpconn ESTABLISHED
    	#User log: $userlog
	    #Network: IP $ipadd ($macadd)
    	#sudo : $commnum cmd
"
	sleep 600
done
