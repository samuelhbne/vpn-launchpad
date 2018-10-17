FROM ubuntu:18.04

RUN apt-get update && apt-get install -y python-pip
RUN pip install shadowsocks==2.8.2 && rm -rf /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.pyc
RUN sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g' /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py

ENTRYPOINT ["/usr/local/bin/ssserver"]
