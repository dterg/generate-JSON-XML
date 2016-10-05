# generate-JSON-XML
Generate JSON and XML file from a MATLAB cell array. Format of JSON compatible with D3 hierarchical tree (Radial Reingold–Tilford Tree) and XML format compatible with iTol (interactive online tool). 

### How to use
Uses a MATLAB string cell array, where columns are hierarchical levels and rows are different classes/samples. Last column represents the child nodes/classes i.e. the classes at the bottom-most hierarchy level. 

Function takes this cell array as an input argument and generates a JSON or XML file in the same directory. 

More details are provided on http://www.dietergalea.com/vis-hierarchical-trees/
