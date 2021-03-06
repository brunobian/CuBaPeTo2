% parallelRunLMM  run R scripts of LMM through a bash script that
% paralelize it in N cores. This script run nCores time a Rscript under 
% nohup, opening nCores independent processes. Each session will load only
% nFiles / nCores CSV files generated by lm_exportErpCsv.m.
%
% fixEf = char with the fixed effect section for the lmer function
%         i.e. '(freq + pos + pred) * type'  
%
% ranEf = char with the random effect section for the lmer function
%         i.e. '(1|suj) + (1|word)'  
%
% nIter = number of permutation for the Cluster-Based Permutation Test
%
% modType = Model type. 
%           'lmm': run everythin in lmm
%           'lm' : run everythin in lmm
%           'ranef': run original data un lmm, permutations in lm (not
%           implemented yet)
%
% nCores  = Number of cores to parallelize
%
% lm_Conf = config struct from the toolbox

function parallelRunLMMOLD(fixEf, ranEf, nIter, modType, nCores, lm_Conf)
    

inPath   = lm_Conf.csvPath;             % Path of time CSV from 
                                        % lm_exportCsv.m
outPath  = lm_Conf.lmmOutPath;          % Path for LMM outputs
nohupOut = lm_Conf.nohupOutPath;        % Path for nohup outputs
cstPath  = lm_Conf.customFunsPath;      % Path with custom functions
nFiles   = lm_Conf.nTimes;              % Number of time files generated in 
                                        % lm_exportCsv.m
rPath    = lm_Conf.rFunctionsPath;      % Path with the R functions
                                        % defaulr toolbox/R_functions
perPath  = lm_Conf.permutationMatPath;  % Path where csv with permutation 
                                        % with the location of permutation
                                        % matrices
perVar   = lm_Conf.permutationVariable; % Random factor to permutate within
                                        % if permutation is across or model
                                        % is lm, perVar = 0


nRun = floor(nFiles/nCores);

tEnd = 0;
for iIter = 1:nCores
    fprintf('Start running in core %0.0f \n', iIter)
    tStart = tEnd + 1;
	tEnd   = tStart + nRun;
    
    % if mod(nFiles,nCores) ~= 0, set last core to last file
    if iIter == nCores; tEnd = nFiles; end
    
    % Convert numbers to str
    tStartStr = num2str(tStart);
    tEndStr   = num2str(tEnd);
    nIterStr  = num2str(nIter);
    iIterStr  = num2str(iIter);
        
    % Generate the str of commando to be run
    sep = ' ';
    q = '"';
    command = ['nohup Rscript completeRun.R' sep ...
                q tStartStr q sep ... args[1]
                q tEndStr   q sep ... args[2]
                q nIterStr  q sep ... args[3]
                q inPath    q sep ... args[4]
                q outPath   q sep ... args[5]
                q modType   q sep ... args[6]
                q rPath     q sep ... args[7]
                q fixEf     q sep ... args[8]
                q ranEf     q sep ... args[9]
                q perPath   q sep ... args[10]
                q perVar    q sep ... args[11]
                q cstPath   q sep ... args[12]
                '>' sep nohupOut modType '_' iIterStr sep '&'];     

    % Run the command trough bash
    system(['cd ' rPath  ' ; ' command]);
    
    %For the first core, I waitfor the generation of the permutation 
    % matrix. 30s should be enough. 
	if iIter == 1 
		pause(30) % Waits 30 seconds.
    end

end
end