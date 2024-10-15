function test_fitswrite
flnm = 'test.fits';
im = rand(10, 10);
import matlab.io.*

try
    fptr = fits.createFile(flnm);
catch 
    delete(flnm);
    fptr = fits.createFile(flnm);
end

[rows,cols,dims] = size(im);

fits.createImg(fptr,'double_img',[rows,cols,dims]);
fits.writeImg(fptr,im);

fits.closeFile(fptr);

end