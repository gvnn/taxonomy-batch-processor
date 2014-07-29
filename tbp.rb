#!/usr/bin/env ruby
require "thor"

class TrbConsole < Thor

  desc "gen", "Generates html report files"

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

  def gen()
    puts "input dir: #{options[:i]}" if options[:i]
    puts "output dir: #{options[:o]}" if options[:o]
  end

end

TrbConsole.start
