!take_trash.

// if the trash is full, it empties it, if not wait                
+!take_trash : trash(full)
	<- empty_trash(trash);                                               
	-trash(full);
	.print("Trash has been emptied.");
	!take_trash.
	

+!take_trash : not trash(full) 
	<- !take_trash.                                    