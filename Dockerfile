FROM alpine:3.20

ENV BIN_TF_VER 1.9.0
RUN apk update && apk add --no-cache curl unzip aws-cli
RUN curl -o "terraform.zip" "https://releases.hashicorp.com/terraform/${BIN_TF_VER}/terraform_${BIN_TF_VER}_linux_amd64.zip" \
      && unzip -qq terraform.zip \
      && install -Dm 755 terraform /usr/bin \
      && rm -rf terraform.zip LICENSE.txt
RUN apk remove curl unzip

COPY . /tf-run
WORKDIR /tf-run


