
class Tree
  attr_accessor :children, :node_name

  def initialize(spec)
    spec.each do |name, children|
      subtrees = []
      children.each do |cname, grandchildren|
        subtrees.push(Tree.new(cname => grandchildren))
      end

      @children = subtrees
      @node_name = name
    end
  end

  def visit_all(&block)
    visit &block
    children.each {|c| c.visit_all &block}
  end

  def visit(&block)
    block.call self
  end
end

family = Tree.new('grandpa' => { 'dad' => {'child 1' => {}, 'child 2' => {} },
                                 'uncle' => {'child 3' => {}, 'child 4' => {} } })

puts "Visiting entire tree"
family.visit_all {|node| puts node.node_name}

