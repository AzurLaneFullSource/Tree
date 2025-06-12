local var0_0 = class("FurnitureSlideExtraLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dFurnitureSlideExtraUI"
end

function var0_0.init(arg0_2)
	arg0_2.slideList = ApartmentProxy.GetSlideInviteList()

	arg0_2:InitUI()
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.ShowInteraction", function()
		arg0_2:ShowIneraction()
	end)
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.HideInteraction", function()
		arg0_2:HideInteraction()
	end)
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.ShowPerformance", function()
		arg0_2:ShowPerformance()
	end)
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.HidePerformance", function()
		arg0_2:HidePerformance()
	end)

	arg0_2.system = SlideExtraSystem.New(arg0_2.event, arg0_2.contextData.scene)

	arg0_2.system:Init()
end

function var0_0.InitUI(arg0_7)
	arg0_7.queuePanel = arg0_7._tf:Find("top")
	arg0_7.performancePanel = arg0_7._tf:Find("performance")
	arg0_7.queueContainer = arg0_7._tf:Find("top/bg/container/group")
	arg0_7.performanceContainer = arg0_7._tf:Find("performance/line/container")
	arg0_7.queueItemList = UIItemList.New(arg0_7.queueContainer, arg0_7.queueContainer:Find("tpl"))
	arg0_7.performanceItemList = UIItemList.New(arg0_7.performanceContainer, arg0_7.performanceContainer:Find("tpl"))

	arg0_7.queueItemList:make(function(arg0_8, arg1_8, arg2_8)
		local var0_8 = arg1_8 + 1
		local var1_8 = arg0_7.slideList[var0_8]

		if arg0_8 == UIItemList.EventUpdate then
			local var2_8 = pg.dorm3d_resource.get_id_list_by_ship_group[var1_8][2]

			GetImageSpriteFromAtlasAsync(pg.dorm3d_resource[var2_8].head_Icon, "", arg2_8:Find("icon"), true)
		end
	end)
	arg0_7.performanceItemList:make(function(arg0_9, arg1_9, arg2_9)
		local var0_9 = arg1_9 + 1
		local var1_9 = arg0_7.slideList[var0_9]

		if arg0_9 == UIItemList.EventUpdate then
			local var2_9 = pg.dorm3d_resource.get_id_list_by_ship_group[var1_9][2]

			GetImageSpriteFromAtlasAsync(pg.dorm3d_resource[var2_9].head_Icon, "", arg2_9:Find("icon"), true)
			setText(arg2_9:Find("name"), ShipGroup.getDefaultShipNameByGroupID(var1_9))
			onButton(arg0_7, arg2_9, function()
				arg0_7:emit(FurnitureSlideExtraMediator.GO_SLIDE_PERFORMANCE, var1_9)
			end, SFX_DORM_CLICK)
		end
	end)
	onButton(arg0_7, arg0_7._tf:Find("top/bg"), function()
		arg0_7:emit(FurnitureSlideExtraMediator.OPEN_INVITE_LAYER, arg0_7.slideList)
	end, SFX_DORM_CLICK)
	onButton(arg0_7, arg0_7._tf:Find("top/walk"), function()
		arg0_7.system.wayPoints = arg0_7.system.ladyMovePointsDic[30221].WalkToSlide

		warning(arg0_7.wayPoints)

		arg0_7.system.curIndex = 0
	end)
	onButton(arg0_7, arg0_7._tf:Find("top/ladder"), function()
		arg0_7.system.ladyEnv:PlaySingleAction("swim_slide_ladder_01")

		arg0_7.system.bonePosition = arg0_7.system.ladyBoneRoot.localPosition
	end)
	onButton(arg0_7, arg0_7._tf:Find("top/slide"), function()
		arg0_7.system.ladyEnv:PlaySingleAction("swim_slide_inwater_01")

		arg0_7.system.bonePosition = arg0_7.system.ladyBoneRoot.localPosition
	end, SFX_DORM_CLICK)
end

function var0_0.InitSlide(arg0_15)
	arg0_15.system:InitSlide()
end

function var0_0.didEnter(arg0_16)
	arg0_16:HideInteraction()
	arg0_16:HidePerformance()
end

function var0_0.UpdateSlideInviteList(arg0_17, arg1_17, arg2_17, arg3_17)
	arg0_17.slideList = arg1_17

	arg0_17:Flush()
	arg0_17.system:UpdateSlideInviteList(arg2_17, arg3_17)
end

function var0_0.Flush(arg0_18)
	arg0_18.queueItemList:align(#arg0_18.slideList)
	arg0_18.performanceItemList:align(#arg0_18.slideList)
end

function var0_0.ShowIneraction(arg0_19)
	setActive(arg0_19.queuePanel, true)
	arg0_19.queueItemList:align(#arg0_19.slideList)
end

function var0_0.HideInteraction(arg0_20)
	setActive(arg0_20.queuePanel, false)
end

function var0_0.ShowPerformance(arg0_21)
	setActive(arg0_21.performancePanel, true)
	arg0_21.performanceItemList:align(#arg0_21.slideList)
end

function var0_0.HidePerformance(arg0_22)
	setActive(arg0_22.performancePanel, false)
end

function var0_0.willExit(arg0_23)
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.ShowInteraction")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.HideInteraction")
	arg0_23.system:Dispose()
end

return var0_0
