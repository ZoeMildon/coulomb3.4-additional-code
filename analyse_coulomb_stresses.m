function [ output_args] = analyse_coulomb_stresses (input_args)
% Calculates the following values from a Coulomb output .csv file:
%   - average Coulomb stress for a whole fault plane (when the source/receiver faults are comprised of multiple elements) 
%   - the percentage of the individual fault planes that are positively stressed
%   - the maximum and minimum stress on each individual fault plane
% 

% Outputs a .txt file with a list of the fault names, the average stress
% and the percentage of each fault plane that is positively stressed.

disp('Select the .csv file')

    [csv_filename,filepath]=uigetfile('*.csv');

    output_data_file='filepathcsv_filename.txt';
    output_data_file=strrep(output_data_file,'filepath',filepath);
    output_data_file=strrep(output_data_file,'csv_filename',csv_filename);
    % Reading in the csv file
    data=readtable(csv_filename,'Delimiter',',','HeaderLines',2,'ReadVariableNames',false);
    xcenter=table2array(data(:,2));
    ycenter=table2array(data(:,3));
    zcenter=table2array(data(:,4));
    strike=table2array(data(:,6));
    coulomb_stress=table2array(data(:,20));
    element_id=string(table2array(data(:,21)));

    fid=fopen(output_data_file,'wt');
    
    fprintf(fid,'%s \t %s \t %s \t %s \t %s\n','Fault name','Average CST (bars)','Max CST (bars)','Min CST (bars)','% positive');

    fault_names=unique(element_id);
    A=fault_names==""; 
    fault_names=fault_names(~A);
    for i=1:length(fault_names)
        fault_name=fault_names{i};
        n=find(strcmp(element_id,{fault_name}));
        mean_coulomb=mean(coulomb_stress(n));
        perc_positive=(length(find(coulomb_stress(n)>0))/length(n))*100;
        max_stress=max(coulomb_stress(n));
        min_stress=min(coulomb_stress(n));
        fprintf(fid,'%s \t %f \t %f \t %f \t %2.1f\n',fault_name,mean_coulomb,max_stress,min_stress,perc_positive);
    end
    
    fclose(fid);
    
    fprintf('Data written to %s.txt\n',csv_filename)
end
