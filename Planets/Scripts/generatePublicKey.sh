#!/bin/sh

openssl s_client -connect swapi.dev:443 | openssl x509 -pubkey -noout
