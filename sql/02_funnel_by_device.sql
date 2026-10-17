SELECT
  device.category AS device,
  event_name,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name IN (
    'view_item', 'add_to_cart', 'begin_checkout',
    'add_payment_info', 'purchase'
)
GROUP BY device, event_name
ORDER BY device, users DESC