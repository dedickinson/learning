# The web server here is used by NAT-based VMs to PXE boot.

if [ "$http_ps" == "" ] 
then
    echo "Starting web service"
    (cd http&&python -m http.server>../webserver.log)&
else
    echo "Web service is already running under process $http_ps"
fi