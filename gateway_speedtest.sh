#!/bin/bash
DEVICE_MAC=$1
IP=$2
SAT_CLIENT_ID=$3
SAT_CLIENT_SECRET=$4
echo " "
echo ">>>>>>>>>>>>>>>> START >>>>>>>>>>>>>>>>> cmmac: $1 >>>>>>>>>>>>>>>>>>>>>>>> IP: $2 "


APIGW="https://rest.imp.comcast.net"
SAT_TOKEN=$(curl -s --request POST   --url https://sat-prod.codebig2.net/oauth/token   --header "x-client-id:x1:speedtest_cpe_qa:7ed9bc"   --header "x-client-secret:dd3e08298d23d85ca29d897c2c17e5ee" | cut -d ':' -f 2 | cut -d "," -f 1 | tr -d '"')

#SAT_TOKEN=$(curl --request POST   --url https://sat-prod.codebig2.net/oauth/token   --header "x-client-id: $SAT_CLIENT_ID"   --header "x-client-secret: $SAT_CLIENT_SECRET" | jq  -r '.access_token' )
#echo $SAT_TOKEN '
#echo $SAT_TOKEN
if [ $2 == "ipv4" ];
    then
        OPTION="OPTION_IPV4_ONLY"
    else
        OPTION="OPTION_IPV6_ONLY"
fi


# for each device in the file, run ipv4-only or ipv6-only with random seleciton


        DEVICE=$(echo $DEVICE_MAC | tr 'A-Z' 'a-z')

        curl --request POST --url $APIGW/api/v2/measurement/new --header 'authorization: Bearer '$SAT_TOKEN'' --data '{
        "device_id": "'$DEVICE'",
        "reason": "rdkb_cpe_qa",
        "bandwidth": {
        "standard_bandwidth": {
            "ip_option": "'$OPTION'",
            "direction": "DIRECTION_BOTH"
        }
    }
}
'
echo
echo
echo "---->>>>: If there is no error in the response above^, test may take around 30-60sec to complete. Check atom side /rdklogs/logs/SpeedtestLog.txt.0 for the results"