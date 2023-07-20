FROM node:17.0.1-slim
RUN curl -o- -L https://yarnpkg.com/install.sh | \
    bash -s --

RUN mkdir -p /usr/src/app
ENV PATH="/usr/local/bin:${PATH}"
ADD . /usr/src/app/
EXPOSE 3000
WORKDIR /usr/src/app