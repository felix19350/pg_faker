# Postgres 17 dev container: Should not be used for production workloads
FROM postgres:17.2-bookworm

# Ensure the directory to store the custom functions has been created
# The src directory will be mounted here at runtime.
RUN mkdir -p /usr/share/pg-custom-functions


# Ensure dev tools are installed
RUN apt update && apt install build-essential postgresql-server-dev-17 -y

# Run postgres as usual
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]

