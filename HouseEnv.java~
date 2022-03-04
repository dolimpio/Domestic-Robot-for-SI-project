import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.Location;
import jason.environment.grid.Area;
import java.util.logging.Logger;

public class HouseEnv extends Environment {

    // common literals
    public static final Literal of  = Literal.parseLiteral("open(fridge)");
    public static final Literal clf = Literal.parseLiteral("close(fridge)");
    public static final Literal gb  = Literal.parseLiteral("get(beer)");
    public static final Literal hb  = Literal.parseLiteral("hand_in(beer)");
    public static final Literal sb  = Literal.parseLiteral("sip(beer)");
    public static final Literal hob = Literal.parseLiteral("has(owner,beer)");
	
    public static final Literal pt = Literal.parseLiteral("pick_trash(can)");
	public static final Literal tt = Literal.parseLiteral("throw_trash(can)");
	public static final Literal hot = Literal.parseLiteral("has(owner,trash)");
	
	public static final Literal pd = Literal.parseLiteral("pick_delivery(beer)");
	
    public static final Literal af = Literal.parseLiteral("at(robot,fridge)");
    public static final Literal ao = Literal.parseLiteral("at(robot,owner)");
	public static final Literal ad = Literal.parseLiteral("at(robot,delivery)");
	public static final Literal at = Literal.parseLiteral("at(robot,trash)");
	
    static Logger logger = Logger.getLogger(HouseEnv.class.getName());

    HouseModel model; // the model of the grid

    @Override
    public void init(String[] args) {
        model = new HouseModel();

        if (args.length == 1 && args[0].equals("gui")) {
            HouseView view  = new HouseView(model);
            model.setView(view);
        }

        updatePercepts();
    }

    /** creates the agents percepts based on the HouseModel */
    void updatePercepts() {
        // clear the percepts of the agents
        clearPercepts("robot");                                               
        clearPercepts("owner");
		clearPercepts("supermarket");                                          
		
        // get the robot location
        Location lRobot = model.getAgPos(0);
		Area ownerArea = new Area​( 5,  5,  6,  6);
		Area fridgeArea = new Area​( 0,  0,  1,  1);
		Area trashArea = new Area​( 0,  5,  1,  6);
		Area deliveryArea = new Area​( 0,  0,  2,  1);
                   
        // add agent location to its percepts
        if (fridgeArea.contains​(lRobot)) {               
            addPercept("robot", af);
        }
        if (ownerArea.contains​(lRobot)) {
            addPercept("robot", ao);
        }
		if (trashArea.contains​(lRobot)) {
			addPercept("robot", at);
		}                                                                    
		if (deliveryArea.contains​(lRobot)) {                                  
            addPercept("robot", ad);
        }
        // add beer "status" the percepts   
        if (model.fridgeOpen) {
            addPercept("robot", Literal.parseLiteral("stock(beer,"+model.availableBeers+")"));
        }
		                                                                 
        if (model.sipCount > 0) {
            addPercept("robot", hob);
            addPercept("owner", hob);
        }
		
		if(model.hasTrash & model.numberTrashOwner > 0){   
			//addPercept("robot",Literal.parseLiteral("trashOwner(beer,"+model.numberTrashOwner+")"));
			addPercept("robot", hot);
 
		}
                                                                   
    }


    @Override
    public boolean executeAction(String ag, Structure action) {
		
        System.out.println("["+ag+"] doing: "+action);
        boolean result = false; 
		
		if (action.getFunctor().equals("move_towards")) {
			
			String l = action.getTerm(0).toString();
			Location dest = null;
			               
			if (l.equals("fridge")) {
				dest = model.lFridge;
			}                             
			else if (l.equals("owner")) {
				dest = model.lOwner;
			} 
			else if(l.equals("delivery")){
				dest = model.lDelivery;
			}else if(l.equals("trash")){
				dest = model.lTrash;
			}
			
			try {
				result = model.moveTowards(dest);
			} catch (Exception e) {
					e.printStackTrace();
			}
		}
		
		if(ag.equals("robot")){
			if (action.equals(of)) { // of = open(fridge)
				result = model.openFridge();
			} 
			else if (action.equals(clf)) { // clf = close(fridge)
				result = model.closeFridge();
			} 
			else if (action.equals(gb)) { //gb = get(beer)
				result = model.getBeer();
			} 
			else if (action.equals(hb)) { //hb hand_in(beer)
				result = model.handInBeer();
			}
			else if (action.equals(pt)){ //pt pick_trash(can)  
			    result = model.pickTrash();    
			}
			else if (action.equals(tt)){ //tt throw_trash(can)
			    result = model.throwTrash();    
			}
			else if (action.equals(pd)){ //tt pick_delivery(beer)
			    result = model.pickDelivery();    
			}
		}
		else if (ag.equals("owner")) {                   
			if(action.equals(sb)){
				result = model.sipBeer();
			}
                  
		}
		else if(ag.equals("supermarket")){
			if (action.getFunctor().equals("deliver")) {	
				// wait 4 seconds to finish "deliver"
				try {                                                              
					Thread.sleep(4000);
					result = model.addBeer( (int)((NumberTerm)action.getTerm(1)).solve());
					
				} catch (Exception e) {
					logger.info("Failed to execute action deliver!"+e);
				}
			}

        } else {
            logger.info("Failed to execute action "+action);
        }
                                                                                                                                                                        
        if (result) {
            updatePercepts();
            try {
                Thread.sleep(100);
            } catch (Exception e) {}
        }
        return result;
    }
}
