FROM land007/n2n-edge:latest

MAINTAINER Jia Yiqiu <yiqiujia@hotmail.com>

RUN apt-get update && apt-get install -y python ffmpeg && apt-get clean
ADD install.sh /root/
RUN chmod +x /root/install.sh && /root/install.sh
ENV NVM_DIR=/root/.nvm \
#	SHIPPABLE_NODE_VERSION=v8.11.1
#	SHIPPABLE_NODE_VERSION=v8.14.0
#	SHIPPABLE_NODE_VERSION=v9.11.1
	SHIPPABLE_NODE_VERSION=v9.11.2
#	SHIPPABLE_NODE_VERSION=v10.13.0
#	SHIPPABLE_NODE_VERSION=v10.14.1
RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && cd / && npm init -y && npm install -g node-gyp supervisor http-server && npm install socket.io ws express http-proxy bagpipe eventproxy pty.js chokidar request nodemailer await-signal log4js moment ssh2 && \
#RUN . $HOME/.nvm/nvm.sh && nvm install $SHIPPABLE_NODE_VERSION && nvm alias default $SHIPPABLE_NODE_VERSION && nvm use default && npm install gulp babel  jasmine mocha serial-jasmine serial-mocha aws-test-worker -g && \
#	. $HOME/.nvm/nvm.sh && cd / && npm install pty.js && \
	. $HOME/.nvm/nvm.sh && which node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/node /usr/bin/node
#RUN ln -s /root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin/supervisor /usr/bin/supervisor
ENV PATH $PATH:/root/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/bin

# Define working directory.
#RUN mkdir /node
ADD node /node
RUN ln -s $HOME/.nvm/versions/node/$SHIPPABLE_NODE_VERSION/lib/node_modules /node && \
#	sed -i 's/\r$//' /node/start.sh && chmod a+x /node/start.sh && \
	ln -s /node ~/ && ln -s /node /home/land007 && \
	mv /node /node_
WORKDIR /node
VOLUME ["/node"]

RUN echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/n2n-edge-forward" >> /.image_names && \
	echo "land007/n2n-edge-forward" > /.image_name

EXPOSE 80/tcp
#CMD /check.sh /node ; /etc/init.d/ssh start ; /node/start.sh
RUN echo "/check.sh /node" >> /task.sh && \
#RUN echo "supervisor -w /node/ /node/server.js" >> /start.sh && \
#	echo "/usr/bin/nohup supervisor -w /node/ /node/server.js > /node/node.out 2>&1 &" >> /start.sh
	echo "supervisor -w /node/ /node/server.js" >> /start.sh

#docker build -t land007/n2n-edge-forward:latest .
#> docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t land007/n2n-edge-forward:latest --push .
#docker rm -f n2n-edge-forward; docker run -it --privileged --network host --restart=always --log-opt max-size=1m --log-opt max-file=1 --name n2n-edge-forward -e "CONNECT=127.0.0.1:30151" -e "IP=192.168.11.21" land007/n2n-edge-forward:latest
#docker rm -f watchtower; docker run -it --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 30 --label-enable
#docker rm -f n2n-edge-forward; docker run -it --privileged --network host --restart=always --log-opt max-size=1m --log-opt max-file=1 --name n2n-edge-forward -e "CONNECT=127.0.0.1:30151" --label=com.centurylinklabs.watchtower.enable=true -e "IP=192.168.11.1" -e "GROUP=openwrt" -p 20022:20022 -p 13389:3389 -p 10022:22 land007/n2n-edge-forward:latest
