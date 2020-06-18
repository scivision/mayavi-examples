#!/usr/bin/env python3
import numpy as np
import typing as T

from mayavi import mlab

"""
trivial demo of Mayavi VTK visualization
using ionosphere-like space
Michael Hirsch
"""


def gsim(
    z0: float = 200,
    h0: float = 50,
    n0: float = 1e12,
    zlim: T.Sequence[float] = (100, 500),
    dz: float = 2,
    xlim: T.Sequence[float] = (-50, 50),
    dx: float = 1,
    ylim: T.Sequence[float] = (-100, 100),
    dy: float = 1,
    xsc: float = 1 / 100.0,
    ysc: float = 1 / 150.0,
) -> T.Tuple[np.ndarray, ...]:

    # keep the axes in x,y,z order instead of z,x,y.
    # must be mgrid, NOT ogrid
    x, y, z = np.mgrid[xlim[0]: xlim[1] + dx: dx, ylim[0]: ylim[1] + dy: dy, zlim[0]: zlim[1] + dz: dz]  # type: ignore
    ne = chapman(z0, h0, n0, z)
    ne = modu(x, xsc, ne)
    ne = modu(y, ysc, ne)

    return ne, x, y, z


def chapman(z0: float, h0: float, n0: float, z: float) -> np.ndarray:
    z1 = (z - z0) / h0
    return n0 * np.exp(0.5 * (1 - z1 - np.exp(-z1)))


def modu(p: float, mp: float, ne: float) -> np.ndarray:
    return ne * (0.5 * np.cos(2 * np.pi * mp * p) + 1)


def plotsim(s, x, y, z):
    p1090 = np.percentile(s, (10, 90))  # for axes limit
    # %% transparent volume example
    """
    http://docs.enthought.com/mayavi/mayavi/auto/mlab_pipeline_other_functions.html
    can manipulate opacity and combine with mutable slices
    """

    scf = mlab.pipeline.scalar_field(x, y, z, s)
    fig1 = mlab.gcf()
    hvol = makevol(scf, p1090, fig1)
    figlbl(fig1, hvol)
    # %% mutable slice
    fig2 = mlab.figure()
    scf = mlab.pipeline.scalar_field(x, y, z, s)
    makeslice(scf, fig2)
    figlbl(fig2)


def makevol(scf, p1090, figh=None):
    """
    transparent, pretty
    http://docs.enthought.com/mayavi/mayavi/auto/mlab_pipeline_other_functions.html#volume
    """
    return mlab.pipeline.volume(scf, figure=figh, vmin=p1090[0], vmax=p1090[1])


def makeslice(scf, figh=None):
    """
     we can put multiple slices in one figure
     each slice can be flipped, twisted, and slid on the fly wuth mouse or touchscreen
    http://docs.enthought.com/mayavi/mayavi/auto/mlab_pipeline_other_functions.html
    """
    mlab.pipeline.image_plane_widget(scf, figure=figh, colormap="jet", plane_orientation="x_axes", slice_index=10)

    mlab.pipeline.image_plane_widget(scf, figure=figh, plane_orientation="z_axes", slice_index=50)


def figlbl(fig, obj=None):
    fig.scene.anti_aliasing_frames = 0
    mlab.outline(figure=fig)  # box around data axes
    mlab.orientation_axes(figure=fig)
    mlab.scalarbar(obj)
    mlab.axes(figure=fig, xlabel="x (km)", ylabel="y (km)", zlabel="z (km)")


if __name__ == "__main__":
    ne, x, y, z = gsim()
    plotsim(ne, x, y, z)
    mlab.show()
