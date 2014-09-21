frok-linux
==========

Docker image for frok project
To download compiled image run: `sudo docker pull dobrygnom/frok-linux`

To compile from downloaded repo run in Dockerfile folder: `sudo docker build -t <name_of_result_image>`

To start frok-server (with ds) run: `sudo docker run -t -i -d --restart="always" -p 8080:8080 dobrygnom/frok-linux /bin/bash /start.sh 1 27015`
