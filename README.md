# value_iteration_benchmark

## Intro 

Originally the purpose of this repo was to compare a C++ and Python implementation on a hard-coded value iteration. (What does 'hard-coded value iteration' mean, you ask? The MDP is hardcoded, and it takes two iterations to converge, although the loop is run millions of times anyway.)

After initially writing the cython implementation (the one found in the cython folder), and finding that it did not run any faster then when the Cython compiler was used to compile Python code, I spent a couple days learning some basic Cython and how to use it properly to optimise code.





## TL;DR

C++ runs much faster than Python on CPU bound code, as compiling is faster than interpreting. Python can be compiled using the Cython compiler to speed it up. In this code we run a simple CPU bound process in C++, Python and Cython to compare performance. I've added the qualitative results in a box below:

| What you want? | Likely Solution |
| - | - |
| Code that matches the speed of C++ and can be used in Python | Write your code in C++ and write a Cython wrapper for it (no free lunch I'm afraid). | 
| A significant speed up (of about 10x or more sometimes) | Use Cython, adding Cython types as much as required to reach desired speed. | 
| A small speed up of my Python code without really having to do anything | The Cython compiler will compile Python code, and can lead of immediate speed ups of up to 2x speed. | 
| <3 Python | Continue snaking :) | 

I think the amount of effort that it is to actually make Cython much faster, I have to convert the code to use C++ classes like vector , and I thought if I do that I might as well go all out and convert to C++ for the value curve stuff

I think there are parts of the code base that would be best to change to Cython though (e.g. my THTS code would have to use both Python code from the models folder + 





## Results

Below we give the runtimes, measured using the bash `time` command, for each of the different languages and compilation methods. The main differences between the different Cython versions are that the naive Cython implementation was written having after only having looked at how to compile a Cython program, whereas the faster Cython version was built after reading the [Getting Started Guide](https://cython.readthedocs.io/en/latest/src/quickstart/index.html) and the final optimised code was produced after having read all of the referenced documentation from the "A GOALS group guide to Cython (hopefully)" section. This *may* give some indication of the relative amounts of work required for different speed ups.

| Language/Compilation Method | Macbook Time | Intel i7 Desktop Time | 
| --- | --- | --- |
| C++ | TODO | 0.101s |
| Python | TODO | 4.092s |
| Python Compiled | TODO | 1.436s |
| (Naive) Cython | TODO | 1.337s |
| (Faster) Cython | TODO | 1.269s |
| (Optimised (C-array)) Cython | TODO | 0.185s |
| (Optimised (Vector)) Cython | TODO | 0.207s |



## A GOALS group guide to Cython (hopefully)

This section aims to be an entry point to learning (the relevant parts of) Cython for the [GOALS group](https://ori.ox.ac.uk/labs/goals/). Really, this just lists the relevant parts of the Cython documentation, so I'll present it in a table with some notes about why that particular bit of documentation is relevant.

| Documentation | Relevance | Notes |
| --- | --- | --- |
| [Cython Documentation](https://cython.readthedocs.io/en/latest/index.html) | Reference Page | The homepage for Cython's documentation. Everything about Cython can be found here, including changelogs. (In particular you might want to see the full user guide which goes very in-depth and it might be helpful for debugging, and I don't link to it much from here (other than some subsections of pages)). |
| [Getting Started Guide](https://cython.readthedocs.io/en/latest/src/quickstart/index.html) | Read | A quick tutorial to install Cython and get some Cython code compiling and running. You should read this to learn how to compile Cython code. |
| [Basic Tutorial](https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html) | Read | The introduction tutorial. Teaches the basics, so obviously need to read :) |
| [Cdef classes (a.k.a. Extension Types?)](https://cython.readthedocs.io/en/latest/src/tutorial/cdef_classes.html) | Read (assuming you need OOP in Cython) | Describes how to make classes in Cython. N.B. I think these can be used as cstructs in C, and can therefore write a C or C++ header file to use the compiled C(++) code in a C(++) codebase. |
| [Type Conversion](https://cython.readthedocs.io/en/latest/src/userguide/language_basics.html#automatic-type-conversions) | Read | Only read the section on type conversions. Its important to read this to properly learn how to type things
| [Vector (List) Example In Cython And C++ Type Conversions](http://docs.cython.org/en/latest/src/userguide/wrapping_CPlusPlus.html#standard-library) | Recommended (I recommend replacing lists with the `vector` class from C++ in Cython code) | Example of using the vector class from the C++ STL in Cython code, and conversions between data types to and from C++ and Python. N.B. The link is for only a **portion** of the page, with the title (Standard Library). | 
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
| [FAQ](https://github.com/cython/cython/wiki/FAQ) | Reference Page | If something weird happens sometimes the answer was here and not on stack overflow :) | 

 
Some bits of advice that I learned while making this repo:
- (Not from making this repo, but important.) If you care about speed, [profile your code](https://cython.readthedocs.io/en/latest/src/tutorial/profiling_tutorial.html).
- If your Cython code is slower than expected (for example, compiled Python is just as fast) then use `cython -a <your_file>.pyx` to produce a report that shows where Python's C-API is called (a.k.a. the bit thats making your Cython code slow).
- Avoid using Python objects as much as possible. Lots of the C and C++ standard libraries are available, for all of your list, set, queue and so on needs. An example in this repo is using the `vector` class from the C++ STL instead of Python lists.
- Sometimes a line may not look like it will lead to Python C-API calls. This is because Cython is reproducing the behaviour of Python which is a high level language. For example, C will not raise an excaption for an 'out of bounds' error when accessing an array, whereas Cython will. These can be turned off using compiler directives, as described in the [basic tutorial](https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html).
- (I'm not sure where I read about this.) When defining something, there are a few choices, which I will explain three. `def` is used to define a Python function in the normal way. `cdef` is used to define C-types for variables and C functions. `cpdef` can be used to define a C function, however, it can also be called directly from Python code. `cpdef` will add boilerplate code in a 'wrapper function' that creates a wrapper function that also produces a Python function (or similarly for classes). 





## Some Notes About This Code And How To Run It

This repo contains seven different folders each containing code that performs the same (poor) hard coded value iteration. In each, the MDP is encoded in either lists or arrays. The MDP used is the same seven state MDP, which has a value of two in its initial state. Note that this value iteration is "poor" because it cannot take an arbitrary MDP, and it actually converges in two iterations while 4 million are run (so that the runtime isn't in micro seconds).

### Python

The first folder to look at is the `python` folder. This is just Python code and hopefully is simple and easy to follow what it does. An attempt was made to describe the MDP in the comments at the top of the file. 

### Compiled Python 

Next to look at is the `python_compiled` folder. The only difference to the `python` folder is the addition of the `setup_python.py` file, which contains the following code:
```
from distutils.core import setup
from Cython.Build import cythonize

setup(name='Hello world app',
      ext_modules=cythonize("vi_pyth.py"))
```

This allows the python code in `vi_python.py` to be compiled using `python setup_python.py build_ext --inplace` from within the `python_compiled` folder, which will produce both a C file and a `.so` file. Whenever code is imported from the `vi_python.py` it will then use the compiled code in the `.so` file.

### Cython 

In the `cython` folder is my first attempt at speeding up the code. Optimistically ignoring the majority of the documentation and armed with knowing how to compile cython files, this was my attempt. The main differences to note is the change of file extension from `.py` to `.pyx` and the addition of C type declarations inside the function running value iteration, which we copy here:
```
	cdef list s    = [   0,   0,   1,   1,   4,   4]
	cdef list acts = ["a1","a1","a1","a1","a1","a1"]
	cdef list sp   = [   1,   4,   2,   3,   5,   6]
	cdef list r    = [ 1.0, 0.0, 0.0, 1.0, 2.0, 4.0]
	cdef list prob = [ 0.5, 0.5, 0.8, 0.2, 0.6, 0.4]

	cdef list V = [0.0] * 7
	cdef list next_V = [0.0] * 7
	cdef int counter = 0
```

Running the command `cython -a vi_cython.py` will produce the file `vi_cython.html` which can be opened to see a report about the C code that is produced when `vi_cython.pyx` is compiled. This report shows how Python code (that are indicated with a plus marker) is translated into the C code produced by the compiler. Lines are tinted yellow depending on how much Python C-API interaction is required. 

### Faster Cython

After producing the report found in `cython/vi_cython.html` the slowness of the Cython code (relative to what I expected compared to the compiled Python code) can be attributed to two things: firstly, I forgot to declare a type for the `iterations` variable and secondly, the code still uses list objects, which are Python objects and are therefore slow to use. Note that `cdef list` is never something useful to actually do, it doesn't help Cython at all, because `list` is a Python type. 

Having only spent a limited time in the Cython documentation for attempt, it's not obvious how to solve the second problem. However, the additional cdefs to make the loops 'fully C' can be found in the `cython_faster` folder. The only real changes are the following three lines of code:
```
cdef int iterations = 4000000
```
```
	cdef int len_s = len(s)
```
```
		for i in range(len_s):
```

Looking at the `vi_cython.html` report in the `cython_faster` folder shows that the loops are now successfully purely C loops. According to the Cython documentation (somewhere, would like to reference it) just running Python code from a C loop can be significantly faster than running compiled Python code. However I did not see such improvements.

### Optimised Cython 

After spending a little more time in the Cython documentation I found two solutions.

Solution one is found in the `cython_optimised_carray` folder, which changes the list types to C array types. Importantly, the code below uses Python lists to instantiate C arrays. It is important to realise that the variables will now be C arrays, and not Python lists anymore, which means that a number of Python features are lost, such as automatic bounds checks and being able to append elements. However, this code is a lot faster as it doesn't have to rely on Python objects anymore.

The main changes in `cython_optimised_carray` are just in the cdefs:

```
	cdef int[6] s       = [   0,   0,   1,   1,   4,   4]
	cdef list acts      = ["a1","a1","a1","a1","a1","a1"]
	cdef int[6] sp      = [   1,   4,   2,   3,   5,   6]
	cdef double[6] r    = [ 1.0, 0.0, 0.0, 1.0, 2.0, 4.0]
	cdef double[6] prob = [ 0.5, 0.5, 0.8, 0.2, 0.6, 0.4]

	cdef double[7] V = [0.0] * 7
	cdef double[7] next_V = [0.0] * 7
	cdef int counter = 0
	cdef int len_s = len(s)
```

Solution two is found in the `cython_optimized_vector` folder, which uses the `vector` class from the C++ STL. The `vector` class is templated, and provides similar functionality of Python lists in C++. Independent of any speed differences between the two optimized versions, this is my personal preferred solution to 'the second problem' in the cython code, as it allows for code more similar to standard Python.

A few more changes are required for this version. Firstly, a header is added to the file, to tell Cython to compile in C++: 
```
# distutils: language=c++
```

Then the `.pxd` header file for `vector` needs to be imported with:
```
```
noting that `cimport` vs `import` is important. 

Then all of the cdef types need to be updated:
```
	cdef vector[int] s       = [   0,   0,   1,   1,   4,   4]
	cdef list acts           = ["a1","a1","a1","a1","a1","a1"]
	cdef vector[int] sp      = [   1,   4,   2,   3,   5,   6]
	cdef vector[double] r    = [ 1.0, 0.0, 0.0, 1.0, 2.0, 4.0]
	cdef vector[double] prob = [ 0.5, 0.5, 0.8, 0.2, 0.6, 0.4]

	cdef vector[double] V = ([0.0] * 7)
	cdef vector[double] next_V = [0.0] * 7
	cdef vector[double] zero_vect = [0.0] * 7
	cdef int counter = 0
```

Finally, a very subtle, but crucial point (on my machine the runtime reduces from 0.6s to 0.2s from this change), is that lines such as `foo = <some_python_list>` require Python interaction if `foo` is an instance of `vector`. So if the line `next_V = [0.0] * 7` inside the loop is not changed, the code will run much slower. I've kept this version in of the code in `cython_optimised_vector/vi_cython_slow.pyx`, which you can compile yourself to see (or just look at `vi_cython_slow.html` and see the Python interaction in the loop). To resolve this problem, notice a new variable was defined above `zero_vect`, which can be used in an assignment during the loop:
```
		next_V = zero_vect
```

Note to see the operations that `vector` allows, see the [C++ reference](http://www.cplusplus.com/reference/vector/vector/) and see the [Cython vector header file](https://github.com/cython/cython/blob/master/Cython/Includes/libcpp/vector.pxd) to see the Cython interface.

Finally, Reports can be produced for both optimised sets of code that show no python interaction in the main loop and the runtime is similar to the C++ implementation as a result.

### Cpp

The `cpp` folder contains the C++ implementation, and can be compiled using g++. 

## Final Words

Hopefully this 'sort of guide' helps, but it is far from comprehensive unfortunately, and there are lots of language features that I have skipped, such as using [cdef blocks](https://cython.readthedocs.io/en/latest/src/userguide/language_basics.html#grouping-multiple-c-declarations) to define lots of types in one go. 