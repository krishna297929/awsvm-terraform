
#Author ---krishna Ganji---
#FROM microsoft/azure-cli
FROM amazon/aws-cli:latest

# terraform
RUN cd /bin && wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip && unzip terraform_0.11.11_linux_amd64.zip
RUN ln -s /bin/terraform /bin/tf
RUN az login

# add local files
ADD  . /linuxvm

#RUN cd ~/.ssh/ && touch authorized_keys
#RUN find /ydot -type f -name "*.sh" -print0 | xargs -0 dos2unix --

# change working directory
WORKDIR /linuxvm

RUN terraform init

# open console
ENTRYPOINT /bin/sh
RUN cd ~/ && mkdir .ssh
RUN cd ~/ && chmod 700 .ssh
RUN cd ~/.ssh && cp /linuxvm/authorized_keys .
RUN cd ~/.ssh/ && chmod 644 authorized_keys

RUN cd ~/.ssh && cp /linuxvm/deploy_key.sh .
RUN cd ~/.ssh/ && chmod 755 deploy_key.sh

RUN cd ~/.ssh && cp /linuxvm/terraform_rsa .
RUN cd ~/.ssh/ && chmod 600 terraform_rsa

RUN cd ~/.ssh && cp /linuxvm/id_rsa .
RUN cd ~/.ssh/ && chmod 600 id_rsa

RUN cd /etc && touch hybris_dev
RUN cd /etc && chmod 755 hybris_dev
#RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCo61ECY2sepEObAhB4koTKWLWa4e93MSRtk2EgEy16EXupZUZZN46YvTBfHxxuAdUVBKXBCXDKpTnqRgrgWxcMWsZuggy8pfeilkeTE0UD8Q2hdyNnBbC5YvAvxRHChyonAwKzRFO2B27r2mRj5ZyNYjOayU8rthgwA2qO/Hek6szVmLkqRxkKDYGVJ9bLbJmLJXbHy1xzIBSHHslD7eNZetjNbCRzDE5Cup2ix4PII07sRvS2rmQDLLOXM9rdZDpeo+y/HG2u8w/naoN7hT8DGk0WER4Hc+/pldPaGReyTbdAFGnKQWPFAs4QaQAYDrTsD1qnYHwDaiXGltw3Fp7L azureadmin@uw1vminas001p.arwcloud.net" >>  ~/.ssh/authorized_keys



#RUN yum install vim -y