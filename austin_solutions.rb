require 'byebug'
# Write a recursive method that returns all of the permutations of an array
def permutations(array)
  return [array] if array.count <= 1
  duped = array.dup
  first = duped.shift
  perms = permutations(duped)
  all = []
  perms.each do |permutation|
    for i in (0..permutation.length)
      all << permutation.take(i) + [first] + permutation.drop(i)
    end
  end
  all
end

# CHALLENGE: Eight queens puzzle precursor
#
# Write a recursive method that generates all 8! possible unique ways to
# place eight queens on a chess board such that no two queens are in
# the same board row or column (the same diagonal is OK).
#
# Each of the 8! elements in the return array should be an array of positions:
# E.g. [[0,0], [1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7]]
#
# My solution used 3 method parameters: current_row, taken_columns, and
# positions so far
def eight_queens_possibilities(current_row, taken_columns, positions)

end

# make better change problem from class
# make_better_change(24, [10,7,1]) should return [10,7,7]
# make change with the fewest number of coins

# To make_better_change, we only take one coin at a time and
# never rule out denominations that we've already used.
# This allows each coin to be available each time we get a new remainder.
# By iterating over the denominations and continuing to search
# for the best change, we assure that we test for 'non-greedy' uses
# of each denomination.

def make_better_change(value, coins)
  
end

# Write a recursive method that takes in a base 10 number n and
# converts it to a base b number. Return the new number as a string
#
# E.g. base_converter(5, 2) == "101"
# base_converter(31, 16) == "1f"

def base_converter(num, b)
  digits = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f)
  return "" if num == 0
  base_converter(num/b, b) + digits[num % b]
end

# return b^n recursively. Your solution should accept negative values
# for n
def exponent(b, n)
  if n > 0
    return b if n == 1
    b * exponent(b, n - 1)
  else
    return 1 if n == 0
    1.0/(b * exponent(b, (n + 1).abs))
  end
end

# Using recursion and the is_a? method,
# write an Array#deep_dup method that will perform a "deep" duplication of the interior arrays.

def deep_dup(arr)
  ret = []
  arr.each do |el|
    if el.is_a?(Array)
      ret << deep_dup(el)
    else
      ret << el.dup
    end
  end
  ret
end

# Write a recursive method that returns the first "num" factorial numbers.
# Note that the 1st factorial number is 0!, which equals 1. The 2nd factorial
# is 1!, the 3rd factorial is 2!, etc.

def factorials_rec(num)
  return [1] if num == 1
  factorials_rec(num - 1) << factorials_rec(num - 1)[-1] * (num - 1)
end

# Write a method, `digital_root(num)`. It should Sum the digits of a positive
# integer. If it is greater than 10, sum the digits of the resulting number.
# Keep repeating until there is only one digit in the result, called the
# "digital root". **Do not use string conversion within your method.**
#
# You may wish to use a helper function, `digital_root_step(num)` which performs
# one step of the process.

def digital_root(num)
  return num if num < 10
  digital_root((num % 10) + (num / 10))
end

# Write a recursive function that returns the prime factorization of
# a given number. Assume num > 1
#
# prime_factorization(12) => [2,2,3]
def prime_factorization(num)
  # byebug
  return [num] if is_prime?(num)

  for i in (2..Math.sqrt(num))

    if num % i == 0 && is_prime?(i)
      return [i] + prime_factorization(num/i)
    else
      i+=1
    end

  end
  [num]
end

def is_prime?(num)
  root = Math.sqrt(num)
  for i in (2..root)
    return false if num % i == 0
  end
  true
end

# Write a recursive method that takes in a string to search and a key string.
# Return true if the string contains all of the characters in the key
# in the same order that they appear in the key.
#
# string_include_key?("cadbpc", "abc") => true
# string_include_key("cba", "abc") => false
def string_include_key?(string, key)
  if key.length == 1
    return string.include?(key)
  end

  for i in (0...string.length)

    if key[0] == string[i]
      return string_include_key?(string[(i+1)..-1], key[1..-1])
    else
      i+=1
    end
  end
  false
end

#returns all subsets of an array
def subsets(array)
  # byebug
  return [[]] if array.empty?
  subs = subsets(array.take(array.count - 1))
  subs.concat(subs.map {|el| el.dup << array[-1]})
end

# Implement a method that finds the sum of the first n
# fibonacci numbers recursively. Assume n > 0
def fibs_sum(n)
  return 0 if n == 0
  return 1 if n == 1
  fibs_sum(n - 1) + fibs_sum(n - 2) + 1
end

# Write a recursive method that returns the sum of all elements in an array
def rec_sum(nums)
  return 0 if nums.empty?
  nums[0] + rec_sum(nums[1..-1])
end

# return the sum of the first n even numbers recursively. Assume n > 0
def first_even_numbers_sum(n)
  return 2 if n == 1
  n * 2 + first_even_numbers_sum(n - 1)
end

class Array

  def my_rotate(num = 1)
    shift = num % count
    drop(shift) + take(shift)
  end

end

class Hash

  # Write a version of merge. This should NOT modify the original hash
  def my_merge(hash2)
    ret = {}
    self.each do |k,v|
      ret[k] = v
    end
    hash2.each do |k, v|
      ret[k] = v
    end
    ret
  end

end

class Array

  def my_reverse
    array = []
    self.each {|el| array.unshift(el)}
    array
  end

end

class Array
  # Write a method, `Array#two_sum`, that finds all pairs of positions where the
  # elements at those positions sum to zero.

  # NB: ordering matters. I want each of the pairs to be sorted smaller index
  # before bigger index. I want the array of pairs to be sorted
  # "dictionary-wise":
  #   [0, 2] before [1, 2] (smaller first elements come first)
  #   [0, 1] before [0, 2] (then smaller second elements come first)

  def two_sum
    ret = []
    self.each_with_index do |el1, idx1|
      self.each_with_index do |el2, idx2|
        if el2 + el1 == 0 && idx1 != idx2
          indices = [idx1, idx2].sort
          ret << indices unless ret.include?(indices)
        end
      end
    end
    ret
  end

end

# primes(num) returns an array of the first "num" primes.
# You may wish to use an is_prime? helper method.

def is_prime?(num)
  for i in (2..Math.sqrt(num))
    return false if num % i == 0
  end
  true
end

def primes(num)
  ret = []
  i = 2
  until ret.count == num
    ret << i if is_prime?(i)
    i += 1
  end
  ret
end

# Write a method that returns the median of elements in an array
# If the length is even, return the average of the middle two elements
class Array

  def median
    return nil if self.empty?
    duped = self.sort
    mid = duped.count/2
    if count % 2 == 1
      duped[mid]
    else
      (duped[mid] + duped[mid - 1])/2.0
    end
  end

end

class Array

  # Write a monkey patch of binary search:
  # E.g. [1, 2, 3, 4, 5, 7].my_bsearch(5) => 4
  def my_bsearch(target, &prc)
    mid = count/2
    return mid if self[mid] == target
    return nil if length == 1
    lower = take(mid)
    upper = drop(mid)
    if self[mid] < target
      in_upper = upper.my_bsearch(target, &prc)
      in_upper ? mid + in_upper : in_upper
    else
      lower.my_bsearch(target, &prc)
    end
  end

end

# Write a method that returns the factors of a number in ascending order.

def factors(num)
  ret = []
  for i in (1..num)
    ret << i if num % i == 0
  end
  ret
end

class Array

  def my_join(str = "")
    ret = ""
    self.each_with_index do |el, idx|
      if idx == count - 1
        ret << el.to_s
      else
        ret << (el.to_s + str)
      end
    end
    ret
  end

end

class Array

  # Takes a multi-dimentional array and returns a single array of all the elements
  # [1,[2,3], [4,[5]]].my_controlled_flatten(1) => [1,2,3,4,5]
  def my_flatten
    ret = []
    self.each do |el|
      if el.is_a?(Array)
        ret += el.my_flatten
      else
        ret << el
      end
    end
    ret
  end

  # Write a version of flatten that only flattens n levels of an array.
  # E.g. If you have an array with 3 levels of nested arrays, and run
  # my_flatten(1), you should return an array with 2 levels of nested
  # arrays
  #
  # [1,[2,3], [4,[5]]].my_controlled_flatten(1) => [1,2,3,4,[5]]
  def my_controlled_flatten(n)
    ret = []
    self.each do |el|
      if el.is_a?(Array)
        if n > 0
          ret += el.my_controlled_flatten(n-1)
        else
          ret << el
        end
      else
        ret << el
      end
    end
    ret
  end
end

class Array

  # Write an Array#dups method that will return a hash containing the indices of all
  # duplicate elements. The keys are the duplicate elements; the values are
  # arrays of their indices in ascending order, e.g.
  # [1, 3, 4, 3, 0, 3, 0].dups => { 3 => [1, 3, 5], 0 => [4, 6] }

  def dups
    ret = Hash.new {[]}
    self.each_with_index do |el1, idx1|
      self.each_with_index do |el2, idx2|
        if el1 == el2 && idx1 != idx2
          ret[el1] = ret[el1] << idx1 unless ret[el1].include?(idx1)
        end
      end
    end
    ret
  end

end

# Write a method that capitalizes each word in a string like a book title
# Do not capitalize words like 'a', 'and', 'of', 'over' or 'the'
def titleize(title)
  dont = %w(a and of the over or in)
  array = title.split(" ")

  array.map!.with_index do |word, i|
    if i == 0 || !dont.include?(word)
      word.capitalize
    else
      word
    end
  end
  array.join(" ")
end


# Write a method that translates a sentence into pig latin. You may want a helper method.
# 'apple' => 'appleay'
# 'pearl' => 'earlpay'
# 'quick' => 'ickquay'
def pig_latinify(sentence)
  array = sentence.split(" ")
  array.map! {|el| pig_latinify_word(el)}
  array.join(" ")
end

def pig_latinify_word(word)
  vowels = %w(a e i o u)
  dipths =
  if vowels.include?(word[0])
     word + "ay"
  else
    i = find_first_vowel(word)
    word[i..-1] + word[0...i] + 'ay'
  end
end

def find_first_vowel(string)
  vowels = %w(a e i o u)
  i = 0
  until vowels.include?(string[i])
    i+=1
  end

  return i + 1 if string[i] == 'u' && string[i-1] == 'q'
  i
end

# Back in the good old days, you used to be able to write a darn near
# uncrackable code by simply taking each letter of a message and incrementing it
# by a fixed number, so "abc" by 2 would look like "cde", wrapping around back
# to "a" when you pass "z".  Write a function, `caesar_cipher(str, shift)` which
# will take a message and an increment amount and outputs the encoded message.
# Assume lowercase and no punctuation. Preserve spaces.
#
# To get an array of letters "a" to "z", you may use `("a".."z").to_a`. To find
# the position of a letter in the array, you may use `Array#find_index`.

def caesar_cipher(str, shift)
  letters = ('a'..'z').to_a
  ret = ""
  str.each_char do |char|
    if char == " "
      ret << char
    else
      index = letters.index(char)
      index = (index + shift) % letters.length
      ret << letters[index]
    end
  end
  ret
end

class String

  # Write a String#symmetric_substrings method that returns an array of substrings
  # that are palindromes, e.g. "cool".symmetric_substrings => ["oo"]
  # Only include substrings of length > 1.

  def symmetric_substrings
    subs = self.substrings
    subs.select {|el| el == el.reverse && el.length > 1}
  end

end


class String
  # Returns an array of all the subwords of the string that appear in the
  # dictionary argument. The method does NOT return any duplicates.

  def real_words_in_string(dictionary)
    subs = self.substrings
    ret = []
    subs.each do |sub|
      ret << sub if dictionary.include?(sub)
    end
    ret
  end

  def substrings
    i = 0
    ret = []
    while i < length
      k = 0
      while i +k <= length
        ret << self[i..i+k] unless ret.include?(self[i..i+k])
        k+=1
      end
      i+=1
    end
    ret
  end

end

class Array

  def my_reject(&prc)
    ret = []
    self.each {|el| ret << el unless prc.call(el)}
    ret
  end

end

# Write a method that doubles each element in an array
def doubler(array)
  array.map {|el| el*2}
end

class Array

  def my_zip(*arrs)
    ret = []
    self.each_with_index do |el, i|
      temp = [el]
      arrs.each do |array|
        temp << array[i]
      end
      ret << temp
    end
    ret
  end

end

class Array

  def my_each(&prc)
    for i in (0...count)
      prc.call(self[i])
    end
    self
  end

  def my_each_with_index(&prc)
    for i in (0...count)
      prc.call(self[i], i)
    end
    self
  end

end

class Hash

  # Write a version of my each that calls a proc on each key, value pair
  def my_each(&prc)
    key_array = self.keys
    key_array.each do |key|
      prc.call(key, self[key])
    end
    self
  end

end

class Array

  def my_any?(&prc)
    self.each {|el| return true if prc.call(el)}
    false
  end

end

class Array

  def my_all?(&prc)
    self.each {|el| return false unless prc.call(el)}
    true
  end

end

class Array

  # Monkey patch the Array class and add a my_inject method. If my_inject receives
  # no argument, then use the first element of the array as the default accumulator.

  def my_inject(accumulator = nil, &prc)
    duped = self.dup
    accumulator ||= duped.shift
    duped.each do |el|
      accumulator = prc.call(accumulator, el)
    end
    accumulator
  end

end


class Array

  def my_select(&prc)
    ret = []
    self.each do |el|
      ret << el if prc.call(el)
    end
    ret
  end

end

# Jumble sort takes a string and an alphabet. It returns a copy of the string
# with the letters re-ordered according to their positions in the alphabet. If
# no alphabet is passed in, it defaults to normal alphabetical order (a-z).

# Example:
# jumble_sort("hello") => "ehllo"
# jumble_sort("hello", ['o', 'l', 'h', 'e']) => 'ollhe'

def jumble_sort(str, alphabet = nil)
  alphabet ||= ('a'..'z').to_a
  array = str.chars.sort_by {|char| alphabet.index(char)}
  array.join
end

class Array

  # Write an Array#merge_sort method; it should not modify the original array.

  def merge_sort(&prc)
    return self if count <= 1
    prc ||= Proc.new {|el1, el2| el1 <=> el2}
    left = take(count/2)
    right = drop(count/2)
    Array.merge(left.merge_sort(&prc), right.merge_sort(&prc), &prc)
  end

  private
  def self.merge(left, right, &prc)
    ret = []
    until left.empty? || right.empty?
      if prc.call(left.first, right.first) == -1
        ret << left.shift
      else
        ret << right.shift
      end
    end
    ret + left + right
  end

end

class Array

  def bubble_sort!(&prc)
    sorted = false
    prc ||= Proc.new {|el1, el2| el1 <=> el2}
    until sorted
      sorted = true
      i = 0
      for i in (0...count-1)
        if prc.call(self[i], self[i+1]) == 1
          self[i], self[i+1] = self[i+1], self[i]
          sorted = false
        end
      end
    end
    self
  end

  def bubble_sort(&prc)
    duped = self.dup
    duped.bubble_sort!(&prc)
  end
end

class Array

  #Write a monkey patch of quick sort that accepts a block
  def my_quick_sort!(&prc)
    prc ||= Proc.new {|el1, el2| el1 <=> el2}
    return self if count <= 1
    pivot = self.pop
    less = []
    more = []
    self.each do |el|
      if prc.call(el, pivot) == -1
        less << el
      else
        more << el
      end
    end
    less.my_quick_sort(&prc) + [pivot] + more.my_quick_sort(&prc)
  end

  def my_quick_sort(&prc)
    self.dup.my_quick_sort!(&prc)
  end
end
