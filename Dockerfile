FROM docker:latest

ENV GCLOUD_SDK_URL="https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz" \
    PATH="/opt/google-cloud-sdk/bin:${PATH}"

WORKDIR /opt/app

RUN apk --update --no-cache add \
        bash \
        ca-certificates \
        curl \
        openssl \
        python && \
    curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.16.8/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl && \
    wget -O - -q "${GCLOUD_SDK_URL}" | tar zxf - -C /opt && \
    ln -s /lib /lib64 && \
    ln -s /opt/google-cloud-sdk/bin/docker-credential-gcr /usr/local/bin/docker-credential-gcloud && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set core/disable_prompts true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud components install docker-credential-gcr && \
    gcloud --version && \
    rm -rf /tmp/* && rm -rf /opt/google-cloud-sdk/.install/.backup
