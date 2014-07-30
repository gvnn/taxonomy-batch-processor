require 'xml'
require 'erb'
require 'xslt'
require 'logger'
require 'fileutils'
require_relative 'taxonomy'
require_relative 'destination_template'

class TaxonomyProcessor

  ERB_TEMPLATE = 'res/templates/template.html.erb'
  XSLT_TEMPLATE = 'res/xslt/destination.xslt'
  STATIC_FILES_FOLDER = 'res/templates/static'

  def initialize(options)

    @logger = Logger.new($stdout)
    @taxonomy = Taxonomy.new

    # command line options
    @input_folder = options[:i]
    @output_folder = options[:o]
    @taxonomy_file_name = options[:t]
    @destinations_file_name = options[:d]

    # utility vars with file paths
    @taxonomy_file_full_path = "#{@input_folder}/#{@taxonomy_file_name}"
    @destinations_file_full_path = "#{@input_folder}/#{@destinations_file_name}"

    # vars for rendering
    @erb_renderer = ERB.new(File.read(ERB_TEMPLATE))
    @xslt_stylesheet = XSLT::Stylesheet.new(XML::Document.file(XSLT_TEMPLATE))

  end

  ##
  # Parses the taxonomy file and creates the hash of all the taxonomies

  def import_taxonomy

    parser = XML::Parser.file(@taxonomy_file_full_path, :encoding => XML::Encoding::UTF_8)
    taxonomy_document = parser.parse

    # root node
    root_node = taxonomy_document.find_first('//taxonomy_name')
    @taxonomy.add_node('0', root_node.content, nil)
    @logger.debug "Root: #{root_node.content}"

    # parsing the taxonomy doc into my Taxonomy class
    taxonomy_document.find('//node').each do |node|

      @logger.debug "Node: #{node.attributes['atlas_node_id']}"

      if node.children?

        node_id = node.attributes['atlas_node_id']
        node_name = node.find_first('./node_name').content
        @taxonomy.add_node(node_id, node_name, '0')

        node.find('./node').each do |child|

          @logger.debug "Child #{child.attributes['atlas_node_id']}"

          child_id = child.attributes['atlas_node_id']
          child_name = child.find_first('./node_name').content
          @taxonomy.add_node(child_id, child_name, node_id)

        end

      end

    end

  end

  def generate_file(atlas_id, xml)
    @logger.debug "Generating html for destination #{atlas_id}"
    begin
      template = DestinationTemplate.new atlas_id, @taxonomy, @erb_renderer, @xslt_stylesheet
      template.parse_xml xml
      template.create_html @output_folder
    rescue Exception => e
      @logger.error e
    end
  end

  def generate_files
    # generates the world doc
    generate_file('0', nil)
    # using stream reader to print every destination
    parser = XML::Reader.file(@destinations_file_full_path, :encoding => XML::Encoding::UTF_8)
    while parser.read
      if parser.name == 'destination' and parser.node_type == XML::Reader::TYPE_ELEMENT
        atlas_id = parser.get_attribute('atlas_id')
        unless atlas_id.nil?
          generate_file(atlas_id, parser.read_outer_xml)
        end
      end
    end
  end

  def clean_output_folder
    FileUtils.rm Dir.glob("#{@output_folder}/*.html")
    FileUtils.rm_rf Dir.glob("#{@output_folder}/static")
  end

  def copy_static_files
    static_output_folder = "#{@output_folder}/static"
    unless File.directory?(static_output_folder)
      FileUtils.mkdir_p(static_output_folder)
    end
    FileUtils.cp_r(Dir["#{STATIC_FILES_FOLDER}/*"], static_output_folder)
  end

  def process_xml_files
    @logger.debug @taxonomy_file_full_path
    #check files exists
    if File.file?(@taxonomy_file_full_path) and
        File.file?(@destinations_file_full_path) and
        File.directory?(STATIC_FILES_FOLDER) and
        File.file?(ERB_TEMPLATE) and
        File.file?(XSLT_TEMPLATE)
      import_taxonomy
      clean_output_folder
      generate_files
      copy_static_files
    else
      false
    end
  end

end
