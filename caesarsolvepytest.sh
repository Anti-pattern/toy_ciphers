#!/bin/bash

# This is the 'python support' version done to test whether using the python
# version of caesar made a difference.  It makes an enormous fucking difference.
# Code fairly boring still, but might be optimized or rewritten in python to be fun.


# usage: caesarsolve <known_plaintext> <ciphertext>
# returns caesar rotation of solution
# works
# currently extremely slow, dictionary and freq analysis not feasible until optimized
# Slowness likely fault of caesar being fairly slow.

known_plaintext=$1
ciphertext_original=$2
ciphertext_test=$ciphertext_original

# Test for file and handle
if [[ -f $ciphertext ]]; then
	ciphertext="$(<$ciphertext)"
#	printf "$ciphertext\n"
fi

# Try 26 rotations, speak English or go home!
for (( i=0; i < 26; i++ )); do

#	# Rotate ciphertext by count iteration.
	ciphertext_test=$(./caesar.py $i "$ciphertext_original")

	# Store a count of the number of times known_plaintext occurs in ciphertext.
	found_plain=$(grep -c $known_plaintext <<< "$ciphertext_test")
	# If that count is more than 0, success!
	if [[ found_plain -gt 0 ]]; then
		printf "$i\n"
		break
	fi
done
exit