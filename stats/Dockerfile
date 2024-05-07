FROM rocker/shiny

WORKDIR /var/www

# install packages
RUN R -e "install.packages(c('tidyverse', 'RMySQL', 'dotenv'))"

COPY app.r ./app.r

EXPOSE 81

CMD Rscript ./app.r