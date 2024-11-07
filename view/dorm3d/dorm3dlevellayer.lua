local var0_0 = class("Dorm3dLevelLayer", import("view.base.BaseUI"))

var0_0.SERVER_TYPE = 1
var0_0.CLIENT_TYPE = 2
var0_0.STORY_TYPE = 3
var0_0.NAME_MIN_SIZE = 4
var0_0.NAME_SHORT_SIZE = 8
var0_0.NAME_LONG_SIZE = 14
var0_0.PLAYERPREFS_KEY = "Dorm3dLayer.playerprefs"

function var0_0.getUIName(arg0_1)
	return "Dorm3dLevelUI"
end

function var0_0.init(arg0_2)
	arg0_2.rtLevelPanel = arg0_2._tf:Find("panel")

	onButton(arg0_2, arg0_2._tf:Find("btn_back"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bg/bottom/btn_time"), function()
		local var0_5 = getDorm3dGameset("drom3d_time_unlock")[1]

		if var0_5 > arg0_2.apartment.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("apartment_level_unenough", var0_5))

			return
		end

		arg0_2:ShowTimeSelectWindow()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bg/bottom/btn_skin"), function()
		local var0_6 = getDorm3dGameset("drom3d_clothing_unlock")[1]

		if var0_6 > arg0_2.apartment.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("apartment_level_unenough", var0_6))

			return
		end

		arg0_2:ShowSkinSelectWindow()
	end, SFX_PANEL)
	setActive(arg0_2.rtLevelPanel:Find("bg/bottom/btn_skin"), false)

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

	arg0_2.rtRenameWindow = arg0_2._tf:Find("RenameWindow")

	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bg/left/rot"), function()
		arg0_2:ShowRenameWindow()
	end, SFX_PANEL)

	arg0_2.callInput = arg0_2.rtRenameWindow:Find("panel/input/nickname")

	onButton(arg0_2, arg0_2.rtRenameWindow:Find("panel/confirm"), function()
		local var0_10 = getInputText(arg0_2.callInput)

		if var0_10 == "" then
			return
		end

		if not nameValidityCheck(var0_10, var0_0.NAME_MIN_SIZE, var0_0.NAME_LONG_SIZE, {
			"spece_illegal_tip",
			"dorm3d_appellation_waring3",
			"dorm3d_appellation_waring2",
			"dorm3d_appellation_waring1"
		}) then
			setInputText(arg0_2.callInput, arg0_2.apartment:GetCallName())

			return
		end

		if var0_10 == arg0_2.apartment:GetCallName() then
			return
		end

		if arg0_2.apartment:GetSetCallCd() > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_appellation_waring4"))

			return
		end

		if arg0_2.renameReset then
			arg0_2:emit(Dorm3dLevelMediator.RENAME_RESET, arg0_2.apartment.configId)
		else
			arg0_2:emit(Dorm3dLevelMediator.RENAME, arg0_2.apartment.configId, var0_10)
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.rtRenameWindow:Find("panel/cancel"), function()
		arg0_2:CloseRenameWindow()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.rtRenameWindow:Find("panel/reset"), function()
		setInputText(arg0_2.callInput, pg.dorm3d_dorm_template[arg0_2.apartment.configId].default_appellation)

		arg0_2.renameReset = true
	end)

	arg0_2.nameShort = arg0_2.rtLevelPanel:Find("bg/left/rot/short")
	arg0_2.nameLong = arg0_2.rtLevelPanel:Find("bg/left/rot/long")
	arg0_2.blurPanel = arg0_2._tf:Find("blur")

	arg0_2.callInput:GetComponent(typeof(InputField)).onValueChanged:AddListener(function()
		arg0_2.renameReset = false
	end)
	setActive(arg0_2.rtLevelPanel:Find("bg/left/rot"), not var0_0.IsLockNamed())
	arg0_2:InitItemList()
end

function var0_0.SetApartment(arg0_14, arg1_14)
	arg0_14.apartment = arg1_14
end

function var0_0.InitItemList(arg0_15)
	arg0_15.rtLevelContainer = arg0_15.rtLevelPanel:Find("bg/awards/content")
	arg0_15.levelItemList = UIItemList.New(arg0_15.rtLevelContainer, arg0_15.rtLevelContainer:Find("tpl"))

	arg0_15.levelItemList:make(function(arg0_16, arg1_16, arg2_16)
		local var0_16 = arg1_16 + 1
		local var1_16 = arg0_15.apartment:getFavorConfig("levelup_item", var0_16)
		local var2_16 = arg0_15.apartment:getFavorConfig("levelup_client_item", var0_16)
		local var3_16 = arg2_16:Find("items")
		local var4_16 = {}

		for iter0_16, iter1_16 in pairs(var1_16) do
			table.insert(var4_16, {
				type = var0_0.SERVER_TYPE,
				data = iter1_16
			})
		end

		local var5_16 = false

		for iter2_16, iter3_16 in pairs(var2_16) do
			if iter3_16[1] == Dorm3dIconHelper.DORM_STORY then
				table.insert(var4_16, {
					type = var0_0.STORY_TYPE,
					data = iter3_16
				})

				var5_16 = true
			else
				table.insert(var4_16, {
					type = var0_0.CLIENT_TYPE,
					data = iter3_16
				})
			end
		end

		if arg0_16 == UIItemList.EventInit then
			setActive(arg2_16:Find("bg/normal"), not var5_16)
			setActive(arg2_16:Find("bg/special"), var5_16)

			local function var6_16(arg0_17)
				local var0_17 = var3_16:GetChild(arg0_17 - 1)
				local var1_17 = var0_17:Find("item")
				local var2_17 = var1_17:Find("Dorm3dIconTpl")

				if arg0_17 <= #var4_16 then
					switch(var4_16[arg0_17].type, {
						[var0_0.SERVER_TYPE] = function()
							setActive(var2_17:Find("count"), true)

							local var0_18 = Drop.Create(var4_16[arg0_17].data)

							updateDorm3dIcon(var2_17, var0_18)
							onButton(arg0_15, var0_17, function()
								arg0_15:emit(BaseUI.ON_NEW_DROP, {
									drop = var0_18
								})
							end, SFX_PANEL)
						end,
						[var0_0.CLIENT_TYPE] = function()
							setActive(var2_17:Find("count"), true)
							Dorm3dIconHelper.UpdateDorm3dIcon(var2_17, var4_16[arg0_17].data)

							local var0_20 = Dorm3dIconHelper.Data2Config(var4_16[arg0_17].data)

							onButton(arg0_15, var0_17, function()
								arg0_15:emit(Dorm3dLevelMediator.ON_DROP_CLIENT, {
									data = var4_16[arg0_17].data
								})
							end, SFX_PANEL)
						end,
						[var0_0.STORY_TYPE] = function()
							local var0_22 = Dorm3dIconHelper.Data2Config(var4_16[arg0_17].data)

							setActive(var1_17:Find("sp"), true)
							setActive(var0_17:Find("story"), true)
							onButton(arg0_15, var0_17, function()
								arg0_15:emit(Dorm3dLevelMediator.ON_DROP_CLIENT, {
									data = var4_16[arg0_17].data
								})
							end, SFX_PANEL)
							Dorm3dIconHelper.UpdateDorm3dIcon(var2_17, var4_16[arg0_17].data)
							setText(var0_17:Find("story/Text"), i18n("dorm3d_favor_level_story"))
						end
					})
				else
					setActive(var1_17, false)
					setActive(var0_17:Find("empty"), true)
				end
			end

			for iter4_16 = 1, var3_16.childCount do
				var6_16(iter4_16)
			end
		elseif arg0_16 == UIItemList.EventUpdate then
			local var7_16 = var0_16 <= arg0_15.apartment.level

			setActive(arg2_16:Find("unlock"), var7_16)
			setText(arg2_16:Find("number"), string.format("<color=%s>%02d</color>", var5_16 and "#FFFFFF" or var7_16 and "#b6b1b7" or "#827d82", var0_16))

			if var7_16 then
				setGray(arg2_16:Find("items"), true, true)
			end
		end
	end)
end

function var0_0.didEnter(arg0_24)
	local var0_24, var1_24 = arg0_24.apartment:getFavor()

	setText(arg0_24.rtLevelPanel:Find("bg/favor/level"), string.format("Lv.%d : ", arg0_24.apartment.level))
	setText(arg0_24.rtLevelPanel:Find("bg/favor/level/Text"), string.format("%d/%d", var0_24, var1_24))
	setSlider(arg0_24.rtLevelPanel:Find("bg/favor/progressBg/progress"), 0, var1_24, var0_24)
	arg0_24.levelItemList:align(getDorm3dGameset("favor_level")[1])

	arg0_24.rtLevelContainer:GetComponent(typeof(ScrollRect)).horizontalNormalizedPosition = 0

	local var2_24 = arg0_24.apartment.level >= getDorm3dGameset("drom3d_time_unlock")[1]

	setImageAlpha(arg0_24.rtLevelPanel:Find("bg/bottom/btn_time"), not var2_24 and 0.2 or 1)
	setActive(arg0_24.rtLevelPanel:Find("bg/bottom/btn_time/lock"), not var2_24)

	local var3_24 = arg0_24.apartment.level >= getDorm3dGameset("drom3d_clothing_unlock")[1]

	setImageAlpha(arg0_24.rtLevelPanel:Find("bg/bottom/btn_skin/Image"), not var3_24 and 0.2 or 1)
	setActive(arg0_24.rtLevelPanel:Find("bg/bottom/btn_skin/lock"), not var3_24)
	setText(arg0_24.rtLevelPanel:Find("bg/left/rot/Text"), i18n("dorm3d_appellation_title"))
	setText(arg0_24.rtRenameWindow:Find("panel/cancel/Text"), i18n("word_cancel"))
	setText(arg0_24.rtRenameWindow:Find("panel/confirm/Text"), i18n("word_ok"))
	arg0_24:UpdateName()
	arg0_24:UpdateRed()
end

function var0_0.IsLockNamed()
	return PLATFORM_CODE ~= PLATFORM_CH and DORM_LOCK_NAMED
end

function var0_0.IsShowRed()
	if var0_0.IsLockNamed() then
		return false
	end

	return PlayerPrefs.GetInt(var0_0.PLAYERPREFS_KEY, 0) == 0
end

function var0_0.UpdateRed(arg0_27)
	setActive(arg0_27.rtLevelPanel:Find("bg/left/rot/red"), var0_0.IsShowRed())
	arg0_27:emit(Dorm3dLevelMediator.UPDATE_FAVOR_DISPLAY)
end

function var0_0.UpdateName(arg0_28)
	local var0_28 = arg0_28.apartment:GetCallName()
	local var1_28, var2_28 = utf8_to_unicode(var0_28)
	local var3_28 = var2_28 <= var0_0.NAME_SHORT_SIZE

	setActive(arg0_28.nameShort, var3_28)
	setActive(arg0_28.nameLong, not var3_28)
	setText(var3_28 and arg0_28.nameShort:Find("Text") or arg0_28.nameLong:Find("Text"), var0_28)
end

function var0_0.ShowRenameWindow(arg0_29)
	setActive(arg0_29._tf:Find("bg"), false)
	setActive(arg0_29._tf:Find("btn_back"), false)
	setActive(arg0_29.rtLevelPanel, false)
	setActive(arg0_29.rtRenameWindow, true)
	setActive(arg0_29.blurPanel, true)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_29.blurPanel, {
		pbList = {
			arg0_29.blurPanel
		},
		groupName = LayerWeightConst.GROUP_DORM3D,
		weight = arg0_29:getWeightFromData() + 1
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0_29.rtRenameWindow, {
		groupName = LayerWeightConst.GROUP_DORM3D,
		weight = arg0_29:getWeightFromData() + 1
	})
	setInputText(arg0_29.callInput, arg0_29.apartment:GetCallName())

	local var0_29 = arg0_29.apartment:GetSetCallCd()
	local var1_29

	if var0_29 > 3600 then
		var1_29 = math.floor(var0_29 / 3600) .. i18n("word_hour")
	elseif var0_29 > 60 then
		var1_29 = math.floor(var0_29 / 60) .. i18n("word_minute")
	else
		var1_29 = var0_29 .. i18n("word_second")
	end

	setText(arg0_29.rtRenameWindow:Find("panel/time"), var0_29 == 0 and i18n("dorm3d_appellation_interval") or i18n("dorm3d_appellation_cd", var1_29))
	PlayerPrefs.SetInt(var0_0.PLAYERPREFS_KEY, 1)
	arg0_29:UpdateRed()
end

function var0_0.CloseRenameWindow(arg0_30)
	setActive(arg0_30._tf:Find("bg"), true)
	setActive(arg0_30._tf:Find("btn_back"), true)
	setActive(arg0_30.rtLevelPanel, true)
	setActive(arg0_30.rtRenameWindow, false)
	setActive(arg0_30.blurPanel, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30.blurPanel, arg0_30._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30.rtRenameWindow, arg0_30._tf)
	arg0_30:UpdateName()
end

function var0_0.ShowTimeSelectWindow(arg0_31)
	local var0_31 = arg0_31.rtTimeSelectWindow:Find("panel")

	setText(var0_31:Find("title"), i18n("dorm3d_time_choose"))

	for iter0_31, iter1_31 in ipairs({
		"day",
		"night"
	}) do
		local var1_31 = var0_31:Find("content/" .. iter1_31)

		setText(var1_31:Find("now/Text"), i18n("dorm3d_now_time"))
		setActive(var1_31:Find("now"), iter0_31 == arg0_31.contextData.timeIndex)
		onToggle(arg0_31, var1_31, function(arg0_32)
			if arg0_32 == true then
				arg0_31.selectTimeIndex = iter0_31
			end

			quickPlayAnimation(var1_31, arg0_32 and "anim_dorm3d_timeselect_click" or "anim_dorm3d_timeselect_unclick")
		end, SFX_PANEL)
	end

	triggerToggle(var0_31:Find("content"):GetChild(arg0_31.contextData.timeIndex - 1), true)
	setText(var0_31:Find("bottom/toggle_lock/Text"), i18n("dorm3d_is_auto_time"))
	onToggle(arg0_31, var0_31:Find("bottom/toggle_lock"), function(arg0_33)
		if arg0_33 then
			PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), 0)
		else
			PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), arg0_31.contextData.timeIndex)
		end

		quickPlayAnimation(var0_31:Find("bottom/toggle_lock"), arg0_33 and "anim_dorm3d_timeselect_bottom_on" or "anim_dorm3d_timeselect_bottom_off")
	end, SFX_PANEL)
	triggerToggle(var0_31:Find("bottom/toggle_lock"), PlayerPrefs.GetInt(ApartmentProxy.GetTimePPName(), 1) == 0)
	onButton(arg0_31, var0_31:Find("bottom/btn_confirm"), function()
		warning(arg0_31.contextData.timeIndex, arg0_31.selectTimeIndex)
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_day_night_switching" .. arg0_31.selectTimeIndex))

		if arg0_31.contextData.timeIndex == arg0_31.selectTimeIndex then
			return
		else
			if PlayerPrefs.GetInt(ApartmentProxy.GetTimePPName(), 1) ~= 0 then
				PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), arg0_31.selectTimeIndex)
			end

			triggerButton(arg0_31.rtTimeSelectWindow:Find("bg"))
			arg0_31:emit(Dorm3dLevelMediator.CHAMGE_TIME, arg0_31.selectTimeIndex)
		end
	end, SFX_CONFIRM)
	setActive(arg0_31.rtTimeSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_31.rtTimeSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.ShowSkinSelectWindow(arg0_35)
	local var0_35 = arg0_35.rtSkinSelectWindow:Find("panel")

	setText(var0_35:Find("title"), i18n("dorm3d_clothing_choose"))
	UIItemList.StaticAlign(var0_35:Find("content"), var0_35:Find("content/tpl"), #arg0_35.apartment.skinList, function(arg0_36, arg1_36, arg2_36)
		arg1_36 = arg1_36 + 1

		if arg0_36 == UIItemList.EventUpdate then
			local var0_36 = arg0_35.apartment.skinList[arg1_36]

			if var0_36 == 0 then
				var0_36 = arg0_35.apartment:getConfig("skin_model")
			end

			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/apartment_skin_%d", var0_36), "", arg2_36:Find("Image"))
			GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/apartment_skin_name_%s", pg.dorm3d_resource[var0_36].picture), "", arg2_36:Find("name"))
			setText(arg2_36:Find("select/now/Text"), i18n("dorm3d_now_clothing"))
			setActive(arg2_36:Find("select/now"), arg0_35.apartment:getSkinId() == var0_36)
			onToggle(arg0_35, arg2_36, function(arg0_37)
				if arg0_37 == true then
					arg0_35.selectSkinId = var0_36
				end
			end, SFX_PANEL)
			triggerToggle(arg2_36, arg0_35.apartment:getSkinId() == var0_36)
		end
	end)
	setText(var0_35:Find("bottom/btn_confirm/Text"), i18n("word_ok"))
	onButton(arg0_35, var0_35:Find("bottom/btn_confirm"), function()
		triggerButton(arg0_35.rtSkinSelectWindow:Find("bg"))

		if arg0_35.apartment:getSkinId() ~= arg0_35.selectSkinId then
			arg0_35:emit(Dorm3dLevelMediator.CHANGE_SKIN, arg0_35.apartment.configId, arg0_35.selectSkinId)
		end
	end, SFX_CONFIRM)
	setActive(arg0_35.rtSkinSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_35.rtSkinSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.onBackPressed(arg0_39)
	if isActive(arg0_39.rtSkinSelectWindow) then
		triggerButton(arg0_39.rtSkinSelectWindow:Find("bg"))
	elseif isActive(arg0_39.rtTimeSelectWindow) then
		triggerButton(arg0_39.rtTimeSelectWindow:Find("bg"))
	elseif isActive(arg0_39.rtRenameWindow) then
		triggerButton(arg0_39.rtRenameWindow:Find("panel/cancel"))
	else
		var0_0.super.onBackPressed(arg0_39)
	end
end

function var0_0.willExit(arg0_40)
	return
end

return var0_0
