last_order_id(1). // initial belief

//+!makeMoney.
//+!makeMoney <- !buyBeer.
//+!makeMoney <- !sellBeer.
//+!makeMoney <- !offerBeer.
//+!makeMoney <- !manageOrders.


// plan to achieve the goal "order" for agent Ag
+!order(Product,Qtd)[source(Ag)] : true
  <- ?last_order_id(N);
     OrderId = N + 1;
     -+last_order_id(OrderId);
     deliver(Product,Qtd);
     .send(Ag, tell, delivered(Product,Qtd,OrderId)).

+gotOrder(OrderId)[source(robot)]                                          
  :  true                      
  <- .print("Received, delivery confirmed.").
