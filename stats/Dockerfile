FROM rocker/shiny-verse

WORKDIR /var/www

# mysql required
RUN apt update \
 && apt install -y --no-install-recommends libmysqlclient-dev

# install packages
RUN R -e "install.packages(c('RMySQL', 'dotenv'))"

COPY . .

EXPOSE 8001

CMD Rscript ./app.r