//Auto process the data for the Lutz test
run("Close All");
print("\\Clear");
roiManager("reset");

path1 = File.openDialog("Select Image #1");
path2 = File.openDialog("Select Image #2");

open(path1);
rename("im1");
dOff = getWidth(); //offset for processing via images (keeps numbers from being negative)
run("Duplicate...", "title=findBB1.dcm");
run("Find Maxima...", "noise=100 output=[Maxima Within Tolerance]");
run("Analyze Particles...", "size=1-infinity circularity=0.85-1.00 show=Masks exclude add");
run("Close");
cnt = roiManager("count");
x1 = newArray(cnt);
y1 = newArray(cnt);
for (i = 0; i < cnt; i++) 
{
	//get centroid of each point
	roiManager("select",i);
	List.setMeasurements;
	//get the centroid position
	x1[i] = List.getValue("X");
	y1[i] = List.getValue("Y");
}


roiManager("reset");
open(path2);
rename("im2");
run("Flip Horizontally");
run("Duplicate...", "title=findBB2.dcm");
run("Find Maxima...", "noise=100 output=[Maxima Within Tolerance]");
run("Analyze Particles...", "size=1-infinity circularity=0.85-1.00 show=Masks exclude add");
run("Close");
cnt = roiManager("count");
x2 = newArray(cnt);
y2 = newArray(cnt);
for (i = 0; i < cnt; i++) 
{
	//get centroid of each point
	roiManager("select",i);
	List.setMeasurements;
	//get the centroid position
	x2[i] = List.getValue("X");
	y2[i] = List.getValue("Y");
}

//find the distance from each point to every other point
cnt = x1.length*x2.length;
dx = newArray(cnt);
dy = newArray(cnt);
idx = 0;
for (i = 0; i < x1.length; i++)
{
	for (j = 0; j < x2.length; j++)
	{
		dx[idx] = x1[i]-x2[j]+dOff;
		dy[idx] = y1[i]-y2[j]+dOff;
		idx++;
	}
}

//find the most common offset distance in each direction
newImage("dx arr","16-bit",cnt,1,1);
for (i = 0; i < dx.length; i++)
{
	//change to integer
	setPixel(i,0,round(dx[i]));	
}
List.setMeasurements;
dxm = List.getValue("Mode")-dOff;
run("Close");
print("shift x: " + dxm);

newImage("dy arr","16-bit",cnt,1,1);
for (i = 0; i < dy.length; i++)
{
	//change to integer
	setPixel(i,0,round(dy[i]));	
}
List.setMeasurements;
dym = List.getValue("Mode")-dOff;
run("Close");
print("shift y: " + dym);

//apply offsets to original image
selectWindow("im2");
run("Translate...", "x="+dxm+" y="+dym+" interpolation=None");

//add results
imageCalculator("Add create 32-bit", "im1","im2");
rename("Lutz Result");
setMinAndMax(27700, 32975);

//save results
dir1 = File.directory;
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
saveAs("Tiff", dir1 + "Lutz_Result_" + d2s(year,0) + d2s(month+1,0) + d2s(dayOfMonth,0) + ".tif");
setLocation(0,0);