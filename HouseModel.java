import jason.environment.grid.GridWorldModel;
import jason.environment.grid.Location;

/** class that implements the Model of Domestic Robot application */
public class HouseModel extends GridWorldModel {

    // constants for the grid objects
    public static final int FRIDGE = 16;
    public static final int OWNER  = 32;
	public static final int DELIVERYZONE = 64;
	public static final int TRASH = 128;
	
    // the grid size
    public static final int GSize = 7;

    boolean fridgeOpen   = false; // whethmer the fridge is open
    boolean carryingBeer = false; // whether the robot is carrying beer
	boolean carryingTrash = false;
	boolean onDeliver = false;
	boolean hasTrash = false; //whether the owner has a trash can
    int sipCount        = 0; // how many sip the owner did
    int availableBeers  = 3; // how many beers are available
	int numberTrashOwner = 0; 
	
                                                                                                        
    Location lFridge = new Location(0,0);
	Location lDelivery = new Location(1,0);
	Location lTrash = new Location(0,6);                                   
    Location lOwner  = new Location(GSize-1,GSize-1);

    public HouseModel() {
        // create a 7x7 grid with one mobile agent                                                               
        super(GSize, GSize, 1);

        // initial location of robot (column 3, line 3)
        // ag code 0 means the robot
        setAgPos(0, GSize/2, GSize/2);

        // initial location of fridge, owner and supermarket
		add(DELIVERYZONE, lDelivery);
		add(TRASH, lTrash);
        add(FRIDGE, lFridge);
        add(OWNER, lOwner);
    }
	
    boolean openFridge() {
        if (!fridgeOpen) {
            fridgeOpen = true;
            return true;
        } else {
            return false;
        }
    }

    boolean closeFridge() {
        if (fridgeOpen) {
            fridgeOpen = false;
            return true;
        } else {
            return false;
        }
    }
	

    boolean moveTowards(Location dest) throws InterruptedException {
        Location r1 = getAgPos(0);
        if (r1.x < dest.x)        r1.x++;
        else if (r1.x > dest.x)   r1.x--;
        if (r1.y < dest.y)        r1.y++;
        else if (r1.y > dest.y)   r1.y--;
        setAgPos(0, r1); // move the robot in the grid

        // repaint the fridge and owner locations
        if (view != null) {
			view.update(lDelivery.x,lDelivery.y);
            view.update(lFridge.x,lFridge.y);
            view.update(lOwner.x,lOwner.y);
			view.update(lTrash.x,lTrash.y);                
        }
        return true;
    }
	
	/*boolean isAdjacent(Location l1, Location l2){
		if ((l1.x == l2.x+1 && l1.y == l2.y+1) ||
		(l1.x == l2.x+1 && l1.y == l2.y+1)||
		(l1.x == l2.x+1 && l1.y == l2.y+1)){
			return true;                      
		}
	} */      

    boolean getBeer() {
        if (fridgeOpen && availableBeers > 0 && !carryingBeer) {
            availableBeers--;
            carryingBeer = true;
            if (view != null)                                                            
                view.update(lFridge.x,lFridge.y);
            return true;
        } else {
            return false;
        }
    }

    boolean addBeer(int n) {//Check this function to send the beers elsewhere PROBAR
        availableBeers += n;
        if (view != null)
            view.update(lFridge.x,lFridge.y);
        return true;
    }

    boolean handInBeer() {
        if (carryingBeer) {
            sipCount = 10;
            carryingBeer = false; 
            if (view != null)
                view.update(lOwner.x,lOwner.y);
            return true;
        } else {
            return false;
        }
    }

    boolean sipBeer() {
        if (sipCount > 0) {
            sipCount--;
			if (sipCount == 0){
				numberTrashOwner++;
				hasTrash = true; 
			}
            if (view != null)
                view.update(lOwner.x,lOwner.y);		
            return true;
        } else { 
            return false;
        }
    }

	boolean pickTrash(){
		if(hasTrash){
			hasTrash = false;
			numberTrashOwner = 0; 
			carryingTrash = true;
		return true;
		}else{                    
			return false;
		}
	}

	boolean throwTrash(){
		if(carryingTrash){
			carryingTrash = false;

			return true;
		}else{
			return false;
		}
	}
}
