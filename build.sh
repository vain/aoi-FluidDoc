#!/bin/bash

# As SCons and make didn't work as I'd wanted them to, I had
# to write a build-script. Well.


# What's our file?
BASE=FluidTut66

# Image patterns
PATS=('\\fpic{\([^}]*pdf\)}' '\\includegraphics[^{]*{\([^}]*pdf\)}')


# Clean?
if [[ "$1" == "-c" ]]
then
	CLEAN=true
	shift

	echo "Cleaning TeX stuff."
	rm -v "$BASE".aux "$BASE".log "$BASE".out "$BASE".pdf "$BASE".toc
fi

# Build PDFs from SVGs -- iterate over all defined patterns
NUM=${#PATS[@]}
for i in $(seq 0 $(($NUM - 1)))
do
	# This queer loop is needed in order to read the results
	# from grep/sed LINE BY LINE.
	while read -r m
	do
		PDFFILE="$m"
		SVGFILE="$(echo "$m" | sed 's/pdf$/svg/i')"

		# Clean?
		if [[ ! -z $CLEAN ]]
		then
			echo "Cleaning produced PDF"
			rm -v "$PDFFILE"
		else
			echo "Converting via inkscape:"
			echo "$PDFFILE"
			echo "$SVGFILE"
			echo ""
			inkscape --without-gui --export-pdf="$PDFFILE" "$SVGFILE"
			echo ""
		fi

	done < <(grep -i "${PATS[$i]}" "$BASE".tex | sed "s#.*${PATS[$i]}.*#\1#i")
done

# LaTeX compile
if [[ -z $CLEAN ]]
then
	pdflatex "$BASE".tex || exit 1
	pdflatex "$BASE".tex || exit 1
fi

# View if desired
if [[ "$1" == "view" ]]
then
	xpdf "$BASE".pdf
fi
