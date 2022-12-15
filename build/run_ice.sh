##
## Copyright 2022 International Business Machines
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
## http://www.apache.org/licenses/LICENSE-2.0
##
## The patent license granted to you in Section 3 of the License, as applied
## to the "Work," hereby includes implementations of the Work in physical form.
##
## Unless required by applicable law or agreed to in writing, the reference design
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## The background Specification upon which this is based is managed by and available from
## the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
##

#=================
DESIGN=ice
STRATEGY_INDEX=17
#=================
START=$(date +%s)
echo "Process starting on $(date)"

#start by removing impl_$STRATEGY_INDEX directpry so that a synthesis failure will stop the process
echo "Erasing previously built ./$DESIGN/synth_1 directory (if any)."
rm -rf $DESIGN/synth_1

./run $DESIGN synthesize.tcl
if [ $(ls .OMI_IPs_$DESIGN* 2>/dev/null | wc -l) -gt 0 ]; then
     #echo "file .OMI_IPs_$DESIGN* exists => IP have been created successfully"
    if [ $(ls ./$DESIGN/synth_1/post_synth.dcp 2>/dev/null | wc -l) -gt 0 ]; then
         #echo "synthesis was succesful"
         echo "Erasing previously built ./$DESIGN/impl_$STRATEGY_INDEX directory (if any)."
         rm -rf $DESIGN/impl_$STRATEGY_INDEX
         ./run $DESIGN implement.tcl $STRATEGY_INDEX

        if [ $(ls ./$DESIGN/impl_$STRATEGY_INDEX/post_route.dcp 2>/dev/null | wc -l) -gt 0 ]; then
             ./run $DESIGN gen_bitstream.tcl $STRATEGY_INDEX
        else 
             echo "Errors during implementation Please check ERRORS in ./$DESIGN/implement_script.log"
             exit
        fi
    else 
         echo "Errors during synthesis. Please check ERRORS in ./$DESIGN/synthesize_script.log"
         exit
    fi
else 
     echo "No .OMI_IPs_$DESIGN* file, erasing incomplete ../ip_created_for_$DESIGN directory!"
     echo "Errors during IP creation. Please check ERRORS in ./$DESIGN/create_ip.log"
     rm -rf ../ip_created_for_$DESIGN dir
     exit
fi

#grep -A2 -m1 WNS $DESIGN/impl_$STRATEGY_INDEX/post_route_timing_summary.rpt
WNS_info=$(grep -A2 -m1 WNS $DESIGN/impl_$STRATEGY_INDEX/post_route_timing_summary.rpt| head -3 | tail -1 | awk '{print $1;}')
echo "======================"
echo "WNS_info is: $WNS_info"

complete_path=$(find * -name "$DESIGN.bit")
path=$(dirname $complete_path)
file_ext=$(basename $complete_path)        # get the filename from the complete path to rename it
file=`echo "$file_ext" | cut -d'.' -f1`    # Removing file extension
#echo "     ./$path/${file}.*"
pref=$(ls .OMI_IPs_$DESIGN*)
prefix="${pref:9}"                         # Removing ".OMI_IPs_" from name
git_version=$(git log --oneline | awk '{print $1;}'|head -n 1) # get 1st word of 1st line containing short git version
newfilename=${prefix}_${git_version}_${WNS_info}
mv $path/$file.bit $path/$newfilename.bit
mv $path/$file.ltx $path/$newfilename.ltx
echo "======================"
echo "= bitstream file for this run is available at:"
echo "=           $path/$newfilename.bit (and .ltx for probes)"
#ls -al $DESIGN
echo "= All bistreams available for $DESIGN are now at:"
find * -name '*.bit'|grep $DESIGN
echo "======================"
echo "Suggested command: run ./print_warnings_$DESIGN.sh"
END=$(date +%s)
echo  "Process ended on $(date)"
echo -n "Process took "
echo $((END-START)) | awk '{printf "%d hrs %02d mins %02d secs", $1/3600, ($1/60)%60, $1%60}'
echo ""

