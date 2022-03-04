/* Initial beliefs and rules */ 
                           
// initially, I believe that there is some beer in the fridge
available(beer,fridge).

// my owner should not consume more than 10 beers a day :-)
limit(beer,5).
     
too_much(B) :-
   .date(YY,MM,DD) &
   .count(consumed(YY,MM,DD,_,_,_,B),QtdB) &                                 
   limit(B,Limit) &
   QtdB > Limit.

same(X,X).
                  
/* Plans */                                                        
                                      
+!bring(owner,beer)[source(Ag)] 
   :  available(beer,fridge) & not too_much(beer) & (same(Ag,owner)|same(Ag,self)) & not pending(trash)
   <- +pending(beer);
   	  !go_at(robot,fridge);
      open(fridge); 
      get(beer);
      close(fridge);
      !go_at(robot,owner);
      hand_in(beer);
      ?has(owner,beer);
      // remember that another beer has been consumed
      .date(YY,MM,DD); .time(HH,NN,SS);
      +consumed(YY,MM,DD,HH,NN,SS,beer);
	  -pending(beer).

+!bring(owner,beer)[source(Ag)]
   :  not available(beer,fridge) & (same(Ag,owner)|same(Ag,self)) & not pending(trash)
   <- .send(supermarket, achieve, order(beer,3));
      !go_at(robot,delivery);
	  pick_delivery(beer);// go to delivery and wait there.
	  !go_at(robot,fridge);
	  give_fridge(beer).
	  
                                                                                                                                     
+!bring(owner,beer)
   :  too_much(beer) & limit(beer,L) 
   <- .concat("The Department of Health does not allow me to give you more than ", L,                                                      
              " beers a day! I am very sorry about that!",M);
      .send(owner,tell,msg(M)).

-!bring(_,_)
   :  true                                                                   
   <- .current_intention(I);
      .print("Failed to achieve goal '!has(_,_)'. Current intention is: ",I).

+!can_to_trash(can)[source(Ag)] : not pending(beer) & (same(Ag,owner)|same(Ag,self)) //Hay que buscar contexto adecuado
	<- +pending(trash);
		!go_at(robot,owner);
		pick_trash(can);
		!go_at(robot, trash);
		throw_trash(can);
		//-has(owner,trash);
		-pending(trash). 
		
+!can_to_trash(can) : pending(beer) <- true.
+!go_at(robot,P) : at(robot,P) <- true.                                                                                                                          
+!go_at(robot,P) : not at(robot,P) 
  <- move_towards(P);
     !go_at(robot,P). 
            
// when the supermarket makes a delivery, try the 'has' goal again
+delivered(beer,_Qtd,_OrderId)[source(supermarket)]                                          
  :  true                      
  <- +available(beer,fridge);
  	.print("Got the delivery! Thanks!!!");
  	.send(supermarket, tell, gotOrder(OrderId));
     !bring(owner,beer).
	 
                                                                                                                                                                
// when the fridge is opened, the beer stock is perceived
// and thus the available belief is updated
+stock(beer,0)
   :  available(beer,fridge)                                                                                                                
   <- -available(beer,fridge).                                                                     
+stock(beer,N)
   :  N > 0 & not available(beer,fridge)
   <- -+available(beer,fridge).

+?time(T) : true
  <-  time.check(T).


