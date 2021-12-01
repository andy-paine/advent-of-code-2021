package aoc

nums = [num | n := split(input, " ")[_]; num := to_number(n)]
part_1 = count(increase)
part_2 = count(moving_increase)

increase[i] {
    i := numbers.range(1, count(nums))[_]
    nums[i] > nums[i-1]
}

moving_increase[i] {
    i := numbers.range(3, count(nums))[_]
    sum(array.slice(nums, i-2, i+1)) > sum(array.slice(nums, i-3, i))
}

tests["part-1"] = "PASSED" {
    inc := part_1 with input as `199 200 208 210 200 207 240 269 260 263`
    inc == 7
}

tests["part-2"] = "PASSED" {
    inc := part_2 with input as `199 200 208 210 200 207 240 269 260 263`
    inc == 5
}
