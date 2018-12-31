FROM ruby:alpine

RUN gem install redmon

EXPOSE 4567

ENTRYPOINT ["redmon -r redis://redis:6379"]
