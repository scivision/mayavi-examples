
=========================
mayavi examples in python
=========================

.. image:: mayavi_iono.png
  :alt: [example ionosphere in Mayavi]
  
3-D and 4-D plotting with Mayavi in Python

Version 4.5 of Mayavi works with Python 2.7 / 3.4 / 3.5 and Jupyter Notebook::

    conda install -c menpo mayavi


Note 
=======
For Mayavi 4.5, you may get error::


To fix, consider::

    patch $(python -c "import traits; print(traits.__path__[0])")/trait_handlers.py trait_handlers.patch
