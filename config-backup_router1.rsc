# 2025-10-15 12:25:36 by RouterOS 7.19.6
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
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=172.16.20.100-172.16.20.200
add name=dhcp_pool1 ranges=10.10.20.100-10.10.20.200
add name=dhcp_pool2 ranges=172.16.20.100-172.16.20.200
add name=dhcp_pool3 ranges=10.10.20.100-10.10.20.200
add name=dhcp_pool4 ranges=192.168.40.100-192.168.40.200
add name=dhcp_pool5 ranges=10.10.20.100-10.10.23.200
/ip dhcp-server
add address-pool=dhcp_pool2 interface=vlan1-adm lease-time=10m name=dhcp1
add address-pool=dhcp_pool4 interface=vlan20-guest lease-time=10m name=dhcp3
add address-pool=dhcp_pool5 interface=vlan10-ws lease-time=10m name=dhcp2
/interface bridge port
add bridge=bridge-lan interface=ether2
add bridge=bridge-lan interface=ether3 pvid=10
add bridge=bridge-lan interface=ether4 pvid=20
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/interface bridge vlan
add bridge=bridge-lan tagged=bridge-lan untagged=ether2 vlan-ids=1
add bridge=bridge-lan tagged=bridge-lan untagged=ether3 vlan-ids=10
add bridge=bridge-lan tagged=bridge-lan untagged=ether4 vlan-ids=20
/ip address
add address=172.16.20.1/24 interface=vlan1-adm network=172.16.20.0
add address=10.10.20.1/22 interface=vlan10-ws network=10.10.20.0
add address=192.168.40.1/24 interface=vlan20-guest network=192.168.40.0
/ip dhcp-client
add default-route-tables=main interface=ether1
/ip dhcp-server network
add address=10.10.20.0/24 dns-server=8.8.8.8 gateway=10.10.20.1
add address=10.10.20.0/22 dns-server=8.8.8.8 gateway=10.10.20.1
add address=172.16.20.0/24 dns-server=8.8.8.8 gateway=172.16.20.1
add address=192.168.40.0/24 dns-server=8.8.8.8 gateway=192.168.40.1
/ip firewall filter
add action=drop chain=input comment="Block all inbound WAN to router" \
    in-interface=ether1
add action=accept chain=forward comment="Allow ADM to WS" dst-address=\
    10.10.20.0/22 src-address=172.16.20.0/24
add action=accept chain=forward comment="Allow WS to ADM" dst-address=\
    172.16.20.0/24 src-address=10.10.20.0/22
add action=drop chain=forward comment="Block GUEST to ADM" dst-address=\
    172.16.20.0/24 src-address=192.168.40.0/24
add action=drop chain=forward comment="Block ADM to GUEST" dst-address=\
    192.168.40.0/24 src-address=172.16.20.0/24
add action=drop chain=forward comment="Block GUEST to WS" dst-address=\
    10.10.20.0/22 src-address=192.168.40.0/24
add action=drop chain=forward comment="Block WS to GUEST" dst-address=\
    192.168.40.0/24 src-address=10.10.20.0/22
add action=drop chain=forward comment="Drop everything else" disabled=yes
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/system clock
set time-zone-name=Europe/Tallinn
/system identity
set name=Sander-Projekt1
