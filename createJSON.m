function createJSON(ytaxa)

%%% open an empty JSON file
global fileID
fileID = fopen('generatedJSON.json','wt');

%%% write the root class
fprintf(fileID, '{\n"name": "root", \n"children": [\n');

[uniqueSp,uniqueIdx,~] = unique(ytaxa(:,end));

%%% remove duplicate species
ytaxa = ytaxa(uniqueIdx,:);
indent = '';
determineUnique(ytaxa,1, indent);
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
        indent = createIndentation(iLevel);
        if iSp == length(uniqueSp)
            fprintf(fileID, '%s{"name": "%s"}\n', indent, currSp{:});
            indent = createIndentation(iLevel-1);
            fprintf(fileID, '%s]\n%s}', indent, indent);
        else
            fprintf(fileID, '%s{"name": "%s"},\n', indent, currSp{:});            
        end
        continue
    else
        indent = createIndentation(iLevel);
        fprintf(fileID, '%s{\n%s"name": "%s",\n%s"children": [\n', indent, indent, currSp{:}, indent);
        determineUnique(ytaxa(idx,:), iLevel+1, indent)
        if closeBranch
            fprintf(fileID, '\n%s]\n%s}\n',indent,indent);
        else
            fprintf(fileID, ',\n');
        end
    end
end

end

function [indent] = createIndentation(iLevel)
indent = [''];
for i = 1:iLevel
    indent = [indent, '   '];
end
end