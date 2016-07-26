
=========================
mayavi examples in python
=========================

.. image:: mayavi_iono.png
  :alt: [example ionosphere in Mayavi]
  
3-D and 4-D plotting with Mayavi in Python

Version 4.4.4 of Mayavi works with Python 2.7 / 3.4 / 3.5::

    conda install -c menpo mayavi

Version 4.5 of Mayavi is `coming soon with Jupyter support <https://github.com/enthought/mayavi/issues/384>`_

Note 
=======
For Mayavi 4.4.4, you may get error::


To fix, consider::

    patch $(python -c "import traits; print(traits.__path__[0])")/trait_handlers.py trait_handlers.patch
