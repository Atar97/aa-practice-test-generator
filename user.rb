class User

  def initialize
    @defaults = {}
    @input

  end

  def initial_instructions
    system("clear")
    puts "Welcome to a/A Practice 01Assessment Generator 2.0".cyan
    puts "This generator will create a practice test based on your input. " \
          "You can choose how many problems from each category to include in your test. "
    puts "This program will generate 3 files in this folder: practice_test, spec, and solution. " \
          "Complete the practice_test file, running the spec file to check your answers. " \
          "When your time is up (you are timing yourself, right?), compare your answers to the solutions."
    puts "Good luck!"
  end

  def make_defaults(problem_counts)
    counts = problem_counts
    @defaults[:"1"] = ["array: 2, recursion: 1, sort: 1"]
    @defaults[:"2"] = ["recursion: 3, sort: 2, enumerable: 1"]
    @defaults[:"3"] = ["array: 3, recursion: 1, sort: 1, string: 2"]
    @defaults[:"4"] = ["array: 1, recursion: 1, sort: 1, enumerable: 1, string: 1"]
    @defaults[:"5"] = ["array: 2, recursion: 1, sort: 1"]
    @defaults[:"6"] = ["array: 2, recursion: 1, sort: 1"]
    @defaults[:"7"] = ["Every array problem", "array: #{counts['array']}"]
    @defaults[:"8"] = ["Every recursion problem", "recursion: #{counts['recursion']}"]
    @defaults[:"9"] = ["Every string problem", "string: #{counts['string']}"]
    @defaults[:"10"] = ["Every enumerable problem", "enumerable: #{counts['enumerable']}"]
    @defaults[:"11"] = ["Every sort problem", "sort: #{counts['sort']}"]
    all_probs_str = ""
    counts.each do |category, number|
      all_probs_str += "#{category}: #{number}, "
    end
    all_probs_str = all_probs_str[0..-3]
    @defaults[:"12"] = ["Every Problem", all_probs_str]
    @defaults
  end

end
