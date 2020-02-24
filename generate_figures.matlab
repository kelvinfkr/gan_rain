pic_num = 1;

load('C:\Users\kelvi\Documents\MATLAB\liumaofeng\mask.mat')

nam_nldas = 'C:\Users\kelvi\Documents\MATLAB\liumaofeng\NLDAS\nldas_rain_' ;

nam_stage = 'C:\Users\kelvi\Documents\MATLAB\liumaofeng\StageIV\stageiv_rain_'; 


track = track(find(track(:,7)==1),:);

for i = 1:length(track(:,1))
	year = (track(i,1) - mod(track(i,1),1000000))/1000000;
	month = (track(i,1) - mod(track(i,1),10000))/10000 - year*100; 
	t =  (mod(track(i,1),10000)-mod(track(i,1),100))/100*24 + mod(track(i,1),100);

%	name_points = ['center_' num2str(year) '_' num2str(month,'%02d') '.mat'];
	name_data_nldas = [nam_nldas num2str(year) '_' num2str(month,'%02d') '.mat'];
	nldasrain = load(name_data_nldas,'rain');
	nldasrain = nldasrain.rain;
	clear temp_nldas		

	name_data_stage = [nam_stage num2str(year) '_' num2str(month,'%02d') '.mat'];
	stagerain = load(name_data_stage,'rain');
	stagerain = stagerain.rain;
 	clear temp_stage

tic;

stagerain(find(stagerain<0)) = NaN;
nldasrain(find(nldasrain<0)) = NaN;
temp = mean(stagerain,3);
for i = 1:length(mask_stage)
nldasrain(ceil(mask_stage(i,1)/3),ceil(mask_stage(i,2)/3),:) = NaN;
stagerain(mask_stage(i,1),mask_stage(i,2),:) = NaN;
end
temp = mean(nldasrain,3);
for i = 1:length(mask_nldas)
for ii = 1:3
	for jj = 1:3
		a = (mask_nldas(i,1)-1)*3+ii;
		b = (mask_nldas(i,2)-1)*3+jj;
stagerain(a,b,:) = NaN;
end
end
end
toc;

	shapen = size(nldasrain);

	tempfuture = min((t+6),shapen(3));
	temppast = max((t-5),1);
		
	if tempfuture~=shapen(3)&temppast~=1
	stt1 = temppast:tempfuture;%interval of generated sample
	end

	if tempfuture ==shapen(3)
		stt1 = (shapen(3)-11):shapen(3);
	end

	if temppast == 1
		stt1 = 1:12;
	end

	pic_temp_nlda = nldasrain(:,:,stt1);
	pic_temp_stage = stagerain(:,:,stt1);

	pic_stage = uint8(zeros(192,192,3));

for i = 1:208
	for j = 1:328
		for jj = 1:4
			if jj == 1
				base_pic_i = (i-1)*6+(1:3);
				base_pic_j = (j-1)*6+(1:3);
				ori_pic_i = (i*3-2):i*3;
				ori_pic_j = (j*3-2):j*3;
				pic_stage(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_stage(ori_pic_i,ori_pic_j,[1,5,9]));
			end

			if jj == 2
				base_pic_i = (i-1)*6+(4:6);
				base_pic_j = (j-1)*6+(1:3);
				ori_pic_i = (i*3-2):i*3;
				ori_pic_j = (j*3-2):j*3;
				pic_stage(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_stage(ori_pic_i,ori_pic_j,[2,6,10]));
			end	

			if jj == 3
				base_pic_i = (i-1)*6+(1:3);
				base_pic_j = (j-1)*6+(4:6);
				ori_pic_i = (i*3-2):i*3;
				ori_pic_j = (j*3-2):j*3;
				pic_stage(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_stage(ori_pic_i,ori_pic_j,[3,7,11]));
			end

			if jj == 4
				base_pic_i = (i-1)*6+(4:6);
				base_pic_j = (j-1)*6+(4:6);
				ori_pic_i = (i*3-2):i*3;
				ori_pic_j = (j*3-2):j*3;
				pic_stage(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_stage(ori_pic_i,ori_pic_j,[4,8,12]));
			end
		end
	end
end

newname = num2str(pic_num,'stage_%04i.png');
imwrite(255-pic_stage,newname);

pic_nlda = uint8(zeros(64,64,3));
for i = 1:208
	for j = 1:328
		for jj = 1:4
			if jj == 1
				base_pic_i = (i-1)*2+(1);
				base_pic_j = (j-1)*2+(1);
				ori_pic_i = i;
				ori_pic_j = j;
				pic_nlda(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_nlda(ori_pic_i,ori_pic_j,[1,5,9]));
			end

			if jj == 2
				base_pic_i = (i-1)*2+(2);
				base_pic_j = (j-1)*2+(1);
				ori_pic_i = i;
				ori_pic_j = j;
				pic_nlda(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_nlda(ori_pic_i,ori_pic_j,[2,6,10]));
			end	

			if jj == 3
				base_pic_i = (i-1)*2+(1);
				base_pic_j = (j-1)*2+(2);
				ori_pic_i = i;
				ori_pic_j = j;
				pic_nlda(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_nlda(ori_pic_i,ori_pic_j,[3,7,11]));
			end

			if jj == 4
				base_pic_i = (i-1)*2+(2);
				base_pic_j = (j-1)*2+(2);
				ori_pic_i = i;
				ori_pic_j = j;
				pic_nlda(base_pic_i,base_pic_j,1:3) = uint8(pic_temp_nlda(ori_pic_i,ori_pic_j,[4,8,12]));
			end
		end
	end
end

		newname = num2str(pic_num,'nlda_%04i.png');
		imwrite(255-pic_nlda,newname);

	pic_num = pic_num+1;



end