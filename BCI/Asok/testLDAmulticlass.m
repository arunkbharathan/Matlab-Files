voted=cell(4,4)
 rng('default')
X = [randn(10,2); randn(10,2) + 1.5;randn(10,2)+5;randn(10,2)+10];  Y = [ones(10,1); 2*ones(10,1);3*ones(10,1);4*ones(10,1)];
voted{1,2}=LDA(X(1:20,:),Y(1:20))
voted{2,3}=LDA(X(11:30,:),Y(11:30))
voted{3,4}=LDA(X(21:40,:),Y(21:40))
voted{1,3}=LDA(X([1:10,21:30],:),Y([1:10,21:30]))
voted{1,4}=LDA(X([1:10,31:40],:),Y([1:10,31:40]))
voted{2,4}=LDA(X([11:20,31:40],:),Y([11:20,31:40]))
x=X([1 11 21 31],:);
classs=computeOP(voted,x)