#!/bin/bash
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

sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' -e '/parameter real   P_FREERUN_FREQUENCY/ c \  parameter real   P_FREERUN_FREQUENCY    = 195.3125,' ./gtwizard_ultrascale_0_example_init.v > DLx_phy_example_init.v
