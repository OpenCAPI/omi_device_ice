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


# This script auto-generates registers to capture the git version in
# VHDL and Verilog designs. This is primarily useful to compare
# generated HW with a specific source.

set -eu

# cd to the directory containing this script
cd $(dirname "$(readlink -f "$0")")

# Grab 28 bits of hash
SHORT_HASH=$(git rev-parse --short=7 HEAD)
echo -n "                    Writing meta files for commit ${SHORT_HASH}"

# Check if there are any modified or staged files
if ! git diff-index --quiet HEAD --; then
    DIRTY=1
    echo -n "-dirty"
else
    DIRTY=0
    #echo # Complete newline
fi

# Meta Version Register:
#   BIT 31:29 = was Reserved but are now defined to enter frequency into design code
#   Bit 31:29 = 001=21.33GBPS - 010=23.46GBPS - 011=25.6GBPS
#             - 000 + 100 to 111=unsupported
#   Bit    28 = dirty (1 if repository has untracked or staged changes, 0 otherwise)
#   Bits 27:0 = 7 character git hash
echo " for frequency ${OMI_FREQ} MHz"
if [ ${OMI_FREQ} -eq 333 ]; then
 #Bit 31:29 = 001=21.33GBPS > SPEED_FIELD=2 (1 <<1)
 SPEED_FIELD=2
else
 #Bit 31:29 = 011=25.6GBPS > SPEED_FIELD=6 (4 <<1)
 SPEED_FIELD=6
fi
DIRTY_FIELD=${SPEED_FIELD}+${DIRTY}
QUALIFIER_FIELD=$(printf "%x" $((DIRTY_FIELD * 1)))
META_REGISTER_VALUE="${QUALIFIER_FIELD}${SHORT_HASH}"

META_REGISTER_VERILOG_DEFINE="\`define FIRE_ICE_META_VERSION 32'h${META_REGISTER_VALUE}"
#echo
#echo "Adding in # VERILOG"
#echo "${META_REGISTER_VERILOG_DEFINE}"

read -r -d '' META_REGISTER_VHDL_CONSTANT<<EOM || true
library ieee;
use ieee.std_logic_1164.all;

package meta_pkg is
  constant FIRE_ICE_META_VERSION : std_ulogic_vector(31 downto 0) := x"${META_REGISTER_VALUE}";
end package meta_pkg;
EOM
#echo "Adding in # VHDL"
#echo "${META_REGISTER_VHDL_CONSTANT}"

HEADER_TEXT="This file automatically generated from $(basename -- $0)"
VERILOG_HEADER="// ${HEADER_TEXT}"
VHDL_HEADER="-- ${HEADER_TEXT}"

# Generate vhdl and verilog files. Each file is purposely put on it's
# own line in the for loop to make diffs look good.
#echo
for file in \
    ../${DESIGN}/src/vhdl/meta_pkg.vhdl \
    ; do
    echo "${VHDL_HEADER}" > $file
    echo "${META_REGISTER_VHDL_CONSTANT}" >> $file
    echo "                        Updated ${file}"
done

