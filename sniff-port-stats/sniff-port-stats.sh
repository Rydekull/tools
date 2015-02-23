#!/usr/bin/env bash

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
which tshark > /dev/null 2>&1
if [ $? != 0 ] 
then
  echo "Needs tshark installed to operate, you can usually get it with wireshark."
  exit 99
fi

SNIFF_DURATION=${SNIFF_DURATION:-60}    
SNIFF_DUMPFILE=${SNIFF_DUMPFILE:-/tmp/dump.cap}

function p () {
  echo $(date '+%Y%m%d %H:%M:%S') $1
}

function usage () {
  echo "$(basename $0) -dump <interface> | -print <file>"
  echo
  echo "Configuration:"
  echo "  Dumpfile: SNIFF_DUMPFILE=${SNIFF_DUMPFILE}"
  echo "  Duration: SNIFF_DURATION=${SNIFF_DURATION} # seconds"
  echo
  echo "You can set the above by exporting the variables in your shell."
  echo
  echo "Do not forget to specify the interface when you run the command."
  echo "  Example: $(basename $0) -dump eth0"
  exit 1
}

if [ -z $1 ]
then
  usage
fi

if [ "$1" = "-dump" ]
then
  if [ ! -z $2 ]
  then
    SNIFF_INTERFACE=${2}
  fi

  p "Dumping data from ${SNIFF_INTERFACE} for ${SNIFF_DURATION} seconds into ${SNIFF_DUMPFILE}..."
  tshark -i ${SNIFF_INTERFACE} -q -a duration:${SNIFF_DURATION} -w ${SNIFF_DUMPFILE} > /dev/null 2>&1 
  p "Done"
elif [ "$1" = "-print" ]
then
  if [ ! -z $2 ]
  then
    SNIFF_DUMPFILE=${2}
  fi

  echo "UDP Statistics"
  echo -e "# Count\tPort\tSrc\t\tDest"
  tshark -nn -r ${SNIFF_DUMPFILE} -T fields -E separator=';' -e udp.dstport -e ip.src -e ip.dst udp 2>&1 | grep -v "^Running" | sed 's/;/\t/g' | sort -n | uniq -c | sort -n
  echo
  echo "TCP Statistics"
  echo -e "# Count\tPort\tSrc\t\tDest"
  tshark -nn -r ${SNIFF_DUMPFILE} -T fields -E separator=';' -e tcp.dstport -e ip.src -e ip.dst '(tcp.flags.syn == 1 and tcp.flags.ack == 0)' 2>&1 | grep -v "^Running" | sed 's/;/\t/g' | sort -n | uniq -c | sort -n
else
  usage
fi
