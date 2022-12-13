#!/usr/bin/env bash
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


echo '##############################################################################################'
echo '## Waived errors not found in ice/synthesize.log ############################################'
echo '##############################################################################################'
while read p; do
    if ! grep -Fq "$p" ice/synthesize.log; then
        echo "$p" | sed -ue 's/^.*$/\x1b[41m&\x1b[m/g'
    fi
done < waived_warnings.txt

declare -a logs=("synthesize.log" "implement_*.log")

for log_file in "${logs[@]}"
do
    echo "##############################################################################################"
    echo "## Unwaived errors and warnings in $log_file"
    echo "##############################################################################################"
    grep "^WARNING: " ice/${log_file} | grep -Fvf waived_warnings.txt | sed -ue 's/^WARNING.*$/\x1b[33m&\x1b[m/g'
    grep "^CRITICAL WARNING: " ice/${log_file} | grep -Fvf waived_warnings.txt | sed -ue 's/^CRITICAL WARNING.*$/\x1b[45m&\x1b[m/g'
    grep "^ERROR: " ice/${log_file} | sed -ue 's/^ERROR.*$/\x1b[41m&\x1b[m/g'
done
