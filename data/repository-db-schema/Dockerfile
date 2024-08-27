FROM liquibase/liquibase:4.29.0-alpine AS base

WORKDIR /liquibase

ADD liquibase/changelog ./changelog

ENV LIQUIBASE_COMMAND_CHANGELOG_FILE=changelog/changelog.yaml

CMD [ "liquibase", "update" ]
