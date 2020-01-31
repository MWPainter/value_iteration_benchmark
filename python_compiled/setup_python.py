from distutils.core import setup
from Cython.Build import cythonize

setup(name='Value Iteration Python',
      ext_modules=cythonize("vi_python.py"))