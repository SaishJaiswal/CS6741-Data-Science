## Question 2 ##

using Plots
pyplot()

using Random
Random.seed!(0)

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
    println("---------- For n = $n -----------")
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

    println("Probability of getting exactly $n Jacks (with replacement) is $prob")

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

    println("Probability of getting exactly $n Jacks (without replacement) is $prob")

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

    println("Probability of getting at least $n Jacks (with replacement) is $prob")

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

    println("Probability of getting at least $n Jacks (without replacement) is $prob")
end

###################### Plot ######################
N = collect(0:4)

p = plot(N, probExactN_R, lw=3, label="Exact n (with replacement)", title="Experimental Results", xlabel="Number of Jacks (n)", ylabel="Probability")
plot!(p, N, probExactN_WR, lw=3, label="Exact n (without replacement)", ls=:dashdot)
plot!(p, N, probAtLeastN_R, lw=3, label="At least n (with replacement)")
plot!(p, N, probAtLeastN_WR, lw=3, label="At least n (without replacement)", ls=:dashdot)
savefig("experimentalResults.png")