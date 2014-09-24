% Attempt to summarize all the QA data from all spreadsheets in a directory
% into a single csv file

clear all;
close all;

%dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\TX1\AllMonthly\'
%dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\Annual\'
%dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\TX3\';
dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\TX4\';

%photon cells
phDateC = 'B2';
phPhantC = 'C5';
phDoneC = 'F2';
phCheckC = 'I2';
phElecC = 'D5';
phChIDC = 'I5';
mvOut6C = 'F41';
mvOut6ErC = 'F42';
mvOut16C = 'F32';
mvOut16ErC = 'F33';

f6mv = fopen([dir1 'f6mv.csv'],'w');
f16mv = fopen([dir1 'f16mv.csv'],'w');
f6mev = fopen([dir1 'f6mev.csv'],'w');
f9mev = fopen([dir1 'f9mev.csv'],'w');
f12mev = fopen([dir1 'f12mev.csv'],'w');
f16mev = fopen([dir1 'f16mev.csv'],'w');

%list out the directory here
list1 = dir(dir1);

%loop through all files
for i = 3:length(list1)

    
    fn = fullfile(dir1,list1(i).name);
    if exist(fn) == 7
        continue; %listing is a folder
    end
    if isempty(regexp(fn,'TG-51'))
        continue; %listing doesn't have TG-51 in the title
    end
    %Is current file a monthly QA file
    [status,sheets,xlFormat] = xlsfinfo(fn);
    if isempty(regexp(status,'Microsoft Excel Spreadsheet'))
        continue; %listing isn't an excel spreadsheet
    end
 
    disp(['Importing ' list1(i).name]);
 
    %[~,phDate] = xlsread(fn,5,'B320');    
    
    %Get date
    [~,phDate] = xlsread(fn,1,phDateC);    
    if isempty(phDate)
        phDate = {''};
    end
        
    %Get phantom
    [~,phPhant] = xlsread(fn,1,phPhantC);
    if isempty(phPhant)
        phPhant = {''};
    end
    
    %Get electrometer
    [~,phElec] = xlsread(fn,1,phElecC);
    if isempty(phElec)
        phElec = {''};
    end
    
    %Get chamber ID
    [~,phChID] = xlsread(fn,1,phChIDC);
    if isempty(phChID)
        phChID = {''};
    end
    
    %Get done ID
    [~,phDone] = xlsread(fn,1,phDoneC);
    if isempty(phDone)
        phDone = {''};
    end
    
    %Get checked ID
    [~,phCheck] = xlsread(fn,1,phCheckC);
    if isempty(phCheck)
        phCheck = {''};
    end
    
    %Get output for each beam
    mvOut6 = xlsread(fn,1,mvOut6C);
    mvOut6Er = xlsread(fn,1,mvOut6ErC);

    %Get error for each beam
    mvOut16 = xlsread(fn,1,mvOut16C);
    mvOut16Er = xlsread(fn,1,mvOut16ErC);

    %Write data into csv output file
    fprintf(f6mv,'%s,%s,%s,%s,%s,%s,%04f,%04f\r\n',phDate{1},phPhant{1},phElec{1},phChID{1},phDone{1},phCheck{1},mvOut6,mvOut6Er);
    fprintf(f16mv,'%s,%s,%s,%s,%s,%s,%04f,%04f\r\n',phDate{1},phPhant{1},phElec{1},phChID{1},phDone{1},phCheck{1},mvOut16,mvOut16Er);




end

%Close files
fclose(f6mv);
fclose(f16mv);
fclose(f6mev);
fclose(f9mev);
fclose(f12mev);
fclose(f16mev);