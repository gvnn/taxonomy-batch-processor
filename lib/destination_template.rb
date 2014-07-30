require 'xml'

class DestinationTemplate
  attr_reader :content
  attr_reader :destination

  def initialize(id, taxonomy, erb_renderer, xslt_stylesheet)
    @id = id
    @erb_renderer = erb_renderer
    @xslt_stylesheet = xslt_stylesheet
    @destination = {
        :details => taxonomy.get(@id),
        :parent => taxonomy.parent(@id),
        :children => taxonomy.get_children(@id)
    }
  end

  def parse_xml(xml)
    begin
      @content = @xslt_stylesheet.apply(XML::Parser.string(xml).parse)
      true
    rescue
      false
    end
  end

  def render_template
    @erb_renderer.result(binding)
  end

  def create_html(output_folder)
    File.open(File.join(output_folder, "#{@id}.html"), "w") do |f|
      f << render_template
    end
  end

end
