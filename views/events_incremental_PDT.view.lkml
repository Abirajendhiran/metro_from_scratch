view: events_incremental_pdt {
  derived_table: {
    datagroup_trigger: ga4_metro_from_scratch_default_datagroup
    increment_key: "event_date"
    increment_offset: 1 #option to reprocess
    explore_source: events {
      column: article_id {}
      column: article_view_flag {}
      column: channel {}
      column: device__browser {}
      column: device__browser_version {}
      column: device__category {}
      column: device__operating_system {}
      column: device__operating_system_version {}
      column: event_date {}
      column: event_day_of_week {}
      column: _event_hour {}
      column: event_name {}
      column: event_previous_timestamp {}
      column: event_server_timestamp_offset {}
      column: event_timestamp {}
      column: ga_session_id {}
      column: geo__city {}
      column: geo__country {}
      column: is_active_user {}
      column: stream_id {}
      column: user_first_touch_timestamp {}
      column: user_id {}
      column: user_pseudo_id {}
      column: video_id {}
      column: video_view_flag {}
      column: count {}
      column: total_page_views {}
      column: total_video_views {}
      column: total_article_views {}
    }
  }
  dimension: article_id {
    description: ""
  }
  dimension: article_view_flag {
    description: ""
    type: number
  }
  dimension: channel {
    description: ""
  }
  dimension: device__browser {
    description: ""
  }
  dimension: device__browser_version {
    description: ""
  }
  dimension: device__category {
    description: ""
  }
  dimension: device__operating_system {
    description: ""
  }
  dimension: device__operating_system_version {
    description: ""
  }
  dimension: event_date {
    description: ""
    type: date
  }
  dimension: event_day_of_week {
    description: ""
    type: date_day_of_week
  }
  dimension: _event_time {
    label: "Events Event Time"
    description: ""
    type: date_time
  }
  dimension: event_week {
    description: ""
    type: date_week
  }
  dimension: event_year {
    description: ""
    type: date_year
  }
  dimension: event_dimensions__hostname {
    description: ""
  }
  dimension: event_name {
    description: ""
  }
  dimension: event_previous_timestamp {
    description: ""
    type: number
  }
  dimension: event_timestamp {
    description: ""
    type: number
  }
  dimension: ga_session_id {
    description: ""
    type: number
  }
  dimension: geo__city {
    description: ""
  }
  dimension: geo__country {
    description: ""
  }
  dimension: is_active_user {
    label: "Events Is Active User (Yes / No)"
    description: ""
    type: yesno
  }
  dimension: stream_id {
    description: ""
  }
  dimension: user_first_touch_timestamp {
    description: ""
    type: number
  }
  dimension: user_id {
    description: ""
  }
  dimension: user_pseudo_id {
    description: ""
  }
  dimension: video_id {
    description: ""
  }
  dimension: video_view_flag {
    description: ""
    type: number
  }
  dimension: total_page_views {
    description: ""
    type: number
  }
  dimension: total_video_views {
    description: ""
    type: number
  }
  dimension: total_article_views {
    description: ""
    type: number
  }
}
