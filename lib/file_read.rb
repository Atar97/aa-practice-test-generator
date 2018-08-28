# require 'singleton'
class FileReader

  # include Singleton

  attr_reader :csv

  def initialize(file_path)
    @path = file_path
    @files = {}
    @csv = FileReader.read_csv_file(@path)
  end

  def self.read_csv_file(path)
    CSV.read("#{path}/#{path}.csv", headers: true, header_converters: :symbol, converters: :all)
  end

  def categories
    @csv.map {|test_info| test_info[1]}.uniq
  end

  def count_problems
    problem_counts = Hash.new(0)
    @csv.each { |test_info| problem_counts[test_info[1]] += 1}
    problem_counts
  end

  def make_files(requests)
    generate_new_files
    add_requirements
    add_questions(make_problem_master(requests))
    close_files
  end

  def make_problem_master(requests)
    master = []
    categories.each do |category|
      all_prob_in_category = []
      @csv.each do |test_info|
        if category == test_info[1]
          all_prob_in_category << test_info
        end
      end
      needed_problems = all_prob_in_category.sample(requests[category])
      master.concat(needed_problems)
    end
    master
  end

  def generate_new_files
    @files[:prac] = File.open("#{@path}/practice_test.rb", "w")
    @files[:spec] = File.open("#{@path}/spec.rb", "w")
    @files[:sol] = File.open("#{@path}/solution.rb", "w")
  end

  def add_requirements
    @files[:spec] << "require 'rspec'\nrequire_relative 'practice_test'\n"
    @files[:prac] << "require 'byebug'\n"
  end

  def add_questions(problem_info_array)
    problem_info_array.each do |file_name|
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
