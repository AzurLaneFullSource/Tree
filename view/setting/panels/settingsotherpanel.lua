local var0_0 = class("SettingsOtherPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsOther"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_Other")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / OTHER SETTINGS"
end

function var0_0.OnInit(arg0_4, ...)
	arg0_4.uilist = UIItemList.New(arg0_4._tf:Find("options"), arg0_4._tf:Find("options/notify_tpl"))

	arg0_4.uilist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateItem(arg1_5 + 1, arg2_5)
		end
	end)

	local var0_4 = PlayerPrefs.GetInt("AUTOFIGHT_BATTERY_SAVEMODE", 0) > 0
	local var1_4 = pg.BrightnessMgr.GetInstance():IsPermissionGranted()

	if var0_4 and not var1_4 then
		PlayerPrefs.SetInt("AUTOFIGHT_BATTERY_SAVEMODE", 0)
		PlayerPrefs.Save()
	end
end

function var0_0.OnUpdate(arg0_6)
	arg0_6.list = arg0_6:GetList()

	arg0_6.uilist:align(#arg0_6.list)
end

function var0_0.UpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.list[arg1_7]

	arg2_7:Find("mask/Text"):GetComponent("ScrollText"):SetText(var0_7.title)
	onButton(arg0_7, arg2_7:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, var0_7)
	end, SFX_PANEL)
	removeOnToggle(arg2_7:Find("on"))

	if arg0_7:GetDefaultValue(var0_7) then
		triggerToggle(arg2_7:Find("on"), true)
	else
		triggerToggle(arg2_7:Find("off"), true)
	end

	onToggle(arg0_7, arg2_7:Find("on"), function(arg0_9)
		arg0_7:OnItemSwitch(var0_7, arg0_9)
	end, SFX_UI_TAG, SFX_UI_CANCEL)
	arg0_7:OnUpdateItem(var0_7)
	arg0_7:OnUpdateItemWithTr(var0_7, arg2_7)
end

function var0_0.OnItemSwitch(arg0_10, arg1_10, arg2_10)
	if arg1_10.id == 1 then
		pg.PushNotificationMgr.GetInstance():setSwitchShipName(arg2_10)
	elseif arg1_10.id == 5 then
		arg0_10:OnClickEffectItemSwitch(arg1_10, arg2_10)
	elseif arg1_10.id == 9 then
		arg0_10:OnAutoFightBatterySaveModeItemSwitch(arg1_10, arg2_10)
	elseif arg1_10.id == 10 then
		arg0_10:OnAutoFightDownFrameItemSwitch(arg1_10, arg2_10)
	elseif arg1_10.type == 0 then
		arg0_10:OnCommonLocalItemSwitch(arg1_10, arg2_10)
	elseif arg1_10.type == 1 then
		arg0_10:OnCommonServerItemSwitch(arg1_10, arg2_10)
	end
end

function var0_0.OnClickEffectItemSwitch(arg0_11, arg1_11, arg2_11)
	local var0_11 = pg.UIMgr.GetInstance().OverlayEffect

	if var0_11 then
		setActive(var0_11, arg2_11)
	end

	arg0_11:OnCommonLocalItemSwitch(arg1_11, arg2_11)
end

function var0_0.OnCommonServerItemSwitch(arg0_12, arg1_12, arg2_12)
	local var0_12 = _G[arg1_12.name]
	local var1_12 = getProxy(PlayerProxy):getRawData():GetCommonFlag(var0_12)
	local var2_12 = not arg2_12

	if arg1_12.default == 1 then
		var2_12 = arg2_12
	end

	if var2_12 then
		pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
			flagID = var0_12
		})
	else
		pg.m02:sendNotification(GAME.COMMON_FLAG, {
			flagID = var0_12
		})
	end
end

function var0_0.OnAutoFightBatterySaveModeItemSwitch(arg0_13, arg1_13, arg2_13)
	local function var0_13()
		local var0_14 = arg0_13.uilist.container:GetChild(arg1_13.id - 1)

		triggerToggle(var0_14:Find("off"), true)
	end

	local var1_13 = pg.BrightnessMgr.GetInstance()

	seriesAsync({
		function(arg0_15)
			if not arg2_13 or var1_13:IsPermissionGranted() then
				return arg0_15()
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("words_autoFight_right"),
				onYes = function()
					var1_13:RequestPremission(function(arg0_17)
						if arg0_17 then
							arg0_15()
						else
							var0_13()
						end
					end)
				end,
				onNo = var0_13
			})
		end,
		function(arg0_18)
			local var0_18 = _G[arg1_13.name]

			PlayerPrefs.SetInt(var0_18, arg2_13 and 1 or 0)
			PlayerPrefs.Save()

			local var1_18 = arg0_13.uilist.container:GetChild(arg1_13.id)

			triggerToggle(var1_18:Find(arg2_13 and "on" or "off"), true)
			var0_0.SetGrayOption(var1_18, arg2_13)
		end
	})
end

function var0_0.OnAutoFightDownFrameItemSwitch(arg0_19, arg1_19, arg2_19)
	if not arg0_19:GetDefaultValue(arg0_19.list[9]) and arg2_19 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("words_autoFight_tips"))

		local var0_19 = arg0_19.uilist.container:GetChild(arg1_19.id - 1)

		triggerToggle(var0_19:Find("off"), true)

		return
	end

	local var1_19 = _G[arg1_19.name]

	PlayerPrefs.SetInt(var1_19, arg2_19 and 1 or 0)
	PlayerPrefs.Save()
end

function var0_0.SetGrayOption(arg0_20, arg1_20)
	setGray(arg0_20:Find("on"), not arg1_20)
	setGray(arg0_20:Find("off"), not arg1_20)
end

function var0_0.OnCommonLocalItemSwitch(arg0_21, arg1_21, arg2_21)
	local var0_21 = _G[arg1_21.name]

	PlayerPrefs.SetInt(var0_21, arg2_21 and 1 or 0)
	PlayerPrefs.Save()
end

function var0_0.OnUpdateItem(arg0_22, arg1_22)
	if arg1_22.id == 10 then
		local var0_22 = arg0_22.uilist.container:GetChild(arg1_22.id - 1)

		var0_0.SetGrayOption(var0_22, arg0_22:GetDefaultValue(arg0_22.list[9]))
	end
end

function var0_0.OnUpdateItemWithTr(arg0_23, arg1_23, arg2_23)
	local var0_23 = findTF(arg2_23, "mask/tip")

	setActive(var0_23, false)

	if arg1_23.id == 18 then
		onButton(arg0_23, var0_23, function()
			pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, arg1_23)
		end, SFX_PANEL)
		setActive(var0_23, true)
	end
end

function var0_0.GetDefaultValue(arg0_25, arg1_25)
	if arg1_25.id == 1 then
		return pg.PushNotificationMgr.GetInstance():isEnableShipName()
	elseif arg1_25.id == 17 then
		return getProxy(SettingsProxy):IsDisplayResultPainting()
	elseif arg1_25.type == 0 then
		return PlayerPrefs.GetInt(_G[arg1_25.name], arg1_25.default or 0) > 0
	elseif arg1_25.type == 1 then
		local var0_25 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[arg1_25.name])

		if arg1_25.default == 1 then
			return not var0_25
		else
			return var0_25
		end
	end
end

function var0_0.GetList(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in ipairs(pg.settings_other_template.all) do
		if LOCK_BATTERY_SAVEMODE and (iter1_26 == 9 or iter1_26 == 10) then
			-- block empty
		elseif LOCK_L2D_GYRO and iter1_26 == 15 then
			-- block empty
		else
			table.insert(var0_26, pg.settings_other_template[iter1_26])
		end
	end

	return var0_26
end

return var0_0
