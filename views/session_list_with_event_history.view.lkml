###########################
# 01: SESSION LIST WITH EVENT HISTORY
# This is the backbone of the block.
# In this query, we parse the date from the table name
# And sessionalize all the events with the sl_key
############################
view: session_list_with_event_history {
  derived_table: {
    datagroup_trigger: ga4_metro_from_scratch_default_datagroup
    partition_keys: ["session_date"]
    cluster_keys: ["unique_session_id","user_pseudo_id","session_date"]
    increment_key: "session_date"
    increment_offset: 0
    sql:-- obtains a list of sessions, uniquely identified by the table date, ga_session_id event parameter, ga_session_number event parameter, and the user_pseudo_id.
          select timestamp(SAFE.PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'(\d{8})'))) session_date
            ,  (select value.int_value from UNNEST(events.event_params) where key = "ga_session_id") ga_session_id
            --,  (select value.int_value from UNNEST(events.event_params) where key = "ga_session_number") ga_session_number
            ,  events.user_pseudo_id
            -- unique key for session:
            ,  events.user_pseudo_id||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_id") as unique_session_id
            --,  row_number() over (partition by (timestamp(SAFE.PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'[0-9]+')))||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_id")||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_number")||events.user_pseudo_id) order by events.event_timestamp) event_rank

            --,  (TIMESTAMP_DIFF(TIMESTAMP_MICROS(LEAD(events.event_timestamp) OVER (PARTITION BY timestamp(SAFE.PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'[0-9]+')))||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_id")||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_number")||events.user_pseudo_id ORDER BY events.event_timestamp asc))
            --   ,TIMESTAMP_MICROS(events.event_timestamp),second)/86400.0) time_to_next_event --might not need it

            --, case when events.event_name = 'page_view' then row_number() over (partition by (timestamp(SAFE.PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'[0-9]+')))||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_id")||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_number")||events.user_pseudo_id), case when events.event_name = 'page_view' then true else false end order by events.event_timestamp)
            --  else 0 end as page_view_rank

            --, case when events.event_name = 'page_view' then row_number() over (partition by (timestamp(SAFE.PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'[0-9]+')))||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_id")||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_number")||events.user_pseudo_id), case when events.event_name = 'page_view' then true else false end order by events.event_timestamp desc)
            --  else 0 end as page_view_reverse_rank

            , TIMESTAMP_DIFF(TIMESTAMP_MICROS(LEAD(events.event_timestamp) OVER (PARTITION BY events.user_pseudo_id||(select value.int_value from UNNEST(events.event_params) where key = "ga_session_id") , case when events.event_name = 'page_view' then true else false end ORDER BY events.event_timestamp asc))
            ,TIMESTAMP_MICROS(events.event_timestamp),second)/86400.0 as time_to_next_page -- this window function yields 0 duration results when session page_view count = 1.
            -- raw event data:
            , events.event_date
            , events.event_timestamp
            , events.event_name
            , events.event_params
            , events.event_previous_timestamp
            , events.event_value_in_usd
            , events.event_bundle_sequence_id
            , events.event_server_timestamp_offset
            , events.user_id
            -- , events.user_pseudo_id
            , events.user_properties
            , events.user_first_touch_timestamp
            , events.user_ltv
            , events.device
            , events.geo
            , events.app_info
            , events.traffic_source
            , events.stream_id
            , events.platform
            , events.event_dimensions
            , events.ecommerce
            , ARRAY(select as STRUCT it.* EXCEPT(item_params) from unnest(events.items) as it) as items
            from `mol-and-metro-ga.analytics_436258270.events_*` events
            where {% incrementcondition %} timestamp(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'[0-9]+'))) {%  endincrementcondition %}
               --where timestamp(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'[0-9]+'))) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -15 DAY)))
                 --and  timestamp(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'[0-9]+'))) <= ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -15 DAY), INTERVAL 16 DAY)))
                ;;
  }
  dimension: session_date {
    type: date
    hidden: yes
    sql: ${TABLE}.session_date;;
  }

  dimension: ga_session_id {
    type: number
    hidden: yes
    sql: ${TABLE}.ga_session_id;;
  }

  dimension: user_pseudo_id {
    type: string
    hidden: yes
    sql: ${TABLE}.user_pseudo_id;;
  }

  dimension: unique_session_id {
    type: string
    sql: ${TABLE}.unique_session_id;;
  }

  dimension: time_to_next_page {
    type: number
    sql: ${TABLE}.time_to_next_page;;
  }

  measure: total_time_to_next_page {
    type: sum
    sql: ${time_to_next_page} ;;
  }


}
