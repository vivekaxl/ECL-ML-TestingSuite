﻿/* Example of how to use ConcordV1 is ecl 
*/

IMPORT ML;
IMPORT ML.Mat as Mat;

realdata := RECORD
   REAL8 val;
END;

// function that transforms a set of reals to mat.types.element. xx is the number of rows (observations).

Mat.Types.Element cvt(realdata v, UNSIGNED c, INTEGER xx) := TRANSFORM
      SELF.x := ((c-1) % xx)+1;
      SELF.y := ((c-1) DIV xx)+1;
      SELF.value := v.val;
END;

MaxAbsDff(DATASET(Mat.Types.Element) zz1, DATASET(Mat.Types.Element) zz2) := FUNCTION
             Mat.Types.Element MatAbsDifference(Mat.Types.Element x1, Mat.Types.Element y1) := TRANSFORM
                        SELF.x:=x1.x;  
                        SELF.y:=x1.y;
                   SELF.value:=ABS(x1.value-y1.value);
             END;
             result := JOIN(zz1,zz2,(LEFT.x=RIGHT.x) AND (LEFT.y=RIGHT.y),MatAbsDifference(LEFT,RIGHT),FULL OUTER);
             result2 := MAX(result,value);
             RETURN result2;
END;

Y := [-1.41475249,1.41466243,-0.79863385,1.12579407,1.07855528,-3.1365708,0.48288317,0.8198658,0.52711916,-0.23421255,-0.63047891,1.4735583,-0.44503211,-1.09844352,0.59702343,-0.59727052,-0.05051723,-0.69952651,1.50914881,1.3671432,-2.16315909,1.09033166,-0.21520686,-0.30390093,0.77522201,0.79689043,2.4941717,0.63806628,-1.411043,-0.25541184,-0.10112761,-1.88456688,-1.05488273,1.01183449,-2.17456631,0.44158509,-0.03275438,-2.04577276,0.03264061,1.99558394,-0.3767668,-0.23536897,-1.48947529,2.24071624,-0.4698244,-1.86652102,-0.78334625,-0.87179585,-0.97585532,-1.35569894,0.31895739,2.59777697,0.64794126,-2.72715187,0.04755478,-0.25526243,0.15658456,-0.94849606,-0.09590263,-1.39379704,0.96481106,-0.37074597,2.1929305,-0.03708266,-1.21552136,1.26525572,-0.25180985,0.77405663,-1.01418833,2.57901465,-2.09679017,1.4662929,1.21158671,-0.34104358,0.57568564,0.70572011,1.64041032,-0.04122645,-0.65001117,-1.08784992,2.63788594,0.82868602,1.53273536,-0.33957508,-0.51342557,-2.38753443,-0.51002291,-1.57187635,0.28238058,-0.63762294,1.05197489,1.76835968,0.33911894,-1.77157082,1.72017505,2.36880812,-0.62195704,-0.674248,1.67882197,1.16103458,0.53081737,-0.27046652,-2.96614302,-1.75349413,-1.43327408,-0.21945592,0.18829463,0.46449005,1.91147547,-2.51517658,-1.27387704,-0.73782262,-0.04296264,1.47573109,0.85266802,-0.57549108,-0.45860908,-2.0446762,0.79559452,1.83723905,-0.05576841,0.43412732,-0.66830601,0.69434856,0.28338356,-0.35216934,-0.04256768,-1.18345715,1.31257972,2.00454734,0.27403309,1.07270652,-2.54893258,-0.58321069,-0.57483895,0.39706665,-2.27975416,-0.34913452,0.84336488,1.52624551,-1.88882158,-1.80392141,-2.17977323,0.85345658,1.17461634,0.4366248,0.31725804,3.02169479,-3.06929154,-0.304033];

omegahatreal := [1.069419907540993,-0.5130315373120118,0.1634488258605444,0.0,0.0,0.0,0.0,-0.07715385153548902,-0.04571242743667089,0.0,-0.5130315373120118,1.182633157588768,0.0,-0.0,-0.0,0.1438746831516246,0.0,0.0,-0.1188280122768702,-0.1041719196511743,0.1634488258605444,0.0,0.8709272241095454,-0.0,-0.0,0.0,0.0256428389389821,-0.2030665866729024,-0.2122915548983389,0.0,0.0,-0.0,-0.0,0.8000034854160089,-0.0,-0.0,0.0,0.01905285603381824,0.0,0.1086947752905236,0.0,-0.0,-0.0,-0.0,0.7708230820672816,-0.06071494085734873,0.0,-0.0,0.0,-0.0,0.0,0.1438746831516246,0.0,-0.0,-0.06071494085734873,1.12645166789413,-0.1199780606734757,0.0,0.0,0.4494132434128593,0.0,0.0,0.0256428389389821,0.0,0.0,-0.1199780606734757,0.7460787864757569,0.0008276946922445386,-0.3642852094741334,0.0,-0.07715385153548902,0.0,-0.2030665866729024,0.01905285603381824,-0.0,0.0,0.0008276946922445386,0.8665517149916113,-0.07279827211125822,0.01027807965413012,-0.04571242743667089,-0.1188280122768702,-0.2122915548983389,0.0,0.0,0.0,-0.3642852094741334,-0.07279827211125822,1.221748805159646,-0.0,0.0,-0.1041719196511743,0.0,0.1086947752905236,-0.0,0.4494132434128593,0.0,0.01027807965413012,-0.0,0.7862049754863583];
omegahat := PROJECT(DATASET(omegahatreal, realdata), cvt(LEFT, COUNTER, 10));

//implementing concordV1 with data = Y as above, n = 15, p = 10, tolerance of 10^(-5) and lambda = 10

Ydata := PROJECT(DATASET(Y, realdata), cvt(LEFT, COUNTER, 15));
eclestimate1:= ML.PopulationEstimate.ConcordV2Blas(Y:=Ydata,lambda:=10,tol:=0.00001);
OUTPUT(MaxAbsDff(eclestimate1,omegahat));