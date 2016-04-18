function extractTexture()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global setPlanes;
global points;
global picture;
[n,~]=size(setPlanes);
disp(setPlanes);
for t=1:n
    %disp(setPlanes(t,:));
    tempp=points(setPlanes(t,:),:);
    disp(tempp);
    %disp(p);
    p=double(rand(4,4));
    p(:,1:2)=double(tempp(:,1:2));
    rp=double(tempp(:,3:5));
    disp(rp);
    p(1,3:4)=0;
    p(2,3)=norm(rp(2,:)-rp(1,:));
    p(2,4)=0;
    p(3,3)=dot(rp(3,:)-rp(1,:),rp(2,:)-rp(1,:))./norm(rp(2,:)-rp(1,:));
    p(3,4)=sqrt( (norm(rp(3,:)-rp(1,:)))^2 - (p(3,3))^2 );
    p(4,3)=dot(rp(4,:)-rp(1,:),rp(2,:)-rp(1,:))./norm(rp(2,:)-rp(1,:));
    p(4,4)=sqrt( (norm(rp(4,:)-rp(1,:)))^2 - (p(4,3))^2 );
    disp(p);
    A = rand(0,9);
    for i=1:4
       B=rand(2,9);
       B(1,1)=p(i,1);
       B(1,2)=p(i,2);
       B(1,3)=1;
       B(1,4:6)=zeros(1,3);
       B(1,7)=-p(i,3)*p(i,1);
       B(1,8)=-p(i,3)*p(i,2);
       B(1,9)=-p(i,3);
       B(2,1:3)=zeros(1,3);
       B(2,4:5)=p(i,1:2);
       B(2,6)=1;
       B(2,7)=-p(i,4)*p(i,1);
       B(2,8)=-p(i,4)*p(i,2);
       B(2,9)=-p(i,4);
       A=[A;B];
    end
    %disp(A);
    A=A'*A;
    %disp('***************');
    %disp(A);
    [V,D]=eig(A);
    %[U,S,V] = svd(A);
    %h=double(U(:,size(U,2)));
%     
    mi=double(D(1,1)); minn=1;
    for i=2:size(D,1)
        if (D(i,i)<mi)
            mi=D(i,i); minn=i;
        end
    end
    h=V(:,minn);
    H=reshape(h,[3,3]);
    %H=H';
    H(1:2,3)=0;
    H=H./H(3,3);
    
    left=min(p(:,1));
    right=max(p(:,1));
    bottom=min(p(:,2));
    top=max(p(:,2));
    disp([left;right;bottom;top]);
    disp(size(picture));
    ori=picture(bottom:top,left:right,:);
    disp(H);
    tran=affine2d(H);
    %imshow(ori);
    imwrite(ori,'temp.bmp');
%     ori=imread('temp.bmp');
    
    display(size(ori));
    orir=ori(:,:,1);
    orig=ori(:,:,2);
    orib=ori(:,:,3);
    tImager=imwarp(orir,tran);
    tImageg=imwarp(orig,tran);
    tImageb=imwarp(orib,tran);
    [sx,sy,~]=size(tImager);
    tImage=uint8(zeros(sx,sy,3));
    tImage(:,:,1)=tImager(:,:,1);
    tImage(:,:,2)=tImageg(:,:,1);
    tImage(:,:,3)=tImageb(:,:,1);
    %tImage=imwarp(ori,tran);
    figure,[IM,~]=imcrop(tImage);
    imwrite(IM,strcat(num2str(t),'.bmp'));
end

end

