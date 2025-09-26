FROM mcr.microsoft.com/mssql/server:2022-latest

COPY ./db-setup /db-setup

RUN chmod +x /db-setup/entrypoint.sh
 
CMD /bin/bash /db-setup/entrypoint.sh