# Tunneling

## Ssh tunnels

    ssh -f -L 8080:localhost:80 root@server2 -N

Listens locally on 8080 and tunnels to srver2, then calling into localhost:80

Locate the tunnel to then kill it:

    ps -ef | grep ssh

## VPN

Yum install epel-release

Yum install openvpn easy-rsa

cp /usr/share/doc/openvpn-x.x.x/sample/sample-config-files/server.conf /etc/openvpn

edit conflict file then

mkdir -p /etc/openvpn/easy-rsa/keys
cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa/

### VPN Client

On VPN server, generate client key

systemctl enable openvpn@server

systemctl start openvpn@server

Network details for VPN will appear under the ip addr command

Client needs to get a copy of the various cert info

Boring


