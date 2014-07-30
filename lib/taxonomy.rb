class Taxonomy
  attr_reader :nodes

  Node = Struct.new(:id, :parent_id, :name, :child_nodes) do
    def add_child(node_id)
      child_nodes.push(node_id)
    end
  end

  def initialize
    # building hash of nodes for a fast access
    @nodes = {}
  end

  ##
  # Adds a node to the taxonomy

  def add_node(id, name, parent_id)
    # not adding nils
    if id.nil? or name.nil?
      return false
    end
    # search for node
    unless nodes.has_key?(id)
      nodes[id] = Node.new(id, parent_id, name, [])
      # add child
      unless parent_id.nil?
        if nodes.has_key?(parent_id)
          nodes[parent_id].add_child(id)
        end
      end
      return true
    end
    false
  end

  def get(id)
    unless nodes[id].nil?
      return nodes[id]
    end
    nil
  end

  def parent(id)
    unless nodes[id].nil?
      unless nodes[nodes[id][:parent_id]].nil?
        return nodes[nodes[id][:parent_id]]
      end
    end
    nil
  end

  ##
  # Returns array structs that belongs to a particular node

  def get_children(id, sort=false)

    if id.nil?
      return nil
    end

    unless nodes.has_key?(id)
      return nil
    end

    children = []
    nodes[id][:child_nodes].each { |child|
      if nodes.has_key?(child)
        children.push(nodes[child])
      end
    }

    if sort and children.length > 0
      children = children.sort_by { |node| node[:name] }
    end

    children
  end


end
