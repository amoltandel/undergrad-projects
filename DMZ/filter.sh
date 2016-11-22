#dmz setup
iptables -F
iptables -t nat -F
#
#1 DEFAULT DROP POLICY FOR ALL CHAINS
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP


#2 PREROUTE THE HTTP PACKETS OF SUBNET 192.168.1.0 to server on 192.168.1.2 
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 192.168.1.2:80
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 192.168.1.2:443



#3 ALLOW HTTPS/HTTPS and SSH connections to the WEBSERVER only for DMZ
iptables -A INPUT -p tcp -m multiport --sport 80,443 -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --sport 80,443 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dport 80,443 -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dport 80,443 -j ACCEPT

#4 Allow ssh for internal network only
iptables -A INPUT -i eth1 -p tcp -m multiport --sport 22,23 -j ACCEPT
iptables -A OUTPUT -o eth1 -p tcp -m multiport --sport 22,23 -j ACCEPT
iptables -A INPUT -i eth1 -p tcp -m multiport --dport 22,23 -j ACCEPT
iptables -A OUTPUT -o eth1 -p tcp -m multiport --dport 22,23 -j ACCEPT

#4 Allow HTTP/HTTPS traffic from outside network
iptables -A FORWARD -p tcp -m multiport --sport 80,443 -j ACCEPT
iptables -A FORWARD -p tcp -m multiport --dport 80,443 -j ACCEPT

iptables -L -v
iptables -t nat -L -v