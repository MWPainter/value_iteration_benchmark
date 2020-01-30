from distutils.core import setup
from Cython.Build import cythonize

setup(name='Cython Test Four',
      ext_modules=cythonize("vi_cyth_four.pyx"))
