require 'colorize'
require 'byebug'
require_relative 'user'
require_relative 'file_read'

class Generator

  def initialize(path)
    @reader = FileReader.new(path)
    @user = FirstUser.new
  end

  def give_user_problems
    @user.make_defaults(@reader.count_problems)
  end

  def run
    @user.initial_instructions
    give_user_problems
    @user.create_request_hash(@reader.categories)
    @reader.make_files(@user.request)
    @user.finish
  end

end

generator = Generator.new('a_01')
generator.run
