require 'csv'
require 'colorize'
require 'byebug'
require_relative 'user'

class Generator

  def initialize(problem_file_name)
    @user_request = Hash.new(0)
    @problem_csv = Generator.read_csv_file(problem_file_name)
    @categories = Generator.make_categories(@problem_csv)
    @generated_files = {}
    make_user(count_problems)
  end

  def make_user(problem_counts)
    @user = User.new(problem_counts)
  end

  def self.read_csv_file(file_name)
    CSV.read(file_name, headers: true, header_converters: :symbol, converters: :all)
  end

  def generate_new_files
    @generated_files[:prac] = File.open("practice_test.rb", "w")
    @generated_files[:spec] = File.open("spec.rb", "w")
    @generated_files[:sol] = File.open("solution.rb", "w")
  end

  def self.make_categories(problem_files)
    result = []
    problem_files.each do |test_info|
      result << test_info[1] unless result.include?(test_info[1])
    end
    result
  end

  def count_problems
    counting_hash = Hash.new(0)
    @problem_csv.each do |test_info|
      counting_hash[test_info[1]] += 1
    end
    counting_hash
  end

  def create_user_requests
    request = @user.receive_requests(@categories).split(", ")
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
      @problem_csv.each do |test_info_array|
        if category == test_info_array[1]
          all_prob_category << test_info_array
        end
      end
      needed_problems = all_prob_category.sample(@user_request[category])
      master.concat(needed_problems)
    end
    master
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
