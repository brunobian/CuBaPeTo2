import os

labos  = [7]
compus = [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]]

npcs     = sum(len(c) for c in compus)
totFiles = 104
filesPc  = totFiles / npcs

count = 0
for i,l in enumerate(labos):
	print 'En el labo ' + str(l)

	perPath	= '"~/Bruno_R/permutations/"'

	if i>1:
		Line = 'cp ' + perPath.replace('"','')  + 'perms_' + perVar.replace('"','') + nIter + ' /tmp/'
		os.system(Line)
		perPath = '"/tmp/"'

	for j,c in enumerate(compus[i]):
		print 'En la compu ' + str(c)

		ip      = '10.2.' + str(l) + "." + str(c)
		nIter	= '200'
		inPath	= '"~/Bruno_R/csv_103_posRel/"'
		outPath	= '"~/lmm_results/"'
		modType	= '"lmm"'
		rPath	= '"~/CuBaPeTo2/R_functions/"'
		fixEf	= '"\\"freq + palnum + MaxJump\\""'
		ranEf	= '"\\"(1|suj_id)\\""'
		perVar	= '"suj_id"'
		cstPath	= '"~/CuBaPeTo2/example/cstFuns/"'
		nCores	= '4'
		nFiles	= str(filesPc)
		nohupOut= '"\"~/Bruno_R/nohup/' + str(l) + "/" + str(c) + '_\""'
		start   = filesPc * count + 1
		end     = start + filesPc + 1 
		filesCP = [inPath + 't' + str(x) + '.csv' for x in range(start,end)]

		fullLineCp = ["ssh " + str(ip) + " -t cp " + x + ' /tmp/' for x in filesCP]

		tmp = [os.system(x) for x in fullLineCp]
		inPath	= '"/tmp/"'


		pars = [nIter,   inPath, outPath, modType, rPath,  fixEf,    ranEf, 
				perPath, perVar, cstPath, nCores,  nFiles, nohupOut, str(start)]

		parStr = " ".join(pars)
		fullLine = "ssh " + str(ip) + " -t sh ~/CuBaPeTo2/bash_functions/runParallelCores.sh " + parStr
                
		#print fullLine
		os.system(fullLine)
		
		# Move permutations to temp to make it faster
		if i == 0 and j == 0:
			Line = 'cp ' + perPath.replace('"','')  + 'perms_' + perVar.replace('"','') + nIter + ' /tmp/'
			os.system(Line)


		count = count + 1

