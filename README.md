<h2>Analyzing and cleaning dataset from Amazon store</h2>

**The idea of exploring sales data on Amazon originated from a conversation with my friend. We were just chatting about different things, and he mentioned how selling products on Amazon could be a great way to make money. He was thinking about going back to India and was looking for ideas to earn money there.**

**This conversation motivated me to help him out. I decided to dig into the dataset of Amazon sales in India to demonstrate how I could support him if he decided to start his own online store.**

<h3>Cleaning</h3>

![image](https://github.com/user-attachments/assets/b4923bec-6312-42f2-adaa-52c2fe17a0a2)
![image](https://github.com/user-attachments/assets/a925da1f-b670-4e9e-93b8-cedc9d8ca538)

<ul>
  <li>Drop column Unnamed_22</li>
  <li>Clean ship_postal_code column</li>
  <li>Clean ship_city, ship_state, ship_country columns</li>
  <li>Fourth item</li>
</ul>

I removed the “Unnamed_22” column mainly because it mostly contained null values.

For better data precision, I converted the datatype of “ship_postal_code” from nvarchar to numeric.

In the columns “ship_city,” “ship_state,” and “ship_country,” there were 33 rows with null values, and I chose to drop them as their absence wouldn’t significantly affect the overall results.

To address null values in the “promotion_ids” column, particularly in orders without promotions, a practical solution is to replace these null entries with the label ‘without promotion.’

For clarity in the “fulfilled_by” column, where the method for delivery is indicated by two values, ‘Amazon’ and null, I updated the null entries to ‘unknown.’

I made adjustments to ensure accuracy in the dataset. Specifically, when the “Status” column indicated cancellation, I set the order amount to 0. This involved replacing 8,000 null values and 10,000 instances where the amount received for the order was recorded. Additionally, I standardized two more columns, setting “currency” to ‘INR’ and “promotion_ids” to ‘without promotion.’

## I have identified six different categories for the questions I want to answer. Here are the questions I aim to address:
**1. Delivery**

* What is the distribution in (column Fulfilment, column ship_service_level, column Status)?
* How likely are orders to be canceled in different categories?

**2. Items**

* What is the distribution of sizes?
* What are the best-selling products?
* How likely is a client to buy an item with quantity more than 1?
* What is the distribution of items by price?”

**3. B2B**

* What role does B2B play in this distribution?
* How many orders are made by B2B?
* What are the top times when B2B spent a lot of money?
* What are the top times when customers spent a lot of money?

**4. Earnings**

* How many items(qty) were sold per month?
* How many items(qty) were sold per week?
* How much did the store earn per month?
* How much did the store earn per week?

**5. Promotions**

* What are the most popular promotions?
* What is the distribution of orders with and without promotion?

**6. Location**

* Which cities and states are the most popular?
* Are there any orders from other countries?
 
 
**1. Delivery**

**What is distribution in (column Fulfilment, column ship_service_level, column Courier_Status)?**

* **Column Fulfilment**

![image](https://github.com/user-attachments/assets/bafac67a-19b8-4fe3-b02a-1343a65f21e1)

70% of all deliveries were made by amazon, and in 30% people choose other fulfilment method


* **Column ship_service_level**

![image](https://github.com/user-attachments/assets/65ddb28e-be3e-4736-b663-c9cfa10c4b06)


Intriguingly, 69% of orders are by expedited delivery — an unexpectedly high figure that prompts reflection on the popularity. Perhaps a revelation for me, as I hadn’t anticipated this level of preference, possibly due to my personal usage patterns.


* **Column Status**

![image](https://github.com/user-attachments/assets/d551992b-11ff-49d9-a9ab-167c10401242)

Delving into order statuses, we encountered 2,112 instances where orders were not received by buyers due to various reasons. Simultaneously, a considerable 18,325 orders faced cancellation for reasons unknown to us, which gives us together almost 16% of the dataset. This percentage underscores the significance of order cancellations.


* **How likely orders to be canceled in different categories?**

![image](https://github.com/user-attachments/assets/c4d1c743-a478-459e-b043-1ddcfe0a1325)

**2. Items**

* **What are best items and their sizes by sales?**

![image](https://github.com/user-attachments/assets/a4deac7b-7494-406a-a10e-88f47c8e0f81)

A compelling discovery emerges when dissecting sales — the first 20 categories out of a total of 57 account for a whopping 80% of all sales. Surprisingly, only 3 out of 9 categories contain the items responsible for this substantial share. The image below highlights these critical items and their corresponding sizes, emphasizing the importance of keeping them consistently in stock.

* **What are the best-selling products?**

![image](https://github.com/user-attachments/assets/a635e6ca-6cd8-43c2-be36-2a44ad38279f)

Upon comprehensive analysis, the visual data reinforces our earlier findings. When considering all available sizes, these three categories astonishingly contribute to 90% of all sales — this discovery is truly mind-blowing that underscores the significant impact of these particular product categories.

* **How likely client going to buy more than 1 qty(quantity)?**

![image](https://github.com/user-attachments/assets/d1ee1a19-dd0a-43c2-984f-de970c57d702)

Surprisingly, the probability of clients buying more than one quantity is minimal, constituting a mere 0.3% of all orders.

Upon closer inspection of cancelled orders, a noteworthy pattern emerged. Specifically, 10% of all orders with a quantity of 2 were cancelled, while with quantity of 1 only 6%, hinting at the possibility of customers behaviour accidentally ordering two items instead of one.

* **What is distribution of items by price?**

![image](https://github.com/user-attachments/assets/b45afbea-dc81-4c47-bd38-d59eb9957dd9)

To bring order to the numerical landscape, I employed the ROUND() function, yielding a more organized presentation. The distribution of items by price showcases a detailed breakdown, providing insights into the pricing spectrum.

**3. B2B**

* **What role b2b play in this distribution?**

![image](https://github.com/user-attachments/assets/1f600335-bd74-4a0a-ba7d-b5d1fa897d98)

B2B transactions do not exert a significant influence on our overall sales.

* **How many orders are made by b2b?**

![image](https://github.com/user-attachments/assets/8b977c29-bd4b-4a0f-8c44-770343aca79f)

Unveiling the B2B landscape, a total of 793 orders, a modest fraction, were placed through B2B channels out of the entire order spectrum.

**4. Earnings**

* **How many items(qty) were sold per month?**

![image](https://github.com/user-attachments/assets/8c8420c0-c89a-4327-b1d1-c6c5e0739e37)

The apparent dip in sales for March is attributed to the limitation of dataset, which captures information only from the last day of the month.

* **How many items(qty) were sold per week?**

![image](https://github.com/user-attachments/assets/ba75f851-c191-48ca-9a8d-43ae0f4c42bf)

* **How much did the store earn per month?**

![image](https://github.com/user-attachments/assets/d4277c9f-3d51-4f78-877d-ec025724e41e)

* **How much did the store earn per week?**

![image](https://github.com/user-attachments/assets/2cf33f49-817b-45b7-a074-b939da72b7bb)

**5. Promotions**

* **What are the most popular promotions?**

![image](https://github.com/user-attachments/assets/e595c810-8baf-4fee-928f-f7fb473af672)

Starting from promotions that have >100 orders we see the most popular promotions within this dataset.

* **What is distribution of orders with and without promotion?**

![image](https://github.com/user-attachments/assets/6a092236-1ae0-46bb-a235-abd881623d0b)

**6. Location**

* **Which cities, states, are the most popular?**

![image](https://github.com/user-attachments/assets/584f7089-3672-4e00-8407-b54f6c778a12)
![image](https://github.com/user-attachments/assets/fe67171f-9723-4fb2-b128-86ab52ec215a)

* **Are there any orders from other countries?**

The dataset indicates an absence of orders from other countries.

## Summary

What we understand from this dataset?

What this business owner can do to improve quality of his service and at the same time earnings?

Examining the dataset, 2,111 orders were not received by the buyer due to specified reasons, while a substantial 18,325 were cancelled for reasons unknown to us. I strongly recommend that the seller considers implementing a data gathering mechanism to understand the reasons behind customer order cancellations. This proactive approach can significantly reduce the number of cancelled orders in the future.

Analyzing the data, it’s evident that 90% of all sales come from just 3 out of 9 categories. To enhance business earnings, I would recommend the store to consider taking out some of available categories that are unpopular. Also make broader range of items and explore opportunities to expand its stock with new products.

An actionable idea to boost sales in the B2B segment would be to introduce special offers tailored for B2B buyers. Crafting enticing offers and incentives for businesses could potentially enhance sales through B2B channels.

Reflecting on our earnings analysis, April emerges as the standout month for this store. Notably, March records have a notably small number of sales, because to the fact that only last day of the month sales data is available from our dataset.

After I finished with analysis, I created dashboard, here is the link: **https://public.tableau.com/app/profile/rostyslav.husaruk5386/viz/AmazonSalesDashboard_17033501627610/Dashboard**























