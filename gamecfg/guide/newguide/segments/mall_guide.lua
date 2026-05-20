return {
	id = "MALL_GUIDE",
	events = {
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "Commander, welcome to Luxury Bay!",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {}
			}
		},
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "Tap here to begin your dream vacation adventure!",
				mode = 2,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {
					{
						lineMode = 2,
						path = "UICamera/Canvas/UIMain/MallMapUI(Clone)/map/content/201",
						pathIndex = -1
					}
				}
			},
			ui = {
				path = "UICamera/Canvas/UIMain/MallMapUI(Clone)/map/content/201",
				pathIndex = -1
			}
		}
	}
}
