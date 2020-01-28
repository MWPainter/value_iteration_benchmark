from distutils.core import setup
from Cython.Build import cythonize

setup(name='Cython Test Three',
      ext_modules=cythonize("vi_cyth_three.pyx"))