/* Initial beliefs and rules */

// initially, I believe that there is some beer in the fridge
available(beer,fridge).

// my owner should not consume more than 10 beers a day :-)
limit(beer,15).
money(5).

same(X,X).

too_much(B) :-
   .date(YY,MM,DD) &
   .count(consumed(YY,MM,DD,_,_,_,B),QtdB) &
   limit(B,Limit) &
   QtdB > Limit.


/* Plans */

+!bring(owner,beer)
   :  available(beer,fridge) & not too_much(beer) & not trash(pending)
   <- +beer(pending);
   !go_at(robot,fridge);
      open(fridge);
      get(beer);
      close(fridge);
      !go_at(robot,owner);
      hand_in(beer);
      ?has(owner,beer);
	  -beer(pending);
      // remember that another beer has been consumed
      .date(YY,MM,DD); .time(HH,NN,SS);
      +consumed(YY,MM,DD,HH,NN,SS,beer).

+!bring(owner,beer)
   :  not available(beer,fridge) & not trash(pending) 
   <-!select_supermarket;
   ?best_price(Supermarket);
   .send(Supermarket, achieve, order(beer,3)); 
    !go_at(robot,fridge). // go to fridge and wait there.  
	
	
// the robot selects the cheaper supermarket	                     
+!select_supermarket : offer(supermarket,X) & offer(supermarket1,Y) & offer(supermarket2,Z)
	<- if ( X < Y ){
			-+best_price(supermarket);
	   }elif ( Z < Y ){
	   		-+best_price(supermarket2);
		}else{ 
			-+best_price(supermarket1);
		}.
            
+!bring(owner,beer)
   :  too_much(beer) & limit(beer,L)
   <- .concat("The Department of Health does not allow me to give you more than ", L,
              " beers a day! I am very sorry about that!",M);
      .send(owner,tell,msg(M)).

+!bring(owner, beer) : trash(pending)
	<- !bring(owner, beer).

-!bring(_,_)
   :  true 
   <- .current_intention(I);
      .print("Failed to achieve goal '!has(_,_)'. Current intention is: ",I).
// the robot pick the can the owner has drank
+!recoger_basura(trash) 
	: has(owner, trash) & not beer(pending) & not has(owner,beer)
	<- +trash(pending);
	.print("Let me take care of that can!");
	-has(owner, trash)[source(owner)];
	+has(robot, trash);
	!tirar_al_cubo(trash).
	
// the robot throws the can in the trash                           
+!tirar_al_cubo(trash)
	: has(robot, trash) & not beer(done)
	<- !go_at(robot,trash);
	to_bucket(trash);
	-has(robot, trash);
	.print("Trash thrown in the bucket! I'll bring you a beer right now.");
	-trash(pending).



+!go_at(robot,P) : at(robot,P) <- true.
+!go_at(robot,P) : not at(robot,P)
  <- move_towards(P);
     !go_at(robot,P).

// when the supermarket makes a delivery, try the 'has' goal again
+delivered(beer,_Qtd,_OrderId)[source(Ag)]  
  :  same(Ag, supermarket) | same(Ag, supermarket1) | same(Ag, supermarket2)                                   
  <- +available(beer,fridge);                         
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

