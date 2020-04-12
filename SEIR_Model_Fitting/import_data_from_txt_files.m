function [largeUni, smallUni, HighSchool] = import_data_from_txt_files()
% Import data from from text files: 

contents = fileread('LargeUni.txt');
contents = strsplit(contents, 'game');
largeUni = ...
    cellfun(@(c) sscanf(c, '%f', [3 Inf])', contents(2:end), 'UniformOutput', false);

contents = fileread('SmallUni.txt');
contents = strsplit(contents, 'game');
smallUni = ...
    cellfun(@(c) sscanf(c, '%f', [3 Inf])', contents(2:end), 'UniformOutput', false);

contents = fileread('HighSchool.txt');
contents = strsplit(contents, 'game');
HighSchool = ...
    cellfun(@(c) sscanf(c, '%f', [3 Inf])', contents(2:end), 'UniformOutput', false);

end