def buy_sell(price_arr)
    sale = [0, price_arr.length - 1]

    (0..price_arr.length-1).to_a.each do |i|
        (i..price_arr.length-1).to_a.each do |j|
            if price_arr[sale[1]] - price_arr[sale[0]] < price_arr[j] - price_arr[i] 
                sale = [i, j]
            end
        end
    end
    sale
end 


puts buy_sell([17,3,6,9,15,8,6,1,10])

