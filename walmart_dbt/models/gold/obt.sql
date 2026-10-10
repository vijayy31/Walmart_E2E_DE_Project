SELECT  
        O.ORDER_ID,
        O.CUSTOMER_ID,
        CONCAT(C.FIRST_NAME, ' ', C.LAST_NAME) AS CUSTOMER_NAME, 
        C.EMAIL AS CUSTOMER_EMAIL, 
        C.CITY AS CUSTOMER_CITY,
        O.STORE_ID, 
        S.STORE_NAME, 
        S.CITY AS STORE_CITY, 
        O.ORDER_TIMESTAMP, 
        O.ORDER_STATUS,
        O.TOTAL_AMOUNT, 
        O.PAYMENT_METHOD, 
        O.CREATED_TIMESTAMP, 
        O.UPDATED_TIMESTAMP, 
        O.IS_ACTIVE

FROM {{ ref("stg_orders")}} AS O

LEFT JOIN {{ ref('stg_stores') }} AS S
ON O.STORE_ID = S.STORE_ID

LEFT JOIN {{ ref('stg_customers') }} AS C
ON O.CUSTOMER_ID = C.CUSTOMER_ID

WHERE O.IS_ACTIVE = 'Y'