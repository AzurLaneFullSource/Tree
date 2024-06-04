local var0 = class("Dorm3dLevelLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dLevelUI"
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("btn_back")

	onButton(arg0, var0, function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.rtLevelPanel = arg0._tf:Find("panel")

	local var1 = arg0.rtLevelPanel:Find("view/container")

	arg0.levelItemList = UIItemList.New(var1, var1:Find("tpl"))

	arg0.levelItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 <= arg0.apartment.level

			setActive(arg2:Find("unlock"), var0)
			setActive(arg2:Find("lock"), not var0)

			local var1 = arg2:Find(var0 and "unlock" or "lock")

			setText(var1:Find("level"), arg1)
			setText(var1:Find("Text"), arg0.apartment:getFavorConfig("levelup_desc", arg1))
		end
	end)
	onButton(arg0, arg0.rtLevelPanel:Find("bottom/btn_time"), function()
		local var0, var1 = arg0.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_clothing_unlock")[2])

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0:ShowTimeSelectWindow()
	end, SFX_PANEL)
	onButton(arg0, arg0.rtLevelPanel:Find("bottom/btn_skin"), function()
		if #arg0.apartment.skinList < 2 then
			pg.TipsMgr.GetInstance():ShowTips("without unlock skin")

			return
		end

		local var0, var1 = arg0.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_clothing_unlock")[2])

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0:ShowSkinSelectWindow()
	end, SFX_PANEL)

	arg0.rtTimeSelectWindow = arg0._tf:Find("TimeSelectWindow")

	onButton(arg0, arg0.rtTimeSelectWindow:Find("bg"), function()
		setActive(arg0.rtTimeSelectWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.rtTimeSelectWindow, arg0._tf)
	end, SFX_CANCEL)

	arg0.rtSkinSelectWindow = arg0._tf:Find("SkinSelectWindow")

	onButton(arg0, arg0.rtSkinSelectWindow:Find("bg"), function()
		setActive(arg0.rtSkinSelectWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.rtSkinSelectWindow, arg0._tf)
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0.SetApartment(arg0, arg1)
	arg0.apartment = arg1
end

function var0.didEnter(arg0)
	local var0 = arg0.apartment.favor
	local var1 = arg0.apartment:getNextExp()

	setText(arg0.rtLevelPanel:Find("title/level"), arg0.apartment.level)
	setText(arg0.rtLevelPanel:Find("title/Text"), i18n("dorm3d_favor_level") .. string.format("%d/%d", var0, var1))
	setSlider(arg0.rtLevelPanel:Find("title/slider"), 0, var1, var0)
	arg0.levelItemList:align(getDorm3dGameset("favor_level")[1])
	setImageAlpha(arg0.rtLevelPanel:Find("bottom/btn_time/Image"), 1)
	setActive(arg0.rtLevelPanel:Find("bottom/btn_time/lock"), false)
	setImageAlpha(arg0.rtLevelPanel:Find("bottom/btn_skin/Image"), #arg0.apartment.skinList < 2 and 0.2 or 1)
	setActive(arg0.rtLevelPanel:Find("bottom/btn_skin/lock"), #arg0.apartment.skinList < 2)
end

function var0.ShowTimeSelectWindow(arg0)
	local var0 = arg0.rtTimeSelectWindow:Find("panel")

	setText(var0:Find("title"), i18n("dorm3d_time_choose"))

	for iter0, iter1 in ipairs({
		"day",
		"twilight",
		"night"
	}) do
		local var1 = var0:Find("content/" .. iter1)

		setText(var1:Find("now/Text"), i18n("dorm3d_now_time"))
		setActive(var1:Find("now"), iter0 == arg0.contextData.timeIndex)
		onToggle(arg0, var1, function(arg0)
			if arg0 == true then
				arg0.selectTimeIndex = iter0
			end
		end, SFX_PANEL)
		triggerToggle(var1, iter0 == arg0.contextData.timeIndex)
	end

	setText(var0:Find("bottom/toggle_lock/Text"), i18n("dorm3d_is_auto_time"))
	onToggle(arg0, var0:Find("bottom/toggle_lock"), function(arg0)
		if arg0 then
			PlayerPrefs.SetInt("DORM3D_SCENE_LOCK_TIME", 0)
		else
			PlayerPrefs.SetInt("DORM3D_SCENE_LOCK_TIME", arg0.contextData.timeIndex)
		end
	end, SFX_PANEL)
	triggerToggle(var0:Find("bottom/toggle_lock"), PlayerPrefs.GetInt("DORM3D_SCENE_LOCK_TIME", 0) == 0)
	onButton(arg0, var0:Find("bottom/btn_confirm"), function()
		warning(arg0.contextData.timeIndex, arg0.selectTimeIndex)

		if arg0.contextData.timeIndex == arg0.selectTimeIndex then
			return
		else
			if PlayerPrefs.GetInt("DORM3D_SCENE_LOCK_TIME", 0) ~= 0 then
				PlayerPrefs.SetInt("DORM3D_SCENE_LOCK_TIME", arg0.selectTimeIndex)
			end

			triggerButton(arg0.rtTimeSelectWindow:Find("bg"))
			arg0:emit(Dorm3dLevelMediator.CHAMGE_TIME, arg0.selectTimeIndex)
		end
	end, SFX_CONFIRM)
	setActive(arg0.rtTimeSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.rtTimeSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0.ShowSkinSelectWindow(arg0)
	local var0 = arg0.rtSkinSelectWindow:Find("panel")

	setText(var0:Find("title"), i18n("dorm3d_clothing_choose"))
	UIItemList.StaticAlign(var0:Find("content"), var0:Find("content/tpl"), #arg0.apartment.skinList, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.apartment.skinList[arg1]

			if var0 == 0 then
				var0 = arg0.apartment:getConfig("skin_model")
			end

			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_skin", var0), "", arg2:Find("Image"))
			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%s_name", pg.dorm3d_resource[var0].picture), "", arg2:Find("name"))
			setText(arg2:Find("select/now/Text"), i18n("dorm3d_now_clothing"))
			setActive(arg2:Find("select/now"), arg0.apartment:getSkinId() == var0)
			onToggle(arg0, arg2, function(arg0)
				if arg0 == true then
					arg0.selectSkinId = var0
				end
			end, SFX_PANEL)
			triggerToggle(arg2, arg0.apartment:getSkinId() == var0)
		end
	end)
	setText(var0:Find("bottom/btn_confirm/Text"), i18n("word_ok"))
	onButton(arg0, var0:Find("bottom/btn_confirm"), function()
		if arg0.apartment:getSkinId() == arg0.selectSkinId then
			pg.TipsMgr.GetInstance():ShowTips("this skin is allready dress")
		else
			triggerButton(arg0.rtSkinSelectWindow:Find("bg"))
			arg0:emit(Dorm3dLevelMediator.CHANGE_SKIN, arg0.apartment.configId, arg0.selectSkinId)
		end
	end, SFX_CONFIRM)
	setActive(arg0.rtSkinSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.rtSkinSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0.onBackPressed(arg0)
	if isActive(arg0.rtSkinSelectWindow) then
		triggerButton(arg0.rtSkinSelectWindow:Find("bg"))
	elseif isActive(arg0.rtTimeSelectWindow) then
		triggerButton(arg0.rtTimeSelectWindow:Find("bg"))
	else
		var0.super.onBackPressed(arg0)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
