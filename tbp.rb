#!/usr/bin/env ruby
require 'thor'
require_relative 'lib/taxonomy_processor'

class TrbConsole < Thor

  desc 'gen', 'Generates html report files'

  option :i,
         :banner => '[INPUT DIR]',
         :default => './data/input',
         :type => :string,
         :required => true,
         :desc => 'location of the two XML input files'

  option :o,
         :banner => '[OUTPUT DIR]',
         :default => './data/output',
         :type => :string,
         :required => true,
         :desc => 'output directory'

  option :t,
         :banner => '[TAXONOMY FILE NAME]',
         :default => 'taxonomy.xml',
         :type => :string

  option :d,
         :banner => '[DESTINATIONS FILE NAME]',
         :default => 'destinations.xml',
         :type => :string

  def gen
    tbp = TaxonomyProcessor.new(options)
    tbp.process_xml_files
  end

end

TrbConsole.start
