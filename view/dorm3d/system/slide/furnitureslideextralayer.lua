local var0_0 = class("FurnitureSlideExtraLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dFurnitureSlideExtraUI"
end

function var0_0.init(arg0_2)
	arg0_2.slideList = ApartmentProxy.GetSlideInviteList()

	arg0_2:InitUI()
end

function var0_0.InitUI(arg0_3)
	arg0_3.queuePanel = arg0_3._tf:Find("top")
	arg0_3.performancePanel = arg0_3._tf:Find("performance")
	arg0_3.queueContainer = arg0_3._tf:Find("top/bg/container")
	arg0_3.performanceContainer = arg0_3._tf:Find("performance/line/container")

	setText(arg0_3._tf:Find("top/bg/Text"), i18n("3ddorm_beach_slide_tip2"))
	setText(arg0_3._tf:Find("performance/btn_invite/Text"), i18n("3ddorm_beach_slide_tip1"))

	arg0_3.queueItemList = UIItemList.New(arg0_3.queueContainer, arg0_3.queueContainer:Find("tpl"))
	arg0_3.performanceItemList = UIItemList.New(arg0_3.performanceContainer, arg0_3.performanceContainer:Find("tpl"))

	arg0_3.queueItemList:make(function(arg0_4, arg1_4, arg2_4)
		local var0_4 = arg1_4 + 1
		local var1_4 = var0_4 > #arg0_3.slideList

		setActive(arg2_4:Find("icon"), not var1_4)
		setActive(arg2_4:Find("front"), not var1_4)
		setActive(arg2_4:Find("plus"), var1_4)

		if not var1_4 then
			local var2_4 = arg0_3.slideList[var0_4]
			local var3_4 = pg.dorm3d_resource.get_id_list_by_ship_group[var2_4][2]

			GetImageSpriteFromAtlasAsync(pg.dorm3d_resource[var3_4].head_Icon, "", arg2_4:Find("icon"), true)
		end
	end)
	arg0_3.performanceItemList:make(function(arg0_5, arg1_5, arg2_5)
		local var0_5 = arg1_5 + 1
		local var1_5 = arg0_3.slideList[var0_5]

		if arg0_5 == UIItemList.EventUpdate then
			local var2_5 = pg.dorm3d_resource.get_id_list_by_ship_group[var1_5][2]

			GetImageSpriteFromAtlasAsync(pg.dorm3d_resource[var2_5].head_Icon, "", arg2_5:Find("icon"), true)
			setText(arg2_5:Find("name"), ShipGroup.getDefaultShipNameByGroupID(var1_5))
			onButton(arg0_3, arg2_5, function()
				arg0_3:emit(FurnitureSlideExtraMediator.GO_SLIDE_PERFORMANCE, var1_5)
			end, SFX_DORM_CLICK)
		end
	end)
	onButton(arg0_3, arg0_3._tf:Find("top/bg"), function()
		arg0_3:emit(FurnitureSlideExtraMediator.OPEN_INVITE_LAYER, arg0_3.slideList)
	end, SFX_DORM_CLICK)
end

function var0_0.didEnter(arg0_8)
	arg0_8:HideInteraction()
	arg0_8:HidePerformance()
end

function var0_0.UpdateSlideInviteList(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9.slideList = arg1_9

	arg0_9:Flush()
end

function var0_0.Flush(arg0_10)
	arg0_10.queueItemList:align(#arg0_10.slideList + 1)
	arg0_10.performanceItemList:align(#arg0_10.slideList)
end

function var0_0.HandleDormUIState(arg0_11, arg1_11)
	local var0_11 = arg1_11 == "base"

	setActive(arg0_11._tf, var0_11)
end

function var0_0.ShowInteraction(arg0_12)
	setActive(arg0_12.queuePanel, true)
	arg0_12.queueItemList:align(#arg0_12.slideList + 1)
end

function var0_0.HideInteraction(arg0_13)
	setActive(arg0_13.queuePanel, false)
end

function var0_0.ShowPerformance(arg0_14)
	setActive(arg0_14.performancePanel, true)
	arg0_14.performanceItemList:align(#arg0_14.slideList)
end

function var0_0.HidePerformance(arg0_15)
	setActive(arg0_15.performancePanel, false)
end

function var0_0.willExit(arg0_16)
	return
end

return var0_0
