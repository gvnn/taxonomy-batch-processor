require_relative '../lib/taxonomy'

describe Taxonomy do

  before(:each) do
    @taxonomy = Taxonomy.new
  end

  it 'should create a root node and add children' do

    @taxonomy.add_node(0, 'root', nil)
    expect(@taxonomy.nodes.has_key?(0)).to be true

    @taxonomy.add_node(1, 'child 1', 0)
    @taxonomy.add_node(2, 'child 2', 0)

    @taxonomy.nodes.each { |key, node|
      if key > 0
        expect(node[:parent_id]).to eq(0)
      else
        # first element is nil
        expect(node[:parent_id]).to be_nil
      end
    }

  end

  it 'should return the children array or a particular node' do
    @taxonomy.add_node(0, 'root', nil)
    @taxonomy.add_node(1, 'child 1', 0)
    @taxonomy.add_node(2, 'child 2', 0)

    children = @taxonomy.get_children(0)
    expect(children.length).to eq(2)
    expect(children[0][:id]).to eq(1)
    expect(children[1][:id]).to eq(2)

  end

  it 'should return a sorted children array' do
    @taxonomy.add_node(0, 'root', nil)
    @taxonomy.add_node(1, 'B', 0)
    @taxonomy.add_node(2, 'A', 0)

    children = @taxonomy.get_children(0, true)
    expect(children.length).to eq(2)
    expect(children[0][:id]).to eq(2)
    expect(children[1][:id]).to eq(1)
  end

  it 'adding a child should return true if successful, and false if not' do
    expect(@taxonomy.add_node(0, 'root', nil)).to be true
    expect(@taxonomy.add_node(0, nil, nil)).to be false
    expect(@taxonomy.add_node(nil, 'root', nil)).to be false
    expect(@taxonomy.add_node(1, 'child 1', 0)).to be true
  end

end
