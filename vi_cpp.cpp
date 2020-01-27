#include <cmath> /* INFINITY, fabs */
#include <iostream>

// # 0 -(a1,0.5,1.0)-> 1 -(a1,0.8,0.0)-> 2
// # 				      -(a1,0.2,1.0)-> 3
// #   -(a1,0.5,0.0)-> 4 -(a1,0.6,2.0)-> 5
// # 				      -(a1,0.4,4.0)-> 6 

// # edges are (action, prob, reward)

// # all (s,a,s',r,Pr(s'|s,a)) tuples needed for value iteration in the given markov reward process above

int REPEAT = 4000000;
float TOL = 1e-6;

int sLength = 6;
int vLength = 7;

int main() {
	int s[6] 		= {   0,   0,   1,   1,   4,   4};
	int sp[6] 		= {   1,   4,   2,   3,   5,   6};
	double r[6] 	= { 1.0, 0.0, 0.0, 1.0, 2.0, 4.0};
	double prob[6] 	= { 0.5, 0.5, 0.8, 0.2, 0.6, 0.4};

	int counter = 0;
	double V[7] = {0.0};
	double maxDiff = INFINITY;

	// Run value iter
	for (int i = 0; i < REPEAT; i++) {
	// while (maxDiff > TOL) {
		// Compute next V
		double nextV[7] = {0.0};
		for (int j=0; j<sLength; j++) {
			nextV[s[j]] += prob[j] * (r[j] + V[sp[j]]);
		}

		// Termination condition
		maxDiff = -INFINITY;
		for (int sIndx=0; sIndx<vLength; sIndx++) {
			double diff = fabs(nextV[sIndx] - V[sIndx]);
			if (diff > maxDiff) {
				maxDiff = diff;
			}
		}

		// Copy nextV to V 
		for (int sIndx=0; sIndx<vLength; sIndx++) {
			V[sIndx] = nextV[sIndx]; // + double(counter); 
		}

		// Increment
		counter++;
	}

	// Print something
	std::cout << "Ran " << counter << " many iterations, to get value of: " << V[0] << std::endl;
}
