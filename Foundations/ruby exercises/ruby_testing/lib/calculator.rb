# lib/calculator.rb

class Calculator
  def add(*args)
    args.sum
  end

  def multiply(*args)
    args.inject(:*)
  end
end
