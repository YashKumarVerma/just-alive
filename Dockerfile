FROM ubuntu:22.10

RUN apt-get update  -y
RUN apt-get upgrade -y

RUN apt install zsh -y
RUN apt install curl -y
RUN apt install git -y
RUN apt install vim -y
RUN apt install telnet -y 
RUN apt install openssh-server -y
RUN service ssh start
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN apt install screen -y

RUN touch init.sh

# setting up prometheus to collect metrics
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz
RUN tar -xvf prometheus-2.39.1.linux-amd64.tar.gz
RUN mv prometheus-2.39.1.linux-amd64 prometheus
RUN rm prometheus-2.39.1.linux-amd64.tar.gz

# setup node_exporter
RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
RUN tar -xvf node_exporter-1.4.0.linux-amd64.tar.gz
RUN mv node_exporter-1.4.0.linux-amd64 node_exporter
RUN rm node_exporter-1.4.0.linux-amd64.tar.gz

# setup grafana
RUN apt install adduser libfontconfig1 -y
RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise_9.1.7_amd64.deb
RUN dpkg -i grafana-enterprise_9.1.7_amd64.deb
RUN rm grafana-enterprise_9.1.7_amd64.deb

COPY ./dist/app ./app

# preparing startup command
RUN echo "service ssh start" >> init.sh
RUN echo "service grafana-server start" >> init.sh
RUN echo "mv node_exporter prometheus ~/" >> init.sh

ENTRYPOINT [ "./app" ]
