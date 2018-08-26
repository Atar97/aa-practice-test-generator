require 'csv'
require 'colorize'
require 'byebug'
class Generator
  def initialize(problem_file_name)
    @user_request = Hash.new(0)
    @problem_file
    read_csv_file(problem_file_name)
    @categories = []
    make_categories
    @generated_files = {}
    @defaults = {}
    make_defaults
  end

  def print_instructions
    system("clear")
    puts "Welcome to a/A Practice 01Assessment Generator 2.0".cyan
    puts "This generator will create a practice test based on your input. " \
          "You can choose how many problems from each category to include in your test. "
    puts "This program will generate 3 files in this folder: practice_test, spec, and solution. " \
          "Complete the practice_test file, running the spec file to check your answers. " \
          "When your time is up (you are timing yourself, right?), compare your answers to the solutions."
    puts "Good luck!"
  end

  def display_defaults
    @defaults.each do |key, string_array|
      puts "Default #{key} == #{string_array.first}"
    end
  end

  def get_default_option
    puts "Enter the number of the default you would like to use: "
    gets.chomp.to_sym
  end

  def make_defaults
    counts = count_problems
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

  def read_csv_file(file_name)
    @problem_file = CSV.read(file_name, headers: true, header_converters: :symbol, converters: :all)
    true
  end

  def make_categories
    @problem_file.each do |test_info|
      @categories << test_info[1] unless @categories.include?(test_info[1])
    end
    @categories
  end

  def count_problems
    counting_hash = Hash.new(0)
    @problem_file.each do |test_info|
      counting_hash[test_info[1]] += 1
    end
    counting_hash
  end

  def receive_requests
    puts "Possible categories: #{@categories.join(", ")}".magenta
    puts "Input your requests, separated by commas and spaces please"
    puts "Example input: " + "array: 2, recursion: 1, sort: 1".yellow
    puts "To see the DEFAULT TESTS you can use type default"
    parse_default_request(gets.chomp)
  end

  def parse_default_request(request)
    default_inputs = ["default", "defaults", "D", "d"]
    if default_inputs.include?(request)
      display_defaults
      default_option = get_default_option
      input = @defaults[default_option].last
    else
      request
    end
  end

  def create_user_requests
    request = receive_requests.split(", ")
    request.each do |request|
      req = request.downcase.split(": ")
      @user_request[req[0]] = req[1].to_i
    end
    @user_request
  end

  def self.request_hash_to_str(request_hash)
    ret = ""
    request_hash.each do |name, number|
      ret << "#{name}: #{number}, "
    end
    ret[0...-1]
  end

  def make_problem_master
    master = []
    @categories.each do |category|
      all_prob_category = []
      @problem_file.each do |test_info_array|
        if category == test_info_array[1]
          all_prob_category << test_info_array
        end
      end
      needed_problems = all_prob_category.sample(@user_request[category])
      master.concat(needed_problems)
    end
    master
  end

  def generate_new_files
    @generated_files[:prac] = File.open("practice_test.rb", "w")
    @generated_files[:spec] = File.open("spec.rb", "w")
    @generated_files[:sol] = File.open("solution.rb", "w")
  end

  def add_requirements
    @generated_files[:spec] << "require 'rspec'\n"
    @generated_files[:spec] << "require_relative 'practice_test'\n"
    @generated_files[:prac] << "require 'byebug'\n"
  end

  def add_questions
    problem_master = make_problem_master
    problem_master.each do |test|
      @generated_files[:prac] << File.read(test[2]) << "\n"
      @generated_files[:spec] << File.read(test[3]) << "\n"
      @generated_files[:sol] << File.read(test[4]) << "\n"
    end
  end

  def finish
    close_files
    puts "Done"
    puts "Your practice test will have this makeup:".cyan
    puts Generator.request_hash_to_str(@user_request).yellow
  end


  def run
    print_instructions
    create_user_requests
    generate_new_files
    add_requirements
    add_questions
    finish
  end

  private

  def close_files
    @generated_files.each {|key, file| file.close}
  end

end

generator = Generator.new('list.csv')
# puts generator.count_problems
generator.run
