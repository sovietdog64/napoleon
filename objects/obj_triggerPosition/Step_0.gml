if(shouldDoAction) {
	try {doAction();}
		catch (err){shouldDoAction = false;}	
}