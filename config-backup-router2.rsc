# 2025-09-11 14:23:51 by RouterOS 7.19.6
# software id = EIDY-MLTG
#
# model = RB962UiGS-5HacT2HnT
# serial number = HEN08ZVS9G6
/interface bridge
add name=bridge-lan vlan-filtering=yes
/interface wireless
set [ find default-name=wlan1 ] ssid=MikroTik
set [ find default-name=wlan2 ] ssid=MikroTik
/interface vlan
add interface=bridge-lan name=vlan1-adm vlan-id=1
add interface=bridge-lan name=vlan10-ws vlan-id=10
add interface=bridge-lan name=vlan20-guest vlan-id=20
add interface=bridge-lan name=vlan30-dmz vlan-id=30
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec peer
add address=192.168.75.111/32 exchange-mode=ike2 name=peer1 port=500
/ip pool
add name=dhcp_pool0 ranges=172.16.10.100-172.16.10.200
add name=dhcp_pool1 ranges=10.10.10.100-10.10.11.200
add name=dhcp_pool2 ranges=192.168.20.100-192.168.20.200
add name=dhcp_pool3 ranges=10.11.12.100-10.11.12.200
/ip dhcp-server
add address-pool=dhcp_pool0 interface=vlan1-adm lease-time=10m name=dhcp1
add address-pool=dhcp_pool1 interface=vlan10-ws lease-time=10m name=dhcp2
add address-pool=dhcp_pool2 interface=vlan20-guest lease-time=10m name=dhcp3
add address-pool=dhcp_pool3 interface=vlan30-dmz lease-time=10m name=dhcp4
/interface bridge port
add bridge=bridge-lan interface=ether2
add bridge=bridge-lan interface=ether3 pvid=10
add bridge=bridge-lan interface=ether4 pvid=20
add bridge=bridge-lan interface=ether5 pvid=30
/interface bridge vlan
add bridge=bridge-lan tagged=bridge-lan untagged=ether2 vlan-ids=1
add bridge=bridge-lan tagged=bridge-lan untagged=ether3 vlan-ids=10
add bridge=bridge-lan tagged=bridge-lan untagged=ether4 vlan-ids=20
add bridge=bridge-lan tagged=bridge-lan untagged=ether5 vlan-ids=30
/ip address
add address=172.16.10.1/24 interface=vlan1-adm network=172.16.10.0
add address=10.10.10.1/22 interface=vlan10-ws network=10.10.8.0
add address=192.168.20.1/24 interface=vlan20-guest network=192.168.20.0
add address=10.11.12.1/24 interface=vlan30-dmz network=10.11.12.0
/ip dhcp-client
add default-route-tables=main interface=ether1
/ip dhcp-server network
add address=10.10.8.0/22 dns-server=8.8.8.8 gateway=10.10.10.1
add address=10.11.12.0/24 dns-server=8.8.8.8 gateway=10.11.12.1
add address=172.16.10.0/24 dns-server=8.8.8.8 gateway=172.16.10.1
add address=192.168.20.0/24 dns-server=8.8.8.8 gateway=192.168.20.1
/ip firewall filter
add action=accept chain=input comment="Allow IPsec IKE/NAT-T" dst-port=\
    500,4500 protocol=udp
add action=accept chain=input comment="Allow IPsec ESP" protocol=ipsec-esp
add action=accept chain=forward comment="Allow ADM to WS IPsec in,ipsec" \
    dst-address=10.10.20.0/22 ipsec-policy=in,ipsec src-address=\
    172.16.10.0/24
add action=accept chain=forward comment="Allow ADM to WS IPsec out,ipsec" \
    dst-address=10.10.20.0/22 ipsec-policy=in,ipsec src-address=\
    172.16.10.0/24
add action=accept chain=forward comment="Allow WS to ADM IPsec in,ipsec" \
    dst-address=172.16.20.0/24 ipsec-policy=in,ipsec src-address=10.10.8.0/22
add action=accept chain=forward comment="Allow WS to ADM IPsec out,ipsec" \
    dst-address=172.16.20.0/24 ipsec-policy=in,ipsec src-address=10.10.8.0/22
add action=drop chain=input comment="Block all inbound WAN to router." \
    in-interface=ether1
add action=accept chain=forward comment="Allow ADM to WS" dst-address=\
    10.10.8.0/22 src-address=172.16.10.0/24
add action=accept chain=forward comment="Allow WS to ADM" dst-address=\
    172.16.10.0/24 src-address=10.10.8.0/22
add action=drop chain=forward comment="Block GUEST to ADM" dst-address=\
    172.16.10.0/24 src-address=192.168.20.0/24
add action=drop chain=forward comment="Block ADM to GUEST" dst-address=\
    192.168.20.0/24 src-address=172.16.10.0/24
add action=drop chain=forward comment="Block GUEST to DMZ" dst-address=\
    10.11.12.0/24 src-address=192.168.20.0/24
add action=drop chain=forward comment="Block DMZ to GUEST" dst-address=\
    192.168.20.0/24 src-address=10.11.12.0/24
add action=drop chain=forward comment="Block GUEST to WS" dst-address=\
    10.10.8.0/22 src-address=192.168.20.0/24
add action=drop chain=forward comment="Block WS to GUEST" dst-address=\
    192.168.20.0/24 src-address=10.10.8.0/22
add action=drop chain=forward comment="Block WS to DMZ" dst-address=\
    10.11.12.0/24 src-address=10.10.8.0/22
add action=drop chain=forward comment="Block DMZ to WS" dst-address=\
    10.10.8.0/22 src-address=10.11.12.0/24
add action=accept chain=forward comment="Allow WAN to DMZ HTTP" dst-address=\
    10.11.12.0/24 dst-port=80 in-interface=ether1 protocol=tcp
add action=accept chain=forward comment="Allow WAN to DMZ HTTPS" dst-address=\
    10.11.12.0/24 dst-port=443 in-interface=ether1 protocol=tcp
add action=drop chain=forward comment="Drop everything else" disabled=yes
/ip firewall nat
add action=accept chain=srcnat dst-address=172.16.20.0/24 src-address=\
    10.10.8.0/22
add action=accept chain=srcnat dst-address=10.10.20.0/22 src-address=\
    172.16.10.0/24
add action=masquerade chain=srcnat out-interface=ether1
/ip ipsec identity
add peer=peer1
/ip ipsec policy
add dst-address=172.16.20.0/24 peer=peer1 src-address=10.10.8.0/22 tunnel=yes
add dst-address=10.10.20.0/22 peer=peer1 src-address=172.16.10.0/24 tunnel=\
    yes
/system clock
set time-zone-name=Europe/Tallinn
/system identity
set name=Sander-Projekt2
