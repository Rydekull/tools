sniff-port-stats.sh
========================

Example output:

[root@server]# ./sniff-port-stats.sh 
sniff-port-stats.sh -dump <interface> | -print <file>

Configuration:
  Dumpfile: SNIFF_DUMPFILE=/tmp/dump.cap
  Duration: SNIFF_DURATION=300 # seconds

You can set the above by exporting the variables in your shell.

Do not forget to specify the interface when you run the command.
  Example: sniff-port-stats.sh -dump eth0
[root@server]# export SNIFF_DURATION=300
[root@server]# ./sniff-port-stats.sh -dump wlp3s0
20150223 17:04:51 Dumping data from wlp3s0 for 300 seconds into /tmp/dump.cap...
20150223 17:09:51 Done
[root@server]# ./sniff-port-stats.sh -print 
UDP Statistics
# Count	Port	Src		Dest
      1 10321	192.168.10.1	192.168.10.211
      1 123	192.168.10.211	x.x.x.x
      1 25323	192.168.10.1	192.168.10.211
      1 25348	192.168.10.1	192.168.10.211
      1 27970	192.168.10.1	192.168.10.211
      1 30307	192.168.10.1	192.168.10.211
      1 37703	x.x.x.x		192.168.10.211
      1 38318	192.168.10.1	192.168.10.211
      1 39013	192.168.10.1	192.168.10.211
      1 58969	192.168.10.1	192.168.10.211
      1 62625	192.168.10.1	192.168.10.211
      1 9768	192.168.10.1	192.168.10.211
      2 42806	192.168.10.1	192.168.10.211
      4 34667	192.168.10.207	192.168.10.211
      4 42080	192.168.10.207	192.168.10.211
      4 43056	192.168.10.207	192.168.10.211
      4 53963	192.168.10.207	192.168.10.211
      4 60195	192.168.10.207	192.168.10.211
      8 5353	192.168.10.207	224.0.0.251
      9 5353	192.168.10.211	224.0.0.251
     12 53	192.168.10.211	192.168.10.1
     20 1900	192.168.10.211	x.x.x.x
    170 60001	192.168.10.211	192.168.10.232
    398 32963	192.168.10.232	192.168.10.211

TCP Statistics
# Count	Port	Src		Dest
      1 443	192.168.10.211	x.x.x.x
      1 443	192.168.10.211	x.x.x.x
      2 443	192.168.10.211	x.x.x.x
      2 80	192.168.10.211	x.x.x.x
      3 80	192.168.10.211	x.x.x.x
    233 443	192.168.10.211	192.168.10.232
[root@server]# 
