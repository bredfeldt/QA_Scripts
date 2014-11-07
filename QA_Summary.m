% Attempt to summarize all the QA data from all spreadsheets in a directory
% into a single csv file

clear all;
close all;

dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\TX1\AllMonthly\'
%dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\Annual\'
%dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\TX3\';
%dir1 = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\TX4\';



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
%for i = 91

    
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
 
    [~, ~, T] = xlsread(fn,1);
    T(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),T)) = {''};    
    
    %[~,phDate] = xlsread(fn,5,'B320');    
    
    %Format for the monthly output check spreadsheet
    sizeT = size(T);
    phDateC = sub2ind(sizeT,2,2);
    phPhantC = sub2ind(sizeT,5,3);
    phDoneC = sub2ind(sizeT,2,6);
    phCheckC = sub2ind(sizeT,2,9);
    phElecC = sub2ind(sizeT,5,4);
    phChIDC = sub2ind(sizeT,5,9);
    %Determine if the format includes FFF entries
    fff = T{sub2ind(sizeT,15,3)};
    if isempty(fff)
        %non-fff format
        %photon cells
        mvOut6C = sub2ind(sizeT,41,6);
        mvOut6ErC = sub2ind(sizeT,42,6);
        adj6C = sub2ind(sizeT,43,2);
        adjOut6C = sub2ind(sizeT,43,6);
        adjOut6ErC = sub2ind(sizeT,44,6);
     
        mvOut16C = sub2ind(sizeT,32,6);
        mvOut16ErC = sub2ind(sizeT,33,6);
        adj16C = sub2ind(sizeT,34,2);
        adjOut16C = sub2ind(sizeT,34,6);
        adjOut16ErC = sub2ind(sizeT,35,6);        
    else
        %new fff format
        %photon cells
        mvOut6C = sub2ind(sizeT,42,6);
        mvOut6ErC = sub2ind(sizeT,43,6);
        adj6C = sub2ind(sizeT,44,2);
        adjOut6C = sub2ind(sizeT,44,6);
        adjOut6ErC = sub2ind(sizeT,45,6);
        
        mvOut16C = sub2ind(sizeT,33,6);
        mvOut16ErC = sub2ind(sizeT,34,6);
        adj16C = sub2ind(sizeT,35,2);
        adjOut16C = sub2ind(sizeT,35,6);
        adjOut16ErC = sub2ind(sizeT,36,6);        
    end
    
    %Get date
    phDate = T{phDateC};    
    if isempty(phDate)
        phDate = '';
    end
        
    %Get phantom
    phPhant = T{phPhantC};
    if isempty(phPhant)
        phPhant = '';
    end
    
    %Get electrometer
    phElec = T{phElecC};
    if isempty(phElec)
        phElec = '';
    end
    
    %Get chamber ID
    phChID = T{phChIDC};
    if isempty(phChID)
        phChID = '';
    end
    
    %Get done ID
    phDone = T{phDoneC};
    if isempty(phDone)
        phDone = '';
    end
    
    %Get checked ID
    phCheck = T{phCheckC};
    if isempty(phCheck)
        phCheck = '';
    end
    
    %Get output for each beam
    mvOut6 = T{mvOut6C};
    mvOut6Er = T{mvOut6ErC};

    %Get error for each beam
    mvOut16 = T{mvOut16C};
    mvOut16Er = T{mvOut16ErC};
    
    %Get if adjusted
    adj6 = T{adj6C};
    adj16 = T{adj16C};
    %if strcmpi(adj6,'yes');
    %    x = 2;
    %end
    adjOut6 = T{adjOut6C};
    adjOut6Er = T{adjOut6ErC};
    adjOut16 = T{adjOut16C};
    adjOut16Er = T{adjOut16ErC};    

    %Write data into csv output file
    fprintf(f6mv,'%s, %s, %s, %s, %s, %s, %04f, %04f, %s, %04f, %04f\r\n',phDate,phPhant,phElec,phChID,phDone,phCheck,mvOut6,mvOut6Er, adj6, adjOut6, adjOut6Er);
    fprintf(f16mv,'%s, %s, %s, %s, %s, %s, %04f, %04f, %s, %04f, %04f\r\n',phDate,phPhant,phElec,phChID,phDone,phCheck,mvOut16,mvOut16Er,adj16,adjOut16,adjOut16Er);




end

%Close files
fclose(f6mv);
fclose(f16mv);
fclose(f6mev);
fclose(f9mev);
fclose(f12mev);
fclose(f16mev);