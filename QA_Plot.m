%QA plot

%Plot stats on QA data

clear all;
%close all;

fname = 'D:\jbredfel\Box Sync\UM Medical Physics\Monthly QA\DataMining\TX1\AllMonthly\f6mv.csv';

%% time
fid = fopen(fname,'r');
tline = fgetl(fid);
i = 1;
j = 1;

while ischar(tline)
    A = strsplit(tline,',');
    if length(A) == 11 && ~isempty(str2num(A{8})) && ~isempty(A{1})
        outd(i) = datenum(A{1});
        outp(i) = str2num(A{8});
        i = i + 1;
        if strcmpi(A(10),'yes') || ~isempty(A(11))
            if ~strcmp(A(11),' ')
                outd2(j) = datenum(A{1});
                outp2(j) = str2num(A{8});
                j = j + 1;          
            end
        end
            
    end
    tline = fgetl(fid);   
end
figure(10);
plot(outd,outp,'*');
hold all;
plot(outd2,outp2,'or');
hold off;
datetick('x');
ylabel('Output % Error');
ylim([-2 2]);
fclose(fid);

%% phantom
fid = fopen(fname,'r');
tline = fgetl(fid);
i = 1;
j = 1;
k = 1;
while ischar(tline)
    A = strsplit(tline,',');
    if length(A) == 11 && ~isempty(str2num(A{8}))
    if strcmp(A(2),' SW')
        swE(i) = str2num(A{8});
        wE(i) = nan;
        i = i + 1;
        j = j + 1;
    else
        wE(i) = str2num(A{8});
        swE(i) = nan;
        i = i + 1;
        k = k + 1;
    end
    else
        x = 1;
    end
    tline = fgetl(fid);   
end
figure(1);
boxplot([wE' swE']);
ylabel('Output % Error');
ylim([-2 2]);
fclose(fid);

%% chamber
fid = fopen(fname,'r');
tline = fgetl(fid);
i = 1;
j = 1;
k = 1;
while ischar(tline)
    A = strsplit(tline,',');
    if length(A) == 11 && ~isempty(str2num(A{8}))
    if strcmp(A(4),' 1383')
        ch1(i) = str2num(A{8});
        ch2(i) = nan;
        i = i + 1;
        j = j + 1;
    elseif strcmp(A(4),' 501')
        ch2(i) = str2num(A{8});
        ch1(i) = nan;
        i = i + 1;
        k = k + 1;
    end
    else
        x = 1;
    end
    tline = fgetl(fid);   
end
figure(2);
boxplot([ch1' ch2']);
ylabel('Output % Error');
ylim([-2 2]);
fclose(fid);

%% Physicist
fid = fopen(fname,'r');
tline = fgetl(fid);
i = 1;
j = 1;
k = 1;
m = 1;
while ischar(tline)
    A = strsplit(tline,',');
    if length(A) == 11 && ~isempty(str2num(A{8}))
    if strcmpi(A(5),' BG')
        bg(i) = str2num(A{8});
        ky(i) = nan;
        tz(i) = nan;
        i = i + 1;
        j = j + 1;
    elseif strcmpi(A(5),' KY')
        ky(i) = str2num(A{8});
        bg(i) = nan;
        tz(i) = nan;       
        i = i + 1;
        k = k + 1;
    elseif strcmpi(A(5),' TZ');
        tz(i) = str2num(A{8});
        bg(i) = nan;
        ky(i) = nan;
        i = i + 1;
        m = m + 1;
    end
    else
        x = 1;
    end
    tline = fgetl(fid);   
end
figure(3);
boxplot([bg' ky' tz']);
ylabel('Output % Error');
ylim([-2 2]);
fclose(fid);
