view: session_fact {
  sql_table_name: `mol-and-metro-ga.analytics_436258270.session_fact` ;;

  dimension: average_time_spent_on_page {
    type: number
    sql: ${TABLE}.average_time_spent_on_page ;;
  }
  dimension: is_engaged_session {
    type: yesno
    sql: ${TABLE}.is_engaged_session ;;
  }
  dimension: session_duration {
    type: number
    sql: ${TABLE}.session_duration ;;
  }
  dimension_group: session_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.session_end ;;
  }
  dimension: session_page_view_count {
    type: number
    sql: ${TABLE}.session_page_view_count ;;
  }
  dimension_group: session_start {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.session_start ;;
  }
  dimension: stream_id {
    type: string
    sql: ${TABLE}.stream_id ;;
  }
  dimension: total_time_spent_on_page {
    type: number
    sql: ${TABLE}.total_time_spent_on_page ;;
  }
  dimension: unique_session_id {
    type: string
    sql: ${TABLE}.unique_session_id ;;
  }
  measure: count {
    type: count
  }
}
