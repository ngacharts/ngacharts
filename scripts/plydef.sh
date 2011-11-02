#!/bin/sh
cd /var/www/virtualhosts/opencpn.xtr.cz/nga-kap
ruby -rubygems kaptool.rb -a PLY -p $1 $2
