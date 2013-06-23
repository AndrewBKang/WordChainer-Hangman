#require "tree_nodes"

class WordChainer
  
  def find_chain(start_word, end_word)
    first_node = TreeNode.new(start_word)
    build_tree(first_node)
    last_node = first_node.bfs(end_word)
    path(last_node)
  end
  
  def adjacent_words(word, dict='dictionary.txt')
    dict_words = File.readlines(dict).map{|line| line.chomp}
    shortened_dict = dict_words.select{|entry| entry.length == word.length}
    
    adj_words = []
    word.length.times do |i|
      ('a'..'z').to_a.each do |letter|
        duped_word = word.dup
        duped_word[i] = letter
        adj_words << duped_word if shortened_dict.include? duped_word
      end
    end
    adj_words
  end
  
  def build_tree(node)
    nodes = [node]
    visited_words = [node.value]
    
    until nodes.empty?
      current_node = array.shift
      adjacent_words(current_node.value).each do |adj_word|
        next if visited_words.include? adj_word
        
        adj_word_node = TreeNode.new(adj_word)
        current_node.child = adj_word_node
        nodes << adj_word_node
        visited_words << adj_word
      end
    end
    "finished building tree"
  end
  
  def path(node)
    path = [node.value]
    until node == nil
      node = node.parent
      path << node.value
    end
    path
  end
  
end
