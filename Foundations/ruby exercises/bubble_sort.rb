def bubbleSort(arr)
    n = arr.length - 1
    loop do 
        m = 0
        (1..n).to_a.each do |i|
            if arr[i-1] > arr[i]
                temp = arr[i-1]
                arr[i-1] = arr[i]
                arr[i] = temp
                m = i
            end
        end
        n = m
        if n <= 1
            return arr
        end
    end
    arr
end

puts bubbleSort([4,3,78,2,0,2])