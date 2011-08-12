# Configuration parameters
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# License::   Distributes under the terms of GPLv2 or later

# Database

# DB host
$db_host = "127.0.0.1"

# Database name
$db_database = "nga"

# Username
$db_username = "root"

# Password
$db_password = "root"

# Data paths

# Path to the original full size NGA image 
# You can use {CHART_NUMBER} which will be substituted with the corresponding chart number while it's being processed
$jpg_path = "/tmp/{CHART_NUMBER}/{CHART_NUMBER}.jpg"

# directory to save all the output
# You can use {CHART_NUMBER} which will be substituted with the corresponding chart number while it's being processed
$output_dir = "/tmp/"

# Program paths

# command to convert the images
$convert_command = "\"C:\\Program Files\\GraphicsMagick-1.3.12-Q16\\gm\" convert" # "gm convert"

# ImgKAP
$imgkap_command = "C:\\work\\opencpn\\ngacharts\\tools\\imgkap" # "imgkap"
