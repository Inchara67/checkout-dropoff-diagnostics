SELECT

    user_pseudo_id,
    ANY_VALUE(device.category) AS device,
    MAX(IF(event_name = 'add_payment_info',1,0)) AS reached_payment,
    MAX(IF(event_name = 'purchase',1,0)) AS purchased,
    IFNULL(SUM(IF(event_name = 'purchase', ecommerce.purchase_revenue_in_usd,0)),0) AS revenue,
    MOD(ABS(FARM_FINGERPRINT(user_pseudo_id)),2) AS grp
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY user_pseudo_id
HAVING MAX(IF(event_name = 'add_payment_info',1,0)) = 1