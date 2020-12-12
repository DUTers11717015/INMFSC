clear all;
clc;
authors = 20                                                                       % number of authors
txt = 30;
traintxt = 0.9*txt;                                                                % number of each author's training set
testtxt = txt-traintxt;
classifier_num=20
validation_folds = 10                                                              % cross validation's folds
folds=validation_folds;

fid3 = fopen(['E:\2011_research\ENexperiment\result\',num2str(authors),'_',num2str(txt),'_emsembles_pca_snn.txt'], 'w+');       
% [label,allsamples]=libsvmread(['E:\2011_research\ENexperiment\ngrams\ngrams_',num2str(authors),'_',num2str(txt),'_','normalized_ig.libsvm']);
% [label,allsamples]=libsvmread('E:\2011_research\ENexperiment\combine_20_30\all_20_10_normalized_ig.libsvm');
allsamples=zeros(authors*txt,20000);
[label,allsamples]=libsvmread(['E:\2011_research\ENexperiment\combine_all\combine_',num2str(authors),'_',num2str(txt),'\all_normalized_ig_',num2str(authors),'_',num2str(txt),'.libsvm']);%30_30->888:85.67%
initial_dimension = size(allsamples,2);
tic

realauthor=0; 
count=0;
accuracys=[];
errortxt=[];                                   % record txts which was identified as error
error=1;

% random subspce method 
options=[];
space=randperm(initial_dimension);
subcol=zeros(1,classifier_num);
for j=1:classifier_num
    begin=floor(((j-1)/classifier_num)*initial_dimension)+1;
    ending=floor((j/classifier_num)*initial_dimension);
    subspace(j,1:ending-begin+1)=space(begin:ending);
    sub_temp=subspace(j,:);
    sub_temp(sub_temp==0)=[];
    [eigvector, eigvalue] = pca(allsamples(:,sub_temp), options);
    subset{j}=allsamples(:,sub_temp)*eigvector;
    eigvalue=[];
    eigvector=[];
    sub_temp=[];
end
    subcol(1)=size(subset{1},2);
for j=2:classifier_num
    subcol(j)=subcol(j-1)+size(subset{j},2);
end
    allset=cell2mat(subset);
base_correctnum=zeros(folds,classifier_num);
indices = crossvalind('Kfold',label,10);                    % 10 folds cross validation
for fold=1:folds
        testidx = (indices == fold);
        trainidx = ~testidx;
        traindata = allset(trainidx,:);
        traingroup = label(trainidx,:);
        trainlength = length(traingroup);
        testdata = allset(testidx,:);
        testgroup = label(testidx,:);
        testlength = length(testgroup);
    %   compute mean value of trainset SCAP
        for p=1:authors
           models(p,:)=mean(traindata(1+(p-1)*traintxt:p*traintxt,:));
        end
        for i=1:testlength
             result=[];
             model=[];
             finalresult=zeros(1,authors);
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             % ensembles classifying process
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             for j=1:classifier_num                          % multi-classifiers construction
                 if j==1
                    model=full(models(:,1:subcol(j)));
                    ss=(pinv(model))';                         % α�淨
                    [result(j,:),yy] = snn(authors,model,ss,testdata(i,1:subcol(j)));
                    [x1,y1]=max(result(j,:));
                     if testgroup(i)==label(y1*txt)
                         base_correctnum(fold,j)=base_correctnum(fold,j)+1;
                     end
                 else
                     model=full(models(:,subcol(j-1)+1:subcol(j)));
                     ss=(pinv(model))';                         % α�淨
                     [result(j,:),yy] = snn(authors,model,ss,testdata(i,subcol(j-1)+1:subcol(j)));
                     [x1,y1]=max(result(j,:));
                     if testgroup(i)==label(y1*txt)
                        base_correctnum(fold,j)=base_correctnum(fold,j)+1;
                     end
                 end
        end
             for c=1:authors
                 finalresult(c)=sum(result(:,c));            % sum ensembles strategy
             end
             finalresult
             % compute sanme number of votes
             if length(find(finalresult==max(finalresult)))>1
                   maxidx=find(finalresult==max(finalresult));
                   for idx=1:length(maxidx)
                       % compare distance between test and possible class
                       % vectors
                       distance(idx)=dist2(traindata((maxidx(idx)-1)*traintxt+1:maxidx(idx)*traintxt,:),testdata(i,:));
                   end
                  y=maxidx(find(min(distance)));
             else
                [x,y]=max(finalresult);  
             end 
%                  idenidx=y-1;
%                  [x,y]=max(finalresult);  
                 if testgroup(i)==label(y*txt)
                   realauthor = realauthor+1;
                 end
                fprintf(fid3, '%d%s%d\r\n', testgroup(i),'->',label(y*txt));
        end
        accuracy = (realauthor/(testtxt*authors))*100;
        accuracys(fold)=accuracy;
    testdata=[];
    traindata=[];
    count=count+realauthor;
    realauthor=0;
end
% display results
maxAccuracy = max(accuracys)
totaltest = folds*testtxt*authors
base_totalcorrectnum=sum(base_correctnum);
base_totalcorrectnum/totaltest
count
allaccuracy=(count/(totaltest))*100
meanaccuracy=mean(accuracys)
fprintf(fid3,'%s%d%s%s\r\n','============================',folds,'folds cross validation','============================');
fprintf(fid3,'%s\t%d\r\n','testset are totally tested in the experiment:', folds*testtxt*authors);
fprintf(fid3,'%s\t%d\r\n','realauthors are identified as true:', count);
fprintf(fid3,'%s\t%f%s\r\n','allaccuracy of identification:',allaccuracy,'%');
fprintf(fid3,'%s\t%f%s\r\n','meanaccuracy of identification:',meanaccuracy,'%');
% end
toc