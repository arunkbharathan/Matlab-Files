a = 5*[randn(500,1)+5, randn(500,1)+5];
b = 5*[randn(500,1)+5, randn(500,1)-5];
c = 5*[randn(500,1)-5, randn(500,1)+5];
d = 5*[randn(500,1)-5, randn(500,1)-5];
e = 5*[randn(500,1), randn(500,1)];

Group_X = [a;b;c];
Group_Y = [d;e];

All_data = [Group_X; Group_Y];
All_data_label = [];

for k = 1:length(All_data)
if k<=length(Group_X)
All_data_label = [All_data_label; 'X'];
else
All_data_label = [All_data_label; 'Y'];
end
end

testing_ind = [];
for i = 1:length(All_data)
if rand>0.8
testing_ind = [testing_ind, i];
end
end
training_ind = setxor(1:length(All_data), testing_ind);



[ldaClass,err,P,logp,coeff] = classify(All_data(testing_ind,:),...
All_data((training_ind),:),All_data_label(training_ind,:),'linear');
[ldaResubCM,grpOrder] = confusionmat(All_data_label(testing_ind,:),ldaClass)

K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x,y) K + [x y]*L;
h2 = ezplot(f,[min(All_data(:,1)) max(All_data(:,1)) min(All_data(:,2)) max(All_data(:,2))]);
hold on


[ldaClass,err,P,logp,coeff] = classify(All_data(testing_ind,:),...
All_data((training_ind),:),All_data_label(training_ind,:),'diagQuadratic');
[ldaResubCM,grpOrder] = confusionmat(All_data_label(testing_ind,:),ldaClass)

K = coeff(1,2).const;
L = coeff(1,2).linear;
Q = coeff(1,2).quadratic;
f = @(x,y) K + [x y]*L + sum(([x y]*Q) .* [x y], 2);
h2 = ezplot(f,[min(All_data(:,1)) max(All_data(:,1)) min(All_data(:,2)) max(All_data(:,2))]);
hold on


Group_X_testing = [];
Group_Y_testing = [];

for k = 1:length(All_data)
if ~isempty(find(testing_ind==k))
if strcmp(All_data_label(k,:),'X')==1
Group_X_testing = [Group_X_testing,k];
else
Group_Y_testing = [Group_Y_testing,k];
end
end
end
plot(All_data(Group_X_testing,1),All_data(Group_X_testing,2),'g.');
hold on
plot(All_data(Group_Y_testing,1),All_data(Group_Y_testing,2),'r.');