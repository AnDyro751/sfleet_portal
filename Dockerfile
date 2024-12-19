FROM ruby:3.2.0
RUN apt-get update -qq && apt-get install -y nodejs npm
WORKDIR /sfleet_portal
COPY Gemfile /sfleet_portal/Gemfile
COPY Gemfile.lock /sfleet_portal/Gemfile.lock
COPY package.json /sfleet_portal/package.json
COPY package-lock.json /sfleet_portal/package-lock.json
RUN bundle install
RUN npm install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]