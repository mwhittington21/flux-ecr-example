FROM quay.io/weaveworks/flux:1.4.1
RUN /sbin/apk -v --update add \
        jq \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
    /sbin/apk -v --purge del py-pip && \
    rm /var/cache/apk/*

COPY make_docker_config_json.sh /usr/local/bin/make_docker_config_json.sh
COPY run_flux.sh /usr/local/bin/run_flux.sh

VOLUME /root/.aws
VOLUME /project
WORKDIR /project
# us-east-1 is an example default here
ENTRYPOINT [ "/sbin/tini", "--", "/usr/local/bin/run_flux.sh"]
