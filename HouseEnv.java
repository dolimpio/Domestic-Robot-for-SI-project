import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.Location;
import java.util.logging.Logger;

public class HouseEnv extends Environment {

    // common literals
    public static final Literal of  = Literal.parseLiteral("open(fridge)");
    public static final Literal clf = Literal.parseLiteral("close(fridge)");
    public static final Literal gb  = Literal.parseLiteral("get(beer)");
    public static final Literal hb  = Literal.parseLiteral("hand_in(beer)");
    public static final Literal sb  = Literal.parseLiteral("sip(beer)");
    public static final Literal hob = Literal.parseLiteral("has(owner,beer)");

    public static final Literal af = Literal.parseLiteral("at(robot,fridge)");
    public static final Literal ao = Literal.parseLiteral("at(robot,owner)");
	public static final Literal ad = Literal.parseLiteral("at(robot,delivery)");
	
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

        // add agent location to its percepts
        if (lRobot.x == model.lFridge.x+1 && lRobot.y == model.lFridge.y+1) {
            addPercept("robot", af);
        }
        if (lRobot.x == model.lOwner.x-1 && lRobot.y == model.lOwner.y-1) {
            addPercept("robot", ao);
        }
		if (lRobot.equals(model.lDelivery)) {
            addPercept("robot", ad);
        }
        // add beer "status" the percepts  (MODIFICAR PARA QUE VAYA A LA ZONA DE ENTREGA )   
        if (model.fridgeOpen) {
            addPercept("robot", Literal.parseLiteral("stock(beer,"+model.availableBeers+")"));
        }
		                                                                 
        if (model.sipCount > 0) {
            addPercept("robot", hob);
            addPercept("owner", hob);
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
