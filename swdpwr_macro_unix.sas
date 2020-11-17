/*==================================================================================
   Macro SWDPWR
  This macro can be used for power calculation of stepped wedge cluster randomized trials.
  Written by: Jiachen Chen (jiachen.chen@yale.edu)
===================================================================================*/
%macro swdpwr
(
 K=, /*number of participants at each time period in a cluster*/
 design=, /*I*J dimensional data set that describes the study design (control 0, intervention 1), I is the number of clusters, J is the number of time periods*/
 family = "binomial", /*family of responses, specify family="gaussian" for continuous outcome and family="binomial" for binary outcome, with default value of "binomial"*/
 model = "conditional", /*choose from conditional model (model="conditional") and marginal model (model="marginal"), with default value of applying conditional model*/
 link = "identity", /*choose link function from link="identity", link="log" and link="logit", with default value of identity link*/
 type = "cross-sectional", /*choose the study type, specify type="cohort" for closed cohort study and type="crosssectional" for cross-sectional study, with default value of cross-sectional study*/
 meanresponse_start = NA, /*the anticipated mean response rate in the control group at the start of the study*/
 meanresponse_end0 = meanresponse_start, /*the anticipated mean response rate in the control group at the end of the study, with default value equals to meanresponse_start (no time effects)*/
 meanresponse_end1 = NA, /*the anticipated mean response rate in the intervention group at the end of the study*/
 effectsize_beta = NA, /*the anticipated effect size, just omit this parameter if you don’t need to specify it. In all scenarios, you can choose to specify the three parameters about mean responses without specifying this effect size, or alternatively specify meanresponse_start, meanresponse_end0 and this effect size. For continuous outcomes, users can conduct power calculations by only specifying this parameter without the above three parameters about mean responses (as the power is dependent just on it), then calculation will be implemented assuming scenarios without time effects. If you would consider scenarios with time effects and continuous outcomes, please specify meanresponse_start, meanresponse_end0 (donot require accurate information, just make sure they are not equal) and this effectsize_beta.*/
 sigma2 = 0, /*marginal variance of the outcome (only needed for continuous outcomes and should not be an input for binary outcomes), with default value of 0.*/
 typeIerror = 0.05, /*two-sided type I error, with default value of 0.05*/
 alpha0 = 0.1, /*within-period correlation, with default value of 0.1*/
 alpha1 = alpha0/2, /*between-period correlation, with default value of alpha0/2*/
 alpha2 = NA /*within-individual correlation, should not be an input under cross-sectional designs although it is numerically identical to alpha1 in this scenario by definition*/
);


%if &meanresponse_start=NA %then %let meanresponse_start=99.9;
%if &meanresponse_end1=NA %then %let meanresponse_end1=99.9;
%if %sysevalf(&effectsize_beta=NA, boolean) %then %let effectsize_beta=99.9;
%if &alpha2=NA %then %let alpha2=99.9;


/*import study design matrix*/
data X_in;
set &design;
length count 8;
count=0;
do until (count ge numofclusters);
output;
count=count+1;
end;
drop count numofclusters;
run;


/*Initialize for combination
data XX;
set X_in(rename=(t1=name t2=para));
run;*/
data XX;
set X_in;
name=put(time1,4.);
para=put(time2,4.);
drop time1 time2;
run;

data roww; set XX;
 I=_N_;
 keep I;
run;

data row; set roww nobs=final;
if _n_=final;
run;

proc transpose data =XX out = tXX;
var _all_;
run;

data columnn; set tXX;
 J=_N_;
 keep J;
run;

data column; set columnn nobs=final;
if _n_=final;
run;


proc transpose data =row out = rowI_old;
var _all_;
run;

data rowI;set rowI_old(rename = (COL1 = COL1_old));
COL1 = put(COL1_old,8.);
drop COL1_old;
run;

proc transpose data =column out = columnJ_old;
var _all_;
run;

data columnJ;set columnJ_old(rename = (COL1 = COL1_old));
COL1 = put(COL1_old,8.);
drop COL1_old;
run;

/*write the input txt for Fortran*/
data covpara;
K=&K;
if &family = 'gaussian' then res=1;
else if &family= 'binomial' then res=2;
else res=0;
if &model = 'marginal' then opt= 2;
else if &model = 'conditional' then opt=1;
else opt=0;
if &link= 'identity' then link=1;
else if &link='log' then link=2;
else if &link='logit' then link=3;
else link=0;
if &type='cohort' then type=1;
else if &type='cross-sectional' then type=2;
else type=0;
meanresponse_start=&meanresponse_start;
meanresponse_end0=&meanresponse_end0;
meanresponse_end1=&meanresponse_end1;
effectsize_beta=&effectsize_beta;
sigma2=&sigma2;
typeone=&typeIerror;
alpha0=&alpha0;
alpha1=&alpha1;
alpha2=&alpha2;
X_in="=";

run;

proc transpose data =covpara out = se1;
var K res opt link type meanresponse_start meanresponse_end0 meanresponse_end1 effectsize_beta sigma2 typeone alpha0 alpha1 alpha2 X_in;
run;



data try;
I=scan('(I=)' ,1);
J=scan('(J=)' ,1);
K= scan('(K=)' ,1);
res= scan('(res=)' ,1);
opt= scan('(opt=)' ,1);
link= scan('(link=)' ,1);
type= scan('(type=)' ,1);
meanresponse_start= scan('(meanresponse_start=)' ,1);
meanresponse_end0= scan('(meanresponse_end0=)' ,1);
meanresponse_end1= scan('(meanresponse_end1=)' ,1);
effectsize_beta= scan('(effectsize_beta=)' ,1);
sigma2= scan('(sigma2=)' ,1);
typeone= scan('(typeone=)' ,1);
alpha0= scan('(alpha0=)' ,1);
alpha1= scan('(alpha1=)' ,1);
alpha2= scan('(alpha2=)' ,1);
X_in =scan('(X_in)' ,1);
run;



proc transpose data = try out = temp3;
var I J K res opt link type meanresponse_start meanresponse_end0 meanresponse_end1 effectsize_beta sigma2 typeone alpha0 alpha1 alpha2 X_in;
run;

data part;
set se1 rowI columnJ;
run;

data part1;
set temp3(rename=(COL1=name));
run;
data part2;
set part(rename=(COL1=para));
run;



proc sort data=part1;
by _NAME_;
run;
proc sort data=part2;
by _NAME_;
run;

data mer;
merge part1 part2;
by _NAME_;
run;

proc sort data=mer out=sorted;
by  para;
run;

data fin;
set sorted;
keep name para;
run;

data new;
set fin XX;
run;

PROC EXPORT DATA= new
            OUTFILE= "./in.txt"
            DBMS=DLM REPLACE;
     DELIMITER='20'x;
PUTNAMES=NO;
RUN;



%let mydir=./swdpower/; /*modify this to the directory to the downloaded exec file swdpwr*/

%let outfile=./out.txt ;

%let myprog=&mydir.swdpwr;
    x "&myprog ./in.txt &outfile";

/*Output the result*/
data output; 
    infile "&outfile"  dlm = '```'; 
    length Result $ 32767; 
    input Result; 
run; 

proc print;
data output;
run;

/*x "rm -f .\in.txt";
x "rm -f &outfile";*/

x "rm ./in.txt";
x "rm &outfile";

%mend swdpwr;



/*test examples*/
/*need to download swdpwr file swdpwr to your own computer*/
/*need to modify line %let mydir=./swdpower/; with proper directory to swdpwr on your own computer*/

/*A cross-sectional design with 12 clusters, 3 periods and binary outcomes applying conditional model. alpha2 should not be specified, as the current version does not support power calculation using conditional models with binary outcomes in a cohort design.*/
/*create a 12*3 matrix which describes the study design, 0 means control status, 1 means intervention status*/
data  dataset;
input numofclusters time1 time2 time3;
cards;
6 0 1 1
6 0 0 1
;
run;
/*specify meanresponse_start, meanresponse_end0 and meanresponse_end1*/
%swdpwr(K = 30, design = dataset, family = "binomial", model = "conditional", link = "logit", type = "cross-sectional", meanresponse_start = 0.2, meanresponse_end0 = 0.3, meanresponse_end1 = 0.4, typeIerror = 0.05, alpha0 = 0.01, alpha1 = 0.01)

/*specify meanresponse_start, meanresponse_end0 and effectsize_beta*/
%swdpwr(K = 30, design = dataset, family = "binomial", model = "conditional", link = "logit", type = "cross-sectional", meanresponse_start = 0.2, meanresponse_end0 = 0.3, effectsize_beta = 0.6, typeIerror = 0.05, alpha0 = 0.01, alpha1 = 0.01)

/*A cohort design with 8 clusters, 3 periods and continuous outcomes applying marginal model. sigma2 should be specified, as continuous outcomes require marginal variance in calculation. */
/*create a 8*3 matrix which describes the study design, 0 means control status, 1 means intervention status*/
data dataset;
input numofclusters time1 time2 time3; 
cards;
4 0 1 1
4 0 0 1
;
run;

/*specify meanresponse_start, meanresponse_end0 and meanresponse_end1*/
%swdpwr(K = 24, design = dataset, family = "gaussian", model = "marginal", link = "identity", type = "cohort", meanresponse_start = 0.1, meanresponse_end0 = 0.2,  meanresponse_end1 = 0.4, sigma2 = 0.095, typeIerror = 0.05, alpha0 = 0.03, alpha1 = 0.015, alpha2 = 0.2)

/*specify effectsize_beta only, then the program runs assuming no time effects*/
%swdpwr(K = 24, design = dataset, family = "gaussian", model = "marginal", link = "identity", type = "cohort",effectsize_beta=0.3, sigma2 = 0.095, typeIerror = 0.05, alpha0 = 0.03, alpha1 = 0.015, alpha2 = 0.2)


