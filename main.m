clear all;clc;close all;
folder={'Oldenburg','SanJoaquin','SanFranciscoBayArea'};
%在此设置所要实验的数据集编号
mapId=3;
% 实验次数
tm=100;
%eplisons参数设置
eplisons=[0.5,1,2,5];
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 读取数据
edge=importdata([folder{mapId} '/edge.txt']);
edge=[edge;fliplr(edge)];
nodeTras=importdata([folder{mapId} '/node.txt']);
fidin=fopen([folder{mapId} '/trajs.txt']);
trajs={};
len=0;
while ~feof(fidin)
    id=fscanf(fidin,'%f',[1,1]);
    m=fscanf(fidin,'%f',[1,1]);
    traj=fscanf(fidin,'%f',[m,1]);
    trajs{id+1}=traj;
    len=len+size(traj,1);
end
fclose(fidin);
disp(['节点数为：' num2str(size(nodeTras,1))]);
mp=sparse(edge(:,1),edge(:,2),1,size(nodeTras,1),size(nodeTras,1));
disp(['边数为：' num2str(sum(sum(sign(mp))))]);
%% 统计轨迹流量图
tic
n=size(nodeTras,1)+1;
extraEdge=[(1:n-1)' ones(n-1,1)*n;ones(n-1,1)*n (1:n-1)'];
edgeExt=[edge;extraEdge];
mp=sparse(edgeExt(:,1),edgeExt(:,2),1,n,n);
mp=sign(mp);
nNode=size(nodeTras,1);
nEdge=size(find(mp(1:nNode,1:nNode)),1);
W=sparse(n,n);
for i=1:size(trajs,2)
    traj=trajs{i};
    len=size(traj,1);
    t1=[traj;n];
    t2=[traj(2:end,1);n;traj(1)];
    dW=sparse(t1,t2,1);
    W=W+dW;
end
disp(['流量统计耗时：' num2str(toc)]);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
errs1=[];
errs2=[];
runTime=[];
AW1s={};
AW2s={};
for k=1:size(eplisons,2)
    AW1=sparse(size(W,1),size(W,2));
    AW2=sparse(size(W,1),size(W,2));
    eplison=eplisons(k);
    for i=1:tm
        %% 添加拉普拉斯噪声
        [a,b]=find(mp);
        rnds=GenLaplace(size(a,1),1,0,4/eplison);
        Rnd=sparse(a,b,rnds,size(mp,1),size(mp,2));
        W1=W+Rnd;
        %% 一致性调节
        tic
        [r2,W2]=consistencyAdjustment(W1,mp);
        runTime(k,i)=toc;
        %% 计算标准误差
        err1=norm(W1(1:n-1,1:n-1)-W(1:n-1,1:n-1),'fro');
        err2=norm(W2(1:n-1,1:n-1)-W(1:n-1,1:n-1),'fro');
        errs1(k,i)=err1;
        errs2(k,i)=err2;
        AW1=W1+AW1;
        AW2=W2+AW2;
    end
    AW1s{k}=AW1/tm;
    AW2s{k}=AW2/tm;
end
%% 对多次实验结果取平均作为最后实验结果
errs1=mean(errs1,2);
errs2=mean(errs2,2);
runTime=mean(runTime,2);
%% 结果
for k=1:size(eplisons,2)
    eplison=eplisons(k);
    disp(['eplison为' num2str(eplison) '的调节前后流量图为：']);
    disp('调节前：');
    AW1s{k}
    disp('调节后：');
    AW2s{k}
end
disp(['eplison值：' sprintf('%g\t',eplisons)]);
disp(['调节前标准误差：' sprintf('%g\t',errs1)]);
disp(['调节后标准误差：' sprintf('%g\t',errs2)]);
disp(['一致性调节的实验耗时：' sprintf('%g\t',runTime)]);
disp(['调节后减小的误差：' sprintf('%g%%\t',100*(errs1-errs2)./errs1)]);