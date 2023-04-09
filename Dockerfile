FROM ubuntu:latest
RUN apt-get update -qq && apt-get install -y net-tools iputils-ping
CMD [ "ifconfig | grep "inet" | awk '{print $2}' | head -n 1" , "docker run -it ubuntu"]
