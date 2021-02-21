## Question 8 ##

using Plots
pyplot()

pValue = []
probValue = []

for p = 0.1:0.1:1
    local prob = 0
    local denom = 0
    for i = 10:20
        prob = prob + binomial(20,i)*((1-p)^i)*(p^(20-i))
    end
    for i = 6:9
        denom = denom + binomial(20,i)*((1-p)^i)*(p^(20-i))
    end
    push!(pValue, p)
    expectedProb = prob/(prob+denom)
    if prob+denom == 0
        expectedProb = 0.0000000001
    end
    push!(probValue, expectedProb)
    println("For p = $p, the probability of being left with Rs. 10 at the end of 20 days (given that you don't go bankrupt at least once) is $expectedProb")
end

p = plot(pValue, probValue, xlabel = "Value of p", ylabel="Probability", legend = false, title="Results for different values of p (Que.8)", lw=3)
plot!(p)
savefig("condProb.png")