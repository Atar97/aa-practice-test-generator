require 'csv'
require 'colorize'
require 'byebug'
require_relative 'user'
require_relative 'file_read'

class Generator

  def initialize(path)
    @reader = FileReader.new(path)
    @categories = @reader.categories
    @generated_files = {}
    @user = User.new
  end

  def give_user_problems
    @user.make_defaults(@reader.count_problems)
  end

  def make_problem_master
    master = []
    @categories.each do |category|
      all_prob_category = []
      @reader.csv.each do |test_info_array|
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
