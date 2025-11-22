#!/bin/zsh

# data format of log file
# date | server | data size | data rate sender | data rate receiver | IPV4 or IPV6 | local=client or reverse |

# LOGFILE
LOGFILE=~/iperf_measurement
LOGFILE_UL="${LOGFILE}_ul.log"
LOGFILE_DL="${LOGFILE}_dl.log"

# Which servers and corresponding ports
#SERVERS="ping6.online.net"
SERVERS="localhost"
PORTS="5209"

# IPv4 or IPv6"
IPVx="-6"

# FORMAT: kBytes/s
FORMAT="-fK"

# Number of parallel clients
CLIENTS=4

# iperf binary
BIN=$(which iperf3)

# temporary storage of logs
TMP_LOG=$(mktemp)

# Timestamp
TIMEINFO=$(date +"%s")

# Normal mode
${BIN} -c ${SERVERS} -p ${PORTS} -P ${CLIENTS} ${IPVx} ${FORMAT} > ${TMP_LOG}

if [ $? -eq 0 ]; then
	sender="$(cat $TMP_LOG | grep '[SUM]' | tail -n2 | grep sender)"
	receiver="$(cat $TMP_LOG | grep '[SUM]' | tail -n2 | grep receiver)"

	sp_snd="$(echo $sender | awk '{print $6}')"
	sp_rcv="$(echo $receiver | awk '{print $6}')"

	sz_snd="$(echo $sender | awk '{print $4}')"
	sz_rcv="$(echo $receiver | awk '{print $4}')"

	echo -ne "${TIMEINFO}\t${SERVERS}\t${sz_snd}\t${sz_rcv}\t${sp_snd}\t${sp_rcv}\t${IPVx}\tN\n" >> $LOGFILE_UL
fi

${BIN} -c ${SERVERS} -p ${PORTS} -P ${CLIENTS} ${IPVx} ${FORMAT} -R > ${TMP_LOG}
if [ $? -eq 0 ]; then
	sender="$(cat $TMP_LOG | grep '[SUM]' | tail -n2 | grep sender)"
	receiver="$(cat $TMP_LOG | grep '[SUM]' | tail -n2 | grep receiver)"

	sp_snd="$(echo $sender | awk '{print $6}')"
	sp_rcv="$(echo $receiver | awk '{print $6}')"

	sz_snd="$(echo $sender | awk '{print $4}')"
	sz_rcv="$(echo $receiver | awk '{print $4}')"

	echo -ne "${TIMEINFO}\t${SERVERS}\t${sz_snd}\t${sz_rcv}\t${sp_snd}\t${sp_rcv}\t${IPVx}\tR\n" >> $LOGFILE_DL
fi

rm ${TMP_LOG}
