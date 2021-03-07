### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 3bcdb596-7c32-11eb-2380-f10b692e4ee6
begin
	using DataFrames
	DataFrames
end

# ╔═╡ d3b4462e-7f0a-11eb-114b-e757740285d3
using Dates

# ╔═╡ 8a83cd5c-7f0b-11eb-2a40-dfcf77b7e433
begin
	using HTTP
	using JSON
end

# ╔═╡ cd56d91e-7f1d-11eb-3011-2bd652aacd63
using Query

# ╔═╡ 7a7a9368-7f20-11eb-2f61-f335513f682c
begin
	using Plots
	pyplot()
end

# ╔═╡ 22f684c0-7c2e-11eb-0a19-cf435609667c
md"
**CS6741: Data Science, Assignment 2**

Author: Saish Jaiswal, CS20D405
"

# ╔═╡ 4b586b34-7c30-11eb-39c0-170f77146b89
md"
**Question 1:** In the first 3 questions, we will use datasets from the Tidy Data note. In each question, you will find two datasets - called untidy and tidy. You are required to (a) create a Julia dataframe manually to replicate the untidy data, and (b) transform the untidy dataset into the tidy dataset using different commands in Julia that we saw such as select, transform, groupby, etc. For creating the untidy dataset, you are free to use your own values to fill up the dataset - beyond what is indicated in the pictures.

In this first question, notice that there are multiple columns in the untidy data. This is the wide format. You are required to reshape it into the narrow format.

- Output display of the untidy data
- Julia commands to transform the data
- Output display of the tidy data
"

# ╔═╡ 32a49fdc-7c31-11eb-302e-b1be81405fcb
begin
	df1 = DataFrame(
		Religion = ["Agonist", "Atheist", "Buddhist", "Catholic", "Don't know/refused", "Evangelical Prot", "Hindu", "Historically Black Prot", "Jehova's Witness", "Jewish"]
		)
	
	nReligions = length(df1.Religion)
	
	inc = ["<10k", "10k-20k", "20k-30k", "30k-40k", "40k-50k", "50k-75k", "75k-100k", "100k-150k", ">150k", "Don't know/refused"]
	nRangeCols = length(inc)
	
	for i = 1:nRangeCols
		insertcols!(df1, i+1, inc[i] => rand(1:10,nReligions))
	end
	df1
end

# ╔═╡ 2d0b8d78-7e9c-11eb-0a9a-1319f553ed06
begin
	df1New = DataFrames.stack(df1, inc)
	rename!(df1New, :variable => :Income, :value => :Frequency)
	sort!(df1New, :Religion)
end

# ╔═╡ 57e2e604-7c30-11eb-005b-611a4cf5e4c8
md"
**Question 2:** In this second question, notice that the data is missing. You can put in dummy data for the minimum and maximum temperatures for different days. Missing data should be modelled using missing in Julia. This data is to be transformed into a tidy dataset where each date is a single row. Notice that the date column in the tidy dataframe is a combination of the year, month, and date.

- Output display of the untidy data
- Julia commands to transform the data
- Output display of the tidy data
"

# ╔═╡ d8396ee8-7caf-11eb-287c-8fc563135632
begin
	df2 = DataFrame()
	
	df2.ID = ["a", "a", "b", "b", "c", "c", "d", "d", "e", "e"]
	df2.Year = [2010, 2010, 2011, 2011, 2012, 2012, 2013, 2013, 2013, 2013]
	df2.Month = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
	df2.element = ["tmax", "tmin", "tmax", "tmin", "tmax", "tmin", "tmax", "tmin", "tmax", "tmin"]
	
	nIDs = length(df2.ID)
	
	for i = 5:15
		insertcols!(df2, i, "d"*string(i-4) => missings(Float64,nIDs))
	end
	df2.d1[7] = 1.25
	df2.d1[8] = 5.00
	df2.d2[1] = 10.25
	df2.d2[2] = 15.00
	df2.d3[5] = 5.75
	df2.d3[6] = 6.00
	df2.d4[3] = 8.00
	df2.d4[4] = 7.75
	df2.d3[9] = 4.50
	df2.d3[10] = 9.75
	df2
end

# ╔═╡ d03451f2-7f2c-11eb-3d68-af6e51750700
begin
	df2New = DataFrames.stack(df2, [i for i = 5:15])
	dropmissing!(df2New)
	
	nRowsdf2New = length(df2New.ID)
	DateCol = []
	for i = 1:nRowsdf2New
		dt = string(df2New.Year[i]) * "-" * string(df2New.Month[i]) * "-" * df2New.variable[i][2]
		push!(DateCol, dt)
	end
	
	DateColumn = unique(Date.(DateCol, "yyyy-mm-dd"))
	
	df2Updated = DataFrames.unstack(df2New, :ID, :element, :value, allowduplicates=true)
	
	insertcols!(df2Updated, 2, :Date => DateColumn)
end

# ╔═╡ 5d8dbdf6-7c30-11eb-3672-9d9bca6e0149
md"
**Question 3:** In this third question, you will be generating two dataframes as a part of the tidy dataset. We will separate columns that are not dependent on time from those that vary from week-to-week. Notice that week  is not included in the tidy data since the information is already captured in the date column.

- Output display of the untidy data
- Julia commands to transform the data
- Output display of the tidy data
"

# ╔═╡ 26c19cce-7ea8-11eb-3343-bb122bc38683
# Creating Dataframe
begin
	df3 = DataFrame()
	df3.year = [2000, 2000, 2000, 2000, 2000, 2000, 2000, 2001, 2001, 2001, 2002]
	df3.artist = ["2 Pac", "2 Pac", "2 Pac", "2 Pac", "2 Pac", "2 Pac", "2 Pac", "2Ge+Her", "2Ge+Her", "2Ge+Her", "3 Doors Down"]
	df3.time = ["4:22", "4:22", "4:22", "4:22", "4:22", "4:22", "4:22", "3:15", "3:15", "3:15", "3:53"]
	df3.track = ["Baby don't cry", "Baby don't cry", "Baby don't cry", "Baby don't cry", "Baby don't cry", "Baby don't cry", "Baby don't cry", "The Hardest Part", "The Hardest Part", "The Hardest Part", "Kryptonite"]
	df3.date = Date.(["2000-02-26", "2000-03-04", "2000-03-11", "2000-03-18", "2000-03-25", "2000-04-01", "2000-04-08", "2001-09-02", "2001-09-09", "2001-09-16", "2000-4-3"], "yyyy-mm-dd")
	df3.week = [1,2,3,4,5,6,7,1,2,3,1]
	df3.rank = [87, 82, 72, 77, 87, 94, 99, 91, 87, 92, 81]
	df3
end

# ╔═╡ fc1791e2-7f42-11eb-259d-bd9904364de1
# Adding ID column
begin
	FreqTracks = [(i, count(==(i), df3.track)) for i in unique(df3.track)]
	IDcol = []
	for i = 1:length(FreqTracks)
		count = FreqTracks[i][2]
		for j = 1:count
			append!(IDcol, i)
		end
	end
	insertcols!(df3, 1, :ID => IDcol)
end

# ╔═╡ fd3ef432-7f44-11eb-09db-053b10346028
# Table 1 -- Tidy data
begin
	df3New = select(df3, :ID, :artist, :track, :time)
	Q3Table1 = unique!(df3New)
end

# ╔═╡ 344bc8a2-7f44-11eb-1279-27d7c88cdc46
# Table 2 -- Tidy Data
Q3Table2 = select(df3, :ID, :date, :rank)

# ╔═╡ 61cc7efa-7c30-11eb-2537-adbd4d17003e
md"
**Question 4:** Let us now move on beyond tidy data. In this question, you are required to access the dataset on CoViD cases reported in the country as available from this API.  You are required to load this dataset into a dataframe of Julia. (You will have to figure out the HTTP request and JSON to dataframe conversion). After that, you are required to transform the columns and use split-apply-combine to report the aggregate number of confirmed, deceased, and recovered cases in each calendar month.
"

# ╔═╡ 8f821cc8-7f10-11eb-13cc-15c7a248a317
begin
	resp = HTTP.get("https://api.covid19india.org/data.json")
	json_str = String(resp.body)
	a = JSON.Parser.parse(json_str)
	cols = keys(a["cases_time_series"][1])
	df4 = DataFrame()
	for c in cols
    	df4[:, c] = []
	end
	nRows = length(a["cases_time_series"])
	for i = 1:nRows
		push!(df4, a["cases_time_series"][i])
	end
	df4New = DataFrame()
	df4New.dailyconfirmed = [parse(Int, x) for x in df4.dailyconfirmed]
	df4New.dailydeceased = [parse(Int, x) for x in df4.dailydeceased]
	df4New.dailyrecovered = [parse(Int, x) for x in df4.dailyrecovered]
	df4New.dateymd = [Date.(x, "yyyy-mm-dd") for x in df4.dateymd]
	df4
end

# ╔═╡ 1581f50c-7f1e-11eb-113a-c3a5e368a0cf
begin
	df4Updated = df4New |>
          @groupby(yearmonth(_.dateymd)) |>
          @map({YearMonth=key(_), Confirmed=sum(_.dailyconfirmed), Deceased=sum(_.dailydeceased), Recovered=sum(_.dailyrecovered)}) |>
          DataFrame
	df4Updated
end

# ╔═╡ 660e261c-7c30-11eb-2443-47e691bca0a6
md"
**Question 5:** In this last question, we will try out a slightly more complex transformation on the dataset. If you plot the number of cases (in any of the three categories) across time, you would find the plot is not smooth, i.e., values vary from day to day with small unexpected variations. One way to smooth such plots, yet not lose the trend over longer periods of time is to compute a moving average. You are required to compute 7 preceding days’ moving average for each of the three columns - confirmed, deceased, and recovered as three new columns. For each of these three columns, you are required to visualise separate plots showing both the original values and the values smoothened with the moving average. Notice that the moving average for the first six days is not defined and can be left blank.
"

# ╔═╡ 96deb1e2-7f34-11eb-2cbe-eb364d061d84
function moving_average(arr, n)
	ma = []
	lArr = length(arr)
	for i = 1:n-1
		push!(ma, 0)
	end
	for i = n:lArr
		avg = sum(arr[i-n+1:i])/n
		push!(ma, avg)
	end
	return ma
end

# ╔═╡ f6efcdf6-7f29-11eb-1eec-f79851a9d8d4


# ╔═╡ fce79996-7f29-11eb-0a53-99cfee687ea8
begin
	pConfirmed = plot(df4New.dailyconfirmed, label="Original", title="Daily Confirmed Cases", xlabel="Jan. 30, 2020 onwards", ylabel="Number of confirmed cases")
	maConfirmed = moving_average(df4New.dailyconfirmed, 7)
	plot!(pConfirmed, maConfirmed, label="Moving Average")
end

# ╔═╡ 08df9b08-7f2b-11eb-2968-83b2ee7e0429
begin
	pDeceased = plot(df4New.dailydeceased, label="Original", title="Daily Deceased Cases", xlabel="Jan. 30, 2020 onwards", ylabel="Number of deceased cases")
	maDeceased = moving_average(df4New.dailydeceased, 7)
	plot!(pDeceased, maDeceased, label="Moving Average")
end

# ╔═╡ 9ed70920-7f2b-11eb-39dc-d7c45fc6ca12
begin
	pRecovered = plot(df4New.dailyrecovered, label="Original", title="Daily Recovered Cases", xlabel="Jan. 30, 2020 onwards", ylabel="Number of recovered cases")
	maRecovered = moving_average(df4New.dailyrecovered, 7)
	plot!(pRecovered, maRecovered, label="Moving Average")
end

# ╔═╡ a45cb612-7f4f-11eb-392a-ff28176979b4
begin
insertcols!(df4New, "MA Confirmed" => maConfirmed, "MA Deceased" => maDeceased, "MA Recovered" => maRecovered)
end

# ╔═╡ Cell order:
# ╟─22f684c0-7c2e-11eb-0a19-cf435609667c
# ╠═3bcdb596-7c32-11eb-2380-f10b692e4ee6
# ╟─4b586b34-7c30-11eb-39c0-170f77146b89
# ╠═32a49fdc-7c31-11eb-302e-b1be81405fcb
# ╠═2d0b8d78-7e9c-11eb-0a9a-1319f553ed06
# ╟─57e2e604-7c30-11eb-005b-611a4cf5e4c8
# ╠═d8396ee8-7caf-11eb-287c-8fc563135632
# ╠═d03451f2-7f2c-11eb-3d68-af6e51750700
# ╟─5d8dbdf6-7c30-11eb-3672-9d9bca6e0149
# ╠═d3b4462e-7f0a-11eb-114b-e757740285d3
# ╠═26c19cce-7ea8-11eb-3343-bb122bc38683
# ╠═fc1791e2-7f42-11eb-259d-bd9904364de1
# ╠═fd3ef432-7f44-11eb-09db-053b10346028
# ╠═344bc8a2-7f44-11eb-1279-27d7c88cdc46
# ╟─61cc7efa-7c30-11eb-2537-adbd4d17003e
# ╠═8a83cd5c-7f0b-11eb-2a40-dfcf77b7e433
# ╠═8f821cc8-7f10-11eb-13cc-15c7a248a317
# ╠═cd56d91e-7f1d-11eb-3011-2bd652aacd63
# ╠═1581f50c-7f1e-11eb-113a-c3a5e368a0cf
# ╟─660e261c-7c30-11eb-2443-47e691bca0a6
# ╠═7a7a9368-7f20-11eb-2f61-f335513f682c
# ╠═96deb1e2-7f34-11eb-2cbe-eb364d061d84
# ╟─f6efcdf6-7f29-11eb-1eec-f79851a9d8d4
# ╠═fce79996-7f29-11eb-0a53-99cfee687ea8
# ╠═08df9b08-7f2b-11eb-2968-83b2ee7e0429
# ╠═9ed70920-7f2b-11eb-39dc-d7c45fc6ca12
# ╠═a45cb612-7f4f-11eb-392a-ff28176979b4
