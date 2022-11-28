class Node
  attr_accessor :value, :right, :left
  def initialize(value=nil, right=nil, left=nil)
    @value = value
    @right = right
    @left = left
  end
end

class Tree
  attr_accessor :root
  def initialize(arr)
    arr = arr.uniq.sort
    @root = build_tree(arr)
  end

  def build_tree(arr)
    return nil if arr.empty?
    mid = (arr.length)/2
    root_node = Node.new(arr[mid])
    root_node.left = build_tree(arr[0...mid])
    root_node.right = build_tree(arr[mid+1...arr.length])
    return root_node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, root = @root)
    if root.value == nil
      root = Node.new(value)
      return
    end

    if value < root.value
      if root.left == nil
        root.left = Node.new(value)
        return
      end
      insert(value, root.left)
    end

    if value > root.value
      if root.right == nil
        root.right = Node.new(value)
        return
      end
      insert(value, root.right)
    end
  end

  def delete(value, root = @root)
    current_node = root
    
    until value == current_node.value
      if value < current_node.value
        prev_node = current_node
        current_node = current_node.left
      else
        prev_node = current_node
        current_node = current_node.right
      end
    end

    if current_node.right == nil && current_node.left == nil
      if value < prev_node.value
        prev_node.left = nil
        return
      else
        prev_node.right =  nil
        return
      end
    end


    if current_node.right != nil && current_node.left == nil || current_node.right == nil && current_node.left != nil
      if current_node.right == nil
        if prev_node.value < current_node.value
          prev_node.right = current_node.left
          return
        end

        if prev_node.value > current_node.value
          prev_node.left = current_node.left
          return
        end
      end

      if current_node.left == nil
        if prev_node.value < current_node.value
          prev_node.right = current_node.right
          return
        end

        if prev_node.value > current_node.value
          prev_node.left = current_node.right
          return
        end
      end
    end

    if current_node.right != nil && current_node.left != nil
      rep_node = current_node.right
      
      until rep_node.left == nil
        rep_node = rep_node.left
      end
      
      current_node.value =  rep_node.value
      par_node = current_node.right
      
      until par_node.left == rep_node
        par_node = par_node.left
      end
      
      delete(rep_node.value, par_node) 
    end

  end 

  def find(value, root = @root)
    current_node = root
    until current_node.value == value
      if value < current_node.value
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
    current_node
  end

  def level_order(current_node = @root, que = Queue.new, result = [], &block)
    que << current_node.value

    until que.empty?
      node = que.shift
      result << node
      next_node = find(node)

      if block_given?
        block.call(node)
      end
     
      if next_node.left != nil
        que << next_node.left.value
      end
      
      if next_node.right != nil
        que << next_node.right.value
      end
    end
    result
  end

  def level_order_rec(current_node = @root, que = Queue.new, result = [], &block)
    if que.empty?
      que << current_node 
    end

    kicked_node = que.shift
    if block_given?
      block.call(kicked_node.value)
    end
    result << kicked_node.value
    
    if kicked_node.left != nil
      que << kicked_node.left
    end
    
    if kicked_node.right != nil
      que << kicked_node.right
    end
    
    if que.empty?
      return result
    end

    level_order_rec(kicked_node, que, result)
  end

  def inorder(node = @root, arr = [], result = [], &block)
    current_node  = node
    loop do
      while current_node != nil
        arr << current_node
        current_node = current_node.left
      end
      if arr.length == 0
        break
      end
      pop_node = arr.pop
      if block_given?
        block.call(pop_node.value)
      end
      result << pop_node.value
      current_node = pop_node.right
    end
    result
  end 

  def preorder(node = @root, arr = [], result = [], &block)
    current_node = node
    loop do
      while current_node != nil
        arr << current_node
        result << current_node.value
        current_node = current_node.left
      end
      if arr.length == 0
        break
      end
      pop_node = arr.pop
      if block_given?
        block.call(pop_node.value)
      end
      current_node = pop_node.right
    end
    result
  end

  def post_order(node = @root, arr = [], result = [], &block)
    current_node = node 
    arr<< current_node
    while !arr.empty?
      top_node = arr.pop
      if top_node.left != nil
        arr << top_node.left
      end

      if top_node.right != nil
        arr << top_node.right
      end
      
      if top_node.value != nil
        result << top_node.value
      end
    end
    result = result.reverse
    result
  end

  def height(node = @root)
    if node == nil
      return 0
    end

  left_height = height(node.left)
  right_height = height(node.right)
  total_height = 1 + [left_height, right_height].max

  end

  def depth(node, total = 0, current_node = @root)
    if node.nil?
      nil
    elsif node == current_node.value
      total
    elsif node < current_node.value
      total += 1
      depth(node,total, current_node.left)
    elsif node > current_node.value
      total += 1
      depth(node, total, current_node.right)
    end
  end

  def balanced?(node = @root)
    left_height = height(node.left)
    right_height = height(node.right)
    if(left_height-right_height).abs < 2
      return true
    else 
      return false
    end
  end

  def rebalance
    @root = build_tree(inorder)
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
a= Tree.new(arr)
a.insert(6)
a.insert(44)
a.insert(66)
a.insert(67)
a.insert(69)
a.insert(56)
a.insert(666)
a.insert(6343)
a.insert(7000)
a.insert(70001)
a.insert(56454)
a.insert(34345)
a.insert(444)
a.insert(44444)
p a.find(23)
a.pretty_print
p a.level_order
p a.inorder
p a.preorder
p a.post_order
p a.height
p a.depth(6345)
p a.balanced?
p a.rebalance
a.pretty_print
p a.balanced?
