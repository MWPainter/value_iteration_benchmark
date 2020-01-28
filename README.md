# value_iteration_benchmark
Used to compare python vs cython vs c++.

## TL;DR

C++ runs much faster than Python on CPU bound code, as compiling is faster than interpreting. Python can be compiled using the Cython compiler to speed it up. 

Our experiments give the following times for equivalent code that runs a (bad) implementation of value iteration:
1. C++ = 0.217s
2. Python = 13.105s
3. Compiled Python = 3.733s
4. Naive Cython = 4.211s
5. Optimised Cython = TODO

To effectively improve speed in Cython, the focus should be on reducing the ammount that Python's C-API needs to be called. When something cannot be converted directly to C by Cython, for example, python lists, it calls the Python C-API. So the result of the Cython compiler is still C code, that uses the Python C-API when Python aspects are required.

The primary tool for optimising Cython code is to use the report produced by the cython compiler when the following is run: `cython -a <your_file>.pyx`. This gives an effective way to 

From this code, the main few points to consider when porting Python code to Cython are the following:
- Always use the reports from running `cython -a <your_file>.pyx`
- Make sure variables used in loops are declared using cdef
- Use typed functions where possible. (I.e. always use cdef and cpdef if a python interface is required).
- Avoid 

Finally, it always seems best to use the reports from the python compiler. For example, in the loop `for i in range(len(l))` it will identify the python interaction required by using the `len` function, on a list `l`, and it will identify if `i` is not declared using a cdef. (N.B. It will not say these directly, but solving either of the problems will cause the line to be 'less yellow' in the report, which means less Python API interection, which means faster code.)

## Compiling, running and timing

C++:
```
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ time ./a.out
Ran 4000000 many iterations, to get value of: 2

real	0m0.217s
user	0m0.213s
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

## Other Notes About Cythonizing

See http://docs.cython.org/en/latest/src/quickstart/cythonize.html, for guide on 'cythonizing' code

Some quotes to pay attention to?:
Since the iterator variable i is typed with C semantics, the for-loop will be compiled to pure C code




## Incremental Improving The Cython Code

Adding cdefs for iterator variables so loops can be converted to c. 2x speed up.
-> ref to two lines of code in github

```
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ python setup_cyth_two.py build_ext --inplace
Compiling vi_cyth_two.pyx because it changed.
[1/1] Cythonizing vi_cyth_two.pyx
/Users/mpainter/opt/anaconda3/envs/bn/lib/python3.7/site-packages/Cython/Compiler/Main.py:369: FutureWarning: Cython directive 'language_level' not set, using 2 for now (Py2). This will change in a later release! File: /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_cyth_two.pyx
  tree = Parsing.p_module(s, pxd, full_module_name)
running build_ext
building 'vi_cyth_two' extension
creating build
creating build/temp.macosx-10.9-x86_64-3.7
gcc -Wno-unused-result -Wsign-compare -Wunreachable-code -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include/python3.7m -c vi_cyth_two.c -o build/temp.macosx-10.9-x86_64-3.7/vi_cyth_two.o
gcc -bundle -undefined dynamic_lookup -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -arch x86_64 build/temp.macosx-10.9-x86_64-3.7/vi_cyth_two.o -o /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_cyth_two.cpython-37m-darwin.so
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ time python run_cython_two.py
Ran 4000000 iterations to get value: 2.0

real	0m2.245s
user	0m2.051s
sys	0m0.091s
```

Changing def to cpdef. def = python, cdef = cython, cpdef = cython + python wrapper, which is a small overhead over cdef.
-> ref to line of code in github

```
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ python setup_cyth_three.py build_ext --inplace
Compiling vi_cyth_three.pyx because it changed.
[1/1] Cythonizing vi_cyth_three.pyx
/Users/mpainter/opt/anaconda3/envs/bn/lib/python3.7/site-packages/Cython/Compiler/Main.py:369: FutureWarning: Cython directive 'language_level' not set, using 2 for now (Py2). This will change in a later release! File: /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_cyth_three.pyx
  tree = Parsing.p_module(s, pxd, full_module_name)
running build_ext
building 'vi_cyth_three' extension
gcc -Wno-unused-result -Wsign-compare -Wunreachable-code -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include -arch x86_64 -I/Users/mpainter/opt/anaconda3/envs/bn/include/python3.7m -c vi_cyth_three.c -o build/temp.macosx-10.9-x86_64-3.7/vi_cyth_three.o
gcc -bundle -undefined dynamic_lookup -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -L/Users/mpainter/opt/anaconda3/envs/bn/lib -arch x86_64 -arch x86_64 build/temp.macosx-10.9-x86_64-3.7/vi_cyth_three.o -o /Users/mpainter/Desktop/value_iter_benchmark/value_iteration_benchmark/vi_cyth_three.cpython-37m-darwin.so
(bn) tempadmins-MacBook-Pro:value_iteration_benchmark mpainter$ time python run_cython_three.py
Ran 4000000 iterations to get value: 2.0

real	0m2.139s
user	0m2.082s
sys	0m0.048s
```

After this, we used the reports from the cython compiler. In the 4th version of the code we add a cdef that was missed, and slowed a loop down:
-> link to the cdef on the REPEAT variable and where it's used.

Secondly, lists were replaced by arrays (OR SOMETHING TODO)