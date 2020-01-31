# distutils: language=c++

from libcpp.vector cimport vector
import numpy as np 
import math

# 0 -(a1,0.5,1.0)-> 1 -(a1,0.8,0.0)-> 2
# 				      -(a1,0.2,1.0)-> 3
#   -(a1,0.5,0.0)-> 4 -(a1,0.6,2.0)-> 5
# 				      -(a1,0.4,4.0)-> 6 

# edges are (action, prob, reward)

# all (s,a,s',r,Pr(s'|s,a)) tuples needed for value iteration in the given markov reward process above

cdef int iterations = 4000000

def run_cyth():
	cdef vector[int] s       = [   0,   0,   1,   1,   4,   4]
	cdef list acts           = ["a1","a1","a1","a1","a1","a1"]
	cdef vector[int] sp      = [   1,   4,   2,   3,   5,   6]
	cdef vector[double] r    = [ 1.0, 0.0, 0.0, 1.0, 2.0, 4.0]
	cdef vector[double] prob = [ 0.5, 0.5, 0.8, 0.2, 0.6, 0.4]

	cdef vector[double] V = ([0.0] * 7)
	cdef vector[double] next_V = [0.0] * 7
	cdef vector[double] zero_vect = [0.0] * 7
	cdef int counter = 0

	for _ in range(iterations):
		# compute next V
		next_V = zero_vect
		for i in range(s.size()):
			next_V[s[i]] += prob[i] * (r[i] + V[sp[i]])

		# update V, counter. 
		V = next_V
		counter += 1

	print("Ran {iter} iterations to get value: {v}".format(iter=counter,v=V[0]))