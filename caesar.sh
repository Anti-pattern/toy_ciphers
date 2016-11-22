#!/bin/bash


# usage: caesar <to rotate by> <string or file>
# note, no usage/proper variable handling/etc implemented yet.  Just a toy, and largely intended for other scripts to call.
# Pearce wrote it and it's his and his alone, you can't have it, it's mine until I say so. So there.
# Extremely legal addendum: unless I like you and you ask nicely.

#TODO add proper option handling
#TODO add help/usage
#TODO add -n or similar option for 'no newline'
#TODO licensing
#TODO decide on whether signed variables should be allowed, and if so, why do they cause unexpected behavior.
#TODO Decide on how to handle numbers.
#TODO Almost certain slowness caused by printf calls.  Append result to variable in less stupid way and then system call out



#Ideas for caesarsolve:
	#Attempt all 26 rotations and test for
		#dictionary words
		#frequency analysis
		#known-plaintext
#Ideas for vigenere
	#call caesar with different rotate_by values per character based on key string

# Ideas for vigeneresolve
	# try dictionary, freq analysis, known plaintext with various keys
	# specify key, list of keys, otherwise defaults to dictionary and prompt for brute force


rotate_by=$1
ciphertext=$2

# Test if ciphertext is a file or not.
# If it is, load into memory first.
if [[ -f $ciphertext ]]; then
	ciphertext="$(<$ciphertext)"
fi

# rotate_by must be between 0-25 inclusive, thus, mod it.
# Be extremely careful with large numbers here, have seen very unexpected behavior.
rotate_by=$((rotate_by%26))
# printf "rotate_by: $rotate_by\n"
# For every character in the string we're given:
	# The syntax ${#<variable>} returns number of characters in <variable>
	# The syntax ${<variable>:<position>:1} returns the <position> character of variable.
for (( i=0; i<${#ciphertext}; i++ )); do
	current_char=${ciphertext:$i:1}



	# If character is not a-z, or A-Z, print it untouched.
	# TODO Simple caesars with numbers is an unexpected problem. Maybe fix?
		# What does someone caesaring a number expect as output?
		# Maybe each character incremented by amount modulo 10?
	# TODO Very inefficient, rebuild smarter.
	# Syntax tr -dc <characters> deletes all characters not in <characters> and outputs remaining
	# We only have one character here, so typical unexpected behaviors of tr not relevant.
	current_char_nulltest=$(printf %c "$current_char" |tr -dc a-zA-Z)
	if [[ -z $current_char_nulltest ]]; then
#		printf "Nulltested: "
		printf %c "$current_char"
#		printf "\n"
		continue
	fi

	# Get the ASCII number of current_char
	# Printf demands that "'<variable>" syntax for reasons I don't understand and could not find documented.  Beware.
	current_char=$(printf %d "'$current_char")

	# current_char is now a number, so figure out how much to subtract from ascii table values.

	# CAPITAL LETTER
	if [[ "$current_char" -gt "64" && "$current_char" -lt "91" ]]; then
		ascii_offset=65
#		printf "Capital letter: "
	fi

	# lowercase letter
	if [[ "$current_char" -gt "96" && "$current_char" -lt "123" ]]; then
		ascii_offset=97
#		printf "lowercase letter: "
	fi

	# Subtract offset from number to get a 0-25 value.
	current_char=$((current_char - ascii_offset))

	# current_char is now a number, add rotate number to it.
	current_char=$((current_char + rotate_by))

	# current_char is now a number possibly over 25, we should modulo it.
	current_char=$((current_char % 26))

	# Now that we've added asciioffset, we should transform it back.
	current_char=$((current_char + ascii_offset))

	# Now to transform back from ascii number to character.
	current_char=$(printf "\x$(printf %x $current_char)")

	printf "$current_char"

done
printf "\n"
exit

#printf %d "'$1"
#printf "\n"
#exit