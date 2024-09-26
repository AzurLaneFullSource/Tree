local var0_0 = class("SettingsOtherGraphicsPanle", import(".SettingsBasePanel"))

var0_0.EVT_UPDTAE = "SettingsOtherGraphicsPanle:EVT_UPDTAE"

local var1_0 = {
	toggle = 1,
	select = 2
}
local var2_0 = GraphicSettingConst.assetPath
local var3_0 = GraphicSettingConst.settings

function var0_0.GetUIName(arg0_1)
	return "GraphicSettingsOther"
end

function var0_0.GetTitle(arg0_2)
	return i18n("grapihcs3d_setting_universal")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / STANDBY MODE SETTINGS"
end

function var0_0.OnInit(arg0_4)
	arg0_4.init = true
	arg0_4.uilist = UIItemList.New(arg0_4._tf:Find("options"), arg0_4._tf:Find("options/notify_tpl"))

	arg0_4.uilist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateItem(arg1_5 + 1, arg2_5)
		end
	end)
end

function var0_0.JumpToCustomSettingSetChild(arg0_6, arg1_6)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGraphics(4))
	PlayerPrefs.SetInt("dorm3d_graphics_settings", 4)

	for iter0_6, iter1_6 in ipairs(arg0_6.playerSettingPlaySet) do
		local var0_6

		if iter1_6.type == var1_0.toggle then
			var0_6 = iter1_6.value and 2 or 1

			if iter1_6.hasParent then
				var0_6 = 1
			end
		else
			var0_6 = iter1_6.value
		end

		if arg1_6 ~= nil and iter1_6.name == arg1_6.name then
			PlayerPrefs.SetInt(arg1_6.name, arg1_6.value)
		else
			PlayerPrefs.SetInt(iter1_6.name, var0_6)
		end
	end

	pg.m02:sendNotification(NewSettingsMediator.SelectCustomGraphicSetting)
end

function var0_0.JumpToCustomSetting(arg0_7, arg1_7)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGraphics(4))
	PlayerPrefs.SetInt("dorm3d_graphics_settings", 4)

	for iter0_7, iter1_7 in ipairs(arg0_7.playerSettingPlaySet) do
		local var0_7

		if iter1_7.type == var1_0.toggle then
			var0_7 = iter1_7.value and 2 or 1
		else
			var0_7 = iter1_7.value
		end

		if arg1_7 ~= nil and iter1_7.name == arg1_7.name then
			PlayerPrefs.SetInt(arg1_7.name, arg1_7.value)
		else
			PlayerPrefs.SetInt(iter1_7.name, var0_7)
		end
	end

	pg.m02:sendNotification(NewSettingsMediator.SelectCustomGraphicSetting)
end

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.list[arg1_8]
	local var1_8 = pg.dorm3d_graphic_setting[var0_8.cfgId]
	local var2_8 = arg2_8:Find("mask/Text")

	setText(var2_8, var1_8.settingName)

	local var3_8 = var1_8.displayType == var1_0.toggle
	local var4_8 = arg2_8:Find("toggle")
	local var5_8 = arg2_8:Find("select")

	setActive(var4_8, var3_8)
	setActive(var5_8, not var3_8)

	if var3_8 then
		local function var6_8(arg0_9)
			local var0_9 = arg0_9 and 2 or 1

			return {
				name = var0_8.playerPrefsname,
				value = var0_9
			}
		end

		local var7_8 = arg2_8:Find("toggle/off")
		local var8_8 = arg2_8:Find("toggle/on")
		local var9_8

		local function var10_8(arg0_10)
			var9_8 = arg0_10

			SetActive(var7_8:Find("show"), not arg0_10)
			SetActive(var8_8:Find("show"), arg0_10)
		end

		onButton(arg0_8, var8_8, function()
			if var9_8 == true then
				return
			end

			if var0_8.tips then
				local var0_11 = {}

				table.insert(var0_11, function(arg0_12)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_NORMAL,
						content = var0_8.tips,
						onYes = function()
							arg0_12()
						end,
						onNo = function()
							return
						end
					})
				end)
				seriesAsync(var0_11, function()
					var10_8(true)

					local var0_15 = var6_8(true)

					arg0_8:JumpToCustomSetting(var0_15)
				end)
			else
				var10_8(true)

				local var1_11 = var6_8(true)

				arg0_8:JumpToCustomSetting(var1_11)
			end
		end, SFX_CANCEL)
		onButton(arg0_8, var7_8, function()
			if var9_8 == false then
				return
			end

			var10_8(false)

			local var0_16 = var6_8(false)

			arg0_8:JumpToCustomSetting(var0_16)
		end, SFX_CANCEL)

		local var11_8
		local var12_8 = PlayerPrefs.GetInt(var0_8.playerPrefsname, 0)

		if arg0_8.customSetting and var12_8 ~= 0 then
			var11_8 = var12_8 == 2 and true or false
		else
			var11_8 = ReflectionHelp.RefGetField(arg0_8.qualitySettingAssetType, var0_8.CsharpValue, arg0_8.qualitySettingAsset)
		end

		var10_8(var11_8)
		table.insert(arg0_8.playerSettingPlaySet, {
			name = var0_8.playerPrefsname,
			value = var11_8,
			type = var1_8.displayType,
			hasParent = var0_8.parentSetting ~= nil
		})
	else
		local var13_8 = ReflectionHelp.RefGetField(arg0_8.qualitySettingAssetType, var0_8.CsharpValue, arg0_8.qualitySettingAsset)
		local var14_8
		local var15_8 = PlayerPrefs.GetInt(var0_8.playerPrefsname, 0)

		if arg0_8.customSetting and var15_8 ~= 0 then
			var14_8 = var15_8
		else
			local var16_8 = ReflectionHelp.RefGetField(arg0_8.qualitySettingAssetType, var0_8.CsharpValue, arg0_8.qualitySettingAsset)

			var14_8 = var0_8.Enum[tostring(var16_8)]
		end

		local function var17_8()
			local var0_17 = var14_8 == 1
			local var1_17 = var14_8 == #var1_8.dispaySelectName

			setActive(var5_8:Find("leftbu"), not var0_17)
			setActive(var5_8:Find("rightbu"), not var1_17)
			setText(var5_8:Find("Text"), var1_8.dispaySelectName[var14_8])
		end

		var17_8()
		onButton(arg0_8, var5_8:Find("leftbu"), function()
			var14_8 = var14_8 - 1

			var17_8()

			if var0_8.childList and var14_8 == 1 then
				arg0_8:JumpToCustomSettingSetChild({
					name = var0_8.playerPrefsname,
					value = var14_8
				})
			else
				arg0_8:JumpToCustomSetting({
					name = var0_8.playerPrefsname,
					value = var14_8
				})
			end
		end)
		onButton(arg0_8, var5_8:Find("rightbu"), function()
			var14_8 = var14_8 + 1

			var17_8()
			arg0_8:JumpToCustomSetting({
				name = var0_8.playerPrefsname,
				value = var14_8
			})
		end)
		table.insert(arg0_8.playerSettingPlaySet, {
			name = var0_8.playerPrefsname,
			value = var14_8,
			type = var1_8.displayType
		})
	end
end

function var0_0.OnUpdate(arg0_20)
	if not arg0_20.init then
		return
	end

	arg0_20.playerSettingPlaySet = {}
	arg0_20.customSetting = PlayerPrefs.GetInt("dorm3d_graphics_settings", 1) == 4

	local var0_20 = var2_0[PlayerPrefs.GetInt("dorm3d_graphics_settings", 2)]

	arg0_20.qualitySettingAsset = ResourceMgr.Inst:getAssetSync("three3dquaitysettings/defaultsettings", var0_20, nil, true, true)
	arg0_20.qualitySettingAssetType = arg0_20.qualitySettingAsset:GetType()
	arg0_20.list = arg0_20:GetList()

	arg0_20.uilist:align(#arg0_20.list)
end

function var0_0.RefreshPanelByGraphcLevel(arg0_21)
	arg0_21:OnUpdate()
end

function var0_0.GetList(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(var3_0) do
		local var1_22 = pg.dorm3d_graphic_setting[iter1_22.cfgId]
		local var2_22 = arg0_22:GetParentSetting(var1_22.parentSetting)
		local var3_22 = false

		if var2_22 then
			local var4_22 = PlayerPrefs.GetInt(var2_22.playerPrefsname, 0)
			local var5_22

			if arg0_22.customSetting and var4_22 ~= 0 then
				var5_22 = var4_22
			else
				local var6_22 = ReflectionHelp.RefGetField(arg0_22.qualitySettingAssetType, var2_22.CsharpValue, arg0_22.qualitySettingAsset)

				var5_22 = var2_22.Enum[tostring(var6_22)]
			end

			var3_22 = var5_22 == 1
		end

		if not (var1_22.isShow == 0 or var3_22) then
			table.insert(var0_22, iter1_22)
		end
	end

	return var0_22
end

function var0_0.GetParentSetting(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(var3_0) do
		if iter1_23.cfgId == arg1_23 then
			return iter1_23
		end
	end

	return nil
end

return var0_0
