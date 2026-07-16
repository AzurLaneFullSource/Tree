return {
	id = "AUCTION_GUIDE_1",
	events = {
		{
			is3dDorm = false,
			alpha = 0.2,
			style = {
				text = "Welcome to \"Top Bidder\". Here, you'll compete with other players on the auction floor to drive up the winning bid and earn Bid Coins.",
				mode = 2,
				dir = 1,
				char = 1,
				posY = 0,
				posX = 0,
				uiset = {}
			}
		},
		{
			is3dDorm = false,
			alpha = 0.2,
			style = {
				text = "There are 3 types of auctions. They differ in the value of the items on offer, as well as the risks and rewards.",
				mode = 2,
				dir = 1,
				char = 1,
				posY = 302.6,
				posX = -355.3,
				uiset = {
					{
						lineMode = 2,
						path = "OverlayCamera/Overlay/UIMain/adapt/locationBtn3",
						pathIndex = -1
					},
					{
						lineMode = 2,
						path = "OverlayCamera/Overlay/UIMain/adapt/locationBtn1",
						pathIndex = -1
					},
					{
						lineMode = 2,
						path = "OverlayCamera/Overlay/UIMain/adapt/locationBtn2",
						pathIndex = -1
					}
				}
			}
		},
		{
			is3dDorm = false,
			alpha = 0.2,
			style = {
				text = "Information about the auction can be found here. Some auctions have an entry fee as well as a minimum bid amount.",
				mode = 2,
				dir = 1,
				char = 1,
				posY = -121.63,
				posX = 404.4,
				uiset = {
					{
						lineMode = 2,
						path = "OverlayCamera/Overlay/UIMain/adapt/locationInfo",
						pathIndex = -1
					}
				}
			}
		},
		{
			is3dDorm = false,
			alpha = 0.2,
			style = {
				text = "Once per day, you can use Order Items to have a representative order a set of items for you. You can check your results the next day.",
				mode = 2,
				dir = 1,
				char = 1,
				posY = -234.49,
				posX = 0,
				uiset = {
					{
						lineMode = 2,
						path = "OverlayCamera/Overlay/UIMain/adapt/preorderBtn",
						pathIndex = -1
					}
				}
			}
		},
		{
			is3dDorm = false,
			code = 1,
			alpha = 0.2,
			style = {
				text = "Tap the \"Missions\" button to check your auction missions.",
				mode = 2,
				dir = -1,
				char = 1,
				posY = -284.7,
				posX = -452.73,
				uiset = {}
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/adapt/taskBtn",
				pathIndex = -1,
				fingerPos = {
					posY = -28.32,
					posX = 86.2
				}
			}
		},
		{
			is3dDorm = false,
			code = 1,
			alpha = 0.2,
			style = {
				text = "New daily missions will appear every day, but challenge missions can only be done once.",
				mode = 2,
				dir = 1,
				char = 1,
				posY = -305.6,
				posX = 203.86,
				uiset = {}
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/AuctionGameTaskUI(Clone)/adapt/getAllBtn",
				pathIndex = -1
			}
		},
		{
			is3dDorm = false,
			code = 1,
			alpha = 0.2,
			ui = {
				path = "OverlayCamera/Overlay/UIMain/AwardInfoUI(Clone)",
				pathIndex = -1
			}
		},
		{
			is3dDorm = false,
			code = 1,
			alpha = 0.2,
			style = {
				text = "Tap to return to the previous screen.",
				mode = 2,
				dir = -1,
				char = 1,
				posY = 320.87,
				posX = -529.79,
				uiset = {}
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/AuctionGameTaskUI(Clone)/adapt/closeBtn",
				pathIndex = -1,
				fingerPos = {
					posY = -47.6,
					posX = 56.68
				}
			}
		},
		{
			is3dDorm = false,
			alpha = 0.2,
			style = {
				text = "Select an auction and tap \"Matchmaking\" to start up a game with other competitors.",
				mode = 2,
				dir = 1,
				char = 1,
				posY = -232.83,
				posX = 500.3,
				uiset = {}
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/adapt/matchBtn",
				pathIndex = -1,
				fingerPos = {
					posY = -28.18,
					posX = 226.64
				}
			}
		}
	}
}
