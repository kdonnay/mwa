import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.io.*;

/**
 * WakeCounter class:
 * generates wakes for the mwa.R package
 * 
 * @author Karsten Donnay & Sebastian Schutte, ETH Zurich 2014
 * 
 */


class WakeCounter {
    /**
     * Wake Counting Method:
     *  
     * @author Karsten Donnay, ETH Zurich 2014
     * 
     * @param timevarinput
     * @param spatvarinput
     * @param data
     * @param wakeindexinput
     * @param wakeparams
     * @param treatment
     * @param control
     * @param depvar
     * @param matchColumns
     * @param path
     *  
     * @return
     */
    public static String[][] wakeCounting(String[] timevarinput, String[] spatvarinput, String[][] data, String[][] wakeindexinput, String[] wakeparams, String[] treatment, String[] control, String[] depvar, String[] matchColumns, String[] path){
	int events = data.length;
	int wakeevents = wakeindexinput.length;
	int[] wakeindex = new int[wakeevents];
	for (int var=0;var<wakeevents;var++){
	    try{
		wakeindex[var]=(int) Double.parseDouble(wakeindexinput[var][0])-1;
	    }
	    catch ( NumberFormatException e){
		e.printStackTrace();
	    }
	}
	int[] timevar = new int[timevarinput.length];
	for (int var=0;var<timevarinput.length;var++){
	    try{
		timevar[var] = (int) Double.parseDouble(timevarinput[var]);
	    }
	    catch ( NumberFormatException e){
		e.printStackTrace();
	    }
	}
	double[] spatvar = new double[spatvarinput.length];
	for (int var=0;var<spatvarinput.length;var++){
	    try {
		spatvar[var] = Double.parseDouble(spatvarinput[var]);
	    }
	    catch ( NumberFormatException e){
		e.printStackTrace();
	    }		
	}
	int[] latlongindex = new int[2];
	try{
	    latlongindex[0] = (int) Double.parseDouble(wakeparams[0])-1;
	    latlongindex[1] = (int) Double.parseDouble(wakeparams[1])-1;
	}
	catch ( NumberFormatException e){
	    e.printStackTrace();
	}
	int timeindex=-1;
	try{
	    timeindex = (int) Double.parseDouble(wakeparams[2])-1;
	}
	catch ( NumberFormatException e){
	    e.printStackTrace();
	}
	int[] treatmentcontroldepvarindex = new int[3];
	try{
	    treatmentcontroldepvarindex[0] = (int) Double.parseDouble(treatment[0])-1;
	    treatmentcontroldepvarindex[1] = (int) Double.parseDouble(control[0])-1;
	    treatmentcontroldepvarindex[2] = (int) Double.parseDouble(depvar[0])-1;
	}
	catch ( NumberFormatException e){
	    e.printStackTrace();
	}
	int[] matchColumnIndices = new int[matchColumns.length];
	for (int column_count=0; column_count<matchColumns.length; column_count++){
	    try{
		matchColumnIndices[column_count] = (int) Double.parseDouble(matchColumns[column_count])-1;
	    }
	    catch ( NumberFormatException e){
		e.printStackTrace();
	    }
	}
	double timescaling = -1;
	if (wakeparams[3].equals("secs")){
	    timescaling = 1000;
	}
	if (wakeparams[3].equals("mins")){
	    timescaling = 60*1000;
	}
	if (wakeparams[3].equals("hours")){
	    timescaling = 60*60*1000;
	}
	if (wakeparams[3].equals("days")){
	    timescaling = 24*60*60*1000;
	}	
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	if (data[0][timeindex].length() > 10){
	    format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	}
	Date[] date = new Date[events];
	for (int event = 0; event<events; event++){
	    try{
		date[event] = format.parse(data[event][timeindex]);
	    }
	    catch ( ParseException e){
		e.printStackTrace();
	    }
	}
	double[] lat = new double[events];
	for (int event = 0; event<events; event++){
	    try{
		lat[event] = Double.parseDouble(data[event][latlongindex[0]]);
	    }
	    catch ( NumberFormatException e){
		e.printStackTrace();
	    }
	}
	double[] lon = new double[events];
	for (int event = 0; event<events; event++){
	    try{
		lon[event] = Double.parseDouble(data[event][latlongindex[1]]);
	    }
	    catch ( NumberFormatException e){
		e.printStackTrace();
	    }
	}
	int variations = wakeevents*timevar.length*spatvar.length;
	String[][] wakes = new String[variations][11+matchColumns.length];
	boolean remove = false;
	int forwarddependent = -1;
	int backwarddependent = -1;
	int double_pre = -1;
	int double_post = -1;
	int spill_pre = -1;
	int spill_post = -1;
	boolean check = true;
	int eventcounter = -1;
	int eventindex = -1;
	Date date1 = null;
	Date date2 = null;
	int datediff = -1;
	double spatialdiff = -1;
	int index_offset = -1;
	int index = -1;
	int split = -1;
	double firstsum= -1;
	double secondsum= -1;
	double firstsplit = -1;
	double secondsplit = -1;
	String[][] missing_wake = new String[timevar.length][wakeevents];
	boolean missing_wake_flag = false;
	int removedwakes = 0;
	int varcounter = 0;
	double progresscounter = ((double)variations)/20;
	System.out.printf("Iterating through sliding windows and generating wakes");
	for (int spatialwindow=0; spatialwindow<spatvar.length; spatialwindow++){
	    for (int timewindow=0; timewindow<timevar.length; timewindow++){
		for (int event=0; event<wakeevents; event++){
		    wakes[varcounter][0] = wakeindexinput[event][0];
		    wakes[varcounter][1] = timevarinput[timewindow];
		    wakes[varcounter][2] = spatvarinput[spatialwindow];
		    wakes[varcounter][3] = wakeindexinput[event][1];
		    remove = false;
		    double[] trendseries = new double[timevar[timewindow]+1];
		    check = true;
		    forwarddependent = 0;
		    backwarddependent = 0;
		    double_pre = 0;
		    spill_pre = 0;
		    double_post = 0;
		    spill_post = 0;                    
		    eventcounter = 1;
		    while(check){
			eventindex = wakeindex[event] - eventcounter;
			if (eventindex > -1){
			    datediff = (int) Math.floor((date[wakeindex[event]].getTime() - date[eventindex].getTime())/timescaling);
			    spatialdiff = getGreatCircleDistance(lat[eventindex],lon[eventindex],lat[wakeindex[event]],lon[wakeindex[event]]);
			    if (datediff >= 0 && datediff<=timevar[timewindow] && spatialdiff<=spatvar[spatialwindow]){
				if (data[eventindex][treatmentcontroldepvarindex[2]].equals(depvar[1])){
				    backwarddependent = backwarddependent + 1;
				    trendseries[datediff] = trendseries[datediff] + 1;
				}
				if (wakes[varcounter][3].equals("1")){
				    if (data[eventindex][treatmentcontroldepvarindex[0]].equals(treatment[1])){
					double_pre = double_pre + 1;
				    }
				    if (data[eventindex][treatmentcontroldepvarindex[1]].equals(control[1])){
					spill_pre = spill_pre + 1;
				    }
				}
				if (wakes[varcounter][3].equals("0")){
				    if (data[eventindex][treatmentcontroldepvarindex[1]].equals(control[1])){
					double_pre = double_pre + 1;
				    }
				    if (data[eventindex][treatmentcontroldepvarindex[0]].equals(treatment[1])){
					spill_pre = spill_pre + 1;
				    }
				}
			    }
			    if (datediff>timevar[timewindow]){
				check = false; 
			    }
			}
			if (eventindex < 0){
			    check = false;
			    remove = true;
			    missing_wake[timewindow][event] = wakeindexinput[event][0];
			    missing_wake_flag = true;
			} 
			eventcounter = eventcounter+1;
		    }
		    wakes[varcounter][4] = Integer.toString(backwarddependent);
		    if (!remove && (timevar[timewindow] % 2) == 0){
			split = (int) (timevar[timewindow]/2.0);
			firstsum = 0;
			for (int splitcount=split; splitcount<timevar[timewindow]+1; splitcount++){
			    firstsum=firstsum+trendseries[splitcount];
			}
			secondsum = 0;
			for (int splitcount=0; splitcount<split; splitcount++){
			    secondsum = secondsum + trendseries[splitcount];
			}
			wakes[varcounter][5] = Double.toString(secondsum-firstsum);
		    }
		    if (!remove && (timevar[timewindow] % 2) > 0){
			split = (int) Math.ceil((timevar[timewindow]+1)/2.0);
			firstsum = 0;
			for (int splitcount=split; splitcount<timevar[timewindow]+1; splitcount++){
			    firstsum = firstsum + trendseries[splitcount];
			}
			secondsum = 0;
			for (int splitcount=0; splitcount<split; splitcount++){
			    secondsum = secondsum + trendseries[splitcount];
			}
			firstsplit = secondsum-split/(split-1)*firstsum;
			firstsum = 0;
			for (int splitcount=split-1; splitcount<timevar[timewindow]+1; splitcount++){
			    firstsum = firstsum + trendseries[splitcount];
			}
			secondsum = 0;
			for (int splitcount=0; splitcount<split-1; splitcount++){
			    secondsum = secondsum + trendseries[splitcount];
			}
			secondsplit = split/(split-1)*secondsum-firstsum;
			wakes[varcounter][5] = Double.toString(0.5*(firstsplit+secondsplit));
		    }
		    wakes[varcounter][6] = Integer.toString(double_pre);
		    wakes[varcounter][7] = Integer.toString(spill_pre);
		    check = true;
		    eventcounter = 1;
		    while (check && !remove){
			eventindex = wakeindex[event] + eventcounter;
			if (eventindex<events){
    			    datediff = (int) Math.floor((date[eventindex].getTime() - date[wakeindex[event]].getTime())/timescaling);
			    spatialdiff = getGreatCircleDistance(lat[eventindex],lon[eventindex],lat[wakeindex[event]],lon[wakeindex[event]]);
			    if (datediff >= 1 && datediff<=timevar[timewindow] && spatialdiff<=spatvar[spatialwindow]){
				if (data[eventindex][treatmentcontroldepvarindex[2]].equals(depvar[1])){
				    forwarddependent = forwarddependent + 1;
				}
				if (wakes[varcounter][3].equals("1")){
				    if (data[eventindex][treatmentcontroldepvarindex[0]].equals(treatment[1])){
					double_post = double_post + 1;
				    }
				    if (data[eventindex][treatmentcontroldepvarindex[1]].equals(control[1])){
					spill_post = spill_post + 1;
				    }
				}
				if (wakes[varcounter][3].equals("0")){
				    if (data[eventindex][treatmentcontroldepvarindex[1]].equals(control[1])){
					double_post = double_post + 1;
				    }
				    if (data[eventindex][treatmentcontroldepvarindex[0]].equals(treatment[1])){
					spill_post = spill_post + 1;
				    }
				}
			    }

			    if (datediff>timevar[timewindow]){
				check = false;
			    }
			}
			if (eventindex > events-1){
			    check = false;
			    remove = true;    
			    missing_wake[timewindow][event] = wakeindexinput[event][0];
			    missing_wake_flag = true;
			}
			eventcounter = eventcounter+1;

		    }
		    wakes[varcounter][8] = Integer.toString(forwarddependent);
		    wakes[varcounter][9] = Integer.toString(double_post);
		    wakes[varcounter][10] = Integer.toString(spill_post);
		    if (!remove){
			index_offset = 11;
			for (int column_count=0; column_count<matchColumns.length; column_count++){
			    wakes[varcounter][column_count+index_offset] = data[wakeindex[event]][matchColumnIndices[column_count]];
			}
		    }
		    if (remove){
			wakes[varcounter][1]="NaN";
			removedwakes++;
		    }
		    varcounter++;
		    if (varcounter>=progresscounter){
		   	System.out.printf(".");
			progresscounter = progresscounter + ((double)variations)/20;
		    }
		}
	    }
	}
	if (missing_wake_flag){
	    int completewakes = varcounter-removedwakes;
	    createLog(missing_wake,completewakes,removedwakes,timevar,wakeparams,wakeevents,path);
	}
	return wakes;
    }

    /**
     * Great Circle Distance Method:
     * all distances are metric (km)
     * 
     * @Author: Karsten Donnay, ETH Zurich 2014
     * 
     * @param latPos
     * @param longPos
     * @param latTarget
     * @param longTarget
     * @return
     */
    public static double getGreatCircleDistance(double latPos, double longPos, double latTarget, double longTarget){
	double a,b,d,l;
	a = Math.toRadians(latPos);
	b = Math.toRadians(latTarget);
	l = Math.toRadians(longPos) - Math.toRadians(longTarget);
	d = Math.sqrt(Math.pow(Math.cos(b) * Math.sin(l),2)+Math.pow(Math.cos(a) * Math.sin(b) - Math.sin(a)*Math.cos(b)*Math.cos(l),2));
	d = Math.atan2(d,(Math.sin(a) * Math.sin(b)) + Math.cos(a) * Math.cos(b) * Math.cos(l));
	d = Math.toDegrees(d);
	return d * 111.111;
    }

    /**
     * Log file generator
     * 
     * @Author: Karsten Donnay, ETH Zurich 2014
     * 
     * @param missing_wake
     * @param completewakes
     * @param removedwakes
     * @param timevar
     * @param wakeparams
     * @param events
     * 
     */
    public static void createLog(String[][] missing_wake, int completewakes, int removedwakes, int[] timevar, String[] wakeparams, int wakeevents, String[] path){
	try{
	    FileWriter fstream = new FileWriter(path[0]+"/matchedwake_log.txt");
	    BufferedWriter out = new BufferedWriter(fstream);
	    String outstring = "";
	    boolean entry = false;
	    out.write("This log file contains a list of cases for which the time window around a 'wake event'" +
		      " (i.e. an event of either treatment or control type) either in the forward or backward" +
		      " time direction exceeded the range of the data set for a given temporal window size.\n\n" +
		      "IMPORTANT: The resulting incomplete wakes are thus not considered for the matched wake analysis.\n\n" +
		      "The events omitted are identified by their position in the time-ordered data set, i.e." +
		      " 1 represents the first (treatment or control type) event etc.. For the temporal window sizes" +
		      " you specified " + removedwakes + " wakes are incomplete; for the matched wake analysis thus only "
		      + completewakes + " complete wakes were considered.\n\n- - - - - - - - - - - - - - - - - -  \n\n" +
		      "Please find below the list of omitted events for each time window size you specified.\n");				
	    for (int windowcount=0;windowcount<timevar.length;windowcount++){
		out.write("\ntime window of "+timevar[windowcount]+" "+wakeparams[3]+":\n");
		outstring = "incomplete wakes for events ";
		entry = false;
		for (int writecount=0;writecount<wakeevents;writecount++){
		    if (missing_wake[windowcount][writecount]!=null){
			if (!entry){
			    outstring=outstring+missing_wake[windowcount][writecount];
			    entry = true;
			}
			else{
			    outstring=outstring+", "+missing_wake[windowcount][writecount];
			}
		    }
		}
		if (!entry){
		    outstring = "no incomplete wakes";
		}
		outstring=outstring+"\n";
		out.write(outstring);
	    }
	    out.close();
	}
	catch (Exception e){//Catch exception if any
	    System.err.println("Error: " + e.getMessage());
	}
    }
    
     /**
     * Returns heap space of running JVM
     * 
     * @Author: Karsten Donnay, ETH Zurich 2014
     * 
     */
     public static String heapspace(){
	 String memory = Long.toString(Runtime.getRuntime().maxMemory());
	 return memory;
     }

}
