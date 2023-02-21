if(prevLoaded != loaded) {
	for(var i=0; i<array_length(roads); i++) {
		roads[i].loaded = loaded;
		with(roads[i]) {
			for(var j=0; j<array_length(leftHouses); j++)
				leftHouses[j].loaded = loaded;
			for(var j=0; j<array_length(rightHouses); j++)
				rightHouses[j].loaded = loaded;
		}
	}
}

prevLoaded = loaded;