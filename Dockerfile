FROM engineyard/kontainers:ruby-2.5-v1.0.0

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev

RUN curl -L https://github.com/papertrail/remote_syslog2/releases/download/v0.20/remote_syslog_linux_amd64.tar.gz --output remote_syslog_linux_amd64.tar.gz &&\
    tar -xvf remote_syslog_linux_amd64.tar.gz &&\
    cp remote_syslog/remote_syslog /usr/bin

RUN mkdir /app
WORKDIR /app
COPY . /app
RUN bundle 

ARG papertrail_host
ARG papertrail_port
RUN erb -T - ./papertrail_config.yml.erb > /etc/log_files.yml

CMD remote_syslog && bundle exec rails s -b 0.0.0.0 -p 5000