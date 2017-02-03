function wos2bibtext(file_in)
%    This function is a tool to convert Web of Science exported lists of
%    bibliographic items to bibtext format. 
%
%    Go to https://github.com/juangpc/wos2bibtex for more info.
%
%    Copyright (C) 2017  Juan Garcia-Prieto
%   
%    This file is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FastFC is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FastFC.  If not, see <http://www.gnu.org/licenses/>.
%
%    ------------------------------------------ 
%    Contact: Juan Garcia-Prieto    juangpc (at) gmail.com
%    ------------------------------------------
%
%% read tab delimited file

% extract path, filename and extension from input
[path_str,file_name,file_ext] = fileparts(file_in);

%output user 
fprintf('\n');
fprintf(' Starting wos2bibtext ...\n');
fprintf([' Opening ' file_name file_ext ' ...\n']);
fid_in=fopen(file_in);

%creating structure to hold all items in the file.
bib_registers={};
num_registers=-1; %first line is only acronyms

%if file created properly following instructions (in repo readme file) it 
%should have one item per line. (first line is for field names definition).
%open file and parse each line (item) into the structure bib_registers.
while(~feof(fid_in))
    [new_reg]=parse_wos_register(fid_in);
    bib_registers=cat(1,bib_registers,new_reg);
    num_registers=num_registers+1;
end

fclose(fid_in);

fid_out=fopen([path_str '\' file_name '.bib'],'wt');
fprintf(['\n File ' file_name '.bib created ...\n']);

fprintf(fid_out,'\n@COMMENT { ');
fprintf(fid_out,'\n\tThis file was created with wos2bibtext.');
fprintf(fid_out,'\n\tPlease checkout github https://github.com/juangpc/wos2bibtex for updates.');
fprintf(fid_out,'\n\tDo not work too much.');
fprintf(fid_out,'\n}');

for reg_n=2:num_registers %first line is only for field names.
	if strcmp(bib_registers{reg_n,1},'J') %J stands for journal article
        fprintf(fid_out,'\n\n@article{');
        name_no_space=bib_registers{reg_n,2}(double(bib_registers{reg_n,2})~=double(' '));
        fprintf(fid_out,[name_no_space(1:3) bib_registers{reg_n,33} ',']);
        fprintf(fid_out,['\n author = {' bib_registers{reg_n,2} '},']);
        fprintf(fid_out,['\n title = {' bib_registers{reg_n,10} '},']);
        fprintf(fid_out,['\n journal = {' bib_registers{reg_n,18} '},']);
        fprintf(fid_out,['\n volume = {' bib_registers{reg_n,22} '},']);
        fprintf(fid_out,['\n issue = {' bib_registers{reg_n,23} '},']);
        fprintf(fid_out,['\n pages = {' bib_registers{reg_n,26} '--' bib_registers{reg_n,27} '},']);
        fprintf(fid_out,['\n doi = {' bib_registers{reg_n,29} '},']);
        fprintf(fid_out,['\n abstract = {' bib_registers{reg_n,34} '},']);
        fprintf(fid_out,['\n issn = {' bib_registers{reg_n,50} '},']);
        fprintf(fid_out,['\n year = {' bib_registers{reg_n,33} '},']);
        fprintf(fid_out,'\n}');
    elseif strcmp(bib_registers{reg_n,1},'B') % B stands for book
        fprintf(fid_out,'\n\n@book{');
        name_no_space=bib_registers{reg_n,2}(double(bib_registers{reg_n,2})~=double(' '));
        fprintf(fid_out,[name_no_space(1:3) bib_registers{reg_n,33} ',']);
        fprintf(fid_out,['\n author = {' bib_registers{reg_n,2} '},']);
        fprintf(fid_out,['\n title = {' bib_registers{reg_n,10} '},']);
        fprintf(fid_out,['\n journal = {' bib_registers{reg_n,18} '},']);
        fprintf(fid_out,['\n volume = {' bib_registers{reg_n,22} '},']);
        fprintf(fid_out,['\n issue = {' bib_registers{reg_n,23} '},']);
        fprintf(fid_out,['\n pages = {' bib_registers{reg_n,26} '--' bib_registers{reg_n,27} '},']);
        fprintf(fid_out,['\n doi = {' bib_registers{reg_n,29} '},']);
        fprintf(fid_out,['\n abstract = {' bib_registers{reg_n,34} '},']);
        fprintf(fid_out,['\n issn = {' bib_registers{reg_n,50} '},']);
        fprintf(fid_out,['\n year = {' bib_registers{reg_n,33} '},']);
        fprintf(fid_out,'\n}');
    end        
end
fclose(fid_out);

fprintf('\n');
fprintf(' File correctly created ...\n');
fprintf('\n');
fprintf(' Exiting now. Everything worked fine.\n');

end

%% some other functions
function [new_register]=parse_wos_register(fid_in)

new_field=[];
new_register={};

new_c=fread(fid_in,1); %typically new line feed

while ~feof(fid_in) && new_c ~= 13 %end of line
    if new_c == 09 %horizontal tab
        if(isempty(new_field))
            new_field=0;
        end
        new_register=cat(2,new_register,char(new_field));
        new_field=[];
    elseif (new_c > 31 && new_c<127) %|| new_c==0
        new_field=cat(2,new_field,new_c);                
    end
    new_c=fread(fid_in,1);
end

end



%% web of science acronyms

% FN	File Name
% VR	Version Number
% PT	Publication Type (conference, book, journal, book in series, or patent)
% AU	Authors
% AF	Author Full Name
% CA	Group Authors
% TI	Document Title
% ED	Editors
% SO	Publication Name
% SE	Book Series Title
% BS	Book Series Subtitle
% LA	Language
% DT	Document Type
% CT	Conference Title
% CY	Conference Date
% HO	Conference Host
% CL	Conference Location
% SP	Conference Sponsors
% DE	Author Keywords
% ID	Keywords Plus®
% AB	Abstract
% C1	Author Address
% RP	Reprint Address
% EM	E-mail Address
% FU	Funding Agency and Grant Number
% FX	Funding Text
% CR	Cited References
% NR	Cited Reference Count
% TC	Times Cited
% PU	Publisher
% PI	Publisher City
% PA	Publisher Address
% SC	Subject Category
% SN	ISSN
% BN	ISBN
% J9	29-Character Source Abbreviation
% JI	ISO Source Abbreviation
% PD	Publication Date
% PY	Year Published
% VL	Volume
% IS	Issue
% PN	Part Number
% SU	Supplement
% SI	Special Issue
% BP	Beginning Page
% EP	Ending Page
% AR	Article Number
% PG	Page Count
% DI	Digital Object Identifier (DOI)
% SC	Subject Category
% GA	Document Delivery Number
% UT	Unique Article Identifier
% ER	End of Record
% EF	End of File


