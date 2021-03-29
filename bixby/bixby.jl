### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 159b1374-90bd-11eb-1b95-1dc211d25cad
using Arrow, CairoMakie, DataFrames, Dates, Showoff

# ╔═╡ f5e11114-90bc-11eb-1700-d55fe92e8688
import Pkg;Pkg.activate(@__DIR__);Pkg.instantiate()

# ╔═╡ 6562f900-90c0-11eb-1d55-e57ee391b640
Pkg.add("Showoff")

# ╔═╡ 40389a66-90bd-11eb-1cf5-870bea5a8245
# Estimates + guesstimate interpolation based on Bixby's papers
bixby_data = "1991	1	1
1993	3.193905817	3.193905817
1994	5.43767313	17.36741584
1995	2.770083102	48.10918516
1997	1.772853186	85.29052217
1999	1.074792244	91.66959169
2000	9.526315789	873.2734787
2001	2.470914127	2157.783776
2002	1.673130194	3610.253187
2003	1.673130194	6040.423615
2005	1.872576177	11311.15336
2007	2.470914127	27948.88864
2009	2.2	61487.55501
2011	1.9	116826.3545
2013	1.3	151874.2609
2015	1.7	258186.2435
2016	1.9	490553.8626
2017	2.5	1226384.657"

# ╔═╡ 2eebf34c-90be-11eb-3485-7b82017aba9c
y(dt) = year(dt) + dayofyear(dt)/daysinyear(dt)

# ╔═╡ 757deed8-90bd-11eb-2e09-594c73b6cc6c

function plot_bixby(data)
    # Bixby
    ds = Float64[]
    fs = Float64[]
    cfs = Float64[]
    lines = split(data,"\n")
    for l in lines
       d,f,cf = split(l)
       push!(ds,y(Date(d)))
       push!(fs,parse(Float64,f)) 
       push!(cfs,parse(Float64,cf)) 
    end

    # Moore's law
    md = Float64[]
    mf = Float64[]
    d = ds[1]
    f = 1.
    while d < ds[end] 
        push!(md,d)
        push!(mf,f)
        d = d + 1.5#Dates.Month(18)
        f = f * 2
    end

    return ds,fs,cfs,md,mf
end


# ╔═╡ 7c23d586-90bd-11eb-16a9-addd2c4b86da
ds,fs,cfs,md,mf = plot_bixby(bixby_data)

# ╔═╡ 3b9c38be-90c2-11eb-20b4-d16f87e8a907
md"# Moore's law vs Bixby
Cumulative performance MILP algorithmic improvements CPLEX/Gurobi estimates vs Moore's law (2x every 18 months)"

# ╔═╡ 0eb4b364-90be-11eb-1a4f-1bb68d210dad
begin
	exp_rng = log10(10):log10(maximum(cfs)) #Manual log scale
	bixby = Figure()
	ax = bixby[1, 1] = Axis(
		bixby,
		yticks = (exp_rng, [s[6:end] for s in Showoff.showoff(10. .^(exp_rng), :scientific)]), #Manual log ticks
		)
	moo = lines!(md, log10.(mf),	linewidth=2.5, color=:orange)
	bix = lines!(ds, log10.(cfs),	linewidth=2.5, color=:darkblue)
	
	leg = bixby[1, end+1] = Legend(bixby,
    [moo, bix],
    ["Moore", "Bixby"])
	
	bixby
end

# ╔═╡ 0059dd86-90c2-11eb-02eb-d362829c28a5
bixby |> save("bixby.svg");

# ╔═╡ Cell order:
# ╠═f5e11114-90bc-11eb-1700-d55fe92e8688
# ╠═6562f900-90c0-11eb-1d55-e57ee391b640
# ╠═159b1374-90bd-11eb-1b95-1dc211d25cad
# ╟─40389a66-90bd-11eb-1cf5-870bea5a8245
# ╠═7c23d586-90bd-11eb-16a9-addd2c4b86da
# ╠═2eebf34c-90be-11eb-3485-7b82017aba9c
# ╠═757deed8-90bd-11eb-2e09-594c73b6cc6c
# ╟─3b9c38be-90c2-11eb-20b4-d16f87e8a907
# ╠═0eb4b364-90be-11eb-1a4f-1bb68d210dad
# ╠═0059dd86-90c2-11eb-02eb-d362829c28a5
