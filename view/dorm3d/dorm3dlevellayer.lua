local var0_0 = class("Dorm3dLevelLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dLevelUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2._tf:Find("btn_back")

	onButton(arg0_2, var0_2, function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.rtLevelPanel = arg0_2._tf:Find("panel")

	local var1_2 = arg0_2.rtLevelPanel:Find("view/container")

	arg0_2.levelItemList = UIItemList.New(var1_2, var1_2:Find("tpl"))

	arg0_2.levelItemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg1_4 <= arg0_2.apartment.level

			setActive(arg2_4:Find("unlock"), var0_4)
			setActive(arg2_4:Find("lock"), not var0_4)

			local var1_4 = arg2_4:Find(var0_4 and "unlock" or "lock")

			setText(var1_4:Find("level"), arg1_4)
			setText(var1_4:Find("Text"), arg0_2.apartment:getFavorConfig("levelup_desc", arg1_4))
		end
	end)
	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bottom/btn_time"), function()
		local var0_5, var1_5 = arg0_2.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_clothing_unlock")[2])

		if not var0_5 then
			pg.TipsMgr.GetInstance():ShowTips(var1_5)

			return
		end

		arg0_2:ShowTimeSelectWindow()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bottom/btn_skin"), function()
		if #arg0_2.apartment.skinList < 2 then
			pg.TipsMgr.GetInstance():ShowTips("without unlock skin")

			return
		end

		local var0_6, var1_6 = arg0_2.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_clothing_unlock")[2])

		if not var0_6 then
			pg.TipsMgr.GetInstance():ShowTips(var1_6)

			return
		end

		arg0_2:ShowSkinSelectWindow()
	end, SFX_PANEL)

	arg0_2.rtTimeSelectWindow = arg0_2._tf:Find("TimeSelectWindow")

	onButton(arg0_2, arg0_2.rtTimeSelectWindow:Find("bg"), function()
		setActive(arg0_2.rtTimeSelectWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.rtTimeSelectWindow, arg0_2._tf)
	end, SFX_CANCEL)

	arg0_2.rtSkinSelectWindow = arg0_2._tf:Find("SkinSelectWindow")

	onButton(arg0_2, arg0_2.rtSkinSelectWindow:Find("bg"), function()
		setActive(arg0_2.rtSkinSelectWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.rtSkinSelectWindow, arg0_2._tf)
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2._tf, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.SetApartment(arg0_9, arg1_9)
	arg0_9.apartment = arg1_9
end

function var0_0.didEnter(arg0_10)
	local var0_10 = arg0_10.apartment.favor
	local var1_10 = arg0_10.apartment:getNextExp()

	setText(arg0_10.rtLevelPanel:Find("title/level"), arg0_10.apartment.level)
	setText(arg0_10.rtLevelPanel:Find("title/Text"), i18n("dorm3d_favor_level") .. string.format("%d/%d", var0_10, var1_10))
	setSlider(arg0_10.rtLevelPanel:Find("title/slider"), 0, var1_10, var0_10)
	arg0_10.levelItemList:align(getDorm3dGameset("favor_level")[1])
	setImageAlpha(arg0_10.rtLevelPanel:Find("bottom/btn_time/Image"), 1)
	setActive(arg0_10.rtLevelPanel:Find("bottom/btn_time/lock"), false)
	setImageAlpha(arg0_10.rtLevelPanel:Find("bottom/btn_skin/Image"), #arg0_10.apartment.skinList < 2 and 0.2 or 1)
	setActive(arg0_10.rtLevelPanel:Find("bottom/btn_skin/lock"), #arg0_10.apartment.skinList < 2)
end

function var0_0.ShowTimeSelectWindow(arg0_11)
	local var0_11 = arg0_11.rtTimeSelectWindow:Find("panel")

	setText(var0_11:Find("title"), i18n("dorm3d_time_choose"))

	for iter0_11, iter1_11 in ipairs({
		"day",
		"twilight",
		"night"
	}) do
		local var1_11 = var0_11:Find("content/" .. iter1_11)

		setText(var1_11:Find("now/Text"), i18n("dorm3d_now_time"))
		setActive(var1_11:Find("now"), iter0_11 == arg0_11.contextData.timeIndex)
		onToggle(arg0_11, var1_11, function(arg0_12)
			if arg0_12 == true then
				arg0_11.selectTimeIndex = iter0_11
			end
		end, SFX_PANEL)
		triggerToggle(var1_11, iter0_11 == arg0_11.contextData.timeIndex)
	end

	setText(var0_11:Find("bottom/toggle_lock/Text"), i18n("dorm3d_is_auto_time"))
	onToggle(arg0_11, var0_11:Find("bottom/toggle_lock"), function(arg0_13)
		if arg0_13 then
			PlayerPrefs.SetInt("DORM3D_SCENE_LOCK_TIME", 0)
		else
			PlayerPrefs.SetInt("DORM3D_SCENE_LOCK_TIME", arg0_11.contextData.timeIndex)
		end
	end, SFX_PANEL)
	triggerToggle(var0_11:Find("bottom/toggle_lock"), PlayerPrefs.GetInt("DORM3D_SCENE_LOCK_TIME", 0) == 0)
	onButton(arg0_11, var0_11:Find("bottom/btn_confirm"), function()
		warning(arg0_11.contextData.timeIndex, arg0_11.selectTimeIndex)

		if arg0_11.contextData.timeIndex == arg0_11.selectTimeIndex then
			return
		else
			if PlayerPrefs.GetInt("DORM3D_SCENE_LOCK_TIME", 0) ~= 0 then
				PlayerPrefs.SetInt("DORM3D_SCENE_LOCK_TIME", arg0_11.selectTimeIndex)
			end

			triggerButton(arg0_11.rtTimeSelectWindow:Find("bg"))
			arg0_11:emit(Dorm3dLevelMediator.CHAMGE_TIME, arg0_11.selectTimeIndex)
		end
	end, SFX_CONFIRM)
	setActive(arg0_11.rtTimeSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_11.rtTimeSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.ShowSkinSelectWindow(arg0_15)
	local var0_15 = arg0_15.rtSkinSelectWindow:Find("panel")

	setText(var0_15:Find("title"), i18n("dorm3d_clothing_choose"))
	UIItemList.StaticAlign(var0_15:Find("content"), var0_15:Find("content/tpl"), #arg0_15.apartment.skinList, function(arg0_16, arg1_16, arg2_16)
		arg1_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = arg0_15.apartment.skinList[arg1_16]

			if var0_16 == 0 then
				var0_16 = arg0_15.apartment:getConfig("skin_model")
			end

			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_skin", var0_16), "", arg2_16:Find("Image"))
			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%s_name", pg.dorm3d_resource[var0_16].picture), "", arg2_16:Find("name"))
			setText(arg2_16:Find("select/now/Text"), i18n("dorm3d_now_clothing"))
			setActive(arg2_16:Find("select/now"), arg0_15.apartment:getSkinId() == var0_16)
			onToggle(arg0_15, arg2_16, function(arg0_17)
				if arg0_17 == true then
					arg0_15.selectSkinId = var0_16
				end
			end, SFX_PANEL)
			triggerToggle(arg2_16, arg0_15.apartment:getSkinId() == var0_16)
		end
	end)
	setText(var0_15:Find("bottom/btn_confirm/Text"), i18n("word_ok"))
	onButton(arg0_15, var0_15:Find("bottom/btn_confirm"), function()
		if arg0_15.apartment:getSkinId() == arg0_15.selectSkinId then
			pg.TipsMgr.GetInstance():ShowTips("this skin is allready dress")
		else
			triggerButton(arg0_15.rtSkinSelectWindow:Find("bg"))
			arg0_15:emit(Dorm3dLevelMediator.CHANGE_SKIN, arg0_15.apartment.configId, arg0_15.selectSkinId)
		end
	end, SFX_CONFIRM)
	setActive(arg0_15.rtSkinSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_15.rtSkinSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.onBackPressed(arg0_19)
	if isActive(arg0_19.rtSkinSelectWindow) then
		triggerButton(arg0_19.rtSkinSelectWindow:Find("bg"))
	elseif isActive(arg0_19.rtTimeSelectWindow) then
		triggerButton(arg0_19.rtTimeSelectWindow:Find("bg"))
	else
		var0_0.super.onBackPressed(arg0_19)
	end
end

function var0_0.willExit(arg0_20)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_20._tf)
end

return var0_0
