FROM mysql:5.7
ENV TZ Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /import/

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    net-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ADD database_17032021.sql /import/file.sql
ADD database_17032021.sql /docker-entrypoint-initdb.d/dump.sql
ADD script.sh /import/script.sh
RUN chmod +x /import/script.sh