#!/bin/bash

# Copyright (C) 2010 Steve Ward

tar --verbose --create --auto-compress --file archive-$(date +'%Y-%m-%d-%H-%M-%S').tar.bz2 *.html *.js *.php *.css *.txt
