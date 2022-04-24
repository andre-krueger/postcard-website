#!/usr/bin/env bash

find src/ -iname "*.hbs" -o -name "*.html" | xargs yarn parcel --dist-dir ../backend/static --public-url /static
