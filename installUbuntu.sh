#From the sensor download page get the hash of the installer
export SENSOR_HASH= && \
export FALCON_CLIENT_ID= && \
export FALCON_CLIENT_SECRET= && \
export FALCON_CID= && \
export FALCON_CLOUD_REGION=eu-1 && \
export FALCON_CLOUD_API=api.eu-1.crowdstrike.com

FALCON_API_BEARER_TOKEN=$(curl \
--silent \
--header "Content-Type: application/x-www-form-urlencoded" \
--data "client_id=${FALCON_CLIENT_ID}&client_secret=${FALCON_CLIENT_SECRET}" \
--request POST \
--url "https://$FALCON_CLOUD_API/oauth2/token" | \
python3 -c "import sys, json; print(json.load(sys.stdin)['access_token'])"
)


#SENSOR_HASH=${SENSOR_HASH//[\[\'\]]/}

curl --request GET \
--url "https://${FALCON_CLOUD_API}/sensors/entities/download-installer/v1?id=$SENSOR_HASH" \
--header "authorization: Bearer ${FALCON_API_BEARER_TOKEN}" \
--header 'Accept: application/json' \
-o installer3.deb

#Install on Ubuntu

sudo dpkg -i installer.deb
sudo /opt/CrowdStrike/falconctl -s --cid=$FALCON_CID
sudo service falcon-sensor start

#Check installer
ps -e | grep falcon-sensor
