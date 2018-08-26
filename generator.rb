require 'csv'
require 'colorize'
require 'byebug'
class Generator
  def initialize(problem_file_name)
    @user_request = Hash.new(0)
    @problem_file
    read_csv_file(problem_file_name)
  end

  def display_defaults(defaults_hash)
    defaults_hash.each do |key, string|
      puts "Default #{key} == #{string}"
    end
  end

  def get_default_option
    puts "Enter the number of the default you would like to use: "
    gets.chomp.to_sym
  end

  def print_instructions
    system("clear")
    puts "Welcome to Mallory's (Refactored by Austin) a/A Practice Assessment Generator".cyan
    puts "This generator will create a practice test based on your input. " \
          "You can choose how many problems from each category to include in your test. "
    puts "This program will generate 3 files in this folder: practice_test, spec, and solution. " \
          "Complete the practice_test file, running the spec file to check your answers. " \
          "When your time is up (you are timing yourself, right?), compare your answers to the solutions."
    puts "Good luck!"
  end

  def make_defaults
    defaults_hash = {}
    defaults_hash[:"1"] = "array: 2, recursion: 1, sort: 1"
    defaults_hash[:"2"] = "recursion: 3, sort: 2, enumerable: 1"
    defaults_hash[:"3"] = "array: 3, recursion: 1, sort: 1, string: 2"
    defaults_hash[:"4"] = "array: 1, recursion: 1, sort: 1, enumerable: 1, string: 1"
    defaults_hash[:"5"] = "array: 2, recursion: 1, sort: 1"
    defaults_hash[:"6"] = "array: 2, recursion: 1, sort: 1"
    #those are a work in progress
    # defaults_hash[:"7"] = "Every array problem"
    # defaults_hash[:"8"] = "Every recursion problem"
    # defaults_hash[:"9"] = "Every string problem"
    # defaults_hash[:"10"] = "Every enumerable problem"
    # defaults_hash[:"11"] = "Every sort problem"
    defaults_hash
  end

  def read_csv_file(file_name)
    @problem_file = CSV.read(file_name, headers: true, header_converters: :symbol, converters: :all)
    true
  end

  def make_categories(csv_tests)
    categories = []
    csv_tests.each do |test|
      categories << test[1] unless categories.include?(test[1])
    end
    categories
  end

  def receive_requests(categories)
    puts "Possible categories: #{categories.join(", ")}".magenta
    puts "Input your requests, separated by commas and spaces please"
    puts "Example input: " + "array: 2, recursion: 1, sort: 1".yellow
    puts "To see the DEFAULT TESTS you can use type default"
    gets.chomp
  end

  def process_requests(request)
    default_inputs = ["default", "defaults", "D", "d"]
    if default_inputs.include?(request)
      defaults = make_defaults
      display_defaults(defaults)
      default_option = get_default_option
      input = defaults[default_option]
    else
      request
    end
  end

  def make_category_request(input_string)
    input_string = input_string.split(", ")
    input_string.each do |request|
      req = request.downcase.split(": ")
      @user_request[req[0]] = req[1].to_i
    end
    @user_request
  end

  def make_master(categories)
    master = []
    categories.each do |category|
      all_prob_for_category = []
      @problem_file.each do |test_info_array|
        if category == test_info_array[1]
          all_prob_for_category << test_info_array
        end
      end

      num_problems_requested = @user_request[category]
      master.concat(all_prob_for_category.sample(num_problems_requested))
    end
    master
  end

  def run
    print_instructions
    category_array = make_categories(@problem_file)
    user_request = receive_requests(category_array)
    input = process_requests(user_request)


    make_category_request(input)
    # make test array for each category

    master = make_master(category_array)


    # create new test, spec and solution files
    practice_test = File.open("practice_test.rb", "w")
    spec = File.open("spec.rb", "w")
    solution = File.open("solution.rb", "w")

    # require rspec and the practice_test in the spec
    spec << "require 'rspec'" << "\n"
    spec << "require_relative 'practice_test'" << "\n"

    # loop through master tests and add text to the new files
    master.each do |test|
      practice_test << File.read(test[2]) << "\n"
      spec << File.read(test[3]) << "\n"
      solution << File.read(test[4]) << "\n"
    end

    # close the files that were just created
    practice_test.close
    spec.close
    solution.close

    puts
    puts "Done!"
  end
end

generator = Generator.new('list.csv')
generator.run
