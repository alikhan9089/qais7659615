#/bin/bash

/opt/glassfish4/bin/asadmin start-domain domain1
/opt/glassfish4/bin/asadmin deploy --force --contextroot frok /home/workspace/frok-download-server/target/frok-1.0-SNAPSHOT
/home/workspace/frok-server/build/build_release/bin/FrokAgentApp $@
