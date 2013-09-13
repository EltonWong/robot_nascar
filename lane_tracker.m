%TODO:  Video Logger
%       Robust
%

function s = lane_tracker()

global kbhit;
kbhit = false;

KinectHandles=mxNiCreateContext();
figure('KeyPressFcn', @my_kbhit);
I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
h = imagesc(I);
colormap gray;

while ~kbhit
        I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
        pic = I;
        I(I < 250) = 0;
        I(1:160,:,:) = 0;
        I = rgb2gray(I);
        I(I~=0) = 255;
        CC = bwconncomp(I);
        s = regionprops(CC, 'Area', 'PixelIdxList');
        [val, ind] = sort([s.Area], 'descend');

        I(1:end,1:end) = 0;
        if length(ind) > 1;
            r = pic(:,:,1);
            g = pic(:,:,2);
            b = pic(:,:,3);

            r(CC.PixelIdxList{ind(1)}) = 255; 
            r(CC.PixelIdxList{ind(2)}) = 255; 
            g(CC.PixelIdxList{ind(1)}) = 0;
            g(CC.PixelIdxList{ind(2)}) = 0;
            b(CC.PixelIdxList{ind(1)}) = 0;
            b(CC.PixelIdxList{ind(2)}) = 0;

            pic(:,:,1) = r;
            pic(:,:,2) = g;
            pic(:,:,3) = b;
        end

        set(h,'CDATA', pic);
        drawnow;
    end

    mxNiDeleteContext(KinectHandles);

