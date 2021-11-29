export PROJECT_HOME="/ds1/pdi/vtop/HRIT/cb_location_dummy/cb_location_dummy/PDI/Common"
#The following line will be added to the top of the file by the deployment script. Commented here to show an example. 
#export PROJECT_HOME="/ds1/pdi/vtop/HRIT/cb_location_dummy/cb_location_dummy/PDI/Common"

#script which calls kettle by passing job path.
echo "run the kettle or anything you want"

export LOG_DIR="/ds1/pdi/data/CB/log/cb_location_dummy"

if [ ! -d ${LOG_DIR} ]; then
  mkdir -p ${LOG_DIR}
fi

file_folder_name=`date +%Y-%m-%d`

log_date=`date +%Y%m%d-%H%M%S`
log_ext='.log'
log_file=${LOG_DIR}/$file_folder_name/'cb_location_dummy-'$log_date$log_ext

echo "Log File Name is $log_file"

mkdir -p ${LOG_DIR}/$file_folder_name

/ds1/pdi/pdi-ce/kitchen.sh  -file=${PROJECT_HOME}/main.kjb -param:PROJECT_HOME=${PROJECT_HOME} -param:LOG_FILE_PATH=${log_file} -level:Detailed -logfile=${log_file} "$@"

ce=`grep ERROR $log_file|wc -l`
host_name=`hostname`
current_date_time=`date +%Y%m%d-%H%M%S`
if  [ $ce -gt 0 ]; then
  {
    grep 'ERROR' $log_file
    echo ""
    echo "Send on :-"$current_date_time
    echo "Log file path - "$log_file
  } | mailx -s $host_name' - CB cb_location_dummy PDI Process - ' -r noreply@kuehne-nagel.com amer.hrit.support@kuehne-nagel.com
fi