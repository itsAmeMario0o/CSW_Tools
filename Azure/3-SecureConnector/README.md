Secure Connector - Background

Create API key - external system integration capability

Update `secureconnector.sh` with HOST, API_KEY, API_SECRET and ROOTSCOPE_NAME. Run the script to retrieve the registration token

HOST=https://mytaas.portal.com
API_KEY="API KEY HERE"
API_SECRET="SECRET HERE"
ROOTSCOPE_NAME="MYROOTSCOPE"

`./secureconnector.sh`

Stop the secure connector and copy the registration token. Once the token is copied, start the secure connector. At this point the connector is fully set up

`sudo systemctl stop tetration-secure-connector`

`sudo cp registration.token /etc/tetration/cert/registration.token`

`sudo systemctl start tetration-secure-connector`
