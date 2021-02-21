## Question 5 ##

using Random
Random.seed!(0)

charSet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", 
"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 
"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "~", "!", "@", "#", "\$", "%", "^", "&", "*", "(", ")", "_", "+", "=", "-", "`"]

originalPassword = "Quora`24"
passwordArr = split(originalPassword, "")

n = 8
iter = 1000000
count = 0

for i = 1:iter
    global count
    matches = 0
    for j = 1:n
        randChar = rand(charSet)
        if randChar == passwordArr[j]
            matches = matches + 1
        end
    end
    if matches >= 3
        count = count + 1
    end
end

prob = count/iter

println("The probability of password getting stored in the database is $prob")