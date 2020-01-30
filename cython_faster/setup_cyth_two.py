from distutils.core import setup
from Cython.Build import cythonize

setup(name='Cython Test Two',
      ext_modules=cythonize("vi_cyth_two.pyx"))