#!/usr/bin/env python
import numpy as np
from mayavi import mlab #gateway to VTK
"""
trivial demo of Mayavi VTK visualiztion
using ionosphere-like space
Michael Hirsch
"""


def gsim(z0=200, h0=50, n0=1e12, zlim=(100,500), dz=2,
                                 xlim=(-50,50),  dx=1,
                                 ylim=(-100,100),dy=1,
                                 xsc=1/100., ysc=1/150.):

    # keep the axes in x,y,z order instead of z,x,y.
    # must be mgrid, NOT ogrid
    x,y,z = np.mgrid[xlim[0]:xlim[1]+dx:dx,
                     ylim[0]:ylim[1]+dy:dy,
                     zlim[0]:zlim[1]+dz:dz]
    ne = chapman(z0,h0,n0,z)
    ne = modu(x,xsc,ne)
    ne = modu(y,ysc,ne)

    return ne,x,y,z

def chapman(z0,h0,n0,z):
    z1 = (z-z0)/h0
    return n0*np.exp(0.5*(1-z1-np.exp(-z1)))

def modu(p,mp,ne):
    return ne  *(0.5*np.cos(2*np.pi*mp*p)+1)

def plotsim(s, x,y,z):
    p1090 = np.percentile(s, (10,90)) #for axes limit
#%% transparent volume example
    """
    http://docs.enthought.com/mayavi/mayavi/auto/mlab_pipeline_other_functions.html
    can manipulate opacity and combine with mutable slices
    """

    scf = mlab.pipeline.scalar_field(x,y,z,s)
    fig1 = mlab.gcf()
    makevol(scf,p1090,fig1)
    figlbl(fig1)
#%% mutable slice
    fig2=mlab.figure()
    scf = mlab.pipeline.scalar_field(x,y,z,s)
    makeslice(scf,fig2)
    figlbl(fig2)
    mlab.show()

def makevol(scf,p1090,figh=None):
    """    transparent, pretty but hard to quantify    """
    mlab.pipeline.volume(scf, figure=figh, vmin=p1090[0], vmax=p1090[1])

def makeslice(scf,figh=None):
    """
     we can put multiple slices in one figure
     each slice can be flipped, twisted, and slid on the fly wuth mouse or touchscreen
    http://docs.enthought.com/mayavi/mayavi/auto/mlab_pipeline_other_functions.html
    """
    mlab.pipeline.image_plane_widget(scf, figure=figh,
                                     colormap="jet",
                                     plane_orientation='x_axes',
                                     slice_index=10,
                                     )

    mlab.pipeline.image_plane_widget(scf, figure=figh,
                                     plane_orientation="z_axes",
                                     slice_index=50)

def figlbl(figh=None):
    figh.scene.anti_aliasing_frames=0
    mlab.outline(figure=figh) #box around data axes
    mlab.orientation_axes(figure=figh)
    mlab.scalarbar()
    mlab.axes(figure=figh,xlabel="x (km)", ylabel="y (km)", zlabel="z (km)")

if __name__ == '__main__':
    ne, x,y,z = gsim()
    plotsim(ne, x,y,z)
