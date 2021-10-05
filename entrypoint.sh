#!/bin/sh

> output.json

currentDate=`date`
echo $currentDate

for number in $(seq 1 20)
do
echo https://app.alturanft.com/api/pair/detail/0xdb0047cb1dfc44696f6e9868ef6bb40000280b05/$number
echo https://app.alturanft.com/item/0xdb0047cb1dfc44696f6e9868ef6bb40000280b05/$number
curl https://app.alturanft.com/api/pair/detail/0xdb0047cb1dfc44696f6e9868ef6bb40000280b05/$number | jq  > output.json
cat output.json | jq ".items[] | select(.currency == \"0x8263cd1601fe73c066bf49cc09841f35348e3be0\" and (.price < 5000)) | {price, tokenId}" | jq  > result.json

file=result.json
cat result.json
if [ -f "$file" -a -s "$file" ]; then
    echo "exist and not empty"
    echo https://app.alturanft.com/item/0xdb0047cb1dfc44696f6e9868ef6bb40000280b05/$number >> result.json
    notify -data result.json -bulk
else
    echo "not exist or empty";
fi

done
exit 0

