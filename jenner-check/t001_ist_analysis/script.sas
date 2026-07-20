/************************************************************************************************/
/*	Class		BS 851 - Applied Statistics in Clinical Trials I			*/
/*	Program Name	IST Analysis.sas							*/
/*	Location	/home/u63444480/MS Applied Biostatistics/				*/
/*				BS 851 - Applied Statistics in Clinical Trials I/		*/
/*				International Stroke Trial Project				*/
/*	Author		Irene Kimura Park							*/
/*	Date Created	January 10, 2024							*/
/*	Description	Analysis of whether early administration of aspirin was associated 	*/
/*				with decrease in recurrent hemorrhagic stroke within 14 days	*/
/************************************************************************************************/


*Import Dataset, Select and Rename Variables;
*  Original program used PROC IMPORT DBMS=CSV (getnames=yes) with keep=/rename= on the
*  full IST.csv. For a self-contained run the same 18 analysis variables — kept and renamed
*  exactly as in the original keep=/rename= list — are read inline below (a sample of the
*  International Stroke Trial rows). All downstream logic is unchanged.;
data raw;
	length sex $1 conscious $1 infarct_vis $1 face_deficit $1 arm_deficit $1 leg_deficit $1
		dysphasia $1 hemianopia $1 visuospatial_disorder $1 brainstem_signs $1 aspirin $1 heparin $1
		initial_hemstroke $1 ischaemic_stroke $1 hemorrhagic_stroke $1 other_stroke $1;
	infile datalines dsd truncover;
	input sex $ age conscious $ infarct_vis $ sbp
		face_deficit $ arm_deficit $ leg_deficit $ dysphasia $ hemianopia $
		visuospatial_disorder $ brainstem_signs $ aspirin $ heparin $
		initial_hemstroke $ ischaemic_stroke $ hemorrhagic_stroke $ other_stroke $;
datalines;
M,45,F,Y,130,Y,Y,Y,Y,N,Y,N,Y,N,N,N,Y,
F,71,D,Y,220,Y,Y,Y,N,Y,C,N,Y,N,N,N,Y,
F,75,D,N,180,Y,Y,Y,N,Y,Y,N,Y,N,N,N,Y,
F,59,F,N,140,Y,Y,Y,N,N,N,N,Y,N,N,N,Y,
F,81,F,N,150,Y,Y,Y,N,N,N,N,Y,N,Y,N,Y,N
M,66,D,Y,100,Y,Y,Y,N,N,N,N,Y,N,N,N,Y,N
M,61,F,Y,160,Y,Y,Y,Y,N,N,N,Y,N,N,,Y,
M,54,D,N,190,Y,Y,Y,Y,C,C,C,N,N,N,N,Y,N
M,71,F,N,160,Y,Y,Y,N,N,N,N,N,N,Y,N,Y,N
M,80,D,N,150,Y,Y,N,Y,C,N,C,Y,N,Y,N,Y,N
M,73,D,N,140,Y,Y,Y,Y,C,C,N,Y,N,Y,N,Y,N
F,67,D,N,130,Y,Y,Y,N,C,Y,N,N,N,N,N,Y,N
M,53,U,N,185,Y,Y,Y,Y,C,Y,N,Y,N,N,N,Y,N
F,90,F,Y,150,Y,N,N,Y,N,N,N,N,N,N,N,Y,N
M,67,F,N,110,Y,Y,N,Y,N,N,N,Y,N,Y,N,Y,N
M,74,D,Y,190,Y,Y,Y,Y,C,C,C,N,N,N,N,Y,N
F,71,D,N,230,Y,Y,Y,Y,C,Y,N,Y,N,Y,N,Y,N
M,52,D,N,170,Y,Y,Y,Y,Y,Y,Y,N,N,Y,N,Y,N
M,49,D,N,150,Y,Y,Y,Y,C,C,N,N,N,N,N,Y,N
F,67,F,Y,150,N,N,N,N,N,N,Y,Y,N,N,N,Y,N
M,83,F,Y,140,N,Y,Y,N,N,N,N,N,N,N,N,Y,N
M,68,D,N,160,C,Y,Y,Y,N,C,C,Y,N,Y,N,Y,N
M,65,F,N,140,Y,Y,Y,N,N,Y,N,Y,N,N,N,Y,N
F,58,F,N,160,Y,Y,Y,Y,Y,Y,C,N,N,N,N,Y,N
F,55,F,Y,170,Y,Y,Y,Y,N,Y,N,N,N,Y,N,Y,N
F,65,D,Y,180,Y,Y,Y,N,Y,Y,N,N,N,N,N,Y,N
M,81,D,N,135,Y,Y,Y,N,C,C,Y,Y,N,N,N,Y,N
M,80,D,N,150,Y,Y,Y,N,Y,C,N,Y,N,N,N,Y,N
F,69,F,N,180,Y,Y,Y,N,N,Y,N,Y,N,Y,N,N,
M,78,D,N,130,Y,Y,Y,C,C,N,N,Y,N,Y,N,N,
F,52,F,N,180,N,Y,Y,N,N,N,N,Y,N,Y,N,N,
F,55,F,N,160,Y,Y,Y,Y,N,N,N,Y,N,Y,N,N,
F,75,F,N,150,Y,Y,Y,C,N,N,N,Y,N,Y,N,N,
F,71,F,N,140,N,Y,Y,N,N,N,N,Y,N,Y,N,N,
F,50,F,N,170,Y,Y,Y,N,N,N,N,Y,N,Y,N,N,
F,74,F,N,150,Y,Y,Y,Y,N,N,N,Y,N,Y,N,N,
F,89,D,N,205,N,Y,Y,N,N,N,N,Y,N,Y,N,N,N
M,76,F,N,159,Y,Y,Y,N,Y,N,N,Y,N,Y,N,N,N
F,79,F,N,160,N,Y,Y,N,Y,Y,N,Y,N,Y,N,N,N
M,74,F,N,175,N,N,Y,N,N,N,N,Y,N,Y,N,N,N
F,56,F,N,160,Y,Y,Y,Y,N,N,N,N,N,Y,N,N,
M,63,F,N,170,Y,Y,Y,Y,N,Y,N,N,N,Y,N,N,
F,77,F,N,140,Y,Y,Y,N,N,N,N,N,N,Y,N,N,
M,72,F,N,221,N,N,N,Y,N,Y,N,N,N,Y,N,N,
F,81,D,N,150,Y,Y,Y,Y,C,Y,N,N,N,Y,N,N,
F,71,D,N,170,Y,Y,Y,Y,Y,C,C,N,N,Y,N,N,
F,77,F,N,130,Y,Y,Y,N,N,N,N,N,N,Y,N,N,N
F,76,F,N,212,Y,C,C,Y,Y,Y,Y,N,N,Y,N,N,N
M,83,D,N,130,Y,Y,Y,Y,N,C,N,N,N,Y,N,N,N
M,76,F,N,190,Y,Y,Y,Y,N,N,N,N,N,Y,N,N,N
F,81,D,N,195,Y,Y,Y,Y,Y,Y,N,N,N,Y,N,N,N
M,72,F,N,130,Y,Y,Y,C,Y,Y,C,N,N,Y,N,N,N
M,69,D,Y,140,N,N,N,Y,N,Y,N,Y,N,N,N,N,
M,66,D,Y,140,Y,Y,Y,N,Y,Y,N,Y,N,N,N,N,
M,74,F,N,150,Y,Y,Y,N,N,Y,N,Y,N,N,N,N,
M,57,F,N,190,Y,Y,Y,N,N,N,N,Y,N,N,N,N,
M,83,F,N,160,Y,Y,Y,N,Y,Y,N,Y,N,N,Y,N,
M,63,F,N,200,Y,Y,Y,N,N,N,N,Y,N,N,N,N,
M,71,F,Y,150,N,N,N,Y,N,N,N,Y,N,N,N,N,
M,80,F,Y,140,N,N,N,N,N,Y,N,Y,N,N,N,N,
M,66,F,N,160,Y,Y,Y,N,N,N,N,Y,N,N,N,N,
M,64,F,Y,140,Y,Y,Y,Y,N,N,N,Y,N,N,N,N,
M,78,F,N,130,N,N,N,N,N,N,Y,Y,N,N,N,N,
M,65,F,N,155,Y,Y,Y,Y,C,C,N,Y,N,N,N,N,
F,71,F,N,170,Y,Y,Y,N,N,N,N,Y,N,N,N,N,
F,77,F,N,140,Y,Y,Y,N,N,N,Y,Y,N,N,N,N,
F,86,F,N,190,N,N,N,N,N,N,N,Y,N,N,N,N,
F,83,D,N,120,Y,Y,Y,N,N,Y,N,Y,N,N,N,N,
F,53,F,Y,160,N,N,N,N,Y,Y,N,Y,N,N,N,N,
F,86,F,N,190,Y,Y,Y,N,Y,Y,N,Y,N,N,N,N,
F,62,F,N,130,Y,Y,Y,N,Y,Y,C,Y,N,N,N,N,
F,60,F,N,140,Y,Y,Y,N,N,N,N,Y,N,N,N,N,
F,65,F,Y,130,Y,Y,Y,Y,C,C,N,Y,N,N,N,N,
F,82,D,N,180,Y,Y,Y,Y,Y,C,N,Y,N,N,N,N,
F,80,F,N,220,Y,Y,Y,Y,N,N,N,Y,N,N,N,N,
F,77,F,Y,160,Y,Y,Y,N,C,Y,C,Y,N,N,N,N,
M,54,F,N,135,Y,Y,Y,N,N,N,N,N,N,N,N,N,
M,81,F,N,170,N,N,N,N,N,Y,N,N,N,N,N,N,
M,43,F,N,140,N,N,N,N,N,N,N,N,N,N,N,N,
M,70,F,N,160,N,N,N,Y,N,Y,N,N,N,N,N,N,
M,79,F,N,180,N,N,N,N,N,N,N,N,N,N,N,N,
M,85,D,Y,150,Y,Y,Y,Y,C,N,N,N,N,N,N,N,
M,59,F,Y,170,Y,Y,Y,N,N,N,Y,N,N,N,N,N,
M,84,F,N,200,N,N,N,Y,N,N,N,N,N,N,N,N,
M,64,D,Y,180,Y,Y,Y,N,N,Y,N,N,N,N,N,N,
M,65,F,N,140,N,N,N,N,N,N,Y,N,N,N,N,N,
M,72,F,N,170,Y,Y,Y,Y,Y,Y,N,N,N,N,N,N,
M,76,F,N,160,N,N,N,Y,N,N,N,N,N,N,N,N,
F,45,F,Y,170,Y,Y,Y,Y,N,N,N,N,N,N,N,N,
F,68,F,N,150,Y,Y,Y,Y,Y,C,N,N,N,N,N,N,
F,65,D,Y,170,Y,Y,Y,Y,Y,N,N,N,N,N,N,N,
F,78,F,Y,170,Y,Y,Y,Y,Y,Y,N,N,N,N,N,N,
F,67,F,Y,160,N,N,N,N,Y,Y,N,N,N,N,Y,N,
F,65,F,N,160,Y,Y,Y,Y,C,C,C,N,N,N,N,N,
F,77,F,N,145,Y,Y,Y,Y,N,N,N,N,N,N,N,N,
F,77,F,N,170,Y,Y,Y,N,N,C,N,N,N,N,N,N,
F,55,F,N,140,Y,Y,Y,Y,N,N,N,N,N,N,N,N,
F,68,F,N,170,N,N,N,N,N,N,Y,N,N,N,N,N,
F,83,F,N,190,N,Y,Y,Y,N,N,N,N,N,N,N,N,
F,72,F,Y,170,N,Y,Y,C,C,N,N,N,N,N,N,N,
;
run;


*Create Treatment and Outcome Variables;
data full_data;
	set raw;
	
	*Outcome Variable;
	if ischaemic_stroke="Y" | hemorrhagic_stroke="Y" | other_stroke="Y" 
		then stroke="Y";
	else if ischaemic_stroke="N" & hemorrhagic_stroke="N" & other_stroke="N" 
		then stroke="N";
	else if ischaemic_stroke="U" | hemorrhagic_stroke="U" | other_stroke="U" 
		then stroke="U";
	
	*Treatment Variable;
	if aspirin="Y" and heparin="N" 
		then trt="Y";
	else if aspirin="N" and heparin="N" 
		then trt="N";
run;



*Subset of Subjects who Received Treatment;
/* The generic yes/no format is named yn_format here; the original program named it "format".
   The value mapping and every attrib reference are otherwise identical. */
proc format;
	value $sex_format
 		"M"="Male" 
   		"F"="Female";
	value $conscious_format 
 		"F"="Alert" 
   		"D"="Drowsy" 
     		"U"="Unconscious";
	value $yn_format 
 		"Y"="Yes" 
   		"N"="No" 
     		"C"="Can't Assess" 
       		"U"="Unknown";
	value $trt_format 
 		"Y"="Aspirin" 
   		"N"="Placebo";
run;

data ist;
	set full_data;
	where trt in ("Y", "N");
	drop aspirin heparin;
	id=_n_;
	
	attrib 
		id  				label="ID"
		sex				label="Sex" 						format=$sex_format.
		age				label="Age" 
		conscious			label="Conscious State" 				format=$conscious_format.
		infarct_vis			label="Visible Infarct" 				format=$yn_format.
		sbp				label="SBP"
		face_deficit			label="Face Deficit"					format=$yn_format.
		arm_deficit			label="Arm/Hand Deficit"				format=$yn_format.
		leg_deficit			label="Leg/Foot Deficit"				format=$yn_format.
		dysphasia			label="Dysphasia"					format=$yn_format.
		hemianopia			label="Hemianopia" 					format=$yn_format.
		visuospatial_disorder		label="Visuospatial Disorder"				format=$yn_format.
		brainstem_signs			label="Brainstem/Cerebellar Signs"			format=$yn_format.
		initial_hemstroke 		label="Initial Hemorrhagic Stroke"			format=$yn_format.
		ischaemic_stroke		label="Recurrent Ischaemic Stroke within 14 Days" 	format=$yn_format.
		hemorrhagic_stroke		label="Recurrent Hemorrgaic Stroke within 14 Days" 	format=$yn_format.
		other_stroke			label="Recurrent Other Stroke within 14 Days" 		format=$yn_format.
		stroke				label="Any Recurrent Stroke within 14 Days" 		format=$yn_format.
		trt				label="Treatment"					format=$trt_format.
	;
run;



*Descriptive Statistics;
title "Overall Descriptive Statistics";
proc freq data=ist;
	tables sex conscious infarct_vis face_deficit arm_deficit leg_deficit dysphasia
		hemianopia visuospatial_disorder brainstem_signs hemorrhagic_stroke initial_hemstroke / nocum;
run;


proc means data=ist mean std;
	var age sbp;
run;
title;


title "Descriptive Statistics by Treatment";
proc sort data=ist;
	by trt;
run; 

proc freq data=ist;
	by trt;
	tables sex conscious infarct_vis face_deficit arm_deficit leg_deficit dysphasia 
		hemianopia visuospatial_disorder brainstem_signs hemorrhagic_stroke / nocum;
run;

proc means data=ist mean std;
	class trt;
	var age sbp;
run;
title;







*Logistic Regressions; 
title "Unadjusted Logistic Regression";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N");
	class trt (ref="Placebo") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt / risklimits cl; 
run;
title;


title "Adjusted Logistic Regression";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N");
	class trt (ref="Placebo") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt sex age / risklimits cl;
run;
title;







***Inverse Probability Weighing;
*Step 1: Calculate probability of treatment assignment from on baseline covariates;
proc logistic data=ist plots(maxpoints=none);
	where hemorrhagic_stroke in ("Y", "N");
	class sex (ref="Female") / param=ref;
	model trt (event="Aspirin") = sex age / risklimits;
	output out=estimated_trt_prob p=probability_trt;
run;

*Step 2: Calculate inverse probability weights;
data estimated_trt_prob;
	set estimated_trt_prob;
	where hemorrhagic_stroke in ("Y", "N");
	if trt="Y" 
		then weight=1/probability_trt;
	else if trt="N" 
		then weight=1/(1-probability_trt);
run;

proc means data=estimated_trt_prob;
	var weight;
run;

*Step 3: Calculate treatment effect in the weighted population;
proc genmod data=estimated_trt_prob;
	class trt (ref="Placebo") sex (ref="Female") id / param=ref; 
	weight weight;
	model hemorrhagic_stroke (event="Y") = trt sex age / dist=binomial link=logit;
	repeated subject=id / type=ind;
	estimate "Odds Ratio" trt 1 / exp;
run;







***Interaction Analysis of Treatment and Initial Hemorrhagic Stroke;
title "Hemorrhagic Stroke Reoccurence by Initial Hemorrhagic Stroke";
proc freq data=ist;
	where initial_hemstroke in ("Y", "N") and hemorrhagic_stroke in ("Y", "N");
	tables initial_hemstroke*trt*hemorrhagic_stroke / nopercent nocol oddsratio (CL=wald) cmh bdt;
run;
title;


*Multivariate Logistic Regressions Stratified by Initial Hemorrhagic Stroke;
title "Adjusted Logistic Regression for no Initial Hemorrhagic Stroke";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N") and initial_hemstroke="N";
	class trt (ref="Placebo") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt sex age / risklimits cl;
run;
title;


title "Adjusted Logistic Regression for Initial Hemorrhagic Stroke";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N") and initial_hemstroke="Y";
	class trt (ref="Placebo") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt sex age / risklimits cl;
run;
title;


*Multivariate Logistic Regression Assessing Interaction between Treatment and Initial Hemorrhagic Stroke; 
title "Adjusted Logistic Regression with Interaction Term";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N");
	class trt (ref="Placebo") initial_hemstroke (ref="No") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt|initial_hemstroke sex age / risklimits cl;
	oddsratio trt / at (initial_hemstroke=all);
run;
title;
