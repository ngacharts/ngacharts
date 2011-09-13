# The classes for handling the CHARTCAL.DIR parsing
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# License::   Distributes under the terms of GPLv2 or later

require "./kap.rb"

# Class representing CHARTCAL.DIR
class ChartCal
  # Parses the file into an array of KAPs
  def readcharts(chartcal_text)
    charts = Array.new
    kap = nil
    chartcal_text.each_line { |line|
      if (line.include?(/^\[.*\]$/))
        if (kap != nil)
          charts << kap
        end
      end
      #TODO: parse the rest of the lines
      # /^(NA=)(.*)$/ : normal line
      # /^(B[0-9]*=)(.*),(.*)$/ : PLY points
      # /^(C[0-9]*=)(\d*),(\d*),(.*),(.*)$/ : REF points 
    }
    if (kap != nil)
      charts << kap
    end
    return charts
  end
end