require_relative '../lib/destination'
require 'xslt'

describe Destination do

  XSLT_TEMPLATE = 'res/xslt/destination.xslt'
  ERB_TEMPLATE = 'res/templates/template.html.erb'

  it 'should apply XSLT stylesheets correctly' do
    taxonomy = double
    allow(taxonomy).to receive(:get).with('0')
    allow(taxonomy).to receive(:parent).with('0')
    allow(taxonomy).to receive(:get_children).with('0')

    erb_renderer = double
    xslt_stylesheet = XSLT::Stylesheet.new(XML::Document.file(XSLT_TEMPLATE))
    destination = Destination.new '0', taxonomy, erb_renderer, xslt_stylesheet
    result = destination.parse_xml('<?xml version="1.0" encoding="utf-8"?>
<destinations>
  <destination atlas_id="355064" asset_id="22614-4" title="Africa" title-ascii="Africa">
    <history>
      <history>
        <history>test</history>
      </history>
    </history>
  </destination>
</destinations>')
    expect(result).to be true

  end

  it 'render ERB template correctly' do
    taxonomy = double
    allow(taxonomy).to receive(:get).with('0') { {:id => '0', :parent_id => nil, :name => 'name', :child_nodes => []} }
    allow(taxonomy).to receive(:parent).with('0') { {:id => '0', :parent_id => nil, :name => 'name', :child_nodes => []} }
    allow(taxonomy).to receive(:get_children).with('0') { [{:id => '0', :parent_id => nil, :name => 'name', :child_nodes => []}] }

    erb_renderer = ERB.new(File.read(ERB_TEMPLATE))
    xslt_stylesheet = double
    destination = Destination.new '0', taxonomy, erb_renderer, xslt_stylesheet

    expect { destination.render_template }.to_not raise_error

  end

end