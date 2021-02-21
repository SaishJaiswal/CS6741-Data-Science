## Question 7 ##

using Plots
pyplot()

pValue = []
probValue = []

for p = 0.1:0.1:1
    local prob = 0
    for i = 6:20
        prob = prob + binomial(20,i)*((1-p)^i)*(p^(20-i))
    end
    expectedProb = 1 - prob
    push!(pValue, p)
    push!(probValue, expectedProb)
    println("For p = $p, the probability of going bankrupt at least once is $expectedProb")
end

p = plot(pValue, probValue, xlabel = "Value of p", ylabel="Probability", legend = false, title="Results for different values of p (Que.7)", lw=3)
plot!(p)
savefig("bankruptAtLeastOnce.png")