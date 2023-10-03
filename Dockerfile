FROM postgis/postgis:16-3.4-alpine

ARG MYSQL_FDW_URL=https://github.com/EnterpriseDB/mysql_fdw/archive/REL-2_9_1.tar.gz
ARG MYSQL_FDW_SOURCE_FILES=/tmp/mysql_fdw

ARG CLICKHOUSE_FDW_URL=https://github.com/ildus/clickhouse_fdw/archive/master.tar.gz
ARG CLICKHOUSE_FDW_SOURCE_FILES=/tmp/clickhouse_fdw

#     # mysql_fdw
# RUN apk add --no-cache --virtual .rundeps mariadb-dev && \
#     apk add --no-cache --virtual .builddeps \
#     build-base \
#     clang15 \
#     # postgres 12.2 requires llvm9, 12.4 - already llvm10
#     llvm15 && \
# 
#     # download MYSQL_FDW source files
#     mkdir -p ${MYSQL_FDW_SOURCE_FILES} && \
#     wget -O - ${MYSQL_FDW_URL} | tar -zx -C ${MYSQL_FDW_SOURCE_FILES} --strip-components=1 && \
#     cd ${MYSQL_FDW_SOURCE_FILES} && \
#     # bugfix. see https://github.com/EnterpriseDB/mysql_fdw/issues/187
#     sed -i 's/ | RTLD_DEEPBIND//' ./mysql_fdw.c && \
#     # compilation
#     make USE_PGXS=1 && \
#     make USE_PGXS=1 install && \
# 
#     # cleanup
#     apk del .builddeps && \
#     rm -rf ${MYSQL_FDW_SOURCE_FILES}

    # clickhouse_fdw
RUN apk add --no-cache --virtual .builddeps \
    build-base \
    clang15 \
    llvm15 \
    curl-dev \
    util-linux-dev \
    pkgconfig \
    cmake && \

    mkdir -p ${CLICKHOUSE_FDW_SOURCE_FILES} && \
    wget -O - ${CLICKHOUSE_FDW_URL} | tar -zx -C ${CLICKHOUSE_FDW_SOURCE_FILES} --strip-components=1 && \
    cd ${CLICKHOUSE_FDW_SOURCE_FILES} && \
    mkdir build && cd build && \
    cmake .. && \
    make && make install && \

    # cleanup
    apk del .builddeps && \
    rm -rf ${CLICKHOUSE_FDW_SOURCE_FILES}
