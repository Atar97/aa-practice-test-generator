require 'csv'
require 'colorize'
require 'byebug'
require_relative 'user'
require_relative 'file_read'

class Generator

  def initialize(path)
    @dir = path
    @reader = FileReader.new(path)
    @problem_csv = @reader.read_csv_file
    @categories = Generator.make_categories(@problem_csv)
    @generated_files = {}
    @user = User.new
  end

  def give_user_problems
    @user.make_defaults(count_problems)
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


  def run
    @user.initial_instructions
    give_user_problems
    @user.create_request_hash(@categories)
    @reader.make_files(make_problem_master)
    @user.finish
  end

end

generator = Generator.new('a_01')
generator.run
