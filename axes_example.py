from mayavi import mlab
import numpy as np
x, y, z = np.mgrid[0.01:50:1., 0.01:100:1., 100:200:1.5]
s = np.sin(x*y*z)/(x*y*z)
scf = mlab.pipeline.scalar_field(x,y,z,s)
mlab.pipeline.volume(scf)#, vmin=0, vmax=0.8)
mlab.axes()
mlab.show()