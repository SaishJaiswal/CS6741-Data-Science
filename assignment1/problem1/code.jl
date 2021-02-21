## Question 1 ##
using Random
Random.seed!(0)

using Plots
pyplot()

k = []	# To store the number of iterations
v = []	# To store the average value

N = 1000 # Range of integers: -N to N

for iter = 100:10000:1000000
	sum = 0
	for _ in 1:iter
		sum = sum + rand(-N:N)
	end
	avg = sum/iter
	push!(k,iter)
	push!(v,avg)
end


#################### Plot ####################
p = plot(k,v, xlabel = "Iterations", ylabel = "Average", legend=false)
plot!(p)
savefig("LoLN.png")