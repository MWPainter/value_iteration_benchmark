# value_iteration_benchmark
Originally the purpose of this repo was to compare a C++ and Python implementation on a hard-coded value iteration. (What does 'hard-coded value iteration' mean, you ask? The MDP is hardcoded, and it takes two iterations to converge, although the loop is run millions of times anyway.)

After initially writing the cython implementation (the one found in the cython folder), and finding that it did not run any faster then when the Cython compiler was used to compile Python code, I spent a couple days learning some basic Cython and how to use it properly to optimise code.




## TL;DR

C++ runs much faster than Python on CPU bound code, as compiling is faster than interpreting. Python can be compiled using the Cython compiler to speed it up. In this code we run a simple CPU bound process in C++, Python and Cython to compare performance. I've added the qualitative results in a box below:

| What you want? | Solution |
| - | - |
| Code that matches the speed of C++ and can be used in Python | Write your code in C++ and write a Cython wrapper for it (no free lunch I'm afraid). | 
| A significant speed up (of about 10x or more sometimes) | Use Cython, adding Cython types as much as required to reach desired speed. | 
| A small speed up of my Python code without really having to do anything | The Cython compiler will compile Python code, and can lead of immediate speed ups of up to 2x speed. | 
| <3 Python | Continue snaking :) | 





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

## A GOALS group guide to Cython (hopefully)

This section aims to be an entry point to learning (the relevant parts of) Cython for the [GOALS group](https://ori.ox.ac.uk/labs/goals/). Really, this just lists the relevant parts of the Cython documentation, so I'll present it in a table with some notes about why that particular bit of documentation is relevant.

| Documentation | Relevance | Notes |
| --- | --- | --- |
| [Cython Documentation](https://cython.readthedocs.io/en/latest/index.html) | Reference | The homepage for Cython's documentation. Everything about Cython can be found here, including changelogs. (In particular you might want to see the full user guide which goes very in-depth and it might be helpful for debugging, and I don't link to it much from here (other than some subsections of pages)). |
| [Getting Started Guide](https://cython.readthedocs.io/en/latest/src/quickstart/index.html) | Read | A quick tutorial to install Cython and get some Cython code compiling and running. You should read this to learn how to compile Cython code. |
| [Basic Tutorial](https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html) | Read | The introduction tutorial. Teaches the basics, so obviously need to read :) |
| [Cdef classes (a.k.a. Extension Types?)](https://cython.readthedocs.io/en/latest/src/tutorial/cdef_classes.html) | If you want OOP? | Describes how to make classes in Cython. N.B. I think these can be used as cstructs in C, and can therefore write a C or C++ header file to use the compiled C(++) code in a C(++) codebase. |
| [Vector (List) Example In Cython And Type Conversions](http://docs.cython.org/en/latest/src/userguide/wrapping_CPlusPlus.html#standard-library) | Recommended (Because recommend to use C++ libraries for lists etc) | Example of using the vector class from the C++ STL in Cython code, and conversions between data types to and from C++ and Python. N.B. The link is for only a **portion** of the page, with the title (Standard Library). | 
| [Pxd Files](https://cython.readthedocs.io/en/latest/src/tutorial/pxd_files.html) | Read (because its very short) | The first line basically says it all. They are like C header files. N.B. the cdef classes defined in these files can be used in all of C, C++ and Python, as a struct, C++ class and Python class respectively. |
| [Caveats](https://cython.readthedocs.io/en/latest/src/tutorial/caveats.html) | Read (d.w. also short) | Some things to remember because C and Python aren't completely compatable | 
| [Profiling](https://cython.readthedocs.io/en/latest/src/tutorial/profiling_tutorial.html) | If you need fast code you need to read this (if you just need to understand some Cython skip) | Explains how to use the Python cProfile tool in Cython. |
 | [Typed Memoryviews](https://cython.readthedocs.io/en/latest/src/userguide/memoryviews.html#memoryviews) | Read to understand about typing system for arrays/lists | Describes the typed memoryview data types, which are used for lists and arrays (including numpy, so important if you plan to use numpy etc) | 
| [Python Arrays](https://cython.readthedocs.io/en/latest/src/tutorial/array.html) | I skipped this | If you want to use python arrays this is the guide. Couldn't see why not just use the vector class from the STL. | 
| [Using NumPy](https://cython.readthedocs.io/en/latest/src/tutorial/numpy.html) | Skip | Some useful information about using Cython with NumPy, but hasn't been updated since Typed Memoryviews were introduced, so is a bit confusing. |
| [Strings](https://cython.readthedocs.io/en/latest/src/tutorial/strings.html) | Read as far as you can be bothered (It goes overly in depth about low level string stuff) | If you need to use strings (yes) then read this, if only for only understanding the string datatypes available in Cython. |
| [C++ STL Header Files](https://github.com/cython/cython/tree/master/Cython/Includes) | Reference Page | Here is the GitHub page for the pdx files defining cdef headers for the C++ STL. | 
| [Using C Code](https://cython.readthedocs.io/en/latest/src/tutorial/clibraries.html) | Skip | Describes how to use a C library in Cython. (Remember [standard C libraries](https://github.com/cython/cython/tree/master/Cython/Includes) already have the relevant pxd's, so you likely never need to do this.) |
| [Using C++ Code](https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html) | Skip | Describes how to use a C++ library in Cython *and* a use a Cython library in C++. (Remember [standard C libraries](https://github.com/cython/cython/tree/master/Cython/Includes) already have the relevant pxd's, so you likely never need to do this.) | 
| [Compiler Directives](https://cython.readthedocs.io/en/latest/src/userguide/source_files_and_compilation.html#compiler-directives) | Skip | Options to turn off checks (such as 'out of bounds' errors and so on). N.B. The link is for only a **portion** of the page, called Compiler Directives. | 
| [Memory Allocation](https://cython.readthedocs.io/en/latest/src/tutorial/memory_allocation.html) | Skip | Low level memory allocation and pointers is one option for replacing Python lists in Cython, if you want that. | 
| [FAQ](https://github.com/cython/cython/wiki/FAQ) | Reference | If something weird happens sometimes the answer was here and not on stack overflow :) | 

 
Some bits of advice that I learned while making this repo:
- (Not from making this repo, but important.) If you care about speed, [profile your code](https://cython.readthedocs.io/en/latest/src/tutorial/profiling_tutorial.html).
- If your Cython code is slower than expected (for example, compiled Python is just as fast) then use `cython -a <your_file>.pyx` to produce a report that shows where Python's C-API is called (a.k.a. the bit thats making your Cython code slow).
- Avoid using Python objects as much as possible. Lots of the C and C++ standard libraries are available, for all of your list, set, queue and so on needs. An example in this repo is using the `vector` class from the C++ STL instead of Python lists.
- Sometimes a line may not look like it will lead to Python C-API calls. This is because Cython is reproducing the behaviour of Python which is a high level language. For example, C will not raise an excaption for an 'out of bounds' error when accessing an array, whereas Cython will. These can be turned off using compiler directives, as described in the [basic tutorial](https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html).
- (I'm not sure where I read about this.) When defining something, there are a few choices, which I will explain three. `def` is used to define a Python function in the normal way. `cdef` is used to define C-types for variables and C functions. `cpdef` can be used to define a C function, however, it can also be called directly from Python code. `cpdef` will add boilerplate code in a 'wrapper function'2 that creates a wrapper function th to also produce a Python 


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