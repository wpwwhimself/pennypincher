FROM rocker/r-base

WORKDIR /var/www

# mysql required
RUN apt update \
 && apt install -y --no-install-recommends libmysqlclient-dev

# install packages
RUN R -e "install.packages(c('RMySQL', 'dotenv', 'dplyr', 'ggplot2', 'shiny'))"

COPY . .

EXPOSE 8001

CMD Rscript ./app.r