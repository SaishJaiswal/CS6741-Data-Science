### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 9213644c-9306-11eb-156d-1789726316bb
begin
	using QuadGK
	using Distributions
	using DataFrames
end

# ╔═╡ 2ec0516c-a8c4-47e2-b629-633afe9a63d6
begin
using Plots
plotly()
end

# ╔═╡ e01a23ba-21f8-43a7-9fdf-783c8cba7157
begin
	using Random
	Random.seed!(0)
end

# ╔═╡ fa8a32d4-8add-11eb-1607-d92f1c27cba3
begin
	using Dates
	using CSV
	using StatsPlots
end

# ╔═╡ 995368e4-8ada-11eb-22d0-bb02fe6fbe5c
md"
# Assignment 3
"

# ╔═╡ 82a44fb8-8adb-11eb-3007-8f9f4c3d8ab7
md"
**Question 1:** How do we compare two distributions, i.e., how do we say that one distribution is very similar to another distribution? We need a distance measure. There are many statistical distances. For this question, you will implement the Kullback-Leibler divergence, which is formally defined between distributions P and Q of two random distributions as:

$D_{KL}(P || Q) = \int_{-\infty}^{\infty} p(x) \log \left(\frac{p(x)}{q(x)}\right) \, dx$

Implement a Julia function which computes the KL divergence for two given distributions. 

Now call this function for Q set as N(0, 1) and P as Student’s T distribution separately with v = 1, 2, 3, 4, 5 degrees of freedom. 

* Julia function for KL divergence
* Table of values of KL divergence for v = 1, 2, 3, 4, 5
"

# ╔═╡ 5c5c752e-930f-11eb-2c33-ef6124500961
# Function to calculate KL-Divergence of two distributions
function KLD(D1, D2, r)
	retVal = quadgk(x->(pdf(D2,x)*log(pdf(D2,x)/pdf(D1,x))), -r, r)
	return retVal
end

# ╔═╡ 334ae0e0-9310-11eb-3d6c-99be568a7864
begin
	# Standard Normal Distribution
	D1 = Normal(0,1)
	
	# Dataframe to store KLD values for different values of v
	KLD_Table = DataFrame(v=[], KL_Divergence=[])
	
	# Range of integration -r to r
	r = 5
	
	# Creating dataframe
	for v = 1:5
		D2 = TDist(v)
		kld, err = KLD(D1,D2,r)
		push!(KLD_Table, (v, kld))
	end
	KLD_Table
end

# ╔═╡ f9fc1955-3df4-4de6-8660-3a57f4498cb9
md"
**Observation:** As we increase the degrees of freedom for the T-Distribution, it tends towards a Normal Distribution as we can observe from the KLD values for different v.

--------------------------------------------------------------------
"

# ╔═╡ fbec4e90-8adc-11eb-36ea-df130976afc7
md"
**Question 2:** We have seen that as we add independent random variables, the resultant pdf of the sum of random variables tends towards a normal distribution. We can quantify this tendency now that we know about the KL divergence as a measure.

Consider U as the uniform distribution in the range [0, 1]. Write a function that computes the pdf of the random variable obtained by summing n independent random variates drawn from U. (Hint: recall that when we sum up independent variables, the pdfs get convolved). 

For n varying from 2 to 10, plot the KL divergence with P given by the output of your function with the corresponding n and Q as the normal distribution with mean and standard deviation matching that of P. 

* Julia function of pdf of average of n random variates
* Plot of KL divergence values
"

# ╔═╡ 187a14ff-beec-4420-b6d3-859a69880cfd
function conv(d1,d2)
	arr = [sum(pdf(d2,x-k)*d1[k] for k=-10:0.01:10) for x = -10:0.01:10]
end

# ╔═╡ 3770bd4a-8add-11eb-0395-e948500eed71
function AddRandomVariates(n)
	D = Uniform(0,1)
	pdfs = []
	push!(pdfs, pdf(D, x) for x=-10:0.01:10)
	arr = [sum(pdf(D,x-k)*pdf(D,k) for k=-10:0.01:10) for x = -10:0.01:10]
	t = -10:0.01:10
	push!(pdfs, Dict(zip(t,arr)))
	for i = 3:n
		arr = conv(pdfs[i-1], D)
		push!(pdfs, Dict(zip(t,arr)))
	end
	return pdfs[n]
end

# ╔═╡ dbf787b9-f27b-4329-9863-ca8ffb918855
# Funtion to calculate KL-Divergence of two distributions
function KLD_(D1, D2)
	retVal = 0
	for x = -10:0.01:10
		if(D1[x] != 0)
			retVal = retVal + pdf(D2,x)*log(pdf(D2,x)/D1[x])
		end
	end
	return retVal
end

# ╔═╡ 563c7a15-f855-4130-9535-f3b11a84b517
begin
	nVal = 2:10
	kldVal = []
	for n = 2:10
		resultantPDF = AddRandomVariates(n)
		val = collect(values(resultantPDF))
		#Normalizing
		val = val./length(val)
		m = mean(val)
		s = std(val)
		N_ = Normal(m,s)
		kld_new = KLD_(resultantPDF, N_)
		push!(kldVal, kld_new)
	end
	plot(nVal, kldVal, legend=false, line=2, xlabel="n", ylabel="KLD")
end

# ╔═╡ bc5b5c54-dc9f-4ac3-9585-284ed0596039
md"
**Observation:** From the above figure we observe that as we add more and more independent random variates, the resultant pdf tends towards a normal distribution and hence the KLD value tends towards zero.

--------------------------------------------------------------------
"

# ╔═╡ 393290ea-8add-11eb-191b-83b68205df60
md"
**Question 3:** We saw that Pearson defined his coefficients of skewness based on the relative order of mean, median, and mode. But these are merely rules of thumb. 

Create a synthetic dataset (you are free to do this however you like) of at least 1,000 points such that the distribution of the data is distinctly right skewed, but mean is smaller than the median.

* Logic of how you have generated the data in words
* Julia code to generate data
* Distribution plot marking the mean, median, and mode
"

# ╔═╡ 983db4bb-9b3f-4ec6-910a-ad5f781ac872
md"
```
Logic: The logic is the same as used in the next question. We draw 10000 random samples of length 50 each and find the range of each sample. The distribution of these ranges is distinctly right skewed. Also, the mean of the distribution is smaller than the median.
```
"

# ╔═╡ 6b18f2fa-8add-11eb-28dc-eb22dcbf008e
begin
	U_3 = Uniform(0,1)
	dataRanges = []
	for i in 1:10000
		randSample = rand(U_3,50)
		sampleRange = maximum(randSample) - minimum(randSample)
		push!(dataRanges, sampleRange)
	end
end

# ╔═╡ a148143e-03a8-456d-bb65-1beca7e84e0a
begin
hist3 = histogram(dataRanges, nbins=100, legend=false, fill=(0, :yellow, 0.3))
mean_3 = mean(dataRanges)
mode_3 = mode(dataRanges)
median_3 = median(dataRanges)
plot(hist3)
plot!([mean_3], [0], xlims=(0.75,1), line=4)
end

# ╔═╡ 3ffc4d15-65ea-4c10-826d-0cd7d90be1b1
md"
Mean = $mean_3

Mode = $mode_3

Median = $median_3
"

# ╔═╡ f80c8c7a-3f77-4f4c-b17b-adce2cd9b54c
md"
--------------------------------------------------------------------
"

# ╔═╡ 6c34d7d2-8add-11eb-32cd-c7792d6a4eca
md"
**Question 4:** Consider again the uniform distribution U in the range [0, 1]. Create 10,000 random samples with each sample of 30 elements from U. For each sample calculate the range. Now, these 10,000 values of range can be treated as a random sample itself. Plot the histogram of this range and mark the mean, median, and mode.

* Julia code
* Marking mean, median, mode
"

# ╔═╡ 9780fee8-8add-11eb-23c9-99595edf01f3
begin
	U_4 = Uniform(0,1)
	samples = []
	ranges = []
	for i in 1:10000
		randSample = rand(U_4,30)
		push!(samples, randSample)
		sampleRange = maximum(randSample) - minimum(randSample)
		push!(ranges, sampleRange)
	end
end

# ╔═╡ 797f8e08-5388-4f0e-8ce0-5848061a7839
begin
hist4 = histogram(ranges, nbins=100, legend=false, fill=(0, :blue, 0.3))
mean_4 = mean(ranges)
mode_4 = mode(ranges)
median_4 = median(ranges)
plot(hist4)
#plot!([mean_4, mean_4], [0, pdf(U_4, mean_4)], label="mean", line=(5, :red), xlims=(0.65,1))
end

# ╔═╡ eb07edfa-a21a-4cd7-acb9-bef9f121dd59
md"
Mean = $mean_4

Mode = $mode_4

Median = $median_4
"

# ╔═╡ 98f7d94e-8fef-4895-9007-9cb811034905
md"
--------------------------------------------------------------------
"

# ╔═╡ 994ce5b8-8add-11eb-31d3-ed0401e50492
md"
**Question 5:** Now that you have the computational insight, let us try out a theoretical problem. Again if you are sampling 30 variates from U, what is the probability that the range of the sample is greater than some threshold θ in the interval [0, 1].  (Hint: Approach by first bounding the minimum value say u, then the range being greater than θ implies that the maximum value is greater than u + θ, ...).

* Derivation
"

# ╔═╡ b8d85d0c-8add-11eb-11cb-d9408e9e5b73
md"
**Solution:**

Let the minimum value of the elements in the sample of size 30 be $u$.

Therefore, the range of the sample will be more than $\theta$ is the maximum value of the elements in the sample is more than $u+\theta$.

$\therefore P(\text{range} > \theta) = P(\text{max(sample)} > u+\theta)$
$= 1 - \prod_{i=1}^{30}P(x_i \leq u+\theta)$
$= 1 - (u+\theta)^{30}$
"

# ╔═╡ 02d73af6-e189-4e07-9741-6cd0001cf31d
md"
--------------------------------------------------------------------
"

# ╔═╡ c56f6920-8add-11eb-17b9-5b785447df9f
md"
**Question 6:** In the last assignment, you had worked with the CoViD data for Indian states. Using that data, let us try out a problem in correlation. 

By aggregating data over weeks, compute the weekly total number of new cases reported in each state, i.e., generate a table with rows as distinct week numbers and one column per state with the total number of new cases in that week.

For each pair of states compute the covariance, Pearson’s coefficient of correlation, and Spearman’s coefficient of correlation. Represent this as three separate heat maps, where both axes of the plot are the states.

What do you observe? Are the statistics agreeing?

* Code to create the weekly totals
* Code to compute statistics
* Heatmap plots
* Observations
"

# ╔═╡ b2d17ef4-61ed-4d15-badb-3cdc134e8f2c
begin
	dataset = CSV.read(download("https://api.covid19india.org/csv/latest/states.csv"), DataFrame)
end

# ╔═╡ 5a8977cd-4066-4ac3-8ace-4a5a8ae085ff
begin
	statewiseConfirmed = DataFrames.unstack(dataset, :Date, :State, :Confirmed)
	states = names(statewiseConfirmed)
	filter!(e->e≠"Date",states)
	for state in states
		replace!(statewiseConfirmed[!,state], missing => 0);
	end
	statewiseConfirmed
end

# ╔═╡ 039b9ec9-4ec3-41b8-b111-80b09de9fb74
# Code to create weekly totals
begin
statewiseConfirmed.WeekNo = (Dates.days.(statewiseConfirmed.Date .- Date(2020, 01, 30)) .÷ 7) .+ 1
weeklyTotal = combine(groupby(statewiseConfirmed, :WeekNo), states .=> sum)
end

# ╔═╡ d20b5c73-8bf3-4d64-b6b4-8089d4e9ff5c
# Funtion to find covariance matrix
function covmat(df)
nc = ncol(df)
cov_m = zeros(nc, nc)
for (i, c1) in enumerate(eachcol(df))
   for (j, c2) in enumerate(eachcol(df))
	   sx = collect(c1)
	   sy = collect(c2)
	   cov_m[i, j] = cov(sx, sy)
   end
end
return cov_m
end

# ╔═╡ 6305c53a-d097-4f4f-8c48-927757a72277
# Funtion to find peason's correlation coefficient matrix
function pcorrmat(df)
nc = ncol(df)
pcorr_m = zeros(nc, nc)
for (i, c1) in enumerate(eachcol(df))
   for (j, c2) in enumerate(eachcol(df))
	   sx = collect(c1)
	   sy = collect(c2)
		pcorr_m[i,j] = cor(sx, sy)
   end
end
return pcorr_m
end

# ╔═╡ e1217100-765e-426b-bd3d-a3095bf3874c
findpos(arr) = [indexin(arr[i], sort(arr))[1] for i in 1:length(arr)]

# ╔═╡ a84d2db0-2844-49b0-b17c-0cace06dd73f
cor_s(x, y) = cor(findpos(x), findpos(y))

# ╔═╡ 34429f7b-d39b-4416-80a8-d89943f38109
# Funtion to find spearman's rank correlation coefficient matrix
function scorrmat(df)
nc = ncol(df)
scorr_m = zeros(nc, nc)
for (i, c1) in enumerate(eachcol(df))
   for (j, c2) in enumerate(eachcol(df))
	   sx = collect(c1)
	   sy = collect(c2)
		scorr_m[i,j] = cor_s(sx, sy)
   end
end
return scorr_m
end

# ╔═╡ b27431b1-32db-4e34-9ad9-0defd284fa21
stateData = weeklyTotal[!, states.*"_sum"]

# ╔═╡ ff0b2ed3-e2c7-4e0d-9dfb-1450a72e7772
begin
cov_m = covmat(stateData)
heatmap(states, states, cov_m)
end

# ╔═╡ 6206ca70-4ef4-4e64-96c0-22c5e68fbb72
begin
pcorr_m = pcorrmat(stateData)
heatmap(states, states, pcorr_m)
end

# ╔═╡ 77a6b5bc-80fd-40c4-ade2-635946f4503c
begin
scorr_m = scorrmat(stateData)
heatmap(states, states, scorr_m)
end

# ╔═╡ c8dc367a-9b6f-463f-859e-658e798a5463
md"
**Observations:**
- From the covariance matrix we can observe that the variance for the weekly total cases for the state of Kerala is higher than the other states. For the other states, the covariance values differs a lot.
- Pearson's correlation coefficient value shows high correlation for certian states whereas relatively low correlation for a few. This shows that the increase in the number of cases was not uniform across all the states in India.
- Spearman's rank correlation captures the monotonicity. It shows that the number of new weekly cases were either rising or falling across all states.

--------------------------------------------------------------------
"

# ╔═╡ fbf3967c-8add-11eb-36a1-251a8d87197d
md"
**Question 7:** You will soon realise that statistics is often a tale of tails. So here is a tail’s up:

Write a Julia function OneSidedTail such that the percentile of standard normal distribution computed at OneSidedTail(x) is 100 - x, where, 0 < x < 100. 
Repeated the above process with Student’s T distribution with v = 10.

For x = 95, visualise the output of the two functions with a plot. Hint: think of area under curves. 

* OneSidedTail for normal distribution
* OneSidedTail for student’s T distribution
* Visualisation for x = 95
"

# ╔═╡ 11c7bbec-92fe-11eb-2851-7913c9f5936c
function OneSidedTailNormal(x)
	perVal = 100-x
	D_Norm = Normal(0,1)
	for r = -100:0.01:100
		AUC, err = quadgk(x->pdf(D_Norm,x), -100, r)
		if AUC*100 >= perVal
			return r
		end
	end
end

# ╔═╡ 66c1c25c-bd68-42ed-a5a1-7c5df6cd84f2
function OneSidedTailTDist(x)
	perVal = 100-x
	D_TDist = TDist(10)
	for r = -100:0.01:100
		AUC, err = quadgk(x->pdf(D_TDist,x), -100, r)
		if AUC*100 >= perVal
			return r
		end
	end
end

# ╔═╡ 3f2b214d-96d3-4e4d-94e0-734c29da045a
# One-Sided Tail for Normal Distribution
begin
	x1 = 95
	x_val1 = OneSidedTailNormal(x1)
end

# ╔═╡ 945fdb06-f9fe-44d6-9efb-8bf9b412e624
# Visualization of On-Sided Tail for Normal Distribution
begin
	D_Norm = Normal(0,1)
	
	plot(x->x, x->pdf(D_Norm, x), mean(D_Norm) - 5 * std(D_Norm), x_val1, fill=(0, :orange),fillalpha=0.5, label="", title="Normal Distribution: One-sided tail for x="*string(x1))
	plot!(x->x, x->pdf(D_Norm, x), mean(D_Norm) - 5 * std(D_Norm), mean(D_Norm) + 5 * std(D_Norm), label="", line=4)
end

# ╔═╡ b7e7e14c-513d-48ac-9784-5e2cc2a528ec
# One-Sided Tail for Student's T Distribution
begin
	x2= 95
	x_val2 = OneSidedTailTDist(x2)
end

# ╔═╡ d7af6c51-f4e3-4066-a4d9-108e954c7fce
# Visualization of One-Sided Tail for Student's T Distribution
begin
	D_TDist = TDist(10)
	
	plot(x->x, x->pdf(D_TDist, x), mean(D_TDist) - 5 * std(D_TDist), x_val2, fill=(0, :yellow),fillalpha=0.5, label="", title="T-Distribution: One-Sided Tail for x="*string(x2))
	plot!(x->x, x->pdf(D_TDist, x), mean(D_TDist) - 5 * std(D_TDist), mean(D_TDist) + 5 * std(D_TDist), label="", line=4)
end

# ╔═╡ Cell order:
# ╟─995368e4-8ada-11eb-22d0-bb02fe6fbe5c
# ╠═9213644c-9306-11eb-156d-1789726316bb
# ╠═2ec0516c-a8c4-47e2-b629-633afe9a63d6
# ╠═e01a23ba-21f8-43a7-9fdf-783c8cba7157
# ╠═fa8a32d4-8add-11eb-1607-d92f1c27cba3
# ╟─82a44fb8-8adb-11eb-3007-8f9f4c3d8ab7
# ╠═5c5c752e-930f-11eb-2c33-ef6124500961
# ╠═334ae0e0-9310-11eb-3d6c-99be568a7864
# ╟─f9fc1955-3df4-4de6-8660-3a57f4498cb9
# ╟─fbec4e90-8adc-11eb-36ea-df130976afc7
# ╠═187a14ff-beec-4420-b6d3-859a69880cfd
# ╠═3770bd4a-8add-11eb-0395-e948500eed71
# ╠═dbf787b9-f27b-4329-9863-ca8ffb918855
# ╠═563c7a15-f855-4130-9535-f3b11a84b517
# ╟─bc5b5c54-dc9f-4ac3-9585-284ed0596039
# ╟─393290ea-8add-11eb-191b-83b68205df60
# ╟─983db4bb-9b3f-4ec6-910a-ad5f781ac872
# ╠═6b18f2fa-8add-11eb-28dc-eb22dcbf008e
# ╠═a148143e-03a8-456d-bb65-1beca7e84e0a
# ╟─3ffc4d15-65ea-4c10-826d-0cd7d90be1b1
# ╟─f80c8c7a-3f77-4f4c-b17b-adce2cd9b54c
# ╟─6c34d7d2-8add-11eb-32cd-c7792d6a4eca
# ╠═9780fee8-8add-11eb-23c9-99595edf01f3
# ╠═797f8e08-5388-4f0e-8ce0-5848061a7839
# ╟─eb07edfa-a21a-4cd7-acb9-bef9f121dd59
# ╟─98f7d94e-8fef-4895-9007-9cb811034905
# ╟─994ce5b8-8add-11eb-31d3-ed0401e50492
# ╟─b8d85d0c-8add-11eb-11cb-d9408e9e5b73
# ╟─02d73af6-e189-4e07-9741-6cd0001cf31d
# ╟─c56f6920-8add-11eb-17b9-5b785447df9f
# ╠═b2d17ef4-61ed-4d15-badb-3cdc134e8f2c
# ╠═5a8977cd-4066-4ac3-8ace-4a5a8ae085ff
# ╠═039b9ec9-4ec3-41b8-b111-80b09de9fb74
# ╠═d20b5c73-8bf3-4d64-b6b4-8089d4e9ff5c
# ╠═6305c53a-d097-4f4f-8c48-927757a72277
# ╠═e1217100-765e-426b-bd3d-a3095bf3874c
# ╠═a84d2db0-2844-49b0-b17c-0cace06dd73f
# ╠═34429f7b-d39b-4416-80a8-d89943f38109
# ╠═b27431b1-32db-4e34-9ad9-0defd284fa21
# ╠═ff0b2ed3-e2c7-4e0d-9dfb-1450a72e7772
# ╠═6206ca70-4ef4-4e64-96c0-22c5e68fbb72
# ╠═77a6b5bc-80fd-40c4-ade2-635946f4503c
# ╟─c8dc367a-9b6f-463f-859e-658e798a5463
# ╟─fbf3967c-8add-11eb-36a1-251a8d87197d
# ╠═11c7bbec-92fe-11eb-2851-7913c9f5936c
# ╠═66c1c25c-bd68-42ed-a5a1-7c5df6cd84f2
# ╠═3f2b214d-96d3-4e4d-94e0-734c29da045a
# ╠═945fdb06-f9fe-44d6-9efb-8bf9b412e624
# ╠═b7e7e14c-513d-48ac-9784-5e2cc2a528ec
# ╠═d7af6c51-f4e3-4066-a4d9-108e954c7fce
