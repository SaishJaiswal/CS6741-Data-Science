### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 2be71d07-8e3e-49bc-805c-8c7e893d80cf
begin
using Random
Random.seed!(0)
using Distributions
using QuadGK
using StatsBase
using Plots
plotly()
using StatsPlots
end

# ╔═╡ cce67491-db64-462e-a3a7-df2f47b959ff
md"
# Assignment 4
"

# ╔═╡ e327fe76-3713-4529-a793-e8962ce3f9fc
md"
**Question 1:** You are a statistical (and boring) version of the Two-Face. You throw a fair coin 50 times. If it comes out Heads in at least 30 out of these 50 tosses, you decide to go ahead with a decision. 

Compute the probability of you going ahead with the decision. Do this in three different ways: 
"

# ╔═╡ 94ceb124-6dc3-4dc5-9c03-d25b2e4e8631
md"
- Monte Carlo simulation of using an appropriately chosen large number of trials
"

# ╔═╡ 5f199c02-abcd-11eb-07ff-73115d877daa
begin
	# H-Heads, T-Tails
	Toss = ['H', 'T']
	
	# Number of trials
	nTrials = 1000000
	
	# To store the number of times we go ahead
	countGoingAhead = 0
	
	# Computing the probability of going ahead
	for i = 1:nTrials
		Tosses = rand(Toss, 50)
		countH = sum(Tosses .== 'H')
		if countH >= 30
			global countGoingAhead = countGoingAhead + 1
		end
	end
	
	# Probability of going ahead
	prob1 = countGoingAhead/nTrials
end

# ╔═╡ 8092a41e-7b10-4730-a4d6-b7a434987634
md"
- Computation using the binomial distribution
"

# ╔═╡ b169b4fd-4483-469f-bc93-8d41cba37059
begin
	prob2 = 0
	
	# Computing the probability of going ahead
	for i = 30:50
		prob2 = prob2 + binomial(50,i)/(2^50)
	end
	
	# Probability of going ahead
	prob2
end

# ╔═╡ a18c293b-c8f0-4535-9ac2-29285ffded2c
md"
- Approximation using the central limit theorem
"

# ╔═╡ c1f2d272-32dd-4870-840d-24ee41905945
begin
	# μ = p = 0.5
	# New Mean = nμ
	μ1 = 50*0.5
	
	# σ = √p(1-p)	
	# New Std. Dev. = σ√n
	σ1 = sqrt(50)*0.5
	
	# Computing the probability of going ahead
	D1 = Normal(μ1,σ1)
	prob3, err = quadgk(x->pdf(D1,x), 29.5, 25+5σ1)
	
	# Probability of going ahead
	prob3
end

# ╔═╡ 1da2000f-34b2-4762-bebe-af93f58b7bfb
md"
**Question 2:** Since you are Two-Face, you would like to tweak the two faces of the coin. You want to minimally increase the probability of a toss coming up as Heads such that the above experiment has at least a 50% chance of going ahead. 

Solve this problem using CLT.

Verify that you have solved the problem with both Monte Carlo simulations and using the analytical Binomial distribution. 
"

# ╔═╡ 0371253e-eac8-4724-91f7-cb669aac64ec
md"
- Solution using CLT
"

# ╔═╡ 7839f528-fde9-4c8f-9dbd-75a52675c662
md"
Let probability of getting a head = $P(H) = p = 0.5 + x$

Therefore, the probability of getting a tail = $P(T) = 1-p = 0.5 - x$

Considering the samples points as IIDs, we apply CLT to approximate the distribution to Normal.

The mean of the Normal distribution = $50*μ = 50*p = 50*(0.5+x)$

The standard deviation of the Normal distribution = $\sqrt{50} * \sqrt{p(1-p)} = \sqrt{50} * \sqrt{0.25 - x^2}$
"

# ╔═╡ ff1b9e4b-0bfc-4460-b8c5-ce4c3c2f8b82
begin
	# To store the probability value
	prob4 = 0.0
	x_val = 0.0
	
	# To find the bias of the coin for which the P(Count of Head > 30) ≥ 0.5
	for x = 0.01:0.01:0.5
		μ2 = 25+50x
		σ2 = sqrt(50)*sqrt(0.25-x^2)
		D2 = Normal(μ2,σ2)
		
		# Computing the probability of going ahead
		prob4, err = quadgk(x->pdf(D2,x), 29.5, 25+5σ2)
		if prob4 >= 0.5
			x_val = x
			break
		end
	end
	
	# Probability of getting a Head
	pHead = 0.5 + x_val
	"Probability of getting a Head = $pHead"
end

# ╔═╡ 06a26309-0f15-4814-8b0a-7985aa0937a9
"Probability of going ahead = $prob4"

# ╔═╡ 8de4aaef-6926-4354-a606-27ca6310e508
md"
- Checking solution with Monte Carlo simulations
"

# ╔═╡ 59c1526d-7696-4820-b679-b68e9cf7ce48
begin
	# To store the number of times we go ahead
	countGoingAhead2 = 0
	
	# Biased coin with P(H) = 0.6
	coin = Bernoulli(0.6)
	
	# Computing the probability of going ahead
	for i = 1:nTrials
		Tosses = rand(coin, 50)
		countH = sum(Tosses)
		if countH >= 30
			global countGoingAhead2 = countGoingAhead2 + 1
		end
	end
	
	# Probabilty of getting a Head
	prob5 = countGoingAhead2/nTrials
end

# ╔═╡ f0413748-81d6-46ef-8f4c-43421ec831fa
md"
- Checking solution with Binomial distribution - an analytical formula
"

# ╔═╡ b11d3d44-fa69-48f6-af11-dedfe8a738a1
begin
	prob6 = 0
	pH = 0.6
	pT = 0.4
	
	# Computing the probability of going ahead
	for i = 30:50
		prob6 = prob6 + binomial(50,i)*(pH^i)*(pT^(50-i))
	end
	
	# Probabilty of getting a Head
	prob6
end

# ╔═╡ 78225b05-3531-4400-9212-c2627e006e0b
md"
**Question 3:** You are on the world’s first civilian migration to Mars. You have to of course depend on spacesuits for survival. Each space suit can last for an average of 100 days but with a standard deviation of 30 days. Estimate the minimum number of space suits you have to pack in your luggage to last 3000 days with a probability of at least 95%. 

Setup the computation using Central Limit Theorem and then write the Julia code to explore the right number of space suits.
"

# ╔═╡ 1cc0a469-188b-4890-a620-871e9c4b9121
md"
- Analytical setup/argument with Central Limit Theorem
"

# ╔═╡ 06a48d7b-fa3c-46b7-8727-b7c7a35378b7
md"
Given that the population mean (μ) is 100 days and the population standard deviation (σ) is 30 days.

We assume that the distribution for the number of days is continuous.

Let the sample size (number of suits) be $n$.

Assuming all the $n$ sample elements as IIDs, by CLT, the mean and standard deviation of the normal distribution will be:

$\mu_N = n*\mu$
$\sigma_N = \sqrt{n}*\sigma$

We transform this distribution to standard normal by using Z-score. The z-score for the value 3000 will be

$Z = \frac{3000-\mu_N}{\sigma_N}$

Now, the probability of the $n$ space suits lasting for at least 3000 days is given by the area under the standard normal distribution from Z to ∞.

We find the value $n$ such that the area is at least 95%.
"

# ╔═╡ cbf0ecac-ee38-42a5-ab3f-75ced21ef666
md"
- Julia code 
"

# ╔═╡ dbef19da-fe9e-4a37-bf64-4f48cf28a23e
# Assuming the distribution of the number of days is continuous
# Without continuity correction -- assuming the number of days can be fractional
begin
	μ3 = 100
	σ3 = 30
	D3 = Normal(0,1)
	n_suits = 0
	for n = 1:100
		μ3_new = μ3*n
		σ3_new = σ3*sqrt(n)
		Z = (3000 - μ3_new)/σ3_new
		# Without continuity correction
		prob7, err = quadgk(x->pdf(D3,x), Z-0.5, 5)
		if prob7 >= 0.95
			n_suits = n
			break
		end
	end
	"Total number of suits required = $n_suits"
end

# ╔═╡ c032d068-8f1d-45df-a805-77d0bfeae33e
md"
**Question 4** One way to compare distributions is to ensure that the first few moments of two distributions are reasonably close. For each of the following distributions, compute the smallest sample size at which the approximation made to the normal distribution derived from CLT matches the first four moments within 5% (wrt the Normal distribution):
- Uniform distribution between 0 and 1
- Binomial distribution with p = 0.01
- Binomial distribution with p = 0.5
- Chi-square distribution with 3 degrees of freedom
"

# ╔═╡ 8c13301a-bce5-4c72-8177-c23505c1853b
md"
- Common Julia code 
"

# ╔═╡ fb58bb49-3a27-4b45-94fe-63f18a8b6d2e
# Funtion to compute the smallest sample size required
function ComputeMinSampleSize(D)
	D4 = D
	NormalD = Normal(0,1)
	μ4 = mean(D4)
	σ4 = std(D4)
	nSamples = 500
	samples = []
	sampleSize = 1
	Condition = 1
	# Set the threshold here
	threshold = 0.1
	while Condition == 1
		# Empirically getting the results
		for i = 1:nSamples
			sample = rand(D4,sampleSize)
			sample = (sample .- μ4)./(σ4*sqrt(sampleSize))
			push!(samples, sum(sample))
		end
		samples = convert(Array{Float64,1}, samples)

		abs_mean_diff = abs(mean(samples) - mean(NormalD))
		abs_std_diff = abs(std(samples)-std(NormalD))
		abs_skewness_diff = abs(skewness(samples)- skewness(NormalD))
		abs_kurtosis_diff = abs(kurtosis(samples)- kurtosis(NormalD))
		
		if abs_skewness_diff <= threshold && abs_kurtosis_diff <= threshold
			Condition = 0
		else
			sampleSize = sampleSize + 1
		end
	end
	return samples, sampleSize
end

# ╔═╡ cca84ff5-6876-4d63-b6e3-412162e9469a
md"
- Part a)
"

# ╔═╡ a7209344-3fba-441e-93d0-1ecbd3f40769
begin
	# Uniform distribution between 0 and 1
	D4_1 = Uniform(0,1)
	samples1, minSampleSize1 = ComputeMinSampleSize(D4_1) 
	"The smallest sample size required is = $minSampleSize1"
end

# ╔═╡ b1944ed6-8680-45f8-bc73-6285f5970f0c
begin
StatsPlots.density(samples1, line=3, color=:red, label="CLT Approx.")
plot!(x->x, x->pdf(Normal(0,1),x), -4, 4, line=2, color=:blue, label="N(0,1)")
end

# ╔═╡ d87b1f6b-134c-48ac-98f7-81448e55931e
md"
- Part b)
"

# ╔═╡ 32f8d1bb-3e26-4a57-9c86-e75f8aabd225
begin
	# Binomial distribution with p = 0.01, n=100
	D4_2 = Binomial(100, 0.01)
	samples2, minSampleSize2 = ComputeMinSampleSize(D4_2)
	"The smallest sample size required is = $minSampleSize2"
end

# ╔═╡ 2916c81d-d657-49c9-8fac-5da31c16f5f9
begin
StatsPlots.density(samples2, line=3, color=:red, label="CLT Approx.")
plot!(x->x, x->pdf(Normal(0,1),x), -4, 4, line=2, color=:purple, label="N(0,1)")
end

# ╔═╡ bbca7b0a-6f93-42c6-bec8-bb8000225dfd
md"
- Part c)
"

# ╔═╡ edd86ff8-3d2f-41d9-bea4-c00545ff75bd
begin
	# Binomial distribution with p = 0.5, n=100
	D4_3 = Binomial(100, 0.5)
	samples3, minSampleSize3 = ComputeMinSampleSize(D4_3) 
	"The smallest sample size required is = $minSampleSize3"
end

# ╔═╡ 45f23ad7-f2de-4676-9a16-ad5687add5e8
begin
StatsPlots.density(samples3, line=3, color=:red, label="CLT Approx.")
plot!(x->x, x->pdf(Normal(0,1),x), -4, 4, line=2, color=:green, label="N(0,1)")
end

# ╔═╡ cef51b5c-9c32-456b-a715-059c70fdc82e
md"
- Part d)
"

# ╔═╡ ea8e8d69-b508-4f9d-8380-5fd76059306b
begin
	# Chi-square distribution with 3 degrees of freedom
	D4_4 = Chisq(3)
	samples4, minSampleSize4 = ComputeMinSampleSize(D4_4) 
	"The smallest sample size required is = $minSampleSize4"
end

# ╔═╡ 7d630f06-732e-443b-9c2a-fa95bb011d9a
begin
StatsPlots.density(samples4, line=3, color=:red, label="CLT Approx.")
plot!(x->x, x->pdf(Normal(0,1),x), -4, 4, line=2, color=:yellow, label="N(0,1)")
end

# ╔═╡ aa1b87d1-ffdf-40cd-9483-c3f940276d01
md"
**Question 5:** You are running a business of selling tea bags. You pack a set of 100 tea bags into a tea box which should weigh an average of 200 grams. You want a tight control on the standard deviation of the weight of the tea box. In particular, you want the probability that the variance of the tea box is greater than 5 grams2 to be less than 0.1. What should be the maximum variance when weighing individual tea bags for this condition to hold?
"

# ╔═╡ 2574d836-9996-4736-8abe-492e4d4c1426
md"- Analytical derivation 
"

# ╔═╡ ea8616bc-02b9-48eb-bea8-4c9bd7b2df0d
md"
We know $\frac{(n-1)S_{n-1}^2}{\sigma^2}$ follows a Chi-square distribution $\chi^2(n-1)$

$P(S_{n-1}^2 > 5) = P(\frac{(n-1)S_{n-1}^2}{\sigma^2} > \frac{(n-1)*5}{\sigma^2} )$

$n = 100$

$\therefore P(S_{99}^2 > 5) = P(\frac{(99)S_{n-1}^2}{\sigma^2} > \frac{(99)*5}{\sigma^2} ) = P(Y > \frac{(99)*5}{\sigma^2})$

Now, $ P(Y > \frac{(99)*5}{\sigma^2}) < 0.1$

$1 - CDF(\chi^2_{99}, \frac{(99)*5}{\sigma^2}) < 0.1$
"

# ╔═╡ e0180cb0-c3f5-4498-a63e-ebd9170cfe07
begin
	varTeaBag = 5
	while true
		prob5 = 1 - cdf(Chisq(99), 99*5/varTeaBag)
		if prob5 > 0.1
			global varTeaBag = varTeaBag - 0.01
		else
			break
		end
	end
	sqrt(varTeaBag)
end

# ╔═╡ Cell order:
# ╟─cce67491-db64-462e-a3a7-df2f47b959ff
# ╠═2be71d07-8e3e-49bc-805c-8c7e893d80cf
# ╟─e327fe76-3713-4529-a793-e8962ce3f9fc
# ╟─94ceb124-6dc3-4dc5-9c03-d25b2e4e8631
# ╠═5f199c02-abcd-11eb-07ff-73115d877daa
# ╟─8092a41e-7b10-4730-a4d6-b7a434987634
# ╠═b169b4fd-4483-469f-bc93-8d41cba37059
# ╟─a18c293b-c8f0-4535-9ac2-29285ffded2c
# ╠═c1f2d272-32dd-4870-840d-24ee41905945
# ╟─1da2000f-34b2-4762-bebe-af93f58b7bfb
# ╟─0371253e-eac8-4724-91f7-cb669aac64ec
# ╟─7839f528-fde9-4c8f-9dbd-75a52675c662
# ╠═ff1b9e4b-0bfc-4460-b8c5-ce4c3c2f8b82
# ╠═06a26309-0f15-4814-8b0a-7985aa0937a9
# ╟─8de4aaef-6926-4354-a606-27ca6310e508
# ╠═59c1526d-7696-4820-b679-b68e9cf7ce48
# ╟─f0413748-81d6-46ef-8f4c-43421ec831fa
# ╠═b11d3d44-fa69-48f6-af11-dedfe8a738a1
# ╟─78225b05-3531-4400-9212-c2627e006e0b
# ╟─1cc0a469-188b-4890-a620-871e9c4b9121
# ╟─06a48d7b-fa3c-46b7-8727-b7c7a35378b7
# ╟─cbf0ecac-ee38-42a5-ab3f-75ced21ef666
# ╠═dbef19da-fe9e-4a37-bf64-4f48cf28a23e
# ╟─c032d068-8f1d-45df-a805-77d0bfeae33e
# ╟─8c13301a-bce5-4c72-8177-c23505c1853b
# ╠═fb58bb49-3a27-4b45-94fe-63f18a8b6d2e
# ╟─cca84ff5-6876-4d63-b6e3-412162e9469a
# ╠═a7209344-3fba-441e-93d0-1ecbd3f40769
# ╠═b1944ed6-8680-45f8-bc73-6285f5970f0c
# ╟─d87b1f6b-134c-48ac-98f7-81448e55931e
# ╠═32f8d1bb-3e26-4a57-9c86-e75f8aabd225
# ╠═2916c81d-d657-49c9-8fac-5da31c16f5f9
# ╟─bbca7b0a-6f93-42c6-bec8-bb8000225dfd
# ╠═edd86ff8-3d2f-41d9-bea4-c00545ff75bd
# ╠═45f23ad7-f2de-4676-9a16-ad5687add5e8
# ╟─cef51b5c-9c32-456b-a715-059c70fdc82e
# ╠═ea8e8d69-b508-4f9d-8380-5fd76059306b
# ╠═7d630f06-732e-443b-9c2a-fa95bb011d9a
# ╟─aa1b87d1-ffdf-40cd-9483-c3f940276d01
# ╟─2574d836-9996-4736-8abe-492e4d4c1426
# ╟─ea8616bc-02b9-48eb-bea8-4c9bd7b2df0d
# ╠═e0180cb0-c3f5-4498-a63e-ebd9170cfe07
