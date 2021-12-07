close all;
for looping =1:4
   % clear x frames;
   clearvars -except looping;
clc;
% filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
% files = { '01MDA','02FVA', '03MAB', '06FTB'};

filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuKiemThu/';
files = { '45MDV','42FQT', '44MTT','30FTN'};


name = char(strcat(filePath, files(looping), '.wav'));
Tste= 0.21;
Tma= 0.185;

%0 si 1 speech

FVA=[0 0;0.83 1;1.37 0;2.09 1;2.60 0;3.57 1;4.00 0;4.76 1;5.33 0;6.18 1;6.68 0;7.18 1];
MAB =[0 0;1.03 1;1.42 0;2.46 1;2.80 0;4.21 1;4.52 0;6.81 1;7.14 0;8.22 1;8.50 0;9.37 1];
FTB = [0 0;1.52 1;1.92 0;3.91 1;4.35 0;6.18 1;6.6 0;8.67 1;9.14 0;10.94 1;11.33 0;12.75 1];
MDA = [0 0;0.45 1;0.81 0;1.53 1;1.85 0;2.69 1;2.86 0;3.78 1;4.15 0;4.84 1;5.14 0;5.58 1];

FTN=[0.00 0;0.59 1;0.97 0;1.76 1;2.11 0; 3.44 1;3.77 0;4.70 1;5.13 0;5.96 1;6.28 0;6.78 1];
FQT=[0.00 0;0.46 1;0.99 0;1.56 1;2.13 0;2.51 1;2.93 0;3.79 1;4.38 0;4.77 1;5.22 0;5.79 1];
MTT=[0.00 0;0.93 1;1.42 0;2.59 1;3.00 0;4.71 1;5.11 0;6.26 1;6.66 0;8.04 1;8.39 0;9.27 1];
MDV=[0.00 0;0.88 1;1.34 0;2.35 1;2.82 0;3.76 1;4.13 0;5.04 1;5.50 0;6.41 1;6.79 0;7.42 1];

% if (looping==1)
%     standardVals=MDA;
% elseif (looping==2)
%     standardVals=FVA;
% elseif (looping==3)
%     standardVals=MAB;
% elseif (looping==4)
%     standardVals=FTB;
% end;

if (looping==1)
    standardVals=MDV;
elseif (looping==2)
    standardVals=FQT;
elseif (looping==3)
    standardVals=MTT;
elseif (looping==4)
    standardVals=FTN;
end;




    [x,t1,fs]=normalizedAmplitude(name);

    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdlow=1/450; pdhigh=1/70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);

    lenX = length(x); %do dai tin hieu vao theo mau
    nSampleFrame = time_duration*fs;%do dai 1 frame tinh theo mau
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau

    
    nFrame= int32((lenX-nSampleLag)/(nSampleFrame-nSampleLag))+1;%so frame chia duoc
    t=(1:nFrame)*2*fs/nSampleLag; 
   
    
%     ZCRarr=zeros(1,nFrame);
    STEarr=zeros(1,nFrame);
    MAarr= zeros(1,nFrame);
    VUframe = zeros(1,nFrame);
    VUindex =[0 ];
   
    
    %chia frame
    for frame_index=1:nFrame
        a=(frame_index-1)*(nSampleFrame-nSampleLag)+1;
        if(frame_index ==1)
             b=(frame_index)*nSampleFrame+1;
        else
            b=(frame_index)*nSampleFrame - (frame_index-1)*nSampleLag +1;
        end
        if b < lenX
            frame= x(a:b); %xac dinh 1 frame
        else 
            frame= x(a:lenX);
            frame(lenX:b)=0;
        end
        
%         ZCR computing
%         zcr=0;
%         for  i = 2:nSampleFrame
%             if frame(i)*frame(i-1) <0
%                 zcr=zcr+1;
%             end
%         end
%         ZCRarr(frame_index)=zcr;
       
        %MA computing
        MAarr(frame_index)= sum(abs(frame));
        
        %STE computing
        STEarr(frame_index)=sum(frame.^2);   
    end
         
  
     %ZCRarr= (ZCRarr - min(ZCRarr))/(max(ZCRarr) - min(ZCRarr));
     MAarr= MAarr./max(MAarr);
     STEarr=STEarr./max(STEarr);
     
     %
    %define Speech-Silence
    for frame_index=1:nFrame
       if MAarr(frame_index) >Tma ||  STEarr(frame_index) >Tste
           VUframe(frame_index)=1;
       end
    end
    
        for frame_index=2:nFrame-1
          if VUframe(frame_index) ~= VUframe(frame_index-1) && VUframe(frame_index) == VUframe(frame_index+1)
               index = double(double(frame_index-1)*0.03-double((frame_index-2))*0.01);
               if(index < t1(length(t1)))
                    VUindex=[VUindex index];
               end
          end
        end
        VUindex= [VUindex t1(length(t1))];
       
        
    figure('Name',char(files(looping)));
    subplot(2,1,1); plot(t,STEarr,'g','LineWidth',2);
    hold on;
    plot(t,MAarr,'r','LineWidth',2);
    hold on;
    title('Short-time energy(STE) vs MA');
    xlabel('Time axis')
    ylabel('normailized STE vs MA')
    legend('Short-time energy', 'MA');

    subplot(2,1,2);plot(t1,x);
    hold on;
     for i=1:length(VUindex)
            plot([1 1]*double(VUindex(i)), ylim, 'r','LineWidth', 2.3);
     end
     hold on;
     len=length(standardVals);
     for i=1:len
        if(standardVals(i,2)==1)
         plot([1 1]*standardVals(i,1), ylim, 'green','LineWidth', 1);
        end;
         if(standardVals(i,2)==0)
         plot([1 1]*standardVals(i,1), ylim, 'green','LineWidth', 1);
        end;
     end;
    title('Speech Signal');
    xlabel('Time axis');
    ylabel('normalizedAmplitude');
end

