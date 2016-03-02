# Pull image from local repository or DockerHub.
 FROM ubuntu:latest
 MAINTAINER bekberov <bekberovkerim@gmail.com>

# Add file *.sh
 ADD prepared_file.sh /usr/local/bin/


# Install RabbitMQ.
 RUN apt-get install -y  wget
 RUN wget -qO - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -
 RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
 RUN apt-get update
 RUN DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server
 RUN rm -rf /var/lib/apt/lists/*
 RUN rabbitmq-plugins enable rabbitmq_management
 RUN echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config
 RUN chmod +x /usr/local/bin/prepared_file.sh



# Define environment variables for db-files and log.
 ENV RABBITMQ_LOG_BASE /data/log
 ENV RABBITMQ_MNESIA_BASE /data/mnesia


# Define mount volume.
 VOLUME ["/data/log", "/data/mnesia"]


# Define working directory (home dir which we start to work).
 WORKDIR /var/lib/rabbitmq


# Define default command.
 CMD ["prepared_file.sh"]


# Opening ports for rabbitmq infrastructure services
# 5672 rabbitmq-server - amqp port
# 15672 rabbitmq-server - for management plugin
# 4369 epmd - for clustering
# 25672 rabbitmq-server - for clustering

 EXPOSE 5672 15672 4369 25672
