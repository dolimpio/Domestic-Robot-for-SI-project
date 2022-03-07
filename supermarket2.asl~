last_order_id(1). // initial belief
budget(9).
warehouse_price(beer, 1).
stock(beer,3).
available(beer,store).                                                                                                              
beer_price(3).
profit(0).

!marketing_plan.
                                         

//the supermarket sends the price to the robot   
+!marketing_plan <- .send(robot, tell, offer(supermarket2,3)).

// plan to achieve the goal "order" for agent Ag
+!order(Product,Qtd)[source(Ag)] : available(beer, store)
  <- ?stock(beer, Remaining);
  	Available = Remaining - 3;
	-+stock(beer,Available);
	?profit(Money);
	?beer_price(Price);
	Profit = Money + (3*Price);
	-+profit(Profit);
  	?last_order_id(N);
     OrderId = N + 1;
     -+last_order_id(OrderId);
     deliver(Product,Qtd);
     .send(Ag, tell, delivered(Product,Qtd,OrderId)).
	 
+!order(Product,Qtd)[source(Ag)] : not available(beer, store)
	<- .print("Sorry, i have to order more beer");
	!fill_stock(Product,Qtd);
	!order(Product,Qtd)[source(Ag)].        
	 
// when the supermarket has no more beers, if the budget is available, the stock is refilled   
+!fill_stock(Product,Qtd) : not available(Product, store) & available(budget, store)
	<- 
	?budget(Amount);
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
	!fill_stock(Product,Qtd).                     
                             
+stock(beer,0)
   :  available(beer,store)
   <- -available(beer,store).
                                                                                                                                                                                                                      
// the agent belives it has no more budget 
+budget(0): available(budget, store)
	<- -available(budget, store).
	
+stock(beer,N)
   :  N > 0 & not available(beer,store)
   <- -+available(beer,store).
