libname IVOL "C:\Users\wangjohn\Desktop\Yu Jianfeng\IVOL";

%let wrds = wrds-cloud.wharton.upenn.edu 4016;
 options comamid=TCP remote=WRDS;
 signon username=_prompt_;
 rsubmit;

 %let begindate= '01jan1987'd;
 %let enddate= '31dec1990'd;


data msex1;
set crsp.dsf(keep=permno date ret);
where date between &begindate and &enddate;
run;

proc sort data=msex1;by date permno; 
run;

*merge½øÈ¥factors;
proc sql;
create table merged as
select a.*, b.mktrf, b.smb, b.hml from msex1 as a, ff.factors_daily as b
where a.date=b.date;
quit;

data merged2;
set merged;
year=year(date);
month=month(date);
run;

%macro ivolcal;
%do yy=1987 %to 1990;
%do mm=1 %to 12;

/*%let yy=1987;*/
/*%let mm=1;*/
data temp;
set merged2;
where year=&yy and month=&mm;
run;

proc sort data=temp;by permno;run;

proc sql;
create table temp2 as
select * from temp
group by permno
having count(*) >=10;
quit;

proc reg data=temp edf noprint outest=_stats;
by permno;
model ret= mktrf smb hml;
quit;

data _stats; set _stats;
if _rsq_=. then delete;
label _rmse_ = " "; rename _rmse_=Idrisk_std;
year=&yy; month=&mm;
keep permno _rmse_ year month;
run;

proc append base=_idvol data=_stats force;run;

%end;
%end;
%mend ivolcal;

%ivolcal;

proc download data=_idvol  out=idvolall;
run;
endrsubmit;
