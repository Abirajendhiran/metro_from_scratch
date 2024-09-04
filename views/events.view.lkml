# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
view: events {
  sql_table_name: `mol-and-metro-ga.analytics_436258270.events_*`  ;;

  dimension_group: event {
    type: time
    timeframes: [date, week, day_of_week, month, year]
    sql: TIMESTAMP(PARSE_DATE('%Y%m%d', REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d\d\d\d\d'))) ;;
  }
  dimension_group: _event {
    label: "Event"
    timeframes: [raw,time,hour,minute]
    type: time
    sql: TIMESTAMP_MICROS(${TABLE}.event_timestamp) ;;
  }

#Custom Event Params

  dimension: article_id {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'article_id');;
  }

  dimension: article_view_flag  {
    type: number
    sql: (
        CASE
          WHEN (
            SELECT
              value.int_value
            FROM
              UNNEST (event_params)
            WHERE
              (event_name = 'page_view' or event_name = 'article_view') /*page_view is for WEB, article_views is for APP*/
              AND key = 'article_views'
          ) = 1 THEN 1
          ELSE 0
        END
      );;
  }

  measure: total_article_views {
    type: sum
    sql: ${article_view_flag} ;;
  }

  measure: total_page_views {
    type: count
    filters: [event_name:"page_view"]
  }

  dimension: video_id {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'video_internal_id');;
  }

  dimension: video_view_flag  {
    type: number
    sql: (
        CASE
          WHEN (
            SELECT
              value.int_value
            FROM
              UNNEST (event_params)
            WHERE
              (event_name = 'video_stream_start' or event_name = 'video_stream_continuous_play')
              AND key = 'video_views'
          ) = 1 THEN 1
          ELSE 0
        END
      );;
  }

  measure: total_video_views {
    type: sum
    sql: ${video_view_flag} ;;
  }

  dimension: channel {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
    FROM UNNEST(${event_params})
    WHERE key = 'url_channel');;
  }

  dimension: referrer_type {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
          FROM UNNEST(${event_params})
          WHERE key = 'referrer_type');;
  }

  dimension: ga_session_id {
    type: number
    sql:  (SELECT coalesce(value.int_value,cast(value.string_value as INT64))
          FROM UNNEST(${event_params})
          WHERE key = 'ga_session_id');;
  }

  dimension: user_pseudo_id {
    type: string
    sql: ${TABLE}.user_pseudo_id ;;
  }

  dimension: unique_session_id {
    type: string
    sql: (SELECT ${ga_session_id}||${user_pseudo_id} ) ;;
  }

  measure: visits {
    type:  count_distinct
    sql: ${unique_session_id} ;;
  }

  # Custom dimension

  dimension: article_published_date {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'article_published_date');;
  }

  dimension: article_tags {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'article_tags');;
  }

  dimension: article_title {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'article_title');;
  }

  dimension: author_name {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'author_name');;
  }

  dimension: content_type {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'content_type');;
  }

  dimension: ico_internal_hit {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'ico_internal_hit');;
  }

  dimension: ito_external_hit {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'ito_external_hit');;
  }

  dimension: logged_in_status {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'logged_in_status');;
  }

  dimension: module_name {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'module_name');;
  }

  dimension: module_tracking {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'module_tracking');;
  }

  dimension: multivariant_experiments {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'multivariant_experiments');;
  }

  dimension: openweb_enabled {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'openweb_enabled');;
  }

  dimension: openweb_module_type {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'openweb_module_type');;
  }

  dimension: page_url {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'page_url');;
  }

  dimension: paywall_variant {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'paywall_variant');;
  }

  dimension: poll_id {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'poll_id');;
  }

  dimension: poll_name {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'poll_name');;
  }

  dimension: product_type {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'product_type');;
  }

  dimension: push_notification_campaign_id {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'push_notification_campaign_id');;
  }

  dimension: push_notification_id {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'push_notification_id');;
  }

  dimension: referrer {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'referrer');;
  }

  dimension: referrer_group {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'referrer_group');;
  }

  dimension: referring_channel {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'referring_channel');;
  }

  dimension: referring_module {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'referring_module');;
  }

  dimension: storefront_variant {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'storefront_variant');;
  }

  dimension: subscription_entitlements {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'subscription_entitlements');;
  }

  dimension: url_subchannel_level_1 {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'url_subchannel_level_1');;
  }

  dimension: user_login_details {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'user_login_details');;
  }

  dimension: user_type {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'user_type');;
  }

  dimension: video_headline {
    type: string
    sql: (SELECT cast(coalesce(value.string_value,cast(value.int_value as string)) as STRING)
             FROM UNNEST(${event_params})
             WHERE key = 'video_headline');;
  }

  dimension: time_spent_on_page_flag{
    type: number
    sql: (TIMESTAMP_DIFF( TIMESTAMP_MICROS(LEAD(${event_timestamp}) OVER
              (PARTITION BY ${user_pseudo_id}||(select coalesce (cast(value.string_value as INT64),value.int_value) from UNNEST(${event_params}) where key = "ga_session_id"),
                  CASE WHEN event_name = 'page_view' THEN TRUE ELSE FALSE END ORDER BY ${event_timestamp} ) )
            ,TIMESTAMP_MICROS(${event_timestamp}), SECOND )) ;;
  }

  # Custom Metric

  measure: users {
    type: count_distinct
    sql: ${user_pseudo_id} ;;
  }

  measure: time_spent_on_page {
    type: sum
    sql: ${time_spent_on_page_flag} ;;
  }

 #not modified

  dimension: device__browser {
    type: string
    sql: ${TABLE}.device.browser ;;
    group_label: "Device"
    group_item_label: "Browser"
  }
  dimension: device__browser_version {
    type: string
    sql: ${TABLE}.device.browser_version ;;
    group_label: "Device"
    group_item_label: "Browser Version"
  }
  dimension: device__category {
    type: string
    sql: ${TABLE}.device.category ;;
    group_label: "Device"
    group_item_label: "Category"
  }
  dimension: device__operating_system {
    type: string
    sql: ${TABLE}.device.operating_system ;;
    group_label: "Device"
    group_item_label: "Operating System"
  }
  dimension: device__operating_system_version {
    type: string
    sql: ${TABLE}.device.operating_system_version ;;
    group_label: "Device"
    group_item_label: "Operating System Version"
  }

  dimension: event_dimensions__hostname {
    type: string
    sql: ${TABLE}.event_dimensions.hostname ;;
    group_label: "Event Dimensions"
    group_item_label: "Hostname"
  }
  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }
  dimension: event_params {
    hidden: yes
    sql: ${TABLE}.event_params ;;
  }
  dimension: event_previous_timestamp {
    type: number
    sql: ${TABLE}.event_previous_timestamp ;;
  }
  dimension: event_server_timestamp_offset {
    type: number
    sql: ${TABLE}.event_server_timestamp_offset ;;
  }
  dimension: event_timestamp {
    type: number
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension: geo__city {
    type: string
    sql: ${TABLE}.geo.city ;;
    group_label: "Geo"
    group_item_label: "City"
  }
  dimension: geo__continent {
    type: string
    sql: ${TABLE}.geo.continent ;;
    group_label: "Geo"
    group_item_label: "Continent"
  }
  dimension: geo__country {
    type: string
    sql: ${TABLE}.geo.country ;;
    group_label: "Geo"
    group_item_label: "Country"
  }
  dimension: geo__metro {
    type: string
    sql: ${TABLE}.geo.metro ;;
    group_label: "Geo"
    group_item_label: "Metro"
  }
  dimension: geo__region {
    type: string
    sql: ${TABLE}.geo.region ;;
    group_label: "Geo"
    group_item_label: "Region"
  }
  dimension: geo__sub_continent {
    type: string
    sql: ${TABLE}.geo.sub_continent ;;
    group_label: "Geo"
    group_item_label: "Sub Continent"
  }
  dimension: is_active_user {
    type: yesno
    sql: ${TABLE}.is_active_user ;;
  }
  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension: stream_id {
    type: string
    sql: ${TABLE}.stream_id ;;
  }
  dimension: traffic_source__medium {
    type: string
    sql: ${TABLE}.traffic_source.medium ;;
    group_label: "Traffic Source"
    group_item_label: "Medium"
  }
  dimension: traffic_source__name {
    type: string
    sql: ${TABLE}.traffic_source.name ;;
    group_label: "Traffic Source"
    group_item_label: "Name"
  }
  dimension: traffic_source__source {
    type: string
    sql: ${TABLE}.traffic_source.source ;;
    group_label: "Traffic Source"
    group_item_label: "Source"
  }
  dimension: user_first_touch_timestamp {
    type: number
    sql: ${TABLE}.user_first_touch_timestamp ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_properties {
    hidden: yes
    sql: ${TABLE}.user_properties ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  event_name,
  traffic_source__name,
  event_dimensions__hostname,
  ]
  }

}

view: events_20240719__items {
  drill_fields: [item_id]

  dimension: item_id {
    primary_key: yes
    type: string
    sql: item_id ;;
  }
  dimension: affiliation {
    type: string
    sql: affiliation ;;
  }
  dimension: coupon {
    type: string
    sql: coupon ;;
  }
  dimension: creative_name {
    type: string
    sql: creative_name ;;
  }
  dimension: creative_slot {
    type: string
    sql: creative_slot ;;
  }
  dimension: events_20240719__items {
    type: string
    hidden: yes
    sql: events_20240719__items ;;
  }
  dimension: item_brand {
    type: string
    sql: item_brand ;;
  }
  dimension: item_category {
    type: string
    sql: item_category ;;
  }
  dimension: item_category2 {
    type: string
    sql: item_category2 ;;
  }
  dimension: item_category3 {
    type: string
    sql: item_category3 ;;
  }
  dimension: item_category4 {
    type: string
    sql: item_category4 ;;
  }
  dimension: item_category5 {
    type: string
    sql: item_category5 ;;
  }
  dimension: item_list_id {
    type: string
    sql: item_list_id ;;
  }
  dimension: item_list_index {
    type: string
    sql: item_list_index ;;
  }
  dimension: item_list_name {
    type: string
    sql: item_list_name ;;
  }
  dimension: item_name {
    type: string
    sql: item_name ;;
  }
  dimension: item_params {
    hidden: yes
    sql: item_params ;;
  }
  dimension: item_refund {
    type: number
    sql: item_refund ;;
  }
  dimension: item_refund_in_usd {
    type: number
    sql: item_refund_in_usd ;;
  }
  dimension: item_revenue {
    type: number
    sql: item_revenue ;;
  }
  dimension: item_revenue_in_usd {
    type: number
    sql: item_revenue_in_usd ;;
  }
  dimension: item_variant {
    type: string
    sql: item_variant ;;
  }
  dimension: location_id {
    type: string
    sql: location_id ;;
  }
  dimension: price {
    type: number
    sql: price ;;
  }
  dimension: price_in_usd {
    type: number
    sql: price_in_usd ;;
  }
  dimension: promotion_id {
    type: string
    sql: promotion_id ;;
  }
  dimension: promotion_name {
    type: string
    sql: promotion_name ;;
  }
  dimension: quantity {
    type: number
    sql: quantity ;;
  }
}

view: events_20240719__event_params {

  dimension: events_20240719__event_params {
    type: string
    hidden: yes
    sql: events_20240719__event_params ;;
  }
  dimension: key {
    type: string
    sql: key ;;
  }
  dimension: value__double_value {
    type: number
    sql: ${TABLE}.value.double_value ;;
    group_label: "Value"
    group_item_label: "Double Value"
  }
  dimension: value__float_value {
    type: number
    sql: ${TABLE}.value.float_value ;;
    group_label: "Value"
    group_item_label: "Float Value"
  }
  dimension: value__int_value {
    type: number
    sql: ${TABLE}.value.int_value ;;
    group_label: "Value"
    group_item_label: "Int Value"
  }
  dimension: value__string_value {
    type: string
    sql: ${TABLE}.value.string_value ;;
    group_label: "Value"
    group_item_label: "String Value"
  }
}

view: events_20240719__user_properties {

  dimension: events_20240719__user_properties {
    type: string
    hidden: yes
    sql: events_20240719__user_properties ;;
  }
  dimension: key {
    type: string
    sql: key ;;
  }
  dimension: value__double_value {
    type: number
    sql: ${TABLE}.value.double_value ;;
    group_label: "Value"
    group_item_label: "Double Value"
  }
  dimension: value__float_value {
    type: number
    sql: ${TABLE}.value.float_value ;;
    group_label: "Value"
    group_item_label: "Float Value"
  }
  dimension: value__int_value {
    type: number
    sql: ${TABLE}.value.int_value ;;
    group_label: "Value"
    group_item_label: "Int Value"
  }
  dimension: value__set_timestamp_micros {
    type: number
    sql: ${TABLE}.value.set_timestamp_micros ;;
    group_label: "Value"
    group_item_label: "Set Timestamp Micros"
  }
  dimension: value__string_value {
    type: string
    sql: ${TABLE}.value.string_value ;;
    group_label: "Value"
    group_item_label: "String Value"
  }
}

view: events_20240719__items__item_params {

  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }
  dimension: value__double_value {
    type: number
    sql: ${TABLE}.value.double_value ;;
    group_label: "Value"
    group_item_label: "Double Value"
  }
  dimension: value__float_value {
    type: number
    sql: ${TABLE}.value.float_value ;;
    group_label: "Value"
    group_item_label: "Float Value"
  }
  dimension: value__int_value {
    type: number
    sql: ${TABLE}.value.int_value ;;
    group_label: "Value"
    group_item_label: "Int Value"
  }
  dimension: value__string_value {
    type: string
    sql: ${TABLE}.value.string_value ;;
    group_label: "Value"
    group_item_label: "String Value"
  }
}
