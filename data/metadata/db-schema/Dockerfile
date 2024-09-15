FROM liquibase/liquibase:4.29.0-alpine AS base

WORKDIR /liquibase

ADD liquibase/changelog ./changelog
ADD liquibase/scripts ./scripts

ENV LIQUIBASE_COMMAND_CHANGELOG_FILE=changelog/changelog.yaml

CMD /liquibase/scripts/wait-for-it.sh ${LIQUIBASE_COMMAND_URL} --  /liquibase/scripts/liquibase-init.sh
