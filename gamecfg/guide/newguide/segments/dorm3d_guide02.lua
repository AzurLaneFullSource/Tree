return {
	id = "DORM3D_GUIDE02",
	events = {
		{
			alpha = 0,
			style = {
				text = "先和天狼星互动一下吧！",
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
				text = "和她说说话吧！",
				mode = 1,
				dir = 1,
				char = "char",
				posY = -217,
				posX = -137,
				uiset = {}
			},
			ui = {
				path = "UICamera/Canvas/UIMain/Dorm3dMainUI(Clone)/UI/watch/Role/Talk",
				pathIndex = -1
			}
		},
		{
			alpha = 0.4,
			ui = {
				path = "UICamera/Canvas/UIMain/Dorm3dMainUI(Clone)/UI/watch/btn_back",
				pathIndex = -1
			}
		},
		{
			alpha = 0,
			delay = 1,
			notifies = {
				{
					notify = "story update",
					body = {
						storyId = "DORM3D_GUIDE02"
					}
				}
			}
		},
		{
			notifies = {
				{
					notify = "Dorm3dRoomMediator.GUIDE_CHECK_LEVEL_UP",
					body = {}
				}
			}
		},
		{
			alpha = 0.4,
			ui = {
				path = "OverlayCamera/Overlay/UIMain/LevelUpWindow/bg/Image",
				eventPath = "OverlayCamera/Overlay/UIMain/LevelUpWindow/bg",
				pathIndex = -1
			}
		},
		{
			alpha = 0.4,
			style = {
				text = "领取到了新的礼物呢，去看看吧",
				mode = 1,
				dir = 1,
				char = "char",
				posY = -230,
				posX = -425,
				uiset = {}
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/Dorm3dAwardInfoUI(Clone)/bg/dot",
				eventPath = "OverlayCamera/Overlay/UIMain/Dorm3dAwardInfoUI(Clone)/bg",
				pathIndex = -1
			}
		}
	}
}
