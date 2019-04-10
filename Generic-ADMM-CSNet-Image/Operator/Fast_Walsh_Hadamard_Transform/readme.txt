************************************************************************
            Fast Walsh Hadamard Transform (Sequency Order)
************************************************************************

Copyright (C) 2009 Chengbo Li and Yin Zhang.



Introduction
====================
   
   fWHtrans is a C++ code implementing fast Walsh Hadamard transform 
(sequency order). ifWHtrans implements its inverse transform. They are
around 100 times faster than fwht.m and ifwht.m, which are standard functions
in Matlab R2008b to do the same thing. Users can also use both fWHtrans and 
ifWHtrans in Matlab after compiling fWHtrans.cpp into a Matlab "mex" file.


How To Use  
====================
For the first use, users should run warm_up.m, which would "mex" the file 
aotomatically. Users can also "mex" fWHtrans.cpp manually by type "mex -O 
fWHtrans.cpp" in the Matlab Command Window.


Then, users can call them as following:

               		y = fWHtrans(x)
 	   or       	y = ifWHtrans(x).


Both vectors and matrices are acceptable as input. If inputting matrices, the
fast Walsh Hadamard transform is applied column by column. Please be aware 
that the height (# of rows) of output may be bigger than the height of input.

     	height(y) = power(2, ceil( log2( height(x) ) ) )




Contact Information
=======================


Please feel free to e-mail us with any comments or suggestions. 
We are more than happy to hear that!

Chengbo Li	        cl9@rice.edu	        CAAM, Rice University	
Yin Zhang		yzhang@rice.edu		CAAM, Rice University


Copyright Notice
====================

Both fWHtrans and ifWHtrans are free, and you can redistribute it and/or 
modify it under the terms of the GNU General Public License as published by the 
Free Software Foundation.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details at
<http://www.gnu.org/licenses/>. 

