FROM bitnami/postgresql:16.0.0-debian-11-r5

ARG MYSQL_FDW_VERSION=2_9_1
ARG MYSQL_FDW_URL=https://github.com/EnterpriseDB/mysql_fdw/archive/REL-${MYSQL_FDW_VERSION}.tar.gz
ARG SOURCE_FILES=/tmp/mysql_fdw

    # install packages for runtime and compile into 2 separate packages
RUN apk add --no-cache --virtual .rundeps mariadb-dev; \
    apk add --no-cache --virtual .builddeps \
    build-base \
    clang \
    # postgres 12.2 requires llvm9, 12.4 - already llvm10
    llvm10; \
    # download MYSQL_FDW source files
    mkdir -p ${SOURCE_FILES}; \
    wget -O - ${MYSQL_FDW_URL} | tar -zx -C ${SOURCE_FILES} --strip-components=1; \
    cd ${SOURCE_FILES}; \
    # bugfix. see https://github.com/EnterpriseDB/mysql_fdw/issues/187
    sed -i 's/ | RTLD_DEEPBIND//' ./mysql_fdw.c; \
    # compilation
    make USE_PGXS=1; \
    make USE_PGXS=1 install; \
    # cleanup
    apk del .builddeps; \
    rm -rf ${SOURCE_FILES}
