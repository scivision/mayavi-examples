#!/usr/bin/env python

from mayavi import mlab
import numpy as np
x, y, z = np.mgrid[-10:10:20j, -10:10:20j, -10:10:20j]
s = np.sin(x*y*z)/(x*y*z)

mlab.pipeline.volume(mlab.pipeline.scalar_field(x,y,z,s))
