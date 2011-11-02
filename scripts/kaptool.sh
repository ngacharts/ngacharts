#!/bin/sh
cd /var/www/virtualhosts/opencpn.xtr.cz/nga-kap
nice -n 20 ionice -c3 ruby -rubygems kaptool.rb
