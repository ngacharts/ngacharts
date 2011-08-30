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
$jpg_path = "C:\\work\\opencpn\\ngacharts\\tools\\{CHART_NUMBER}.jpg"

# directory to save all the output
# You can use {CHART_NUMBER} which will be substituted with the corresponding chart number while it's being processed
$output_dir = "C:\\work\\opencpn\\ngacharts\\tools\\" #"/tmp/"

# Program paths

# command to convert the images
$convert_command = "\"C:\\Program Files\\GraphicsMagick-1.3.12-Q16\\gm.exe\" convert" # "gm convert"

# ImgKAP
$imgkap_command = "C:\\work\\opencpn\\ngacharts\\tools\\imgkap.exe" # "imgkap"

# KAP production parameters

# Don't rotate charts if they look skewed less than $skew_angle degrees
$skew_angle = 0.1

# The scaled-down size of the produced KAPs
$kap_size_percent = 30

# Whether to rotate chart images as part of KAP production
$kap_autorotate = true