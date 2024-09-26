return {
	id = "DORM3D_GUIDE03",
	events = {
		{
			alpha = 0,
			style = {
				text = "继续和天狼星互动",
				mode = 1,
				dir = 1,
				char = "char",
				posY = -269,
				posX = 641,
				uiset = {}
			},
			showSign = {
				type = 2,
				signList = {
					{
						signType = 4,
						pos = {
							-23,
							-97,
							0
						}
					}
				},
				clickArea = {
					500,
					880
				}
			}
		},
		{
			alpha = 0,
			notifies = {
				{
					notify = "Dorm3dRoomMediator.GUIDE_CLICK_LADY",
					body = {}
				}
			}
		},
		{
			alpha = 0.4,
			delay = 2,
			style = {
				text = "将准备好的礼物送给天狼星吧！",
				mode = 1,
				dir = 1,
				char = "char",
				posY = -236,
				posX = -102,
				uiset = {}
			},
			ui = {
				path = "UICamera/Canvas/UIMain/Dorm3dMainUI(Clone)/UI/watch/Role/Gift",
				pathIndex = -1
			}
		},
		{
			alpha = 0.4,
			style = {
				text = "点击此处选中礼物",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 172,
				posX = 73,
				uiset = {}
			},
			ui = {
				path = "/OverlayCamera/Overlay/UIMain/gift_panel/content/view/container/1021001",
				pathIndex = -1,
				triggerType = {
					2,
					true
				}
			}
		},
		{
			alpha = 0.4,
			delay = 0.1,
			style = {
				text = "将它送给天狼星吧！",
				mode = 1,
				dir = 1,
				char = "char",
				posY = -224,
				posX = 79,
				uiset = {}
			},
			ui = {
				path = "/OverlayCamera/Overlay/UIMain/gift_panel/bottom/btn_confirm",
				pathIndex = -1
			}
		},
		{
			notifies = {
				{
					notify = "story update",
					body = {
						storyId = "DORM3D_GUIDE03"
					}
				}
			}
		},
		{
			alpha = 0.4,
			delay = 3,
			ui = {
				path = "UICamera/Canvas/UIMain/Dorm3dGiftUI(Clone)/btn_back",
				pathIndex = -1
			}
		},
		{
			alpha = 0.4,
			ui = {
				path = "UICamera/Canvas/UIMain/Dorm3dMainUI(Clone)/UI/watch/btn_back",
				pathIndex = -1
			}
		}
	}
}
