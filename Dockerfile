FROM --platform=linux/amd64 registry.fedoraproject.org/fedora-minimal:38-x86_64

LABEL org.opencontainers.image.source https://github.com/OliveTin/OliveTin
LABEL org.opencontainers.image.title=OliveTin

RUN mkdir -p /config /config/entities/ /var/www/olivetin \
    && \
	microdnf install -y dnf-plugins-core \
        && microdnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo \
	&& microdnf install -y --nodocs --noplugins --setopt=keepcache=0 --setopt=install_weak_deps=0 \
		iputils \
		openssh-clients \
		shadow-utils \
		apprise \
		jq \
		docker \
  		docker-compose-plugin \
	&& microdnf clean all

RUN useradd --system --create-home olivetin -u 1000

EXPOSE 1337/tcp

COPY config.yaml /config
COPY var/entities/* /config/entities/
VOLUME /config

COPY OliveTin /usr/bin/OliveTin
COPY webui /var/www/olivetin/

USER olivetin

ENTRYPOINT [ "/usr/bin/OliveTin" ]
