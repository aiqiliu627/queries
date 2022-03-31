create table linking_attempts as (
select distinct(linking_user_token)
    from INSTRUMENTS.RAW_OLTP.INSTRUMENT_ROLLUPS ir
    join app_bi.app_bi_dw.dim_user du on du.user_token=linking_user_token
    where USER_ACTIVATION_ADDRESS_COUNTRY_CODE='CA' 
    and TYPE='CARD' and Product='INSTANT_DEPOSIT' and UNLINKED_AT is null
     and USER_ACTIVATION_ADDRESS_COUNTRY_CODE='CA'
     and ir.created_at>=current_date-30
  group by 1
);  

// Number of sellers who attempted to link a debit card: 1675
select count(*) from linking_attempts;

// Among sellers who attempted to link a debit card, how many successfully sent an IT: 551
select count(distinct(linking_user_token)) 
from success_linked a inner join "APP_PAYMENTS"."APP_PAYMENTS_ANALYTICS"."FACT_DAILY_DEPOSITS" fdd
on a.linking_user_token = fdd.unit_token
where fdd.settled_at > current_date-35 and is_successful = 1 and currency_code = 'CAD';

// Overall conversion: 551/1675 = 33%
// This is quite different from 54% in here: https://docs.google.com/document/d/18KPmU8uWNmRrOhyLMSaIgZ-PBmPR09j8-YxWQfcVRis/edit#bookmark=id.ep4kq6yumlhn
