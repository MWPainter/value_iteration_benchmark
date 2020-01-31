from distutils.core import setup
from Cython.Build import cythonize

setup(name='Cython Test',
      ext_modules=cythonize("vi_cython.pyx"))