require 'csv'
require 'colorize'
require 'byebug'
require_relative 'user'
class Generator
  def initialize(problem_file_name)
    @user = User.new
    @user_request = Hash.new(0)
    @problem_file
    read_csv_file(problem_file_name)
    @categories = []
    make_categories
    @generated_files = {}
    @defaults = @user.make_defaults(count_problems)
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
    @user.initial_instructions
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
