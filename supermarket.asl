last_order_id(1). // initial belief
supermarket_stock(beer,100).
have_product(beer, Qtd) :-  supermarket_stock(beer,N), N>Qtd.                                  
// plan to achieve the goal "order" for agent Ag
+!order(Product,Qtd)[source(Ag)] : have_product(beer, Qtd)
  <- ?last_order_id(N);                                    
     OrderId = N + 1;
     -+last_order_id(OrderId);
     deliver(Product,Qtd);                                                  
	 ?supermarket_stock(beer, Num);
	 Num = Num-Qtd;
	 -+supermarket_stock(beer,Num);
     .send(Ag, tell, delivered(Product,Qtd,OrderId)).
	 
+!order(Product,Qtd)[source(Ag)] : not have_product(beer, Qtd)
  <- .send(Ag, tell, supermarket_stock(beer, N)).    //We need to inform the Robot agent, I don't think it is this way                                                                                                                                                                                      
