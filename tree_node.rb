class TreeNode
  
  attr_accessor :value, :children, :parent
  
  def initialize(val)
    @value = val
  end
  
  def child=(node)
    node.parent = self
    @children << node
  end
  
  def bfs(val)
    
    looking_thru = [self]
    
    until looking_thru.empty?
      node = array.shift
      return node if node.value == val
      node.children.each do |child|
        looking_thru << child
      end
    end
    
    "did not find it"
    
  end
  
end
