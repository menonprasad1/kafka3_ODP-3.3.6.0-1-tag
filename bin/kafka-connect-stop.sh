
#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
SIGNAL=${SIGNAL:-TERM}

OSNAME=$(uname -s)
if [[ "$OSNAME" == "OS/390" ]]; then
    if [ -z $JOBNAME ]; then
        JOBNAME="KAFKSTRT"
    fi
    PIDS=$(ps -A -o pid,jobname,comm | grep -i $JOBNAME | grep java | grep -v grep | awk '{print $1}')
elif [[ "$OSNAME" == "OS400" ]]; then
    PIDS=$(ps -Af | grep -i 'org\.apache\.kafka\.connect\.cli\.ConnectDistributed' | grep java | grep -v grep | awk '{print $2}')
else
    PIDS=$(ps ax | grep ' org\.apache\.kafka\.connect\.cli\.ConnectDistributed ' | grep java | grep -v grep | awk '{print $1}')
fi

if [ -z "$PIDS" ]; then
  echo "No kafka Connect to stop"
else
  kill -s $SIGNAL $PIDS
fi