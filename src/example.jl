module example

using TyPython
using TyPython.CPython

@export_py function mat_double(a::AbstractArray)::Array
    return a .* 2
end

@export_py function mat_mul(a::AbstractArray, b::AbstractArray)::Array
    return a * b
end

function init()
    @export_pymodule _example begin
        jl_mat_mul = Pyfunc(mat_mul)
        jl_mat_double = Pyfunc(mat_double)
    end
end

# the following code is optional,
# but makes Python code loading much faster since the second time.
precompile(init, ())

end