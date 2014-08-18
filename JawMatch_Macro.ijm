
run("Close All");
print("\\Clear");
roiManager("reset");

//User should select first JawQuandrant image
path1 = File.openDialog("Select First Jaw Image");
dir1 = File.directory;

//Find all JawQuadrant images in directory
list1 = getFileList(dir1);

//
for (i = 0; i < list1.length; i++)
{	
	if (startsWith(list1[i], "JawQuadrant"))
	{
		open(dir1+list1[i]);
	}
}

//run("Images to Stack", "name=Stack title=[] use");
//run("Z Project...", "projection=[Average Intensity]");

