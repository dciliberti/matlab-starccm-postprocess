% mysimfile_alpha0.0.sim  -->  prefix = mysimfile_alpha

close all; clearvars; clc

% Ask user which file consider
[fileName, filePath] = uigetfile('.sim',...
    'Select any sim file of interest so that MATLAB can guess the ''prefix''');

% Predict predix in filename. Assume last 4 chars are file extension (.sim)
% Expect last chars to be a floating point number
simName = fileName(1:end-4);
numChars = length(simName);
position = numChars;
indication = str2double(simName(position));
% cycle backward through file name
while ~isnan(indication) || strcmp(simName(position),'.')
    position = position - 1;
    indication = str2double(simName(position));
end
prefix = simName(1:position);

% Ask user if prefix is correct
answer = questdlg({ ['File name:     ', simName],...
    ['Prefix:     ', prefix],...
    'Is that correct?'},'Check name','Yes','No','Yes');

% If not, make the user write the correct prefix
if strcmp(answer,'No')
    prefix = inputdlg('Write the sim name without variable (prefix)',...
        'Write prefix',[1,60]);
    position = length(prefix);
end

% Ask user to write the independent variable name
indVar = inputdlg('Write the independent variable name (no spaces, no latex symbols)',...
        'X-axis label',[1,40],{'variable'});

% Get the desired sim files
listing = dir([prefix,'*.sim']);
[indx,~] = listdlg('ListString',{listing.name},...
    'PromptString','Select sim files');

% Check variable digit of precision
var = simName(position+1:end);
k = strfind(var,'.');
if isempty(k) % integer as floating point
    formatString = ['%',num2str(length(var)+1),'.0f']; % add a digit for safety
else
    formatString = ['%',num2str(length(var(1:k-1))+1),'.',num2str(length(var(k+1:end))),'f'];
end

% Get variable array
array = zeros(length(indx),1);
c = 0;
for i = indx
    c = c + 1;
    array(c) = str2double(listing(i).name(position+1:end-4));
end
array = sort(array);

%% chiamata STAR-CCM+
pod = '2jHU+QkwqexqrAOdVZ6ZzQ';
disp('Report generation...')
for i = 1:length(array)
    fileName = [prefix,num2str(array(i),formatString)];
    % Maybe add filePath with fileName...
    star = ['starccm+.exe ', fileName, '.sim -batch "Report_to_csv.java" -power -podkey ', pod, ' -licpath 1999@flex.cd-adapco.com'];
    dos(star);
end

%% Visualizzazione risultati

% Get variables name and number
csvName = [prefix,num2str(array(1),formatString),'_report.csv'];
aero = readtable(csvName,'ReadRowNames',true);

% Ask user which variable plot
[indx,~] = listdlg('ListString',aero.Row,...
    'PromptString','Select variables to plot');

varNumber = length(indx);
varName = aero.Row;
var = zeros(length(array),varNumber);

for i = 1:length(array)
    fileName = [prefix,num2str(array(i),formatString),'_report.csv'];
    aero = readtable(fileName,'ReadRowNames',true);
    
    for j = 1:varNumber
        var(i,j) = aero{indx(j),1};
    end

end

% Create output table
tsize = [size(var,1),size(var,2)+1];
out = table('Size',tsize,...
    'VariableTypes',repmat({'double'},tsize(2),1),...
    'VariableNames',[indVar; aero.Row(indx)]);

% Fill and display output table
out{:,1} = array;
for i = 1:size(var,2)
    out{:,i+1} = var(:,i);
end
disp(out)

% Plot data
for i = 1:size(var,2)
    figure
    plot(array,var(:,i),'o-','LineWidth',2)
    grid on
    xlabel(indVar,'Interpreter','none')
    ylabel(aero.Row{indx(i)},'Interpreter','none')
end

% pause
%% Funzionalità addizionali
% disp('Blade load calculation...')
% for i = 1:length(J)
%     filename = [prefix,num2str(J(i),'%2.1f')];
%     star = ['starccm+.exe ', filename, '.sim -batch "PropLoadBatch.java" -power -podkey ', pod, ' -licpath 1999@flex.cd-adapco.com'];
%     dos(star);
% end

disp('END')