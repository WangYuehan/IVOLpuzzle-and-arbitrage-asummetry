libname mylib "C:\Users\wangjohn\Desktop\replicate";

%let wrds = wrds-cloud.wharton.upenn.edu 4016;
 options comamid=TCP remote=WRDS;
 signon username=_prompt_;
 rsubmit;

 %let begindate= '01jan1986'd;
 %let enddate= '31dec1987'd;
*****************************************************************************
�����ӳ���Ĵ��룬�õ�ÿ�յ���ͨ�ɵ�����
 �����޸ģ�
 �� �¶�������ȡ��Ϊ�նȣ�
 �� ���ڵ�Լ��������ǰ��msex1�����ɲ��裻
 �� �¼Ӽ۸񡢹�Ʊ���ı���
*****************************************************************************;
* Complete the time series for exchcd & shrcd and select all common stocks;
data msex1;
set crsp.dsf(keep=permno date ret);
where date between &begindate and &enddate;
run;

proc download data=msex1  out=dayret88687;
run;
endrsubmit;
