FROM debian:jessie

ARG GRAFANA_VERSION

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates && \
    apt-get clean && \
    curl https://grafanarel.s3.amazonaws.com/builds/grafana_3.1.1-1470047149_amd64.deb > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN grafana-cli plugins install grafana-piechart-panel && \
	grafana-cli plugins install mtanda-histogram-panel && \
	grafana-cli plugins install grafana-worldmap-panel && \
	grafana-cli plugins install savantly-heatmap-panel && \
	grafana-cli plugins install mtanda-heatmap-epoch-panel

VOLUME ["/var/lib/grafana", "/var/lib/grafana/plugins", "/var/log/grafana", "/etc/grafana"]

#Add shell script with startup commands
ADD docker_files/grafana-run.sh /apps/grafana-run.sh
ADD docker_files/debug-run.sh /apps/debug-run.sh
RUN chmod a+x /apps/*.sh

EXPOSE 3000

CMD ["/bin/bash"]
