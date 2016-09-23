function createXML(ytaxa)

%%% open an empty xml file
global fileID
fileID = fopen('test.xml','wt');

%%% write the default opening txt
fprintf(fileID, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fileID, '<phyloxml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n');
fprintf(fileID, '   xsi:schemaLocation="http://www.phyloxml.org http://www.phyloxml.org/1.10/phyloxml.xsd"\n');
fprintf(fileID, '   xmlns="http://www.phyloxml.org">\n');
fprintf(fileID, '   <phylogeny rooted="true">\n');
[uniqueSp,uniqueIdx,~] = unique(ytaxa(:,end));

%%% remove duplicate species
ytaxa = ytaxa(uniqueIdx,:);
indent = '   ';
determineUnique(ytaxa,1, indent);
fprintf(fileID, '   </phylogeny>\n');
fprintf(fileID, '</phyloxml>');
fclose('all');
end

function determineUnique(ytaxa,iLevel, indent)
global fileID
%%% unique classes in the current level
[uniqueSp, uniqueIdx,~] = unique(ytaxa(:,iLevel));

%%% for each class determine next level unique classes
for iSp = 1:length(uniqueSp)
    currSp = uniqueSp(iSp);
    idx = find(strcmpi(ytaxa(:,iLevel), currSp{:}));
    %%% if current species is the last one for the current level
    %%% close branch without comma
    if iSp == length(uniqueSp)
        closeBranch = true;
    else
        closeBranch = false;
    end
    %%% have we reached the bottom level yet?
    if iLevel == size(ytaxa,2)
        spaceIdx = strfind(currSp{:}, ' ');
        spName = [currSp{1}(1), '.', currSp{1}(spaceIdx:end)];
        indent = createIndentation(iLevel);
        fprintf(fileID,'%s<clade>\n', indent);
        indent = createIndentation(iLevel+1);
        fprintf(fileID, '%s<name>%s</name>\n', indent, spName);
        indent = createIndentation(iLevel);
        fprintf(fileID, '%s</clade>\n', indent);
        indent = createIndentation(iLevel-1);
        if closeBranch
            fprintf(fileID, '%s</clade>\n',indent);
        else
            fprintf(fileID, '\n');
        end
        continue
    else
        indent = createIndentation(iLevel);
        fprintf(fileID, '%s<clade>\n', indent);
        determineUnique(ytaxa(idx,:), iLevel+1, indent)
        indent = createIndentation(iLevel-1);
        if closeBranch
            if iLevel == 1
            else
                fprintf(fileID, '%s</clade>\n',indent);
            end
        else
            fprintf(fileID, '\n');
        end
    end
end

end

function [indent] = createIndentation(iLevel)
indent = ['   '];
for i = 1:iLevel
    indent = [indent, '   '];
end
end