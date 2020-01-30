import numpy as np
cimport numpy as np  
import math

# 0 -(a1,0.5,1.0)-> 1 -(a1,0.8,0.0)-> 2
#                       -(a1,0.2,1.0)-> 3
#   -(a1,0.5,0.0)-> 4 -(a1,0.6,2.0)-> 5
#                       -(a1,0.4,4.0)-> 6 

# edges are (action, prob, reward)

# all (s,a,s',r,Pr(s'|s,a)) tuples needed for value iteration in the given markov reward process above


cpdef run_cyth4():
    """A function to compile for cython"""
    cdef np.ndarray[np.int_t, ndim=1] s = np.array([   0,   0,   1,   1,   4,   4])
    # cdef list acts = ["a1","a1","a1","a1","a1","a1"]
    cdef np.ndarray[np.int_t, ndim=1] sp = np.array([   1,   4,   2,   3,   5,   6])
    cdef np.ndarray[np.float_t, ndim=1] r = np.array([ 1.0, 0.0, 0.0, 1.0, 2.0, 4.0])
    cdef np.ndarray[np.float_t, ndim=1] prob = np.array([ 0.5, 0.5, 0.8, 0.2, 0.6, 0.4])

    cdef int REPEAT = 4000000
    cdef double tol = 1e-6
    cdef np.ndarray[np.float_t, ndim=1] V = np.zeros(7)
    cdef np.ndarray[np.float_t, ndim=1] next_V = np.zeros(7)
    cdef np.float_t max_diff = np.inf
    cdef int counter = 0

    # while max_diff > tol:
    cdef int i
    cdef int s_indx
    for i in range(REPEAT):
        # compute next V
        next_V = np.zeros(7)
        for i in range(s.shape[0]):
            next_V[s[i]] += prob[i] * (r[i] + V[sp[i]])

        # termination condition
        max_diff = -np.inf
        for s_indx in range(V.shape[0]):
            diff = abs(V[s_indx]-next_V[s_indx])
            if diff > max_diff:
                max_diff = diff

        # update V, counter
        V = next_V
        counter += 1

    print("Ran {iter} iterations to get value: {v}".format(iter=counter,v=V[0]))
