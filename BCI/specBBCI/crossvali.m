function[]=crossvali(data,label)
dataRowNumber = size(data,1);
labels= rand(dataRowNumber,1) > 0.5;
randomColumn = rand(dataRowNumber,1);

X = [ randomColumn data labels];


SortedData = sort(X,1);

crossValidationFolds = 5;
numberOfRowsPerFold = dataRowNumber / crossValidationFolds;

crossValidationTrainData = [];
crossValidationTestData = [];
for startOfRow = 1:numberOfRowsPerFold:dataRowNumber
    testRows = startOfRow:startOfRow+numberOfRowsPerFold-1;
    if (startOfRow == 1)
        trainRows = [max(testRows)+1:dataRowNumber];
        else
        trainRows = [1:startOfRow-1 max(testRows)+1:dataRowNumber];
    end
    crossValidationTrainData = [crossValidationTrainData ; SortedData(trainRows ,:)];
    crossValidationTestData = [crossValidationTestData ;SortedData(testRows ,:)];

end