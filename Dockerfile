FROM node:12
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 8080
RUN chmod +x endless.sh
RUN chmod +x grocer-start.sh