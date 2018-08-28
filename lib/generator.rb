require 'byebug'
require_relative 'user'
require_relative 'file_read'

class Generator

  def initialize(path)
    @reader = FileReader.new(path)
    @user = FirstUser.new('lib/outputs/g1.txt')
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


class G2

  def initialize(path)
    @reader = FileReader.new(path)
    @user = SecondUser.new
  end

end

if __FILE__ == $PROGRAM_NAME
  g1 = Generator.new('a_01')
  g1.run
end
