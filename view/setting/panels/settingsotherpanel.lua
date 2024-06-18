local var0_0 = class("SettingsOtherPanel", import(".SettingsNotificationPanel"))

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
	var0_0.super.OnInit(arg0_4, ...)

	local var0_4 = PlayerPrefs.GetInt("AUTOFIGHT_BATTERY_SAVEMODE", 0) > 0
	local var1_4 = pg.BrightnessMgr.GetInstance():IsPermissionGranted()

	if var0_4 and not var1_4 then
		PlayerPrefs.SetInt("AUTOFIGHT_BATTERY_SAVEMODE", 0)
		PlayerPrefs.Save()
	end
end

function var0_0.OnItemSwitch(arg0_5, arg1_5, arg2_5)
	if arg1_5.id == 1 then
		pg.PushNotificationMgr.GetInstance():setSwitchShipName(arg2_5)
	elseif arg1_5.id == 5 then
		arg0_5:OnClickEffectItemSwitch(arg1_5, arg2_5)
	elseif arg1_5.id == 9 then
		arg0_5:OnAutoFightBatterySaveModeItemSwitch(arg1_5, arg2_5)
	elseif arg1_5.id == 10 then
		arg0_5:OnAutoFightDownFrameItemSwitch(arg1_5, arg2_5)
	elseif arg1_5.type == 0 then
		arg0_5:OnCommonLocalItemSwitch(arg1_5, arg2_5)
	elseif arg1_5.type == 1 then
		arg0_5:OnCommonServerItemSwitch(arg1_5, arg2_5)
	end
end

function var0_0.OnClickEffectItemSwitch(arg0_6, arg1_6, arg2_6)
	local var0_6 = pg.UIMgr.GetInstance().OverlayEffect

	if var0_6 then
		setActive(var0_6, arg2_6)
	end

	arg0_6:OnCommonLocalItemSwitch(arg1_6, arg2_6)
end

function var0_0.OnCommonServerItemSwitch(arg0_7, arg1_7, arg2_7)
	local var0_7 = _G[arg1_7.name]
	local var1_7 = getProxy(PlayerProxy):getRawData():GetCommonFlag(var0_7)
	local var2_7 = not arg2_7

	if arg1_7.default == 1 then
		var2_7 = arg2_7
	end

	if var2_7 then
		pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
			flagID = var0_7
		})
	else
		pg.m02:sendNotification(GAME.COMMON_FLAG, {
			flagID = var0_7
		})
	end
end

function var0_0.OnAutoFightBatterySaveModeItemSwitch(arg0_8, arg1_8, arg2_8)
	local function var0_8()
		local var0_9 = arg0_8.uilist.container:GetChild(arg1_8.id - 1)

		triggerToggle(var0_9:Find("off"), true)
	end

	local var1_8 = pg.BrightnessMgr.GetInstance()

	seriesAsync({
		function(arg0_10)
			if not arg2_8 or var1_8:IsPermissionGranted() then
				return arg0_10()
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("words_autoFight_right"),
				onYes = function()
					var1_8:RequestPremission(function(arg0_12)
						if arg0_12 then
							arg0_10()
						else
							var0_8()
						end
					end)
				end,
				onNo = var0_8
			})
		end,
		function(arg0_13)
			local var0_13 = _G[arg1_8.name]

			PlayerPrefs.SetInt(var0_13, arg2_8 and 1 or 0)
			PlayerPrefs.Save()

			local var1_13 = arg0_8.uilist.container:GetChild(arg1_8.id)

			triggerToggle(var1_13:Find(arg2_8 and "on" or "off"), true)
			var0_0.SetGrayOption(var1_13, arg2_8)
		end
	})
end

function var0_0.OnAutoFightDownFrameItemSwitch(arg0_14, arg1_14, arg2_14)
	if not arg0_14:GetDefaultValue(arg0_14.list[9]) and arg2_14 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("words_autoFight_tips"))

		local var0_14 = arg0_14.uilist.container:GetChild(arg1_14.id - 1)

		triggerToggle(var0_14:Find("off"), true)

		return
	end

	local var1_14 = _G[arg1_14.name]

	PlayerPrefs.SetInt(var1_14, arg2_14 and 1 or 0)
	PlayerPrefs.Save()
end

function var0_0.SetGrayOption(arg0_15, arg1_15)
	setGray(arg0_15:Find("on"), not arg1_15)
	setGray(arg0_15:Find("off"), not arg1_15)
end

function var0_0.OnCommonLocalItemSwitch(arg0_16, arg1_16, arg2_16)
	local var0_16 = _G[arg1_16.name]

	PlayerPrefs.SetInt(var0_16, arg2_16 and 1 or 0)
	PlayerPrefs.Save()
end

function var0_0.OnUpdateItem(arg0_17, arg1_17)
	if arg1_17.id == 10 then
		local var0_17 = arg0_17.uilist.container:GetChild(arg1_17.id - 1)

		var0_0.SetGrayOption(var0_17, arg0_17:GetDefaultValue(arg0_17.list[9]))
	end
end

function var0_0.OnUpdateItemWithTr(arg0_18, arg1_18, arg2_18)
	local var0_18 = findTF(arg2_18, "mask/tip")

	setActive(var0_18, false)

	if arg1_18.id == 18 then
		onButton(arg0_18, var0_18, function()
			pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, arg1_18)
		end, SFX_PANEL)
		setActive(var0_18, true)
	end
end

function var0_0.GetDefaultValue(arg0_20, arg1_20)
	if arg1_20.id == 1 then
		return pg.PushNotificationMgr.GetInstance():isEnableShipName()
	elseif arg1_20.id == 17 then
		return getProxy(SettingsProxy):IsDisplayResultPainting()
	elseif arg1_20.type == 0 then
		return PlayerPrefs.GetInt(_G[arg1_20.name], arg1_20.default or 0) > 0
	elseif arg1_20.type == 1 then
		local var0_20 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[arg1_20.name])

		if arg1_20.default == 1 then
			return not var0_20
		else
			return var0_20
		end
	end
end

function var0_0.GetList(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(pg.settings_other_template.all) do
		if LOCK_BATTERY_SAVEMODE and (iter1_21 == 9 or iter1_21 == 10) then
			-- block empty
		elseif LOCK_L2D_GYRO and iter1_21 == 15 then
			-- block empty
		else
			table.insert(var0_21, pg.settings_other_template[iter1_21])
		end
	end

	return var0_21
end

return var0_0
