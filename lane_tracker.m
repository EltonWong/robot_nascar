%TODO:  Video Logger
%       Robust
%

function lane_tracker()

global kbhit;
kbhit = false;



KinectHandles=mxNiCreateContext();
figure('KeyPressFcn', @my_kbhit);
I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
subplot(1, 2, 1), h1 = imagesc(I);axis image;
subplot(1, 2, 2), h2 = imagesc(I);
axis image;

while ~kbhit
        I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
        pic = I;
        % Consider thresholding on bw image if encounter speed issue
        % Consider adaptive thresholding
        I(I < 240) = 0;
        I(1:130,:,:) = 0;
        I = rgb2gray(I);
        I = im2bw(I, 0.9);
        I = bwmorph(I, 'OPEN', 2);
        I = bwmorph(I, 'CLOSE');
        CC = bwconncomp(I);
        s = regionprops(CC, 'Area', 'PixelIdxList');
        [val, ind] = sort([s.Area], 'descend');

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

        set(h1,'CDATA', pic);
        set(h2, 'CDATA', I);
        colormap gray;
        drawnow;
    end

    close all;
    mxNiDeleteContext(KinectHandles);

