local var0 = class("SettingsOtherPanel", import(".SettingsNotificationPanel"))

function var0.GetUIName(arg0)
	return "SettingsOther"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_Other")
end

function var0.GetTitleEn(arg0)
	return "  / OTHER SETTINGS"
end

function var0.OnInit(arg0, ...)
	var0.super.OnInit(arg0, ...)

	local var0 = PlayerPrefs.GetInt("AUTOFIGHT_BATTERY_SAVEMODE", 0) > 0
	local var1 = pg.BrightnessMgr.GetInstance():IsPermissionGranted()

	if var0 and not var1 then
		PlayerPrefs.SetInt("AUTOFIGHT_BATTERY_SAVEMODE", 0)
		PlayerPrefs.Save()
	end
end

function var0.OnItemSwitch(arg0, arg1, arg2)
	if arg1.id == 1 then
		pg.PushNotificationMgr.GetInstance():setSwitchShipName(arg2)
	elseif arg1.id == 5 then
		arg0:OnClickEffectItemSwitch(arg1, arg2)
	elseif arg1.id == 9 then
		arg0:OnAutoFightBatterySaveModeItemSwitch(arg1, arg2)
	elseif arg1.id == 10 then
		arg0:OnAutoFightDownFrameItemSwitch(arg1, arg2)
	elseif arg1.type == 0 then
		arg0:OnCommonLocalItemSwitch(arg1, arg2)
	elseif arg1.type == 1 then
		arg0:OnCommonServerItemSwitch(arg1, arg2)
	end
end

function var0.OnClickEffectItemSwitch(arg0, arg1, arg2)
	local var0 = pg.UIMgr.GetInstance().OverlayEffect

	if var0 then
		setActive(var0, arg2)
	end

	arg0:OnCommonLocalItemSwitch(arg1, arg2)
end

function var0.OnCommonServerItemSwitch(arg0, arg1, arg2)
	local var0 = _G[arg1.name]
	local var1 = getProxy(PlayerProxy):getRawData():GetCommonFlag(var0)
	local var2 = not arg2

	if arg1.default == 1 then
		var2 = arg2
	end

	if var2 then
		pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
			flagID = var0
		})
	else
		pg.m02:sendNotification(GAME.COMMON_FLAG, {
			flagID = var0
		})
	end
end

function var0.OnAutoFightBatterySaveModeItemSwitch(arg0, arg1, arg2)
	local function var0()
		local var0 = arg0.uilist.container:GetChild(arg1.id - 1)

		triggerToggle(var0:Find("off"), true)
	end

	local var1 = pg.BrightnessMgr.GetInstance()

	seriesAsync({
		function(arg0)
			if not arg2 or var1:IsPermissionGranted() then
				return arg0()
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("words_autoFight_right"),
				onYes = function()
					var1:RequestPremission(function(arg0)
						if arg0 then
							arg0()
						else
							var0()
						end
					end)
				end,
				onNo = var0
			})
		end,
		function(arg0)
			local var0 = _G[arg1.name]

			PlayerPrefs.SetInt(var0, arg2 and 1 or 0)
			PlayerPrefs.Save()

			local var1 = arg0.uilist.container:GetChild(arg1.id)

			triggerToggle(var1:Find(arg2 and "on" or "off"), true)
			var0.SetGrayOption(var1, arg2)
		end
	})
end

function var0.OnAutoFightDownFrameItemSwitch(arg0, arg1, arg2)
	if not arg0:GetDefaultValue(arg0.list[9]) and arg2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("words_autoFight_tips"))

		local var0 = arg0.uilist.container:GetChild(arg1.id - 1)

		triggerToggle(var0:Find("off"), true)

		return
	end

	local var1 = _G[arg1.name]

	PlayerPrefs.SetInt(var1, arg2 and 1 or 0)
	PlayerPrefs.Save()
end

function var0.SetGrayOption(arg0, arg1)
	setGray(arg0:Find("on"), not arg1)
	setGray(arg0:Find("off"), not arg1)
end

function var0.OnCommonLocalItemSwitch(arg0, arg1, arg2)
	local var0 = _G[arg1.name]

	PlayerPrefs.SetInt(var0, arg2 and 1 or 0)
	PlayerPrefs.Save()
end

function var0.OnUpdateItem(arg0, arg1)
	if arg1.id == 10 then
		local var0 = arg0.uilist.container:GetChild(arg1.id - 1)

		var0.SetGrayOption(var0, arg0:GetDefaultValue(arg0.list[9]))
	end
end

function var0.OnUpdateItemWithTr(arg0, arg1, arg2)
	local var0 = findTF(arg2, "mask/tip")

	setActive(var0, false)

	if arg1.id == 18 then
		onButton(arg0, var0, function()
			pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, arg1)
		end, SFX_PANEL)
		setActive(var0, true)
	end
end

function var0.GetDefaultValue(arg0, arg1)
	if arg1.id == 1 then
		return pg.PushNotificationMgr.GetInstance():isEnableShipName()
	elseif arg1.id == 17 then
		return getProxy(SettingsProxy):IsDisplayResultPainting()
	elseif arg1.type == 0 then
		return PlayerPrefs.GetInt(_G[arg1.name], arg1.default or 0) > 0
	elseif arg1.type == 1 then
		local var0 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[arg1.name])

		if arg1.default == 1 then
			return not var0
		else
			return var0
		end
	end
end

function var0.GetList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.settings_other_template.all) do
		if LOCK_BATTERY_SAVEMODE and (iter1 == 9 or iter1 == 10) then
			-- block empty
		elseif LOCK_L2D_GYRO and iter1 == 15 then
			-- block empty
		else
			table.insert(var0, pg.settings_other_template[iter1])
		end
	end

	return var0
end

return var0
