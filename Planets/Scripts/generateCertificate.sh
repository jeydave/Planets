#!/bin/sh

openssl s_client -connect swapi.dev:443 </dev/null | openssl x509 -outform DER -out ../Certs/swapi.dev.der
