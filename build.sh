pushd carrier_infinity_network
sh build.sh
popd 
pushd carrier_infinity_thermostat
sh build.sh
popd
scp carrier_infinity_network/carrier_infinity.c4z carrier_infinity_thermostat/carrier_infinity_thermostat.c4z root@10.10.219.167:/etc/c4i
