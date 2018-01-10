libname mylib "C:\Users\wangjohn\Desktop\replicate";

%let wrds = wrds-cloud.wharton.upenn.edu 4016;
 options comamid=TCP remote=WRDS;
 signon username=_prompt_;
 rsubmit;

 %let begindate= '01jan1986'd;
 %let enddate= '31dec1987'd;
*****************************************************************************
用例子程序的代码，得到每日的普通股的数据
 所做修改：
 ① 月度数据提取改为日度；
 ② 日期的约定规则，提前至msex1的生成步骤；
 ③ 新加价格、股票数的变量
*****************************************************************************;
* Complete the time series for exchcd & shrcd and select all common stocks;
data msex1;
set crsp.dsf(keep=permno date ret);
where date between &begindate and &enddate;
run;

proc download data=msex1  out=dayret88687;
run;
endrsubmit;
