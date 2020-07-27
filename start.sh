# Config Options (Required)
ILAT=""
ILNG=""
IRADIUS=""

echo -n "<?xml version='"1.0"' encoding='"UTF-8"'?><kml xmlns='"http://www.opengis.net/kml/2.2"'><Document>" >> output1.kml
curl "https://api.stagecoach-technology.net/vehicle-tracking/v1/vehicles?client_version=UKBUS_APP&descriptive_fields=1&lat=${ILAT}&lng=${ILNG}&radius=${IRADIUS}" --silent -o response.json
returnedItemCount=$(cat response.json | jq -c -r '.header.returnedItemCount')
for (( n=0; n<=$returnedItemCount-1; n++ ))
do
LAT=$(cat response.json | jq -r '.services['$n'].latitude')
LNG=$(cat response.json | jq -r '.services['$n'].longitude')
SRVNUM=$(cat response.json | jq -r '.services['$n'].serviceNumber')
SRVDESC=$(cat response.json | jq -r '.services['$n'].serviceDescription')
echo -n "<Placemark><name>$SRVDESC</name><description>$SRVNUM</description><Point><coordinates>$LNG,$LAT,0</coordinates></Point></Placemark>" >> output1.kml
done
echo -n "</Document></kml>" >> output1.kml
cat output1.kml > output.kml
rm output1.kml
