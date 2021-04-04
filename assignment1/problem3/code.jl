## Question 3 ##

using Random
Random.seed!(0)

using Plots
pyplot()

################# Experimental Calculations ################# 

# Initializing the deck
deck = Set(collect(Iterators.product(["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"],["Spade","Heart","Diamond","Club"])))

# Number of experiments
iter = 1000000 

# For storing probabilities
probExactN_R = []
probExactN_WR = []
probAtLeastN_R = []
probAtLeastN_WR = []

for n = 0:4
    ## With replacement (exactly n Jacks)
    suc = 0
    for i = 1:iter
        #global suc
        local count = 0
        for j = 1:5
            local card = rand(deck)[1]
            if card == "J"
                count = count + 1
            end
        end
        if count == n
            suc = suc + 1
        end
    end

    prob = suc/iter
    push!(probExactN_R, prob)

    ## Without replacement (exactly n Jacks)
    suc = 0
    for i = 1:iter
        #global suc
        local count = 0
        local tempDeck = copy(deck)
        for j = 1:5
            local card = rand(tempDeck)
            if card[1] == "J"
                count = count + 1
            end
            setdiff!(tempDeck, Set([card]))
        end
        if count == n
            suc = suc + 1
        end
    end

    prob = suc/iter
    push!(probExactN_WR, prob)

    ## With replacement (at least n Jacks)
    suc = 0
    for i = 1:iter
        #global suc
        local count = 0
        for j = 1:5
            local card = rand(deck)[1]
            if card == "J"
                count = count + 1
            end
        end
        if count >= n
            suc = suc + 1
        end
    end

    prob = suc/iter
    push!(probAtLeastN_R, prob)

    ## Without replacement (at least n Jacks)
    suc = 0
    for i = 1:iter
        #global suc
        local count = 0
        local tempDeck = copy(deck)
        for j = 1:5
            local card = rand(tempDeck)
            if card[1] == "J"
                count = count + 1
            end
            setdiff!(tempDeck, Set([card]))
        end
        if count >= n
            suc = suc + 1
        end
    end

    prob = suc/iter
    push!(probAtLeastN_WR, prob)
end


println("############# Experimental Results #############")
for n = 0:4
    println("---------- For n = $n -----------")
    prob = probExactN_R[n+1]
    println("Probability of getting exactly $n Jacks (with replacement) is $prob")
    prob = probExactN_WR[n+1]
    println("Probability of getting exactly $n Jacks (without replacement) is $prob")
    prob = probAtLeastN_R[n+1]
    println("Probability of getting at least $n Jacks (with replacement) is $prob")
    prob = probAtLeastN_WR[n+1]
    println("Probability of getting at least $n Jacks (without replacement) is $prob")
end

#################  Theoretical Calculations ################# 

# For storing probabilities
probExactN_R_Theoretical = []
probExactN_WR_Theoretical = []
probAtLeastN_R_Theoretical = []
probAtLeastN_WR_Theoretical = []

# With replacement -- Binomial Distribution
# Exact n Jacks
for n = 0:4
    prob = binomial(5,n) * (4/52)^n * (48/52)^(5-n)
    push!(probExactN_R_Theoretical, prob)
end

# At least n Jacks
for n = 0:4
    s = 0
    for i = n:4
        s = s + probExactN_R_Theoretical[i+1]
    end
    push!(probAtLeastN_R_Theoretical, s)
end

# Without replacement -- Hypergeometric Distribution
# Exact n Jacks
for n = 0:4
    prob = (binomial(4,n)*binomial(48, 5-n))/binomial(52,5)
    push!(probExactN_WR_Theoretical, prob)
end

# At least n jacks
for n = 0:4
    s = 0
    for i = n:4
        s = s + probExactN_WR_Theoretical[i+1]
    end
    push!(probAtLeastN_WR_Theoretical, s)
end

N = collect(0:4)

println("############# Theoretical Results #############")
for n = 0:4
    println("---------- For n = $n -----------")
    prob = probExactN_R_Theoretical[n+1]
    println("Probability of getting exactly $n Jacks (with replacement) is $prob")
    prob = probExactN_WR_Theoretical[n+1]
    println("Probability of getting exactly $n Jacks (without replacement) is $prob")
    prob = probAtLeastN_R_Theoretical[n+1]
    println("Probability of getting at least $n Jacks (with replacement) is $prob")
    prob = probAtLeastN_WR_Theoretical[n+1]
    println("Probability of getting at least $n Jacks (without replacement) is $prob")
end

#=
################# Plots ################# 
N = collect(0:4)

# Exact n Jacks (With Replacement)
p_EN_R = plot(N, probExactN_R, lw=3, label="Experimental", title="Exactly n Jacks (with replacement)", xlabel="Number of Jacks (n)", ylabel="Probability")
plot!(p_EN_R, N, probExactN_R_Theoretical, lw=3, ls=:dashdot, label="Theoretical")
savefig("ExactN_R.png")

# Exact n Jacks (Without Replacement)
p_EN_WR = plot(N, probExactN_WR, lw=3, label="Experimental", title="Exactly n Jacks (without replacement)", xlabel="Number of Jacks (n)", ylabel="Probability")
plot!(p_EN_WR, N, probExactN_WR_Theoretical, lw=3, ls=:dashdot, label="Theoretical")
savefig("ExactN_WR.png")

# At least n Jacks (With Replacement)
p_ALN_R = plot(N, probAtLeastN_R, lw=3, label="Experimental", title="At least n Jacks (with replacement)", xlabel="Number of Jacks (n)", ylabel="Probability")
plot!(p_ALN_R, N, probAtLeastN_R_Theoretical, lw=3, ls=:dashdot, label="Theoretical")
savefig("AtLeastN_R.png")

# At least n Jacks (Without Replacement)
p_ALN_WR = plot(N, probAtLeastN_WR, lw=3, label="Experimental", title="At least n Jacks (without replacement)", xlabel="Number of Jacks (n)", ylabel="Probability")
plot!(p_ALN_WR, N, probAtLeastN_WR_Theoretical, lw=3, ls=:dashdot, label="Theoretical")
savefig("AtLeastN_WR.png")
=#