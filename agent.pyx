import math
import random

cdef class Agent():

    cdef double world_width
    cdef double world_height

    cdef readonly double x
    cdef readonly double y

    cdef double dx
    cdef double dy

    cdef public double vmax
    cdef public int age
    cdef public int energy
    cdef public bint is_alive

    cdef Agent target

    def __init__(self, x=None, y=None, world_width=0, world_height=0):
        self.world_width = world_width
        self.world_height = world_height

        # default values
        self.vmax = 2.0

        # initial position
        self.x = x if x else random.randint(0, world_width)
        self.y = y if y else random.randint(0, world_height)

        # initial velocity
        self.dx = 0
        self.dy = 0

        # inital values
        self.is_alive = True
        self.target = None
        self.age = 0
        self.energy = 0

    cpdef void update(self, list food) except *:
        cdef double min_dist
        cdef double squared_dist
        cdef double fx
        cdef double fy
        cdef Agent  a

        self.age = self.age + 1

        # we can't move
        if self.vmax == 0:
            return

        # target is dead, don't chase it further
        if self.target and not self.target.is_alive:
            self.target = None

        # eat the target if close enough
        if self.target:
            squared_dist = (self.x - self.target.x) ** 2 + (self.y - self.target.y) ** 2
            if squared_dist < 400:
                self.target.is_alive = False
                self.energy = self.energy + 1

        # agent doesn't have a target, find a new one
        if not self.target:
            min_dist = 9999999
            min_agent = None
            for aa in food:
                a = <Agent?>aa
                if a is not self and a.is_alive:
                    squared_dist = (self.x - a.x) ** 2 + (self.y - a.y) ** 2
                    if squared_dist < min_dist:
                        min_dist = squared_dist
                        min_agent = a
            if min_dist < 100000:
                self.target = min_agent

        # initalize 'forces' to zero
        fx = 0
        fy = 0

        # move in the direction of the target, if any
        if self.target:
            fx += 0.1*(self.target.x - self.x)
            fy += 0.1*(self.target.y - self.y)

        # update our direction based on the 'force'
        self.dx = self.dx + 0.05 * fx
        self.dy = self.dy + 0.05 * fy

        # slow down agent if it moves faster than it max velocity
        velocity = math.sqrt(self.dx ** 2 + self.dy ** 2)
        if velocity > self.vmax:
            self.dx = (self.dx / velocity) * (self.vmax)
            self.dy = (self.dy / velocity) * (self.vmax)

        # update position based on delta x/y
        self.x = self.x + self.dx
        self.y = self.y + self.dy

        # ensure it stays within the world boundaries
        self.x = max(self.x, 0)
        self.x = min(self.x, self.world_width)
        self.y = max(self.y, 0)
        self.y = min(self.y, self.world_height)


cdef class Predator(Agent):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.vmax = 2.5

cdef class Prey(Agent):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.vmax = 2.0

cdef class Plant(Agent):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.vmax = 0.0


cpdef void main(WORLD_WIDTH, WORLD_HEIGHT, TIMESTEPS) except *:
    cdef int timestep
    cdef list preys
    cdef list predators
    cdef list plants
    cdef dict kwargs

    # open the ouput file
    # f = open('output.csv', 'w')
    # print(0, ',', 'Title', ',', 'Predator Prey Relationship / Example 02 / Cython', file=f)

    # create initial agents
    kwargs = dict(
        world_width=WORLD_WIDTH,
        world_height=WORLD_HEIGHT,
    )
    preys = [Prey(**kwargs) for i in range(10)]
    predators = [Predator(**kwargs) for i in range(10)]
    plants = [Plant(**kwargs) for i in range(100)]

    timestep = 0
    while timestep < TIMESTEPS:
        # update all agents
        # no need to update the plants; they do not move
        for a in preys:
            a.update(plants)
        for a in predators:
            a.update(preys)

        # handle eaten and create new plant
        plants = [p for p in plants if p.is_alive is True]
        plants = plants + [Plant(**kwargs) for i in range(2)]

        # handle eaten and create new preys
        preys = [p for p in preys if p.is_alive is True]

        for p in preys[:]:
            if p.energy > 5:
                p.energy = 0
                preys.append(Prey(x = p.x + random.randint(-20, 20), y = p.y + random.randint(-20, 20), **kwargs))

        # handle old and create new predators
        predators = [p for p in predators if p.age < 2000]

        for p in predators[:]:
            if p.energy > 10:
                p.energy = 0
                predators.append(Predator(x = p.x + random.randint(-20, 20), y = p.y + random.randint(-20, 20), **kwargs))

        # write data to output file
        #[print(timestep, ',', 'Position', ',', 'Predator', ',', a.x, ',', a.y, file=f) for a in predators]
        #[print(timestep, ',', 'Position',  ',', 'Prey', ',', a.x, ',', a.y, file=f) for a in preys]
        #[print(timestep, ',', 'Position',  ',', 'Plant', ',', a.x, ',', a.y, file=f) for a in plants]

        timestep = timestep + 1

    print(len(predators), len(preys), len(plants))