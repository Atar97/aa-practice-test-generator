require 'colorize'

class User
end

class FirstUser < User
  attr_reader :defaults, :request

  def initialize
    @defaults = {}
    @request = Hash.new(0)
  end

  def initial_instructions
    system("clear")
    puts "Welcome to a/A Practice 01Assessment Generator 2.0".cyan
    puts "This generator will create a practice test based on your input. " \
          "You can choose how many problems from each category to include in your test. "
    puts "This program will generate 3 files in this folder: practice_test, spec, and solution. " \
          "Complete the practice_test file, running the spec file to check your answers. " \
          "When your time is up (you are timing yourself, right?), compare your answers to the solutions."
    puts "Good luck!"
  end

  def make_defaults(problem_counts)
    counts = problem_counts
    @defaults[:"1"] = ["array: 2, recursion: 1, sort: 1"]
    @defaults[:"2"] = ["recursion: 3, sort: 2, enumerable: 1"]
    @defaults[:"3"] = ["array: 3, recursion: 1, sort: 1, string: 2"]
    @defaults[:"4"] = ["array: 1, recursion: 1, sort: 1, enumerable: 1, string: 1"]
    @defaults[:"5"] = ["array: 2, recursion: 1, sort: 1"]
    @defaults[:"6"] = ["array: 2, recursion: 1, sort: 1"]
    @defaults[:"7"] = ["Every array problem", "array: #{counts['array']}"]
    @defaults[:"8"] = ["Every recursion problem", "recursion: #{counts['recursion']}"]
    @defaults[:"9"] = ["Every string problem", "string: #{counts['string']}"]
    @defaults[:"10"] = ["Every enumerable problem", "enumerable: #{counts['enumerable']}"]
    @defaults[:"11"] = ["Every sort problem", "sort: #{counts['sort']}"]
    all_probs_str = ""
    counts.each do |category, number|
      all_probs_str += "#{category}: #{number}, "
    end
    all_probs_str = all_probs_str[0..-3]
    @defaults[:"12"] = ["Every Problem", all_probs_str]
    @defaults
  end

  def display_defaults
    @defaults.each do |key, string_array|
      puts "Default #{key} == #{string_array.first}"
    end
  end

  def create_request_hash(categories)
    print_category_instructions(categories)
    user_input = gets.chomp
    if FirstUser.defaults?(user_input)
      user_input = handle_default_request
    end
    @request = FirstUser.request_str_to_hash(user_input)
  end

  def self.request_hash_to_str(request_hash)
    ret = ""
    request_hash.each do |name, number|
      ret << "#{name}: #{number}, "
    end
    ret[0...-1]
  end

  def self.request_str_to_hash(request_string)
    ret = Hash.new(0)
    cat_array = request_string.split(", ")
    cat_array.each do |cat_and_num|
      split_array = cat_and_num.split(": ")
      cat_name = split_array[0].downcase
      num_of_prob = split_array[1].to_i
      ret[cat_name] += num_of_prob
    end
    ret
  end

  def finish
    puts "Done"
    puts "Your practice test will have this makeup:".cyan
    puts FirstUser.request_hash_to_str(@request).yellow
  end

  def self.defaults?(input)
    ["default", "defaults", "D", "d"].include?(input)
  end

  def print_category_instructions(categories)
    puts "Possible categories: #{categories.join(", ")}".magenta
    puts "Input your requests, separated by commas and spaces please"
    puts "Example input: " + "array: 2, recursion: 1, sort: 1".yellow
    puts "To see the DEFAULT TESTS you can use type default"
  end

  def handle_default_request
      display_defaults
      default_option = get_default_option
      @defaults[default_option].last
  end

  def get_default_option
    puts "Enter the number of the default you would like to use: "
    gets.chomp.to_sym
  end

end

class SecondUser < User

  def initialize
    @request
  end

  def initial_instructions
    l_num = 0
    File.new('lib/outputs/g2.txt').each_line do |line|
      print line.red
      break if l_num == 1
      l_num +=1
    end
  end

  def which_problem
    l_num = 0
    File.new('lib/outputs/g2.txt').each_line do |line|
      print line.yellow if l_num > 1
      break if l_num == 5
      l_num += 1
    end
    puts "\nMancala, Blackjack, Battleship, Hangman, Simon, Mastermind".light_blue
    gets.chomp
  end


end

user = SecondUser.new
user.initial_instructions
user.which_problem
