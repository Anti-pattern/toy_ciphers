#!/usr/bin/env python3.5

import argparse
import os
import os.path

# Parse arguments
# argparse module more standard in python, does what we need
# Arguments are positional, expecting caesar.py <rotation> <string>
# Catches -h and --help, displays built-in usage function.
#TODO: add 'string only' option that disables file checking
#TODO: write comments to make pretty pretty

parser = argparse.ArgumentParser(description="This is a hello world testing script. Program?  Whatever.")

##mutually_exclusive = parser.add_mutually_exclusive_group()

parser.add_argument(
	"rotations", 
	type=int,
	help="Number of rotations to execute.",
	metavar='<Number of rotations>',
)

parser.add_argument(
	"plaintext",
	help="Plaintext to rotate.",
	metavar='<plaintext>'
)

args=parser.parse_args()

rot=args.rotations
instring=args.plaintext

rot=rot%26

outstring = ""

if os.path.isfile(instring) and os.access(instring, os.R_OK):
	with open(instring, 'r') as instring:
		instring=instring.read()
		

for code in instring.encode('utf8'):
	if code > 96 and code < 123:
		transformed=code-97
		transformed=(transformed+rot)%26
		transformed=transformed+97
		outstring+=chr(transformed)
	elif code > 64 and code < 91:
		transformed=code-65
		transformed=(transformed+rot)%26
		transformed=transformed+65
		outstring+=chr(transformed)
	else:
		outstring+=chr(code)

print(outstring)