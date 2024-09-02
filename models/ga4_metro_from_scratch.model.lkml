connection: "ga4_metro"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: ga4_metro_from_scratch_default_datagroup {
  sql_trigger: SELECT max(event_date) from `mol-and-metro-ga.analytics_436258270.events_*`;;
  max_cache_age: "1 hour"
}

persist_with: ga4_metro_from_scratch_default_datagroup

explore: events_incremental_pdt {
  persist_with: ga4_metro_from_scratch_default_datagroup
  always_filter: {
    filters: [events_incremental_pdt.event_date: "7 days"]
  }
  sql_always_where: ${event_name} <> 'session_start';;
  join: sessions_fact {
    relationship: many_to_one
    sql_on: ${sessions_fact.ga_session_id} = ${events_incremental_pdt.ga_session_id} ;;
  }
}

explore: events {
  always_filter: {
    filters: [events.event_date: "7 days"]
  }
}
