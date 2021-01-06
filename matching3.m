function[output, outputname] = matching(input)

imd = imageDatastore('logos','FileExtensions',{'.png'}, 'LabelSource' ,'foldernames', 'IncludeSubfolders', true);

c = countEachLabel(imd);
a = c.Count;
aa = sum(a)

max1 = 0;
max2 = 0;

%a1 = a(1)+a(2);
%numMatchedPoints = zeros(1,a1);

test = input;
    %rgb2gray:
    %r = test(:,:,1);
    %g = test(:,:,2);
    %b = test(:,:,3);
    %r = double(r);
    %g = double(g);
    %b = double(b); 
    %greyImage = r+g+b;
    %greyImage = greyImage/3;
    %greyImage = uint8(greyImage);
    
%test = greyImage;
%test = rgb2gray(test);
%test(test>150) = 255;
%test(test<=150) = 0;

for i = 1:aa

logo = readimage(imd,i);

%rgb2gray:
    r1 = logo(:,:,1);
    g1 = logo(:,:,2);
    b1 = logo(:,:,3);
    r1 = double(r1);
    g1 = double(g1);
    b1 = double(b1); 
    greyImage1 = r1+g1+b1;
    greyImage1 = greyImage1/3;
    greyImage1 = uint8(greyImage1);
    
    
logo = greyImage1;


%logo(logo>100) = 255;
%logo(logo<=100) = 0;

[rowsL, colsL, c] = size(test);

%logo = imresize(logo, [rowsL colsL]);

cc = normxcorr2_general(logo, test);


[RowCC, ColCc] = size(cc);

[max_cc, imax] = max(abs(cc(:)));
asdf = max_cc


if (max1 <= max_cc)
    max1 = max_cc;
    max2 = i;
end
   
end

fullFileNames = vertcat(imd.Files);
[folder, baseFileNameNoExt, ext] = fileparts(fullFileNames{max2});
%imshow(readimage(imd,max2));
pic = imread(folder+"\1.png");

[asdf, name1] = fileparts(folder);


outputname = name1;

output = pic;

end

function [C,numberOfOverlapPixels] = normxcorr2_general(varargin)


[T, A, requiredNumberOfOverlapPixels] = ParseInputs(varargin{:});

sizeA = size(A);
sizeT = size(T);

% Find the number of pixels used for the calculation as the two images are
% correlated.  The size of this image will be the same as the correlation
% image.  
numberOfOverlapPixels = local_sum(ones(sizeA),sizeT(1),sizeT(2));

local_sum_A = local_sum(A,sizeT(1),sizeT(2));
local_sum_A2 = local_sum(A.*A,sizeT(1),sizeT(2));

% Note: diff_local_sums should be nonnegative, but it may have negative
% values due to round off errors. Below, we use max to ensure the radicand
% is nonnegative.
diff_local_sums_A = ( local_sum_A2 - (local_sum_A.^2)./ numberOfOverlapPixels );
clear local_sum_A2;
denom_A = max(diff_local_sums_A,0); 
clear diff_local_sums_A;

% Flip T in both dimensions so that its correlation can be more easily
% handled.
rotatedT = rot90(T,2);
local_sum_T = local_sum(rotatedT,sizeA(1),sizeA(2));
local_sum_T2 = local_sum(rotatedT.*rotatedT,sizeA(1),sizeA(2));
clear rotatedT;

diff_local_sums_T = ( local_sum_T2 - (local_sum_T.^2)./ numberOfOverlapPixels );
clear local_sum_T2;
denom_T = max(diff_local_sums_T,0); 
clear diff_local_sums_T;

denom = sqrt(denom_T .* denom_A);
clear denom_T denom_A;

xcorr_TA = xcorr2_fast(T,A);
clear A T;
numerator = xcorr_TA - local_sum_A .* local_sum_T ./ numberOfOverlapPixels;
clear xcorr_TA local_sum_A local_sum_T;

% denom is the sqrt of the product of positive numbers so it must be
% positive or zero.  Therefore, the only danger in dividing the numerator
% by the denominator is when dividing by zero. We know denom_T~=0 from
% input parsing; so denom is only zero where denom_A is zero, and in these
% locations, C is also zero.
C = zeros(size(numerator));
tol = 1000*eps( max(abs(denom(:))) );
i_nonzero = find(denom > tol);
C(i_nonzero) = numerator(i_nonzero) ./ denom(i_nonzero);
clear numerator denom;

% Remove the border values since they result from calculations using very
% few pixels and are thus statistically unstable.
% By default, requiredNumberOfOverlapPixels = 0, so C is not modified.
if( requiredNumberOfOverlapPixels > max(numberOfOverlapPixels(:)) )
    error(['ERROR: requiredNumberOfOverlapPixels ' num2str(requiredNumberOfOverlapPixels) ...
    ' must not be greater than the maximum number of overlap pixels ' ...
    num2str(max(numberOfOverlapPixels(:))) '.']);
end
C(numberOfOverlapPixels < requiredNumberOfOverlapPixels) = 0;

end
%-------------------------------
% Function  local_sum
%
function local_sum_A = local_sum(A,m,n)

% This algorithm depends on precomputing running sums.

% If m,n are equal to the size of A, a faster method can be used for
% calculating the local sum.  Otherwise, the slower but more general method
% can be used.  The faster method is more than twice as fast and is also
% less memory intensive. 
if( m == size(A,1) && n == size(A,2) )
    s = cumsum(A,1);
    c = [s; repmat(s(end,:),m-1,1) - s(1:end-1,:)];
    s = cumsum(c,2);
    clear c;
    local_sum_A = [s, repmat(s(:,end),1,n-1) - s(:,1:end-1)];
else
    % Break the padding into parts to save on memory.
    B = zeros(size(A,1)+2*m,size(A,2));
    B(m+1:m+size(A,1),:) = A;
    s = cumsum(B,1);
    c = s(1+m:end-1,:)-s(1:end-m-1,:);
    d = zeros(size(c,1),size(c,2)+2*n);
    d(:,n+1:n+size(c,2)) = c;
    s = cumsum(d,2);
    local_sum_A = s(:,1+n:end-1)-s(:,1:end-n-1);
end
end

%-------------------------------
% Function  xcorr2_fast
%
function cross_corr = xcorr2_fast(T,A)

T_size = size(T);
A_size = size(A);
outsize = A_size + T_size - 1;

% Figure out when to use spatial domain vs. freq domain
conv_time = time_conv2(T_size,A_size); % 1 conv2
fft_time = 3*time_fft2(outsize); % 2 fft2 + 1 ifft2

if (conv_time < fft_time)
    cross_corr = conv2(rot90(T,2),A);
else
    cross_corr = freqxcorr(T,A,outsize);
end
end

%-------------------------------
% Function  freqxcorr
%
function xcorr_ab = freqxcorr(a,b,outsize)
  
% Find the next largest size that is a multiple of a combination of 2, 3,
% and/or 5.  This makes the FFT calculation much faster.
optimalSize(1) = FindClosestValidDimension(outsize(1));
optimalSize(2) = FindClosestValidDimension(outsize(2));

% Calculate correlation in frequency domain
Fa = fft2(rot90(a,2),optimalSize(1),optimalSize(2));
Fb = fft2(b,optimalSize(1),optimalSize(2));
xcorr_ab = real(ifft2(Fa .* Fb));

xcorr_ab = xcorr_ab(1:outsize(1),1:outsize(2));

end
%-------------------------------
% Function  time_conv2
%
function time = time_conv2(obssize,refsize)

% time a spatial domain convolution for 10-by-10 x 20-by-20 matrices

% a = ones(10);
% b = ones(20);
% mintime = 0.1;

% t1 = cputime;
% t2 = t1;
% k = 0;
% while (t2-t1)<mintime
%     c = conv2(a,b);
%     k = k + 1;
%     t2 = cputime;
% end
% t_total = (t2-t1)/k;

% % convolution time = K*prod(size(a))*prod(size(b))
% % t_total = K*10*10*20*20 = 40000*K
% K = t_total/40000;

% K was empirically calculated by the commented-out code above.
K = 2.7e-8; 
            
% convolution time = K*prod(obssize)*prod(refsize)
time =  K*prod(obssize)*prod(refsize);

end
%-------------------------------
% Function  time_fft2
%
function time = time_fft2(outsize)

% time a frequency domain convolution by timing two one-dimensional ffts

R = outsize(1);
S = outsize(2);

% Tr = time_fft(R);
% K_fft = Tr/(R*log(R)); 

% K_fft was empirically calculated by the 2 commented-out lines above.
K_fft = 3.3e-7; 
Tr = K_fft*R*log(R);

if S==R
    Ts = Tr;
else
%    Ts = time_fft(S);  % uncomment to estimate explicitly
   Ts = K_fft*S*log(S); 
end

time = S*Tr + R*Ts;

end
%-----------------------------------------------------------------------------
function [T, A, requiredNumberOfOverlapPixels] = ParseInputs(varargin)

if( nargin < 2 || nargin > 3 )
    error('ERROR: The number of arguments must be either 2 or 3.  Please see the documentation for details.');
end

T = varargin{1};
A = varargin{2};

if( nargin == 3 )
    requiredNumberOfOverlapPixels =  varargin{3};
else
    requiredNumberOfOverlapPixels = 0;
end

% The following requires the image processing toolbox, so it is commented
% out here for generality.
%iptcheckinput(T,{'logical','numeric'},{'real','nonsparse','2d','finite'},mfilename,'T',1)
%iptcheckinput(A,{'logical','numeric'},{'real','nonsparse','2d','finite'},mfilename,'A',2)

checkSizesTandA(T,A)

% See geck 342320. If either A or T has a minimum value which is negative, we
% need to shift the array so all values are positive to ensure numerically
% robust results for the normalized cross-correlation.
A = shiftData(A);
T = shiftData(T);

checkIfFlat(T);
end
%-----------------------------------------------------------------------------
function B = shiftData(A)

B = double(A);

is_unsigned = isa(A,'uint8') || isa(A,'uint16') || isa(A,'uint32');
if ~is_unsigned
    
    min_B = min(B(:)); 
    
    if min_B < 0
        B = B - min_B;
    end
    
end
end
%-----------------------------------------------------------------------------
function checkSizesTandA(T,A)

if numel(T) < 2
    eid = sprintf('Images:%s:invalidTemplate',mfilename);
    msg = 'TEMPLATE must contain at least 2 elements.';
    error(eid,'%s',msg);
end
end
%-----------------------------------------------------------------------------
function checkIfFlat(T)

if std(T(:)) == 0
    eid = sprintf('Images:%s:sameElementsInTemplate',mfilename);
    msg = 'The values of TEMPLATE cannot all be the same.';
    error(eid,'%s',msg);
end
end
%-----------------------------------------------------------------------------
function [newNumber] = FindClosestValidDimension(n)

% Find the closest valid dimension above the desired dimension.  This
% will be a combination of 2s, 3s, and 5s.

% Incrementally add 1 to the size until
% we reach a size that can be properly factored.
newNumber = n;
result = 0;
newNumber = newNumber - 1;
while( result ~= 1 )
    newNumber = newNumber + 1;
    result = FactorizeNumber(newNumber);
end
end
%-----------------------------------------------------------------------------
function [n] = FactorizeNumber(n)

for ifac = [2 3 5]
    while( rem(n,ifac) == 0 )
        n = n/ifac;
    end
end
end