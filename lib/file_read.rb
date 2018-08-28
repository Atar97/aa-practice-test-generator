# require 'singleton'
class FileReader

  # include Singleton

  def initialize(file_path)
    @path = file_path
    @files = {}
  end

  def read_csv_file
    CSV.read("#{@path}/#{@path}.csv", headers: true, header_converters: :symbol, converters: :all)
  end

  def make_files(problem_master)
    generate_new_files
    add_requirements
    add_questions(problem_master)
    close_files
  end


  def generate_new_files
    @files[:prac] = File.open("#{@path}/practice_test.rb", "w")
    @files[:spec] = File.open("#{@path}/spec.rb", "w")
    @files[:sol] = File.open("#{@path}/solution.rb", "w")
  end

  def add_requirements
    @files[:spec] << "require 'rspec'\n"
    @files[:spec] << "require_relative 'practice_test'\n"
    @files[:prac] << "require 'byebug'\n"
  end

  def add_questions(problem_info_array)
    problem_info_array.each do |file_name|
      # byebug
      @files[:prac] << File.read("#{@path}/#{file_name[2]}") << "\n"
      @files[:spec] << File.read("#{@path}/#{file_name[3]}") << "\n"
      @files[:sol] << File.read("#{@path}/#{file_name[4]}") << "\n"
    end
  end

  private

  def close_files
    @files.each {|_, file| file.close}
  end

end
