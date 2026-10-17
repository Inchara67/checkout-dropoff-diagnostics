WITH events AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(event_date) AS first_date
  FROM events
  WHERE event_name = 'first_visit'
  GROUP BY user_pseudo_id
),

activity AS (
  SELECT
    e.user_pseudo_id,
    e.event_name,
    DATE_TRUNC(f.first_date, WEEK(MONDAY)) AS cohort_week,
    DATE_DIFF(
      DATE_TRUNC(e.event_date, WEEK(MONDAY)),
      DATE_TRUNC(f.first_date, WEEK(MONDAY)),
      WEEK
    ) AS weeks_since
  FROM events e
  JOIN first_seen f USING (user_pseudo_id)
)

SELECT
  cohort_week,
  weeks_since,
  COUNT(DISTINCT user_pseudo_id) AS active_users,
  COUNT(DISTINCT IF(event_name = 'purchase', user_pseudo_id, NULL)) AS purchasers
FROM activity
WHERE weeks_since >= 0
GROUP BY cohort_week, weeks_since
ORDER BY cohort_week, weeks_since 