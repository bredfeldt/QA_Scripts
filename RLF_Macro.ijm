run("Close All");
print("\\Clear");
roiManager("reset");

run("Open...");
img_name = getInfo("image.filename");
print(img_name);

run("Duplicate...", "title=findEdge.dcm");
run("Duplicate...", "title=findBBs.dcm");

selectWindow("findBBs.dcm");
//Find the BB's in the image
run("Find Maxima...", "noise=150 output=[Maxima Within Tolerance]");
//run("Create Mask");
run("Gaussian Blur...", "sigma=5"); //attempt to eliminate the delta shaped BB's
setThreshold(5, 35);
//run("Invert");
//setAutoThreshold("Triangle");
run("Create Mask");
run("Analyze Particles...", "size=1-infinity circularity=0.85-1.00 show=Masks exclude add");

//Find the field edge in the image
selectWindow("findEdge.dcm");
setAutoThreshold("Default");
run("Create Mask");
run("Distance Map");

//index into distance map to find distances to each BB
cnt = roiManager("count");
for (i = 0; i < cnt; i++) 
{
	roiManager("select",i);
	List.setMeasurements;
	//get the centroid position
	x = List.getValue("X");
	y = List.getValue("Y");	
	dist = getPixel(x,y)*0.5597;
	reg_idx = i + 1;
	if (dist > 20 && dist < 30)
	{
		if (dist < 24.0 || dist > 26.0)
		{
			print("P" + reg_idx + " Distance = " + dist + " mm <> *FAIL*");
		}
		else
		{
			print("P" + reg_idx + " Distance = " + dist + " mm <> PASS");
		}
	}
}
//Clean up windows
run("Close");
selectWindow("findBBs.dcm");
run("Close");
selectWindow("findBBs.dcm Maxima");
run("Close");
selectWindow("findEdge.dcm");
run("Close");
selectWindow("Mask of mask");
run("Close");
selectWindow("mask");
selectWindow("Log");




