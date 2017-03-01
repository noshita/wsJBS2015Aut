# @String(label="Output Directory") OutputDir
# @String(label="Output File(s) Name") FileName
# @Integer(label="Background Color (0 or 1)",value=1) BGC

import os, sys, csv

from ij import IJ, ImagePlus, WindowManager
from ij.blob import ManyBlobs

def detectAllBlobs(imp):
	allblobs = ManyBlobs(imp)
	allblobs.setBackground(BGC)
	allblobs.findConnectedComponents()
	return allblobs

def chainCodeToCoords(chainCode, scale = 1):
	try:
		maxVal = max(chainCode)
		minVal = min(chainCode)
	except TypeError:
		print("A chain code must only contain INTEGERS in 0-7.")
		raise
	else:
		if (minVal < 0) or  (maxVal >7):
			print("A chain code must only contain integers in '0-7'.")
			sys.exit()
	m = ((1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0),(-1, -1), (0, -1), (1, -1))
	coords = []
	pos = (0,0)
	for pxl in ((m[i]) for i in chainCode):
		x = pos[0]+pxl[0]
		y = pos[1]+pxl[1]
		pos = (x,y) 
		coords.append(pos)
	return coords

def outputBlobs(blobs):
	for i in range(len(blobs)):
		chain = blobs.get(i).getOuterContourAsChainCode()
		chain = [direction for direction in chain]
		coords = chainCodeToCoords(chain)

		filePath = os.path.normpath(os.path.join(os.path.normpath(OutputDir),FileName+"_%(no)02d.csv")) % {"no":i}
		f= open(filePath,"wb")
		writer = csv.writer(f)
		writer.writerows(coords)
		f.close()

def run():
	imp = IJ.getImage()
	print(imp)
	allblobs = detectAllBlobs(imp)

	outputBlobs(allblobs)
	
run()
