
*code to create WDRS Roster;
options nofmterr symbolgen;

*  decided not to use this one - %let date_time = %sysfunc(compress(&SYSDATE&SYSTIME,%str(:)));
*Macro for today's date - to include in file names and Tag;
%let today = %sysfunc(today(),yymmddn8.);  *today’s date as yyyymmdd;
%put =====> today = &today;

*need to manually update the wdrs_to_crest file address;

PROC IMPORT OUT= WORK.wdrs 
            DATAFILE= "Y:\Confidential\DCHS\CDE\01_Linelists_Cross Coverage\Novel CoV\CREST\output\2021-04-23\1238\wdrs_to_crest_20210423_1225.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

*create export table for wdrs roster;

data tmp1 (keep = wdrs_event_id);
set work.wdrs;
if missing(investigation_start_date);
run;

data tmp2;
set work.tmp1;
INVESTIGATION_START_DATE = today();
format INVESTIGATION_START_DATE mmddyy10.;
put INVESTIGATION_START_DATE;
INVESTIGATOR='';
case_note=catx('',"Investigation start date” populated for all cases from LHJs participating in CREST via the “COVID-19 Updating Investigation start date” roster.");
label wdrs_event_id ='Case.CaseID' case_note='Case.Note';
run;


*export to csv with labels;
* run if morning - comment out if afternoon;
/*
 PROC EXPORT DATA= WORK.TMP2 
            OUTFILE= "Y:\Confidential\DCHS\CDE\01_Linelists_Cross Coverage\Novel CoV\CREST\output\InvestigationStartDate Roster\&yearmndy.AM_Covid19UpdatingInvestigationStartDate.csv" 
            DBMS=CSV LABEL REPLACE;
     PUTNAMES=YES;
RUN;
*/

* Run if afternoon - comment out if morning;
/*
 PROC EXPORT DATA= WORK.TMP2 
            OUTFILE= "Y:\Confidential\DCHS\CDE\01_Linelists_Cross Coverage\Novel CoV\CREST\output\InvestigationStartDate Roster\&today.PM_Covid19UpdatingInvestigationStartDate.csv" 
            DBMS=CSV LABEL REPLACE;
     PUTNAMES=YES;
RUN;
*/
