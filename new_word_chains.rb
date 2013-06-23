require "./tree_node"
require 'set'

class WordChainer
  
  def initialize(dict = 'dictionary.txt')
    @dict_words = File.readlines(dict).map{|line| line.chomp}
  end
  
  def find_chain(start_word, end_word)
    first_node = TreeNode.new(start_word)
    build_tree(first_node)
    last_node = first_node.bfs(end_word)
    path(last_node)
  end
  
  def adjacent_words(word, candidates)
    
    adj_words = []
    word.length.times do |i|
      ('a'..'z').to_a.each do |letter|
        duped_word = word.dup
        duped_word[i] = letter
        adj_words << duped_word if candidates.include? duped_word
      end
    end
    adj_words
  end
  
  def build_tree(node)
    
    candidates = @dict_words.select{|entry| entry.length == node.value.length}
    candidates = Set.new(candidates) - [node.value]
    
    nodes = [node]
    visited_words = [node.value]

    until nodes.empty?
      current_node = nodes.shift
      adj_words = adjacent_words(current_node.value, candidates)
      candidates = candidates - adj_words
      adj_words.each do |adj_word|
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
    path = []
    until node == nil
      path.unshift(node.value)
      node = node.parent
    end
    path
  end
  
end
