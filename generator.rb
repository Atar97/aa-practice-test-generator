require 'csv'
require 'colorize'
require 'byebug'
require_relative 'user'

class Generator

  def initialize(problem_file_name, directory_name)
    @dir = directory_name
    @problem_csv = Generator.read_csv_file(problem_file_name, @dir)
    @categories = Generator.make_categories(@problem_csv)
    @generated_files = {}
    @user = User.new
  end

  def give_user_problems
    @user.make_defaults(count_problems)
  end

  def self.read_csv_file(file_name, directory_name)
    CSV.read(directory_name + file_name, headers: true, header_converters: :symbol, converters: :all)
  end

  def generate_new_files
    @generated_files[:prac] = File.open("#{@dir}/practice_test.rb", "w")
    @generated_files[:spec] = File.open("#{@dir}/spec.rb", "w")
    @generated_files[:sol] = File.open("#{@dir}/solution.rb", "w")
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

  def make_problem_master
    master = []
    @categories.each do |category|
      all_prob_category = []
      @problem_csv.each do |test_info_array|
        if category == test_info_array[1]
          all_prob_category << test_info_array
        end
      end
      needed_problems = all_prob_category.sample(@user.request[category])
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
      @generated_files[:prac] << File.read("#{@dir}/#{test[2]}") << "\n"
      @generated_files[:spec] << File.read("#{@dir}/#{test[3]}") << "\n"
      @generated_files[:sol] << File.read("#{@dir}/#{test[4]}") << "\n"
    end
  end

  def run
    @user.initial_instructions
    give_user_problems
    @user.create_request_hash(@categories)
    generate_new_files
    add_requirements
    add_questions
    close_files
    @user.finish
  end

  private

  def close_files
    @generated_files.each {|key, file| file.close}
  end

end

generator = Generator.new('a_01.csv', 'a_01/')
generator.run
