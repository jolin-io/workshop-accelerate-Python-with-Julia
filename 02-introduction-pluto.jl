### A Pluto.jl notebook ###
# v0.19.24

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 2c1c69cb-69e6-486b-9e81-3d5c30999193
begin
	# improve startup time on binder
	import Pkg; Pkg.activate(Base.current_project())

	import PlutoUI
	import Plots
	using PyCall
end

# ╔═╡ ad2f0ea1-ca4c-47ad-8c6d-fe39730eaf2c
md"""
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/jolin-io/workshop-accelerate-Python-with-Julia/main?urlpath=pluto/open?path=./02introduction-pluto.jl)

![](https://www.jolin.io/assets/Jolin/Jolin-Banner-Website-v1.3-darkmode.webp)
"""

# ╔═╡ c7d302a8-c0e4-11ec-24f9-5fd8c9a7e341
md"""
# Introduction to Julia II: Pluto, pure Julia
**Key message:** Julia solves the two language problem

- it is both easy to learn
- and high performant
"""

# ╔═╡ 04bed6e2-4514-4975-ba0e-991bd55853b7
md"""
## This is an interactive Pluto notebook

TLDR: everything is automatically re-executed for you
"""

# ╔═╡ 64443e2c-7b56-43ce-aafb-f80b807840ed
a = 2

# ╔═╡ 612af880-26e3-4ccd-9d26-20cc79162ac7
b = @bind b PlutoUI.Slider(1:10, default=5, show_value=true)

# ╔═╡ 0099e358-0a4f-4b1c-84fa-16305b4e8dfe
c = [a    b
	 a+b  a*b]

# ╔═╡ bb6d2e79-3741-4053-a26d-8fb84ab102d5
Plots.heatmap(c)

# ╔═╡ 881026ba-cf61-4aff-9e84-786ac6e7af6f
md"""
## Two top ingredients for Julia's success
- structs with speed like C
- overloadable functions
"""

# ╔═╡ fb3fedb9-8ef3-4ac7-be9b-a1664bc327f3
md"""
### structs
"""

# ╔═╡ bf8d4242-b70c-4ad4-8ab9-9ce7ce1631fb
struct Cat
	name
end

# ╔═╡ 649325fb-ce88-476c-894e-9d562c95aca8
struct Dog
	name::String
	age::Int
end

# ╔═╡ 22bdec44-2460-447b-9170-713f8e3aaee8
🐱 = Cat("kitty")

# ╔═╡ f793188f-6645-46a0-b9f4-2cd0a7578b9e
🐕 = Dog("dexter", 2)

# ╔═╡ 08081d91-d683-4a8b-a553-ae42b517580a
🐱.name, 🐕.name, 🐕.age

# ╔═╡ 56059199-0a9d-4695-8e54-5911722392e4
md"""
### functions
"""

# ╔═╡ 0afb7b78-1a53-462c-bbde-4eab7d4ba2be
describe(animal) = "This is $(animal.name)"

# ╔═╡ 1db44575-1eda-4f8a-94b1-d977788f4d50
# describe(dog::Dog) = "This is $(dog.name) and it is $(dog.age) years old"

# ╔═╡ b906d85c-3de0-4653-8c77-2a5a36a08d69
describe(🐱)

# ╔═╡ 8f608538-8a27-4b28-836c-23b7e2b06ebe
describe(🐕)

# ╔═╡ e6b62efb-657f-4413-940e-300f93e8e5e3
meet(animal1, animal2) = "$(animal1.name) meets $(animal2.name)"

# ╔═╡ 39577aeb-c21c-4ad6-a610-dd5dbf9c692a
# meet(cat::Cat, dog::Dog) = "The awesome cat $(cat.name) meets our $(dog.age) years old dog $(dog.name)."

# ╔═╡ 87da4727-cce6-4651-8e5d-2e33ed60a93e
meet(🐱, 🐕)

# ╔═╡ 0d323d27-2c2c-40d4-9c19-f8eba3b82556
meet(🐕, 🐕)

# ╔═╡ 82f7355e-628b-4665-b469-01962634d858
function our_little_story(animal1, animal2)
	return [
		describe(animal1)
		describe(animal2)
		meet(animal1, animal2)
	]
end

# ╔═╡ 14886c87-77c8-4cc4-8dec-32984dea9bb5
our_little_story(🐱, 🐕)

# ╔═╡ cb951694-60f9-4fa6-94e7-c254ce9c156d
md"""
## Interact with Python, R, Fortran, C++, C, ...

The foreign function interfaces are extremely good. Also the other way around: You can easily include a Julia component into your C, Python or R package.

Here an example for `PyCall.jl`
"""

# ╔═╡ 1cc9b7b0-1ed4-405a-9597-e0de1c014dd4
array = [1,2,3,4,5,6]

# ╔═╡ 13c3e425-7948-4d22-893f-09539959e56f
begin
	# multiline is like eval
	# in vscode you even get code highlighting
	# (note the string interpolation $array to interact with julia)
	py"""
	import numpy as np
	reshaped = np.reshape($array, (2, 3))
	"""
	# single line is like exec
	py"reshaped"
end

# ╔═╡ df3f0a84-8154-458b-90a1-c8d3a4d3dcef
md"""
In visual studio code, you even get syntax highlighting for the python strings
"""

# ╔═╡ 22b3a5f1-257b-4ee5-83b0-bdcd7c4dac34
md"""
Alterantively, use can use julia directly
"""

# ╔═╡ ca7ad18b-50b2-484a-86aa-98a90a6d03a0
begin
	np = pyimport("numpy")
	np.reshape(array, (2,3))
end

# ╔═╡ 30919fff-c123-4ce8-82a1-adad9e5ded0b
md"""
## Performance Test - Mandelbrot Example

Example is adapted from https://juliacomputing.com/assets/pdf/JuliaVsPython.pdf

**Julia is about 30x faster than Python here** (for larger images the performance impact is even higher, 1000x1000 has factor 50 already)
"""

# ╔═╡ 6777dc04-c5e4-4983-9ed8-87945969865b
width = @bind width PlutoUI.Slider(10:10:250, default=50, show_value=true)

# ╔═╡ 33fa73a0-87ef-4557-a2b2-80b60a20cb2d
md"""
### Julia version
"""

# ╔═╡ 1dfa459c-e611-4241-8e4f-9412c900b10b
begin
	function mandelbrot(c, maxiter)
		z = c
		for n in 1:maxiter
			if abs(z) > 2
				return n
			end
			z = z*z + c
		end
		return 0
	end

	function mandelbrot_set(; xmin = -0.74877, xmax = -0.74872, ymin = 0.06505, ymax = 0.06510, width = 1000, height = 1000, maxiter = 2048)
		r1 = range(xmin, xmax, length=width)
		r2 = range(ymin, ymax, length=height)
		n3 = zeros(Float32, width,height)
		for i in 1:width
			for j in 1:height
				n3[i,j] = mandelbrot(r1[i] + r2[j]im, maxiter)
			end
		end
		return (r1,r2,n3)
	end
	julia_performance = @timed mandelbrot_set(width=width, height=width)
end

# ╔═╡ 0853767e-24ab-4716-a19b-6c040d4f40bb
begin
	(plotx, ploty, plotz) = julia_performance.value
	Plots.heatmap(plotx, ploty, plotz)
end

# ╔═╡ 77ee3f66-65e2-457a-9dae-c26e126f0efb
md"""
### Python version
"""

# ╔═╡ 57d9e671-47d7-4718-b308-15a6997ac73b
python_performance = begin
	py"""
	import numpy as np
	import time
	import timeit

	def mandelbrot(c,maxiter):
	    z = c
	    for n in range(maxiter):
	        if abs(z) > 2:
	            return n
	        z = z*z + c
	    return 0

	def mandelbrot_set(xmin = -0.74877, xmax = -0.74872, ymin = 0.06505, ymax = 0.06510, width = 1000, height = 1000, maxiter = 2048):
	    r1 = np.linspace(xmin, xmax, width)
	    r2 = np.linspace(ymin, ymax, height)
	    n3 = np.empty((width,height))
	    for i in range(width):
	        for j in range(height):
	            n3[i,j] = mandelbrot(r1[i] + 1j*r2[j],maxiter)
	    return (r1, r2, n3)
	"""

	py"timeit.timeit(lambda: mandelbrot_set(width=$width, height=$width), number = 1)"
end

# ╔═╡ b3716732-8fd0-4b3c-863b-206becab2bd4
python_performance / julia_performance.time

# ╔═╡ 1860d1fb-1a33-4b00-a967-ad0f66e1b42f
md"""
## Further resources

- [learning Julia](https://julialang.org/learning/)
- [pyjulia / PyCall.jl](https://github.com/JuliaPy/PyCall.jl) ⚠️CAUTION this is not the same as [juliacall / PythonCall.jl](https://cjdoris.github.io/PythonCall.jl/stable/)⚠️

## Next

Next, we will look at one toy example and compare Cython, C++, and Julia

[Next Notebook](https://mybinder.org/v2/gh/jolin-io/workshop-accelerate-Python-with-Julia/main?filepath=03-example-cython-vs-cpp-vs-julia.ipynb)

![](https://www.jolin.io/assets/Jolin/Jolin-Banner-Website-v1.3-darkmode.webp)
"""

# ╔═╡ Cell order:
# ╟─ad2f0ea1-ca4c-47ad-8c6d-fe39730eaf2c
# ╟─2c1c69cb-69e6-486b-9e81-3d5c30999193
# ╟─c7d302a8-c0e4-11ec-24f9-5fd8c9a7e341
# ╟─04bed6e2-4514-4975-ba0e-991bd55853b7
# ╠═64443e2c-7b56-43ce-aafb-f80b807840ed
# ╠═612af880-26e3-4ccd-9d26-20cc79162ac7
# ╠═0099e358-0a4f-4b1c-84fa-16305b4e8dfe
# ╠═bb6d2e79-3741-4053-a26d-8fb84ab102d5
# ╟─881026ba-cf61-4aff-9e84-786ac6e7af6f
# ╟─fb3fedb9-8ef3-4ac7-be9b-a1664bc327f3
# ╠═bf8d4242-b70c-4ad4-8ab9-9ce7ce1631fb
# ╠═649325fb-ce88-476c-894e-9d562c95aca8
# ╠═22bdec44-2460-447b-9170-713f8e3aaee8
# ╠═f793188f-6645-46a0-b9f4-2cd0a7578b9e
# ╠═08081d91-d683-4a8b-a553-ae42b517580a
# ╟─56059199-0a9d-4695-8e54-5911722392e4
# ╠═0afb7b78-1a53-462c-bbde-4eab7d4ba2be
# ╠═1db44575-1eda-4f8a-94b1-d977788f4d50
# ╠═b906d85c-3de0-4653-8c77-2a5a36a08d69
# ╠═8f608538-8a27-4b28-836c-23b7e2b06ebe
# ╠═e6b62efb-657f-4413-940e-300f93e8e5e3
# ╠═39577aeb-c21c-4ad6-a610-dd5dbf9c692a
# ╠═87da4727-cce6-4651-8e5d-2e33ed60a93e
# ╠═0d323d27-2c2c-40d4-9c19-f8eba3b82556
# ╠═82f7355e-628b-4665-b469-01962634d858
# ╠═14886c87-77c8-4cc4-8dec-32984dea9bb5
# ╟─cb951694-60f9-4fa6-94e7-c254ce9c156d
# ╠═1cc9b7b0-1ed4-405a-9597-e0de1c014dd4
# ╠═13c3e425-7948-4d22-893f-09539959e56f
# ╟─df3f0a84-8154-458b-90a1-c8d3a4d3dcef
# ╟─22b3a5f1-257b-4ee5-83b0-bdcd7c4dac34
# ╠═ca7ad18b-50b2-484a-86aa-98a90a6d03a0
# ╟─30919fff-c123-4ce8-82a1-adad9e5ded0b
# ╠═b3716732-8fd0-4b3c-863b-206becab2bd4
# ╠═6777dc04-c5e4-4983-9ed8-87945969865b
# ╠═0853767e-24ab-4716-a19b-6c040d4f40bb
# ╟─33fa73a0-87ef-4557-a2b2-80b60a20cb2d
# ╠═1dfa459c-e611-4241-8e4f-9412c900b10b
# ╟─77ee3f66-65e2-457a-9dae-c26e126f0efb
# ╠═57d9e671-47d7-4718-b308-15a6997ac73b
# ╟─1860d1fb-1a33-4b00-a967-ad0f66e1b42f
