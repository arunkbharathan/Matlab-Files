uiopen('C:\Users\ArunKB\Documents\Scanned Documents\ScannerDefault1.jpeg',1)
uiopen('C:\Users\ArunKB\Documents\Scanned Documents\BirtCertTheertha_pg2.jpeg',1)
I=BirtCertTheertha_pg2;
 imwrite((2*I-ScannerDefault1)+I,'BirtCertTheertha_pg2.jpg','jpg');
% x=im2single(ScannerDefault);
% d=im2single(semester8);
% y=zeros(size(x));e=zeros(size(x));
% mu = 0.008;            % LMS step size.
% ha = adaptfilt.lms(32,mu);
% for i=1:size(ScannerDefault,3)
%     for j=1:size(ScannerDefault,2)  
% [y(:,j,i),e(:,j,i)] = filter(ha,d(:,j,i),x(:,j,i));
%     end
% end
% beep
