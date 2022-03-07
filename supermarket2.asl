last_order_id(1). // initial belief
budget(6).
warehouse_price(beer, 1).
stock(beer,3).
available(beer,store).
offer(supermarket2,6).
profit(0).                                                                                                    

!marketing_plan.
                                           

//the supermarket sends the price to the robot   
+!marketing_plan : offer(supermarket2, N) <- .send(robot, tell, offer(supermarket2,N)).

// plan to achieve the goal "order" for agent Ag
+!order(Product,Qtd)[source(Ag)] : available(beer, store) & profit(Money) & offer(supermarket2,Price)
  <- ?stock(beer, Remaining);
  	Available = Remaining - 3;
	-+stock(beer,Available);
	Profit = Money + (3*Price);
	-+profit(Profit);
  	?last_order_id(N);
     OrderId = N + 1;
     -+last_order_id(OrderId);
	 !rise_price;
     deliver(Product,Qtd);
     .send(Ag, tell, delivered(Product,Qtd,OrderId)).

	 
+!order(Product,Qtd)[source(Ag)] : not available(beer, store)
	<- .print("Sorry, I have to order more beer");
	!fill_stock(Product,Qtd);
	!order(Product,Qtd)[source(Ag)].

// when the supermarket has no more beers, if the budget is available, the stock is refilled  
+!fill_stock(Product,Qtd) : not available(Product, store) & available(budget, store)
	<- ?budget(Amount);
	?warehouse_price(beer, Price);
	NewAmount = Amount - (3*Price);
	-+stock(Product, 3);
	-+budget(NewAmount);
	+available(Product, store).
	
// when the robot has no more budget, it uses the profit the agent has won 
+!fill_stock(Product,Qtd) : not available(Product, store) & not available(budget, store)
 <- .print("Let me see my budget.");
 	?profit(Money);
	-+profit(0);
	-+budget(Money);
	+available(budget, store);
	!fill_stock(Product,Qtd). //Modificar esto luego para añadir budget

// rises the price on each order, this way the robot has to choose the cheaper supermarket
+!rise_price : last_order_id(N) & N > 1 & offer(supermarket2, P) & P < 18
	<-?offer(supermarket2,Current);
	New = Current + 1;
	-+offer(supermarket2,New).
	
// when the price is to high, the supermarket lowers the price
+!rise_price : offer(supermarket2, N) & N >= 18
	<-?offer(supermarket2,Current);
	New = Current - 1;
	-+offer(supermarket2,New).
	

+stock(beer,0)
   :  available(beer,store)
   <- -available(beer,store).
   
// the agent belives it has no more budget   
+budget(0): available(budget, store)
	<- -available(budget, store).
	
+stock(beer,N)
   :  N > 0 & not available(beer,store)
   <- -+available(beer,store).
