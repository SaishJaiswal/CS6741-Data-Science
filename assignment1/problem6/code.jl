## Question 6 ##

using Plots
pyplot()

pValue = []
probValue = []

for p = 0.1:0.1:1
    local prob = 0
    for i = 10:20
        prob = prob + binomial(20,i)*((1-p)^i)*(p^(20-i))
    end
    push!(pValue, p)
    push!(probValue, prob)
    println("For p = $p, the probability of being left with at least Rs. 10 at the end of 20 days is $prob")
end

p = plot(pValue, probValue, xlabel = "Value of p", ylabel="Probability", legend = false, title="Results for different values of p (Que.6)", lw=3)
plot!(p)
savefig("atleast10.png")