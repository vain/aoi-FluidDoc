# -*- coding: utf-8 -*-

import re
import os

env = Environment()


# Builder, der PDF's aus SVG's mittels Inkscape baut
pdfBuilder = Builder(action='inkscape --without-gui --export-pdf=${TARGET.base}.pdf $SOURCE',
						suffix='.pdf',
						src_suffix='.svg')
env.Append(BUILDERS={'Svg2pdf': pdfBuilder})

# Wrapper für den PDF-Builder, unsauber
# Unbedingt eine bessere Lösung suchen.
def PDFWithSVG(env, target, source):
	patterns = [
		r'\\includegraphics[^\{]*\{([a-zA-Z0-9_\-.,/]+)\}',
		r'\\fpic\{([a-zA-Z0-9_\-.,/]+)\}'
		]
	
	for pat in patterns:
		include_re = re.compile(pat, re.I | re.M)
		f = open(source[0], 'r')
		includes = include_re.findall(f.read())
		includes = [element[:-3] + "svg" for element in includes]
		includes = [element for element in includes if os.path.isfile(element)]
		print includes
		for i in includes:
			env.Svg2pdf(source = i)
	
	env.PDF(target = target, source = source)
	
	return None

env.Append(BUILDERS={'PDFWithSVG': PDFWithSVG})

env.PDFWithSVG(source = 'FluidTut66.tex', target = 'FluidTut66.pdf')
