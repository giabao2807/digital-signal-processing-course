clear;
clc;
close all;
path='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/';
files = dir('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/');
numfilter=26;
k=5;

%trainnings
a=zeros(21*k,numfilter-1);
u=zeros(21*k,numfilter-1);
e=zeros(21*k,numfilter-1);
ii=zeros(21*k,numfilter-1);
o=zeros(21*k,numfilter-1);


for i=4:24
    p=strcat(path,files(i).name);
    p=strcat(p,'/');
    p1=strcat(p, '/*.wav');
    files1 = dir(p1);
    for j=1:length(files1)
        x = files(i).name + "/" + files1(j).name;
        p2=strcat(p,files1(j).name);
        [data,fs]= audioread(p2);
        index = (i-4)*j + j;
        
        %Trich xuat vecto theo tung nguyen am
        if (j==1)
            v=program(data, fs, index, x,numfilter,k);
            for h=1:k
                a((i-4)*k+h,:)=v(h,:);
            end
         elseif (j==2)
            v=program(data, fs, index, x,numfilter,k);
            for h=1:k
                e((i-4)*k+h,:)=v(h,:);
            end
         elseif (j==3)
            v=program(data, fs, index, x,numfilter,k);
            for h=1:k
                ii((i-4)*k+h,:)=v(h,:);
            end
         elseif (j==4)
            v=program(data, fs, index, x,numfilter,k);
            for h=1:k
                o((i-4)*k+h,:)=v(h,:);
            end
         elseif (j==5)
            v=program(data, fs, index, x,numfilter,k);
            for h=1:k
                u((i-4)*k+h,:)=v(h,:);
            end
        end 
    end
end




%TBC cac vecto=
tmp = zeros(21,numfilter-1);
mean_a = zeros(k,numfilter-1);
for i=1:k
    for j=1:21
       indx = k*(j-1)+i;
       tmp(j,:)=a(indx,:);
    end
    mean_a(i,:)=mean(tmp);
end


mean_e = zeros(k,numfilter-1);
for i=1:k
    for j=1:21
       indx = k*(j-1)+i;
       tmp(j,:)=e(indx,:);
    end
    mean_e(i,:)=mean(tmp);
end

mean_ii = zeros(k,numfilter-1);
for i=1:k
    for j=1:21
       indx = k*(j-1)+i;
       tmp(j,:)=ii(indx,:);
    end
    mean_ii(i,:)=mean(tmp);
end

mean_o = zeros(k,numfilter-1);
for i=1:k
    for j=1:21
       indx = k*(j-1)+i;
       tmp(j,:)=o(indx,:);
    end
    mean_o(i,:)=mean(tmp);
end

mean_u = zeros(k,numfilter-1);
for i=1:k
    for j=1:21
       indx = k*(j-1)+i;
       tmp(j,:)=u(indx,:);
    end
    mean_u(i,:)=mean(tmp);
end

 

% %testing
% %Cau 3 so khop va xuat ket qua
mang = zeros(5*k,numfilter-1);
for i =1:5
    for j=1:k
        if i==1
            mang((i-1)*k+j,:)=mean_a(j,:);
        elseif i==2
            mang((i-1)*k+j,:)=mean_e(j,:);
        elseif i==3
            mang((i-1)*k+j,:)=mean_ii(j,:);
        elseif i==4
            mang((i-1)*k+j,:)=mean_o(j,:);
        elseif i==5
            mang((i-1)*k+j,:)=mean_u(j,:);
        end
    end
end


path_kt='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmKiemThu/';
files_kt = dir('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmKiemThu/');
 
result= zeros(5,5);
wrong_result = 0;
for i=4:24
    p=strcat(path,files(i).name);
    p=strcat(p,'/');
    p1=strcat(p, '/*.wav');
    files1 = dir(p1);
    for j=1:length(files1)
        x = files(i).name + "/" + files1(j).name;
        p2=strcat(p,files1(j).name);
        [data,fs]= audioread(p2);
        vecto =program(data, fs, index, x,numfilter,1);
        index= sokhop(files1(j).name ,vecto,mang,k);
        result(j, index) = result(j, index) + 1;
        if(j ~= index) wrong_result = wrong_result + 1;
        end
    end
end

nhan = {'a';'e';'i';'o';'u'};
rs_a = result(:,1);
rs_e =  result(:,2);
rs_i =  result(:,3);
rs_o =  result(:,4);
rs_u =  result(:,5);
T = table(nhan,rs_a,rs_e,rs_i,rs_o,rs_u)
Dochinhxac = (105 - wrong_result) * 100 / 105