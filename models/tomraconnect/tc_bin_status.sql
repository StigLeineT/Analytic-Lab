{{
    config(
        materialized='table' 
    )
}}

select
    col1:ocMessage:installationId::varchar as installation_id,
    col1:serialNumber::varchar as serial_number,
    col1:ocMessage:date::timestamp as date,
    col1:ocMessage:bin::int as bin,
    col1:ocMessage:grandBinCount::bigint as grand_bin_count,
    col1:ocMessage:level::int as level,
    col1:ocMessage:properties::varchar as properties_json,
    col1:ocMessage:status::varchar as status,
    col1:ocMessage:messageId::varchar as message_id,
    col1:ocMessage:processedAt::timestamp as processed_at,
    col1:ocMessage:receivedAt::timestamp as received_at,
    col1:ocMessage:timestamp::timestamp as timestamp,
    sysdate() as sf_processed_dt,
    LOAD_TIME as sp_load_time
from {{source('raw','gcs_tc_oc_messages')}}
where col1:messageType::varchar = 'BIN_STATUS' 
--Temp code to load less data
and LOAD_TIME > dateadd(hour, -1, current_timestamp()) 

{% if is_incremental() %}

and LOAD_TIME > (select max(sp_load_time) from {{ this }})

{% endif %}