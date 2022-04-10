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

//+!doHouseWork.

//+!doHouseWork <- !dialogWithOwner.
//+!doHouseWork <- !cleanHouse.
//+!doHouseWork <- !goAtPlace. //Supongo que este objetivo se tiene que añadir que el robot esquive obstaculos
//+!doHouseWork <- !manageBeer.
                  
/* Plans */                                                        
                                      
+!bring(owner,beer)[source(Ag)] 
   :  available(beer,fridge) & not too_much(beer) & (same(Ag,owner)|same(Ag,self))
   <- !go_at(robot,fridge);
      open(fridge); 
      get(beer);
      close(fridge); 
      !go_at(robot,owner);
      hand_in(beer);
      ?has(owner,beer);
      // remember that another beer has been consumed
      .date(YY,MM,DD); .time(HH,NN,SS);
      +consumed(YY,MM,DD,HH,NN,SS,beer).

+!bring(owner,beer)[source(Ag)]
   :  not available(beer,fridge) & (same(Ag,owner)|same(Ag,self))
   <- //!go_at(robot,delivery);
   .send(supermarket, achieve, order(beer,3));              
      !go_at(robot,fridge). // go to fridge and wait there.
                                                                                                                                                   
+!bring(owner,beer)
   :  too_much(beer) & limit(beer,L) 
   <- .concat("The Department of Health does not allow me to give you more than ", L,                                                      
              " beers a day! I am very sorry about that!",M);
      .send(owner,tell,msg(M)).

-!bring(_,_)
   :  true
   <- .current_intention(I);
      .print("Failed to achieve goal '!has(_,_)'. Current intention is: ",I).
                                                                                          
+!go_at(robot,P) : at(robot,P) <- true.
+!go_at(robot,P) : not at(robot,P) 
  <- move_towards(P);
     !go_at(robot,P). 
            
/*
+!dialogWithOwner : msg(Msg)[source(Ag)] <-
	bot.chat(Msg,Answer);
	-msg(Msg)[source(Ag)];
	.send(Ag,tell,answer(Answer));
	.println("Robot ha recibido el mensaje: ",Msg," de ",Ag);
	!dialogWithOwner.
+!dialogWithOwner <- !dialogWithOwner.
*/

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


