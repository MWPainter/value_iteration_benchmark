# value_iteration_benchmark
Used to compare python vs cython vs c++.

## Compiling, running and timing
C++:
```
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ g++ vi_cpp.cpp
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ time ./a.out
Ran 40000 many iterations, to get value of: 2

real	0m0.226s
user	0m0.223s
sys	0m0.003s
```

Python:
```
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ time python run_python.py
Ran 4000000 iterations to get value: 2.0

real	0m13.105s
user	0m13.042s
sys	0m0.049s
```

Python, compiled by Cython:
```
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ python setup_pyth.py build_ext --inplace
Compiling vi_pyth.py because it changed.
[1/1] Cythonizing vi_pyth.py
/Users/mpainter/opt/anaconda3/envs/bn/lib/python3.7/site-packages/Cython/Compiler/Main.py:369: FutureWarning: Cython directive 'language_level' not set, using 2 for now (Py2). This will change in a later release! File: /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_pyth.py
  tree = Parsing.p_module(s, pxd, full_module_name)
running build_ext
building 'vi_pyth' extension
creating build
creating build/temp.macosx-10.9-x86_64-3.7
gcc -Wno-unused-result -Wsign-compare -Wunreachable-code -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include/python3.7m -c vi_pyth.c -o build/temp.macosx-10.9-x86_64-3.7/vi_pyth.o
gcc -bundle -undefined dynamic_lookup -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -arch x86_64 build/temp.macosx-10.9-x86_64-3.7/vi_pyth.o -o /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_pyth.cpython-37m-darwin.so
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ time python run_python.py
Ran 4000000 iterations to get value: 2.0

real	0m3.733s
user	0m3.682s
sys	0m0.043s
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$
```

Cython (adding cdef declarations):
```
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ python setup_cyth.py build_ext --inplace
Compiling vi_cyth.pyx because it changed.
[1/1] Cythonizing vi_cyth.pyx
/Users/mpainter/opt/anaconda3/envs/bn/lib/python3.7/site-packages/Cython/Compiler/Main.py:369: FutureWarning: Cython directive 'language_level' not set, using 2 for now (Py2). This will change in a later release! File: /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_cyth.pyx
  tree = Parsing.p_module(s, pxd, full_module_name)
running build_ext
building 'vi_cyth' extension
gcc -Wno-unused-result -Wsign-compare -Wunreachable-code -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include/python3.7m -c vi_cyth.c -o build/temp.macosx-10.9-x86_64-3.7/vi_cyth.o
gcc -bundle -undefined dynamic_lookup -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -arch x86_64 build/temp.macosx-10.9-x86_64-3.7/vi_cyth.o -o /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_cyth.cpython-37m-darwin.so
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ time python run_cython.py
Ran 4000000 iterations to get value: 2.0

real	0m4.211s
user	0m4.159s
sys	0m0.045s
```

