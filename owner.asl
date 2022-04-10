/* Initial goals */

//!cheerUp. //Main goal for 'Owner'

!check_bored. // initial goal: verify whether I am getting bored

/*
!cheerUp <- !talkRobot. //Por ahora el plan esta incompleto
!cheerUp <- !cleanHouse.
!cheerUp <- !drinkBeer.
!cheerUp <- !wakeUp.
*/
!drinkBeer <- !get(beer).
+!get(beer) : true                                             
   <- .send(robot, achieve, bring(owner,beer)).

+has(owner,beer) : true
   <- !drink(beer).
-has(owner,beer) : true
   <- !get(beer).
                                                                                                                                                                 
// if I have not beer finish, in other case while I have beer, sip
+!drink(beer) : not has(owner,beer) //Why finish? The goal is still there right? DUDA
   <- true.
+!drink(beer) //: has(owner,beer)
   <- sip(beer);
     !drink(beer).
  
+!check_bored : true
   <- .random(X); .wait(X*5000+2000);   // i get bored at random times
      .send(robot, askOne, time(_), R); // when bored, I ask the robot about the time
      .print(R);
      !check_bored.
	  
+!talkRobot <-
	.println("Owner esta aburrido y le dice Hola al Robot");
	.send(myRobot,tell,msg("Hola!!"));
	.wait(answer(Answer));
	.send(myRobot,tell,msg("Estoy bien")).

+msg(M)[source(Ag)] : true
   <- .print("Message from ",Ag,": ",M);
      -msg(M).

