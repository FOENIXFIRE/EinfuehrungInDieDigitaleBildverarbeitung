%Manuel Leutschacher


function[output, outputname] = matching(input)
%MATCHING Takes input picture and returns the matching brand logo and name
%   Loads the logos from our database and checks their correlation to the
%   input picture via the normxcorr2 method and returns the logo and the name
%   with the highest correlation-value.

imd = imageDatastore('logos','FileExtensions',{'.png'}, 'LabelSource' ,'foldernames', 'IncludeSubfolders', true);
% Sources for the Logo-Database:
% Skoda: https://de.wikipedia.org/wiki/Datei:Skoda_Logo.svg
% Citroen: https://www.pinterest.at/pin/15973773656227428/
% Fiat: https://www.nicepng.com/ourpic/u2e6w7y3w7y3i1o0_fiat-logo-fiat-zeichen-vektor-bedeutendes-logo-und/
% Ford: https://automarken-logos.com/ford-logo/
% Honda: https://freepngimg.com/png/36643-honda-logo
% Hyundai: https://www.pngfind.com/mpng/iixThho_hyundai-logo-png-hyundai-emblem-transparent-png/
% Landrover: https://www.pngegg.com/de/search?q=Land
% Mercedes: https://car-pediem.biz/partner/mercedes-benz-logo-png-file/
% Opel: https://de.wikipedia.org/wiki/Datei:Opel-Logo-2011-Vector.svg
% Porsche: https://de.wikipedia.org/wiki/Datei:Porsche_Wappen.svg
% Seat: https://www.pngfind.com/mpng/hwoxwJi_seat-logo-seat-hd-png-download/
% BMW: https://www.b-m-automation.de/project/bmw/
% Suzuki: https://www.nicepng.com/ourpic/u2w7e6q8a9e6t4o0_suzuki-logo-transparent-png/
% VW: https://de.cleanpng.com/png-iep6ow/

c = countEachLabel(imd);
a = c.Count;
aa = sum(a);

max1 = 0;
max2 = 0;



test = input;
    

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

[rowsL, colsL, c] = size(test);

%Calculate correlation
cc = normxcorr2_self(logo, test);


[RowCC, ColCc] = size(cc);

[max_cc, imax] = max(abs(cc(:)));
%asdf = max_cc

if (max1 <= max_cc)
    max1 = max_cc;
    max2 = i;
end
   
end

%gets the brand by checking the folder the found picture is from and
%the logo by taking the non perspectively distorted 
fullFileNames = vertcat(imd.Files);
[folder, baseFileNameNoExt, ext] = fileparts(fullFileNames{max2});
pic = imread(folder+"\1.png");

[asdf, name1] = fileparts(folder);

if (max1 > 0.5)
    outputname = name1;
    output = pic;
else
    outputname = "Brand not found";
    output = zeros(100);
end
end


function [C,numberOfOverlapPixels] = normxcorr2_self(varargin)
%NORMXCORR2_SELF Takes input pictures and returns their correlation
%values per pixel -> same as normxcorr2
%   At first it takes the input pictures and checks for errors,
%   then it calculates the localsums, then the correlation matrix and 
%   then it normalizes the values to get values between 0 and 1,
%   0 if the pixel has no correlation with the template, 1 if the
%   pixels nearby area is exactly the same.
%   Source: https://github.com/OpenPIV/openpiv-matlab/blob/master/normxcorr2_general.m

[T, A, requiredNumberOfOverlapPixels] = ParseInputs(varargin{:});

sizeA = size(A);
sizeT = size(T);


numberOfOverlapPixels = local_sum(ones(sizeA),sizeT(1),sizeT(2));

local_sum_A = local_sum(A,sizeT(1),sizeT(2));
local_sum_A2 = local_sum(A.*A,sizeT(1),sizeT(2));


diff_local_sums_A = ( local_sum_A2 - (local_sum_A.^2)./ numberOfOverlapPixels );
clear local_sum_A2;
denom_A = max(diff_local_sums_A,0); 
clear diff_local_sums_A;


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


C = zeros(size(numerator));
tol = 1000*eps( max(abs(denom(:))) );
i_nonzero = find(denom > tol);
C(i_nonzero) = numerator(i_nonzero) ./ denom(i_nonzero);
clear numerator denom;


if( requiredNumberOfOverlapPixels > max(numberOfOverlapPixels(:)) )
    error(['ERROR: requiredNumberOfOverlapPixels ' num2str(requiredNumberOfOverlapPixels) ...
    ' must not be greater than the maximum number of overlap pixels ' ...
    num2str(max(numberOfOverlapPixels(:))) '.']);
end
C(numberOfOverlapPixels < requiredNumberOfOverlapPixels) = 0;

end

function local_sum_A = local_sum(A,m,n)
%LOCAL_SUM computes local sums, by recomputing running sums
%   If m and n are the same size as A, there is a faster method used,
%   else, the slower route is taken

if( m == size(A,1) && n == size(A,2) )
    s = cumsum(A,1);
    c = [s; repmat(s(end,:),m-1,1) - s(1:end-1,:)];
    s = cumsum(c,2);
    clear c;
    local_sum_A = [s, repmat(s(:,end),1,n-1) - s(:,1:end-1)];
else
    % splitting padding -> saves memory.
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


function cross_corr = xcorr2_fast(T,A)
%XCORR2_FAST decides if there should be spatial or frequency
%domain used to make the algorithm faster.

T_size = size(T);
A_size = size(A);
outsize = A_size + T_size - 1;

%Using spatial domain vs. freq domain
conv_time = time_conv2(T_size,A_size); % 1 conv2
fft_time = 3*time_fft2(outsize); % 2 fft2 + 1 ifft2

if (conv_time < fft_time)
    cross_corr = conv2(rot90(T,2),A);
else
    cross_corr = freqxcorr(T,A,outsize);
end
end


function xcorr_ab = freqxcorr(a,b,outsize)
%FREQXCORR gets the optimal size, then calculates the
%correlation in the frequency domain and returns it

% Next biggest size wich is multiple of a combination of 2, 3,
% and/or 5. -> Makes FFT calculation much faster.
optimalSize(1) = FindClosestValidDimension(outsize(1));
optimalSize(2) = FindClosestValidDimension(outsize(2));

% Calculate correlation in frequency domain
Fa = fft2(rot90(a,2),optimalSize(1),optimalSize(2));
Fb = fft2(b,optimalSize(1),optimalSize(2));
xcorr_ab = real(ifft2(Fa .* Fb));

xcorr_ab = xcorr_ab(1:outsize(1),1:outsize(2));

end

function time = time_conv2(obssize,refsize)
%TIME_CONV2 times a spatial domain convolution for matrices
%10-by-10 x 20-by-20, code to calculate K is found here:
%https://github.com/OpenPIV/openpiv-matlab/blob/master/normxcorr2_general.m
K = 2.7e-8;
time =  K*prod(obssize)*prod(refsize);

end

function time = time_fft2(outsize)
%TIME_FFT2 times a frequency domain convolution trough timing two
%one dimensional ffts (Fast Fourier Transform), K_fft is calculated by
%time_fft(R)/(R*log(R))


R = outsize(1);
S = outsize(2);

K_fft = 3.3e-7; 
Tr = K_fft*R*log(R);

if S==R
    Ts = Tr;
else
   Ts = K_fft*S*log(S); 
end

time = S*Tr + R*Ts;

end
%-----------------------------------------------------------------------------
function [T, A, requiredNumberOfOverlapPixels] = ParseInputs(varargin)
%PARSEINPUTS checks the input for various properties which are not allowed 
%and result in errors. And shifts the input arrays to positve values.

if( nargin < 2 || nargin > 3 )
    error('ERROR: The number of arguments must be either 2 or 3.');
end

T = varargin{1};
A = varargin{2};

if( nargin == 3 )
    requiredNumberOfOverlapPixels =  varargin{3};
else
    requiredNumberOfOverlapPixels = 0;
end


checkSizesTandA(T,A)

%-> Shifting negative data to positive ones for robustness
A = shiftData(A);
T = shiftData(T);

checkIfFlat(T);
end
%-----------------------------------------------------------------------------
function B = shiftData(A)
%SHIFTDATA takes values and makes sure that there are no negative
%values by adding the minimum value if it is below 0
%-> ensures robust results for the norm. cross-corr.

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
%CHECKSIZESTAND checks if the Templateimage is big enough to be matched

if numel(T) < 2
    eid = sprintf('Images:%s:invalidTemplate',mfilename);
    msg = 'TEMPLATE must contain at least 2 elements.';
    error(eid,'%s',msg);
end
end
%-----------------------------------------------------------------------------
function checkIfFlat(T)
%CHECKIFFLAT returns an error if the input is only one color
%(black or white)

if std(T(:)) == 0
    eid = sprintf('Images:%s:sameElementsInTemplate',mfilename);
    msg = 'The values of TEMPLATE cannot all be the same.';
    error(eid,'%s',msg);
end
end
%-----------------------------------------------------------------------------
function [newNumber] = FindClosestValidDimension(n)
%FINDCLOSESTVALIDDIMENSION searches for the closest valid dimension above
%the desired one.
%   Adds 1 till we reach a size where it can be properly factored by the 
%   FactorizeNumber function.

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
%FACTORIZE NUMBER splits the input number into factors of
%2, 3 and 5
for ifac = [2 3 5]
    while( rem(n,ifac) == 0 )
        n = n/ifac;
    end
end
end