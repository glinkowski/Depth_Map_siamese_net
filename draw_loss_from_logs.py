# ---------------------------------------------------------
# author: Greg Linkowski
# project: Depth Maps from Siamese Nets
# class: ECE 547
# 
# For every file in the logs/ directory, extract the
#	iteration and loss, then plot.
# ---------------------------------------------------------

import matplotlib.pyplot as plt
import os



######## ######## ######## ######## 
# PARAMETERS

# Expected location of log files
logDir = 'logs/'


######## ######## ######## ######## 




######## ######## ######## ######## 
# ANCILLARY FUNCTION(S)

def parseLogFile(fname) :

	# Expected iterations between testing
	tstGap = 300
	trnGap = 50

	# The items to return:
	#	train & test iterations, train & test loss
	#	(and upsampled loss if exists)
	trnIter = list([0])
	trnLoss = list()
	trnUpLoss = list()
	tstIter = list([0])
	tstLoss = list()
	tstUpLoss = list()

	with open(fname, 'r') as fin :
		for line in fin :

			# skip short lines
			if len(line) < 76 :
				continue
			else :
				lv = line.split()

				if len(lv) > 10 :
					# Append the iteration, loss, and optional upsampled_loss
					if lv[4] == 'Train' :
						if lv[8] == 'loss' :
							trnLoss.append( float(lv[10]) )
						elif lv[8] == 'upsampled_loss' :
							trnUpLoss.append( float(lv[10]) )
					elif lv[4] == 'Test' :
						if lv[8] == 'loss' :
							tstLoss.append( float(lv[10]) )
						elif lv[8] == 'upsampled_loss' :
							tstUpLoss.append( float(lv[10]) )
					elif lv[4] == 'Iteration' :
						if float(lv[5]) != trnIter[-1] :
							trnIter.append( float(lv[5]) )
				#end if
	#end with

	if (len(trnIter) > 1) and (len(tstLoss) > 1) :
		finIter = int(trnIter[-1])
		tstIter = list(range( 0, finIter + 1, finIter/(len(tstLoss) - 1) ))
	#end if

	# Catch for badly formatted log file (ie: premature exit / error)
	if len(trnLoss) == 0 :
		trnIter = list()
	if len(tstLoss) == 0 :
		tstIter = list()

	return trnIter, trnLoss, trnUpLoss, tstIter, tstLoss, tstUpLoss
#end def ######## ######## ######## 


def saveStatsTextFile(fname, trnIter, trnLoss, trnUpLoss, tstIter, tstLoss, tstUpLoss) :

	# Extract the name for this net/log
	fnSplit = fname.split('/')
	thisName = fnSplit[len(fnSplit)-1]
	thisName = thisName[0:-4]

	# Set flag to include Upsampled Loss
	hasUp = False
	if len(trnUpLoss) > 0 :
		hasUp = True

	# Write to the stats .txt
	with open(fname, 'w') as fout :
		fout.write('NET\t{}'.format(thisName))
		fout.write('\nWITH_UPS\t{}'.format(hasUp))
		fout.write('\nTRN_ITER')
		for i in range(len(trnIter)) :
			fout.write('\t{}'.format(trnIter[i]))
		fout.write('\nTRN_LOSS')
		for i in range(len(trnLoss)) :
			fout.write('\t{}'.format(trnLoss[i]))
		fout.write('\nTST_ITER')
		for i in range(len(tstIter)) :
			fout.write('\t{}'.format(tstIter[i]))
		fout.write('\nTST_LOSS')
		for i in range(len(tstLoss)) :
			fout.write('\t{}'.format(tstLoss[i]))

		# write the upsampled loss if it was captured
		if hasUp :
			fout.write('\nTRN_ITER')
			for i in range(len(trnIter)) :
				fout.write('\t{}'.format(trnIter[i]))
			fout.write('\nTRN_LOSS_UPS')
			for i in range(len(trnUpLoss)) :
				fout.write('\t{}'.format(trnUpLoss[i]))
			fout.write('\nTST_ITER')
			for i in range(len(tstIter)) :
				fout.write('\t{}'.format(tstIter[i]))
			fout.write('\nTST_LOSS_UPS')
			for i in range(len(tstUpLoss)) :
				fout.write('\t{}'.format(tstUpLoss[i]))
		#end if
	#end with

	return
#end def ######## ######## ######## 


def drawLossPlots(fPrefix, trnIter, trnLoss, tstIter, tstLoss) :

	# Name the type of network used
	netType = 'Siamese'
	if 'fuse' in fPrefix :
		netType = 'Multi-Fuse'
	elif 'single' in fPrefix :
		netType = 'Single-Image'
	#end if

#	print(netType)

	# Draw the plot with both train & test
	pName = fPrefix + '_both.png'

	fig = plt.figure()

	plt.plot(trnIter, trnLoss, tstIter, tstLoss)
	plt.xlabel('Euclidian Loss')
	plt.ylabel('Iterations')

	plt.title('Train/Test Loss for {}'.format(netType))
	plt.savefig(pName)
	plt.close()

	# Draw the plot with both train & test
	pName = fPrefix + '_onlyTrain.png'

	fig = plt.figure()

	plt.plot(trnIter, trnLoss)
	plt.xlabel('Euclidian Loss')
	plt.ylabel('Iterations')

	plt.title('Train Loss for {}'.format(netType))
	plt.savefig(pName)
	plt.close()

	# Draw the plot with both train & test
	pName = fPrefix + '_onlyTest.png'

	fig = plt.figure()

	plt.plot(tstIter, tstLoss)
	plt.xlabel('Euclidian Loss')
	plt.ylabel('Iterations')

	plt.title('Test Loss for {}'.format(netType))
	plt.savefig(pName)
	plt.close()

	return
#end def ######## ######## ######## 




######## ######## ######## ######## 
# PRIMARY FUNCTION(S)

def extractFromLogFiles(path) :

	# The items to return:
	#	names of log files, train iters & loss, test iters & loss


	# Get the name of every file in dir, keep only .log
	fileSet = set(os.listdir(path))
	logFileList = [lf for lf in fileSet if lf.endswith('.log')]

	for lf in logFileList :

		netName = lf[0:-4]

		# Call func to read the file
		lfName = path + lf
		trnIter, trnLoss, trnUpLoss, tstIter, tstLoss, tstUpLoss = parseLogFile(lfName)

		# Call func to write loss stats to text file
		sName = path + 'stats/' + netName + '.txt'
		saveStatsTextFile(sName, trnIter, trnLoss, trnUpLoss, tstIter, tstLoss, tstUpLoss)

		# Call func to draw loss plots
		imgPrefix = path + 'plots/' + netName
		drawLossPlots( imgPrefix, trnIter, trnLoss, tstIter, tstLoss)

		# Call to draw upsampled loss if it was captured
		if len(trnUpLoss) > 0 :
			imgPrefix = imgPrefix + '_up'
			drawLossPlots( imgPrefix, trnIter, trnUpLoss, tstIter, tstUpLoss)
		#end if
	#end for

	return
#end def ######## ######## ######## 



######## ######## ######## ######## 
# FUNCTION CALL

extractFromLogFiles(logDir)