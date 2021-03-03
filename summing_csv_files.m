function [ output_args ] = summing_csv_files( input_args )
% Function to sum two output csv files (e.g. Element_condition.csv) from
% Coulomb 3.4
%   The two .csv files should have the same faults in both files.
%   The resulting .csv file will have summed all the values of stress
%   (sig_right, sig_reverse, normal, coul-right,coul-reverse, element-rake
%   etc). 
%   
%   This code also assumes that for the faults/elements that slip, the
%   stress is reduced to zero in the resulting .csv file.
%
%   Written by Zoe Mildon in 2016, please reference using GitHub repository

disp('Select the first .csv file')
[csv_file1,filepath1]=uigetfile('*.csv');
disp('Select the second .csv file')
[csv_file2,filepath2]=uigetfile('*.csv');

prompt='Name for the output summed csv file (without file extension): ';
output_file=input(prompt,'s');
output_filename='filename.csv'; %% EDIT THIS LINE TO CHANGE DESTINATION OF OUTPUT
output_filename=strrep(output_filename,'filename',output_file);

data1=readtable([filepath1,csv_file1],'Delimiter',',','HeaderLines',2,'ReadVariableNames',false);
fault_name1=table2array(data1(:,1));
xcenter1=table2array(data1(:,2));
ycenter1=table2array(data1(:,3));
zcenter1=table2array(data1(:,4));
length1=table2array(data1(:,5));
strike1=table2array(data1(:,6));
dip1=table2array(data1(:,7));
lat_slip1=table2array(data1(:,8));
dip_slip1=table2array(data1(:,9));
sig_right1=table2array(data1(:,10));
sig_reverse1=table2array(data1(:,11));
normal1=table2array(data1(:,12));
coul_right1=table2array(data1(:,13));
coul_reverse1=table2array(data1(:,14));
opt_rake1=table2array(data1(:,15));
opt_coul1=table2array(data1(:,16));
spec_rake1=table2array(data1(:,17));
spec_coul1=table2array(data1(:,18));
element_rake1=table2array(data1(:,19));
el_rake_coulomb1=table2array(data1(:,20));
element_id1=cellstr(table2array(data1(:,21)));

data2=readtable(csv_file2,'Delimiter',',','HeaderLines',2,'ReadVariableNames',false);
fault_name2=table2array(data2(:,1));
xcenter2=table2array(data2(:,2));
ycenter2=table2array(data2(:,3));
zcenter2=table2array(data2(:,4));
length2=table2array(data2(:,5));
strike2=table2array(data2(:,6));
dip2=table2array(data2(:,7));
lat_slip2=table2array(data2(:,8));
dip_slip2=table2array(data2(:,9));
sig_right2=table2array(data2(:,10));
sig_reverse2=table2array(data2(:,11));
normal2=table2array(data2(:,12));
coul_right2=table2array(data2(:,13));
coul_reverse2=table2array(data2(:,14));
opt_rake2=table2array(data2(:,15));
opt_coul2=table2array(data2(:,16));
spec_rake2=table2array(data2(:,17));
spec_coul2=table2array(data2(:,18));
element_rake2=table2array(data2(:,19));
el_rake_coulomb2=table2array(data2(:,20));
element_id2=cellstr(table2array(data2(:,21)));

% Writing the header of the csv file
%header={'"Fault"','"X-center"','"Y-center"','"Z-center"','"length"','"strike"','"dip"','"lat-slip"','"dip-slip"','"sig-right"','"sig-reverse"','"normal"','"coul-right"','"coul-reverse"','"opt-rake"','"opt-coul"','"spec-rake"','"spec-coul"','"element-rake"','"el-rake-coulomb"','"element_name"'};
%'#    ','(km) ','(km) ','(km) ','(km) ','(km) ','(deg)','(m)  ','(m)  ','(bar)','(bar)','(bar)','(bar)','(bar)','(deg)','(bar)','(deg)','(bar)','(deg)','(bar)','     '};
%dlmwrite(output_filename,header);
fid=fopen(output_filename,'wt');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\r','Fault','X-center','Y-center','Z-center','length','strike','dip','lat-slip','dip-slip','sig-right','sig-reverse','normal','coul-right','coul-reverse','opt-rake','opt-coul','spec-rake','spec-coul','element-rake','el-rake-coulomb','element-name');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\r','#','(km)','(km)','(km)','(km)','(deg)','(m)','(m)','(bar)','(bar)','(bar)','(bar)','(bar)','(bar)','(deg)','(bar)','(deg)','(bar)','(deg)','(bar)','  ');
for i=1:length(xcenter1)
    x=xcenter1(i);
    y=ycenter1(i);
    z=zcenter1(i);
    %a=find((xcenter2<=(x+0.05) & xcenter2>=x-(0.05)) & (ycenter2<=(y+0.05) & ycenter2>=(y-0.05)));
    a=find(xcenter2==x & ycenter2==y);
    if isempty(a)==1
        disp('Cannot find matching elements')
        element_id1{i}
    else
    end
    dip_slip=dip_slip1(i)+dip_slip2(a);
    opt_rake=opt_rake1(i)+opt_rake2(a);
    spec_rake=spec_rake1(i);
    element_rake=element_rake1(i);
    % setting stress to zero on faults which rupture 
    if dip_slip2(a)~=0
        el_rake_coulomb=0;
        sig_right=0;
        sig_reverse=0;
        normal=0;
        coul_right=0;
        coul_reverse=0;
        opt_coul=0;
        spec_coul=0;
    else
        el_rake_coulomb=el_rake_coulomb1(i)+el_rake_coulomb2(a);
        sig_right=sig_right1(i)+sig_right2(a);
        sig_reverse=sig_reverse1(i)+sig_reverse2(a);
        normal=normal1(i)+normal2(a);
        coul_right=coul_right1(i)+coul_right2(a);
        coul_reverse=coul_reverse1(i)+coul_reverse2(a);
        opt_coul=opt_coul1(i)+opt_coul2(a);
        spec_coul=spec_coul1(i)+spec_coul2(a);
    end
    element_id=element_id1{i};
    fprintf(fid,'%i,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%s\r',i,x,y,z,length1(i),strike1(i),dip1(i),lat_slip2(i),dip_slip,sig_right,sig_reverse,normal,coul_right,coul_reverse,opt_rake,opt_coul,spec_rake,spec_coul,element_rake,el_rake_coulomb,element_id);
end
fclose(fid);

%end

