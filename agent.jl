
using PythonCall: pyisnone

function update!(self, food)
    self.age = self.age + 1

    # we can't move
    if Bool(self.vmax == 0.0)
        return
    end

    # target is dead, don't chase it further
    if !pyisnone(self.target) && Bool(!self.target.is_alive)
        self.target = nothing
    end
    
    # eat the target if close enough
    if !pyisnone(self.target)
        squared_dist = (self.x - self.target.x) ^ 2 + (self.y - self.target.y) ^ 2
        if Bool(squared_dist < 400)
            self.target.is_alive = false
            self.energy = self.energy + 1
        end
    # agent doesn't have a target, find a new one
    else
        min_dist = 9999999
        min_agent = nothing
        for a in food
            if Bool(a !== self) && Bool(a.is_alive)
                sq_dist = (self.x - a.x) ^ 2 + (self.y - a.y) ^ 2
                if Bool(sq_dist < min_dist)
                    min_dist = sq_dist
                    min_agent = a
                end
            end
        end
        if Bool(min_dist < 100000)
            self.target = min_agent
        end
    end

    # initalize 'forces' to zero
    fx = 0.0
    fy = 0.0

    # move in the direction of the target, if any
    if !pyisnone(self.target)
        fx += 0.1 * (self.target.x - self.x)
        fy += 0.1 * (self.target.y - self.y)
    end

    # update our direction based on the 'force'
    self.dx = self.dx + 0.05 * fx
    self.dy = self.dy + 0.05 * fy

    # slow down agent if it moves faster than it max velocity
    velocity = sqrt(self.dx ^ 2 + self.dy ^ 2)
    if Bool(velocity > self.vmax)
        self.dx = (self.dx / velocity) * (self.vmax)
        self.dy = (self.dy / velocity) * (self.vmax)
    end

    # update position based on delta x/y
    self.x = self.x + Int(round(self.dx))
    self.y = self.y + Int(round(self.dy))

    # ensure it stays within the world boundaries
    self.x = max(self.x, 0)
    self.x = min(self.x, self.world_width)
    self.y = max(self.y, 0)
    self.y = min(self.y, self.world_height)
end

function (colon::Base.Colon)(start::Int64, stop::Py)
    colon(start, pyconvert(Int, stop))
end
function (colon::Base.Colon)(start::Py, stop::Int)
    colon(pyconvert(Int, start), stop)
end
function (colon::Base.Colon)(start::Py, stop::Py)
    colon(pyconvert(Int, start), pyconvert(Int, stop))
end

function Base.sqrt(num::Py)
    sqrt(pyconvert(Float64, num))
end
function Base.round(num::Py)
    round(pyconvert(Float64, num))
end

function Base.:!(b::Py)
    !(pyconvert(Bool, b))
end


JuliaAgent = pytype("JuliaAgent", (), [
    "__module__" => "__main__",
    pyfunc(
        name = "__init__",
        doc = """
        description
        """,
        function (self; x=nothing, y=nothing, world_width=0, world_height=0)
            # default values
            self.vmax = 2.0

            # initial position
            self.world_width = world_width
            self.world_height = world_height
            self.x = pyisnone(x) ? rand(0:self.world_width) : x
            self.y = pyisnone(y) ? rand(0:self.world_height) : y

            # initial velocity
            self.dx = 0.0
            self.dy = 0.0

            # inital values
            self.is_alive = true
            self.target = nothing
            self.age = 0
            self.energy = 0
            return
        end,
    ),
    pyfunc(
        name = "update",
        update!
    ),
])
