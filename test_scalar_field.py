#!/usr/bin/env python3
from mayavi import mlab
import numpy as np
import os


def test_scalar_field():
    # arbitrary grid
    x, y, z = np.mgrid[-10:10:20j, -10:10:20j, -10:10:20j]  # type: ignore

    # fake data
    s = np.sin(x * y * z) / (x * y * z)

    scf = mlab.pipeline.scalar_field(x, y, z, s)
    vol = mlab.pipeline.volume(scf)
    mlab.colorbar(vol)


if __name__ == "__main__":

    test_scalar_field()

    if not bool(os.environ.get("CI", False)):
        mlab.show()
