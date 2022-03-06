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
   <- .send(supermarket, achieve, order(beer,3));
      !go_at(robot,fridge). // go to fridge and wait there.

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
	  
+!recoger_basura(trash) 
	: has(owner, trash) & not beer(pending) & not has(owner,beer)
	<- +trash(pending);
	.print("Me voy a encargar de esa lata!");
	-has(owner, trash)[source(owner)];
	+has(robot, trash);
	!tirar_al_cubo(trash).

+!tirar_al_cubo(trash)
	: has(robot, trash) & not beer(done) //quitar
	<- !go_at(robot,trash);
	to_bucket(trash);
	-has(robot, trash);
	.print("Basura en el cubo! Ahora te llevo más cerveza.");
	-trash(pending).



+!go_at(robot,P) : at(robot,P) <- true.
+!go_at(robot,P) : not at(robot,P)
  <- move_towards(P);
     !go_at(robot,P).

// when the supermarket makes a delivery, try the 'has' goal again
+delivered(beer,_Qtd,_OrderId)[source(supermarket)]
  :  true
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

