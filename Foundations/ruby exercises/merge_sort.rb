def merge(left_arr, right_arr)
  left_arr.concat(right_arr).sort
end

def merge_sort(arr = [])
  return arr if arr.length < 2

  left_arr = merge_sort(arr[0...arr.length / 2])
  right_arr = merge_sort(arr[arr.length / 2..arr.length])
  merge(left_arr, right_arr)
end

random = (0..100).to_a
puts merge_sort(random.sample(10)).inspect
