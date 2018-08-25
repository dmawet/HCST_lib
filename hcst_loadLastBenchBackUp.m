function bench = hcst_loadLastBenchBackUp()
%hcst_loadLastBenchBackUp(date)

    tmp = hcst_config();% Get bench back up directory 

    path = tmp.info.benchBackUpDir;
    
    % Find the newest bench struct 
    d = dir([path,'*mat']);
    dnums = [];
    for index = 1:length(d)
        dnums = [dnums,datenum(d(index).date)];
    end
    [~,index] = max(dnums);
    flnm = [path,d(index).name];
    
    % Prompt user
    disp('Last bench backup file is:');
    disp(flnm);
    prompt = 'Do you want to load it? Y/N [Y]: ';
    str = input(prompt,'s');
    if isempty(str)
        str = 'Y';
    end
    
    % Load the file, return bench 
    if(or(strcmp(str,'Y'),strcmp(str,'y')))
        load(flnm,'savedbenchstruct');
    end
    
    bench = savedbenchstruct;
    
end

