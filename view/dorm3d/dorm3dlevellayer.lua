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

	arg0_2.rtTimeSelectWindow = arg0_2._tf:Find("TimeSelectWindow")

	onButton(arg0_2, arg0_2.rtTimeSelectWindow:Find("bg"), function()
		setActive(arg0_2.rtTimeSelectWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.rtTimeSelectWindow, arg0_2._tf)
	end, SFX_CANCEL)

	arg0_2.rtRenameWindow = arg0_2._tf:Find("RenameWindow")

	onButton(arg0_2, arg0_2.rtLevelPanel:Find("bg/left/rot"), function()
		arg0_2:ShowRenameWindow()
	end, SFX_PANEL)

	arg0_2.callInput = arg0_2.rtRenameWindow:Find("panel/input/nickname")

	onButton(arg0_2, arg0_2.rtRenameWindow:Find("panel/confirm"), function()
		local var0_8 = getInputText(arg0_2.callInput)

		if var0_8 == "" then
			return
		end

		if not nameValidityCheck(var0_8, var0_0.NAME_MIN_SIZE, var0_0.NAME_LONG_SIZE, {
			"spece_illegal_tip",
			"dorm3d_appellation_waring3",
			"dorm3d_appellation_waring2",
			"dorm3d_appellation_waring1"
		}) then
			setInputText(arg0_2.callInput, arg0_2.apartment:GetCallName())

			return
		end

		if var0_8 == arg0_2.apartment:GetCallName() then
			return
		end

		if arg0_2.apartment:GetSetCallCd() > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_appellation_waring4"))

			return
		end

		if arg0_2.renameReset then
			arg0_2:emit(Dorm3dLevelMediator.RENAME_RESET, arg0_2.apartment.configId)
		else
			arg0_2:emit(Dorm3dLevelMediator.RENAME, arg0_2.apartment.configId, var0_8)
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

function var0_0.SetApartment(arg0_12, arg1_12)
	arg0_12.apartment = arg1_12
end

function var0_0.InitItemList(arg0_13)
	arg0_13.rtLevelContainer = arg0_13.rtLevelPanel:Find("bg/awards/content")
	arg0_13.levelItemList = UIItemList.New(arg0_13.rtLevelContainer, arg0_13.rtLevelContainer:Find("tpl"))

	arg0_13.levelItemList:make(function(arg0_14, arg1_14, arg2_14)
		local var0_14 = arg1_14 + 1
		local var1_14 = arg0_13.apartment:getFavorConfig("levelup_item", var0_14)
		local var2_14 = arg0_13.apartment:getFavorConfig("levelup_client_item", var0_14)
		local var3_14 = arg2_14:Find("items")
		local var4_14 = {}

		for iter0_14, iter1_14 in pairs(var1_14) do
			table.insert(var4_14, {
				type = var0_0.SERVER_TYPE,
				data = iter1_14
			})
		end

		local var5_14 = false

		for iter2_14, iter3_14 in pairs(var2_14) do
			if iter3_14[1] == Dorm3dIconHelper.DORM_STORY then
				table.insert(var4_14, {
					type = var0_0.STORY_TYPE,
					data = iter3_14
				})

				var5_14 = true
			else
				table.insert(var4_14, {
					type = var0_0.CLIENT_TYPE,
					data = iter3_14
				})
			end
		end

		if arg0_14 == UIItemList.EventInit then
			setActive(arg2_14:Find("bg/normal"), not var5_14)
			setActive(arg2_14:Find("bg/special"), var5_14)

			local function var6_14(arg0_15)
				local var0_15 = var3_14:GetChild(arg0_15 - 1)
				local var1_15 = var0_15:Find("item")
				local var2_15 = var1_15:Find("Dorm3dIconTpl")

				if arg0_15 <= #var4_14 then
					switch(var4_14[arg0_15].type, {
						[var0_0.SERVER_TYPE] = function()
							setActive(var2_15:Find("count"), true)

							local var0_16 = Drop.Create(var4_14[arg0_15].data)

							updateDorm3dIcon(var2_15, var0_16)
							onButton(arg0_13, var0_15, function()
								arg0_13:emit(BaseUI.ON_NEW_DROP, {
									drop = var0_16
								})
							end, SFX_PANEL)
						end,
						[var0_0.CLIENT_TYPE] = function()
							setActive(var2_15:Find("count"), true)
							Dorm3dIconHelper.UpdateDorm3dIcon(var2_15, var4_14[arg0_15].data)

							local var0_18 = Dorm3dIconHelper.Data2Config(var4_14[arg0_15].data)

							onButton(arg0_13, var0_15, function()
								arg0_13:emit(Dorm3dLevelMediator.ON_DROP_CLIENT, {
									data = var4_14[arg0_15].data
								})
							end, SFX_PANEL)
						end,
						[var0_0.STORY_TYPE] = function()
							local var0_20 = Dorm3dIconHelper.Data2Config(var4_14[arg0_15].data)

							setActive(var1_15:Find("sp"), true)
							setActive(var0_15:Find("story"), true)
							onButton(arg0_13, var0_15, function()
								arg0_13:emit(Dorm3dLevelMediator.ON_DROP_CLIENT, {
									data = var4_14[arg0_15].data
								})
							end, SFX_PANEL)
							Dorm3dIconHelper.UpdateDorm3dIcon(var2_15, var4_14[arg0_15].data)
							setText(var0_15:Find("story/Text"), i18n("dorm3d_favor_level_story"))
						end
					})
				else
					setActive(var1_15, false)
					setActive(var0_15:Find("empty"), true)
				end
			end

			for iter4_14 = 1, var3_14.childCount do
				var6_14(iter4_14)
			end
		elseif arg0_14 == UIItemList.EventUpdate then
			local var7_14 = var0_14 <= arg0_13.apartment.level

			setActive(arg2_14:Find("unlock"), var7_14)
			setText(arg2_14:Find("number"), string.format("<color=%s>%02d</color>", var5_14 and "#FFFFFF" or var7_14 and "#b6b1b7" or "#827d82", var0_14))

			if var7_14 then
				setGray(arg2_14:Find("items"), true, true)
			end
		end
	end)
end

function var0_0.didEnter(arg0_22)
	local var0_22, var1_22 = arg0_22.apartment:getFavor()
	local var2_22 = arg0_22.apartment:isMaxFavor()

	setText(arg0_22.rtLevelPanel:Find("bg/favor/level"), string.format("Lv.%d : ", arg0_22.apartment.level))

	if var2_22 then
		setText(arg0_22.rtLevelPanel:Find("bg/favor/level/Text"), "MAX")
	else
		setText(arg0_22.rtLevelPanel:Find("bg/favor/level/Text"), string.format("%d/%d", var0_22, var1_22))
	end

	setSlider(arg0_22.rtLevelPanel:Find("bg/favor/progressBg/progress"), 0, var1_22, var0_22)
	arg0_22.levelItemList:align(getDorm3dGameset("favor_level")[1])

	arg0_22.rtLevelContainer:GetComponent(typeof(ScrollRect)).horizontalNormalizedPosition = 0

	local var3_22 = arg0_22.apartment.level >= getDorm3dGameset("drom3d_time_unlock")[1]

	setImageAlpha(arg0_22.rtLevelPanel:Find("bg/bottom/btn_time"), not var3_22 and 0.2 or 1)
	setActive(arg0_22.rtLevelPanel:Find("bg/bottom/btn_time/lock"), not var3_22)
	setText(arg0_22.rtLevelPanel:Find("bg/left/rot/Text"), i18n("dorm3d_appellation_title"))
	setText(arg0_22.rtRenameWindow:Find("panel/cancel/Text"), i18n("word_cancel"))
	setText(arg0_22.rtRenameWindow:Find("panel/confirm/Text"), i18n("word_ok"))
	arg0_22:UpdateName()
	arg0_22:UpdateRed()
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

function var0_0.UpdateRed(arg0_25)
	setActive(arg0_25.rtLevelPanel:Find("bg/left/rot/red"), var0_0.IsShowRed())
	arg0_25:emit(Dorm3dLevelMediator.UPDATE_FAVOR_DISPLAY)
end

function var0_0.UpdateName(arg0_26)
	local var0_26 = arg0_26.apartment:GetCallName()
	local var1_26, var2_26 = utf8_to_unicode(var0_26)
	local var3_26 = var2_26 <= var0_0.NAME_SHORT_SIZE

	setActive(arg0_26.nameShort, var3_26)
	setActive(arg0_26.nameLong, not var3_26)
	setText(var3_26 and arg0_26.nameShort:Find("Text") or arg0_26.nameLong:Find("Text"), var0_26)
end

function var0_0.ShowRenameWindow(arg0_27)
	setActive(arg0_27._tf:Find("bg"), false)
	setActive(arg0_27._tf:Find("btn_back"), false)
	setActive(arg0_27.rtLevelPanel, false)
	setActive(arg0_27.rtRenameWindow, true)
	setActive(arg0_27.blurPanel, true)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_27.blurPanel, {
		pbList = {
			arg0_27.blurPanel
		},
		groupName = LayerWeightConst.GROUP_DORM3D,
		weight = arg0_27:getWeightFromData() + 1
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0_27.rtRenameWindow, {
		groupName = LayerWeightConst.GROUP_DORM3D,
		weight = arg0_27:getWeightFromData() + 1
	})
	setInputText(arg0_27.callInput, arg0_27.apartment:GetCallName())

	local var0_27 = arg0_27.apartment:GetSetCallCd()
	local var1_27

	if var0_27 > 3600 then
		var1_27 = math.floor(var0_27 / 3600) .. i18n("word_hour")
	elseif var0_27 > 60 then
		var1_27 = math.floor(var0_27 / 60) .. i18n("word_minute")
	else
		var1_27 = var0_27 .. i18n("word_second")
	end

	setText(arg0_27.rtRenameWindow:Find("panel/time"), var0_27 == 0 and i18n("dorm3d_appellation_interval") or i18n("dorm3d_appellation_cd", var1_27))
	PlayerPrefs.SetInt(var0_0.PLAYERPREFS_KEY, 1)
	arg0_27:UpdateRed()
end

function var0_0.CloseRenameWindow(arg0_28)
	setActive(arg0_28._tf:Find("bg"), true)
	setActive(arg0_28._tf:Find("btn_back"), true)
	setActive(arg0_28.rtLevelPanel, true)
	setActive(arg0_28.rtRenameWindow, false)
	setActive(arg0_28.blurPanel, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28.blurPanel, arg0_28._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28.rtRenameWindow, arg0_28._tf)
	arg0_28:UpdateName()
end

function var0_0.ShowTimeSelectWindow(arg0_29)
	local var0_29 = arg0_29.rtTimeSelectWindow:Find("panel")

	setText(var0_29:Find("title"), i18n("dorm3d_time_choose"))

	for iter0_29, iter1_29 in ipairs({
		"day",
		"night"
	}) do
		local var1_29 = var0_29:Find("content/" .. iter1_29)

		setText(var1_29:Find("now/Text"), i18n("dorm3d_now_time"))
		setActive(var1_29:Find("now"), iter0_29 == arg0_29.contextData.timeIndex)
		onToggle(arg0_29, var1_29, function(arg0_30)
			if arg0_30 == true then
				arg0_29.selectTimeIndex = iter0_29
			end

			quickPlayAnimation(var1_29, arg0_30 and "anim_dorm3d_timeselect_click" or "anim_dorm3d_timeselect_unclick")
		end, SFX_PANEL)
	end

	triggerToggle(var0_29:Find("content"):GetChild(arg0_29.contextData.timeIndex - 1), true)
	setText(var0_29:Find("bottom/toggle_lock/Text"), i18n("dorm3d_is_auto_time"))
	onToggle(arg0_29, var0_29:Find("bottom/toggle_lock"), function(arg0_31)
		if arg0_31 then
			PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), 0)
		else
			PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), arg0_29.contextData.timeIndex)
		end

		quickPlayAnimation(var0_29:Find("bottom/toggle_lock"), arg0_31 and "anim_dorm3d_timeselect_bottom_on" or "anim_dorm3d_timeselect_bottom_off")
	end, SFX_PANEL)
	triggerToggle(var0_29:Find("bottom/toggle_lock"), PlayerPrefs.GetInt(ApartmentProxy.GetTimePPName(), 1) == 0)
	onButton(arg0_29, var0_29:Find("bottom/btn_confirm"), function()
		warning(arg0_29.contextData.timeIndex, arg0_29.selectTimeIndex)
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_day_night_switching" .. arg0_29.selectTimeIndex))

		if arg0_29.contextData.timeIndex == arg0_29.selectTimeIndex then
			return
		else
			if PlayerPrefs.GetInt(ApartmentProxy.GetTimePPName(), 1) ~= 0 then
				PlayerPrefs.SetInt(ApartmentProxy.GetTimePPName(), arg0_29.selectTimeIndex)
			end

			triggerButton(arg0_29.rtTimeSelectWindow:Find("bg"))
			arg0_29:emit(Dorm3dLevelMediator.CHAMGE_TIME, arg0_29.selectTimeIndex)
		end
	end, SFX_CONFIRM)
	setActive(arg0_29.rtTimeSelectWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_29.rtTimeSelectWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.onBackPressed(arg0_33)
	if isActive(arg0_33.rtTimeSelectWindow) then
		triggerButton(arg0_33.rtTimeSelectWindow:Find("bg"))
	elseif isActive(arg0_33.rtRenameWindow) then
		triggerButton(arg0_33.rtRenameWindow:Find("panel/cancel"))
	else
		var0_0.super.onBackPressed(arg0_33)
	end
end

function var0_0.willExit(arg0_34)
	return
end

return var0_0
