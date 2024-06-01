FROM rocker/shiny

WORKDIR /var/www

# mysql required
RUN apt update \
 && apt install -y --no-install-recommends libmysqlclient-dev

# install packages
RUN R -e "install.packages(c('tidyverse', 'RMySQL', 'dotenv'))"

COPY app.r ./app.r

EXPOSE 81

CMD Rscript ./app.r