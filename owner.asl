/* Initial goals */

!get(beer).   // initial goal: get a beer
!check_bored. // initial goal: verify whether I am getting bored
!give_money.

+!get(beer) : true
   <- .send(robot, achieve, bring(owner,beer)).
   
+!give_money <- .send(robot, tell, money(20)).

+has(owner,beer) : true
   <- !drink(beer).
   
-has(owner,beer) : true
   <-.send(robot, tell ,has(owner,trash));
   .send(robot, achieve,recoger_basura(trash));
   .print("Could you get me some more beer?");
   !get(beer).
   
// if I have not beer finish, in other case while I have beer, sip
+!drink(beer) : not has(owner,beer)
   <- true.
   
+!drink(beer) //: has(owner,beer)
   <- sip(beer);
     !drink(beer).

+!check_bored : true
   <- .random(X); .wait(X*5000+2000);   // i get bored at random times
      .send(robot, askOne, frase1); // when bored, I ask the robot about the time
      .print("Estoy aburrido");
      !check_bored.
	  
+?respuesta1 <-
	.print("Pues la verdad es que he bebido bastantes cervezas, estoy un poco mareado");
	.send(robot, askOne, frase2).

+?respuesta2 <-
	.print("De momento no es necesario, gracias");
	.send(robot, askOne, frase3).

+?respuesta3 <-
	.print("Espera, dime si ya ha acabado la lavadora");
	.send(robot, askOne, frase4).
	
+?respuesta4 <-
	.print("BUFFF que pereza, en un rato voy");
	.send(robot, askOne, frase5).
	
+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M).

