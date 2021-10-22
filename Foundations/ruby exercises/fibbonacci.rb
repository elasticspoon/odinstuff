def fibs(num)
  arr = []
  (num + 1).times do |i|
    arr[i] = 0 if i.zero?
    arr[i] = 1 if i == 1
    arr[i] = (arr[i - 1] + arr[i - 2]) if i > 1
  end
  arr
end

def fibs_recur(num)
  return [0] if num.zero?
  return fibs_recur(num - 1) << 1 if num == 1

  arr = fibs_recur(num - 1)
  arr << (arr[num - 1] + arr[num - 2])
end

10.times do |i|
  puts i
  puts fibs(i).inspect
  puts fibs_recur(i).inspect
end
