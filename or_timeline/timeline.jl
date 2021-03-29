### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ a591b754-9094-11eb-1a5d-934c3a3adad0
using Arrow, CairoMakie, DataFrames, Dates

# ╔═╡ f4cfb868-909c-11eb-2c06-57c9d664035b
import Pkg;Pkg.activate(@__DIR__);Pkg.instantiate()

# ╔═╡ b7706a86-9094-11eb-2daa-41a0f0610308
data = DataFrame(Arrow.Table("timelinedata.arrow"));

# ╔═╡ c8e2be5c-909a-11eb-007e-919d72bc968f
 y(dt) = year(dt) + dayofyear(dt)/daysinyear(dt) # Represent dates as year-float

# ╔═╡ dd5c9798-909a-11eb-3f2c-b199acb685ed
cols = Dict(zip(unique(data.category), [:maroon,:purple,:darkblue,:green])) # Choose colors

# ╔═╡ a0935722-90bb-11eb-2139-771148097b71
md"# OR Timeline"

# ╔═╡ fc93cdde-909a-11eb-36ee-7199c9c4116c
begin
	timeline_theme = Theme(
    Axis = (
        leftspinevisible = false,
        rightspinevisible = false,
        bottomspinevisible = false,
        topspinevisible = false,
		yticksvisible = false,
        xgridcolor = :white,
        ygridcolor = :white,
    )
)
	set_theme!(timeline_theme)
	
	timeline = Figure()
	ax = Axis(timeline[1, 1])
	hideydecorations!(ax, ticks=false)
	limits!(ax,1948,2022,-7,12)
	stem!(y.(data.DateTime), 
		 [i for i in data.val],
		stemcolor = [cols[i] for i in data.category],
			marker="")
	text!(data.txt,
		rotation = [pi/4 for i in data.val],
		position = [Point3f0(y.(data.DateTime[i]), data.val[i], 0) for i in 1:length(data.txt)],
		color = [cols[i] for i in data.category],
		align = [v > 0 ? (:left, :baseline) : (:right, :top) for v in data.val],
		)
	timeline
end

# ╔═╡ 46cae4aa-909b-11eb-3485-edd574e8fd9d
save("or_timeline.svg", timeline);

# ╔═╡ Cell order:
# ╠═f4cfb868-909c-11eb-2c06-57c9d664035b
# ╠═a591b754-9094-11eb-1a5d-934c3a3adad0
# ╠═b7706a86-9094-11eb-2daa-41a0f0610308
# ╠═c8e2be5c-909a-11eb-007e-919d72bc968f
# ╠═dd5c9798-909a-11eb-3f2c-b199acb685ed
# ╟─a0935722-90bb-11eb-2139-771148097b71
# ╠═fc93cdde-909a-11eb-36ee-7199c9c4116c
# ╠═46cae4aa-909b-11eb-3485-edd574e8fd9d
