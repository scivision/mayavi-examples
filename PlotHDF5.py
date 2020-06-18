#!/usr/bin/env python3
"""
Plotting 4-D data set: 3-D spatial + time.
Each HDF5 file holds one time step (3-D array inside file)
"""
import h5py
import numpy as np
from pathlib import Path
from scipy.interpolate import RectBivariateSpline  # interp2d
from matplotlib.pyplot import figure, show
from mayavi import mlab


def loadplot(fn: Path):
    datfn = Path(fn).expanduser()

    with h5py.File(datfn, "r") as f:
        Ne = np.rot90(f["/den1"][:128, ...])

    yg = np.linspace(0, 51.2, Ne.shape[2])
    xg = np.linspace(0, 51.2, Ne.shape[1])
    # zg = np.linspace(0, 51.2, Ne.shape[0])
    # %%
    FNe = np.fft.fft2(Ne)
    Fmag = np.fft.fftshift(abs(FNe))
    # %%
    A = np.arange(0, 2 * np.pi, 0.01)
    r = 2 * np.pi / 3  # [m]
    x = r * np.cos(A)
    y = r * np.sin(A)

    # for now just taking the first slice
    f = RectBivariateSpline(xg, yg, Ne[0, ...])

    # interp2d never finished, extremely long run time--never had this problem before (!)
    xm, ym = np.meshgrid(xg, yg)
    #    f = interp2d(xm,ym,Ne)
    # BivarateSpline is using FITPACK, which appears to accept only single coordinate pairs at a time.
    iNe = np.empty(x.size)
    for i, (xi, yi) in enumerate(zip(x, y)):
        iNe[i] = f(xi, yi)

    # %%
    if 0:
        fg = figure()
        ax = fg.gca()
        hi = ax.pcolormesh(xg, yg, Ne)

        ax.set_xlabel("x [m]")
        ax.set_ylabel("y [m]")
        ax.set_title("Number density $N_e$")
        fg.colorbar(hi).set_label("$N_e$ [normalized]")

        ax = figure().gca()
        hi = ax.pcolormesh(Fmag)

        # state machine code--less reliable way to plot
        # plt.pcolormesh(Ne)
        # plt.colorbar()
        # plt.show()

    ax = figure().gca()
    ax.plot(np.degrees(A), iNe)
    ax.set_xlabel("angle [degrees]")
    ax.set_ylabel("power")
    ax.autoscale(True, axis="x", tight=True)

    fg = mlab.figure()
    scf = mlab.pipeline.scalar_field(Ne, figure=fg)
    vol = mlab.pipeline.volume(scf, figure=fg)
    mlab.colorbar(vol)
    mlab.show()


if __name__ == "__main__":
    from argparse import ArgumentParser

    p = ArgumentParser()
    p.add_argument("fn", help="HDF5 3-D time step file")
    p = p.parse_args()

    loadplot(p.fn)

    show()
