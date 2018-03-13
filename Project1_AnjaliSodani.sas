libname project1 "/home/asodan20/Project 1";

filename dataset "/home/asodan20/Project 1/project1_data_29.csv";
data project1.commodities;
 infile dataset dlm=',' firstobs= 9;
 input 	PALUM_USD	PBANSOP_USD	PBARL_USD	PBEEF_USD	PCOALAU_USD	PCOCO_USD	
 PCOFFOTM_USD	PCOFFROB_USD	PROIL_USD	PCOPP_USD	PCOTTIND_USD
 PFISH_USD	PGNUTS_USD	PHIDE_USD	PIORECR_USD	PLAMB_USD	PLEAD_USD	
 PLOGORE_USD	PLOGSK_USD	PMAIZMT_USD	PNGASEU_USD	PNGASJP_USD	
 PNGASUS_USD	PNICK_USD	POILAPSP_USD;
 run;
 
proc contents data = project1.commodities;
   title "Contents of the given file";
run;

proc means data = project1.commodities;
   title" Summary of the given file";
run;
 *As from the output we can see there are missing values so we will first deal with them.;
 *To find the missing value;
proc means data=project1.commodities n nmiss;
title "Variables with Missing values";
run;
* Variables PNGASEU_USD,PNGASJP_USD,PNGASUS_USD has missing values; 

* For the variable PNGASEU_USD, we will do the following analysis;
title 'Graph of PNGASEU_USD';
ods graphics off;
proc univariate data=project1.commodities;
   histogram PNGASEU_USD;
   var PNGASEU_USD;
run;
* Since the graph is not symmetric we will use median 
 instead of mean to replace the misisng values
 therefore replacing the missing values with 109.5500;
 

* For the variable PNGASJP_USD, we will do the following analysis;
title 'Graph of PNGASJP_USD ';
ods graphics off;
proc univariate data=project1.commodities;
   histogram PNGASJP_USD;
   var PNGASJP_USD;
run;
* Again the graph is not symmetric we will use median
 value 	128.8000 for replacing the missing values;
 
* For the variable PNGASUS_USD, we will do the following analysis; 
title 'Graph of PNGASUS_USD ';
ods graphics off;
proc univariate data=project1.commodities;
   histogram PNGASUS_USD;
   var PNGASUS_USD;
run;
* Again the graph is not symmetric we will use median
 value 101.4100 for replacing the missing values;

*Replacing all the missing values with medians;
data project1.NewCommodities;
  set project1.Commodities;
  if PNGASEU_USD = 'n.a.' then PNGASEU_USD = 109.5500;
  if PNGASJP_USD = 'n.a.' then PNGASJP_USD = 128.8000;
  if PNGASUS_USD = 'n.a.' then PNGASUS_USD = 101.4100;
run;
proc print data =project1.newcommodities;run;

/*Standardise data*/
proc standard data=project1.NewCommodities 
 out=project1.standarddata mean=0 std=1;
 var _numeric_;
run;

proc print data = project1.standarddata;

* correlation between the variables;
proc corr data=project1.standarddata;
 run;
 * check results with/without priors";
title "checking results after priors";
proc factor data=project1.standarddata rotate=varimax scree;
priors smc; 
run;



* Factor Analysis without rotation;
 ods graphics on;
 proc factor data = project1.standarddata 
 plot = SCREE reorder;
   TITLE "Factor Analysis without rotation";
   var PALUM_USD	PBANSOP_USD	PBARL_USD	PBEEF_USD	PCOALAU_USD	PCOCO_USD	
 PCOFFOTM_USD	PCOFFROB_USD	PROIL_USD	PCOPP_USD	PCOTTIND_USD
 PFISH_USD	PGNUTS_USD	PHIDE_USD	PIORECR_USD	PLAMB_USD	PLEAD_USD	
 PLOGORE_USD	PLOGSK_USD	PMAIZMT_USD	PNGASEU_USD	PNGASJP_USD	
 PNGASUS_USD	PNICK_USD	POILAPSP_USD;
 RUN;
ods graphics off;
* As we can see that without rotation, the number of factors= 3 since the eigenvalues of 
3 variables >1  and from the scree plot also we can see that. 
Therefore, we will retain three factors;


* With Rotation ;
* Firstly we will run one method for each rotation to see the correlation between
the factors;

*Running the Orthogonal rotation where rotation = varimax;
*To compare the output of factor patters, we can use the function fuzz
to see values only higher than 0.3 in factor loadings;

%let rotation = varimax;
ods graphics on;
PROC FACTOR DATA= project1.standarddata
            ROTATE=&rotation 
            reorder;
TITLE "Factor Analysis with &rotation Rotation";
RUN;
ods graphics off;

* Running the Oblique rotation
*Promax rotation;
%let rotation1= promax;
ods graphics on;
PROC FACTOR DATA= project1.standarddata 
            ROTATE=&rotation1  fuzz=0.3
             ;
   TITLE "Factor Analysis with &rotation1 Rotation";
RUN;
ods graphics off;


*Rotation = factorparsimax; 
%let rotation2=Factorparsimax;
ods graphics on;
PROC FACTOR DATA= project1.standarddata 
            Plot=SCREE 
            ROTATE=&rotation2
            reorder
           ;
   TITLE "Factor Analysis with &rotation2 Rotation";
RUN;
ods graphics off;















