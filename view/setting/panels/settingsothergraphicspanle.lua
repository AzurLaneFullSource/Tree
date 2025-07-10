local var0_0 = class("SettingsOtherGraphicsPanle", import(".SettingsBasePanel"))

var0_0.EVT_UPDTAE = "SettingsOtherGraphicsPanle:EVT_UPDTAE"

local var1_0
local var2_0
local var3_0
local var4_0

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
	var1_0 = GraphicSettingConst.SettingType
	var2_0 = GraphicSettingConst.assetPath
	var3_0 = GraphicSettingConst.settings
	var4_0 = GraphicSettingConst.SettingLevel
	arg0_4.init = true
	arg0_4.uilist = UIItemList.New(arg0_4._tf:Find("options"), arg0_4._tf:Find("options/notify_tpl"))

	arg0_4.uilist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateItem(arg1_5 + 1, arg2_5)
		end
	end)
end

function var0_0.JumpToCustomSetting(arg0_6, arg1_6)
	if arg0_6.graphicLevel == var4_0.Custom then
		return
	end

	arg0_6:SetPlayerPrefSetting(arg1_6)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGraphics(4))
	PlayerPrefs.SetInt("dorm3d_graphics_settings_new", 4)
	pg.m02:sendNotification(NewSettingsMediator.SelectCustomGraphicSetting)
end

function var0_0.UpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.list[arg1_7]
	local var1_7 = arg2_7:Find("mask/Text")

	setText(var1_7, i18n(var0_7.settingName))

	local var2_7 = var0_7.settingType == var1_0.toggle
	local var3_7 = arg2_7:Find("toggle")
	local var4_7 = arg2_7:Find("select")

	setActive(var3_7, var2_7)
	setActive(var4_7, not var2_7)

	local var5_7 = arg0_7.typeList[arg1_7]

	if var2_7 then
		local function var6_7(arg0_8)
			local var0_8 = arg0_8 and 1 or 0

			PlayerPrefs.SetInt(var0_7.playerPrefsname, var0_8)
		end

		local var7_7 = arg2_7:Find("toggle/off")
		local var8_7 = arg2_7:Find("toggle/on")
		local var9_7

		local function var10_7(arg0_9)
			var9_7 = arg0_9

			SetActive(var7_7:Find("show"), not arg0_9)
			SetActive(var8_7:Find("show"), arg0_9)
		end

		onButton(arg0_7, var8_7, function()
			if var9_7 == true then
				return
			end

			if var0_7.tips then
				local var0_10 = {}

				table.insert(var0_10, function(arg0_11)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_NORMAL,
						content = i18n(var0_7.tips),
						onYes = function()
							arg0_11()
						end,
						onNo = function()
							return
						end
					})
				end)
				seriesAsync(var0_10, function()
					var10_7(true)
					var6_7(true)
					arg0_7:JumpToCustomSetting(var0_7)
				end)
			else
				var10_7(true)
				var6_7(true)

				if arg0_7.customSetting and var0_7.hasChild then
					pg.m02:sendNotification(NewSettingsMediator.SelectCustomGraphicSetting)

					return
				end

				arg0_7:JumpToCustomSetting(var0_7)
			end
		end, SFX_CANCEL)
		onButton(arg0_7, var7_7, function()
			if var9_7 == false then
				return
			end

			var10_7(false)
			var6_7(false)

			if arg0_7.customSetting and var0_7.hasChild then
				pg.m02:sendNotification(NewSettingsMediator.SelectCustomGraphicSetting)

				return
			end

			arg0_7:JumpToCustomSetting(var0_7)
		end, SFX_CANCEL)

		local var11_7

		if var5_7 == GraphicSettingConst.TYPE_GLOBAL_QUALITY then
			var11_7 = arg0_7.graphicLevel == var4_0.Custom and PlayerPrefs.GetInt(var0_7.playerPrefsname, -1) or nil

			if not var11_7 or var11_7 == -1 then
				var11_7 = arg0_7.qualitySettingAsset[var0_7.Cname]
			end
		elseif var5_7 == GraphicSettingConst.TYPE_VOLUME then
			var11_7 = PlayerPrefs.GetInt(var0_7.playerPrefsname, 0)
		end

		var10_7(var11_7 == 1 or var11_7 == true)
	else
		local var12_7

		if var5_7 == GraphicSettingConst.TYPE_GLOBAL_QUALITY then
			local var13_7 = arg0_7.graphicLevel == var4_0.Custom and PlayerPrefs.GetInt(var0_7.playerPrefsname, -1) or nil

			if not var13_7 or var13_7 == -1 then
				var13_7 = arg0_7.qualitySettingAsset[var0_7.Cname]
			end

			for iter0_7, iter1_7 in ipairs(var0_7.options) do
				if iter1_7 == var13_7 then
					var12_7 = iter0_7
				end
			end
		elseif var5_7 == GraphicSettingConst.TYPE_VOLUME then
			var12_7 = 1

			local var14_7 = PlayerPrefs.GetInt(var0_7.playerPrefsname, 0)

			for iter2_7, iter3_7 in ipairs(var0_7.options) do
				if iter3_7 == var14_7 then
					var12_7 = iter2_7
				end
			end
		end

		local function var15_7()
			local var0_16 = var12_7 == 1
			local var1_16 = var12_7 == #var0_7.optionNames

			setActive(var4_7:Find("leftbu"), not var0_16)
			setActive(var4_7:Find("rightbu"), not var1_16)
			setText(var4_7:Find("Text"), i18n(var0_7.optionNames[var12_7]))
		end

		var15_7()
		onButton(arg0_7, var4_7:Find("leftbu"), function()
			var12_7 = var12_7 - 1

			var15_7()
			PlayerPrefs.SetInt(var0_7.playerPrefsname, var0_7.options[var12_7])
			arg0_7:JumpToCustomSetting(var0_7)
		end)
		onButton(arg0_7, var4_7:Find("rightbu"), function()
			var12_7 = var12_7 + 1

			var15_7()
			PlayerPrefs.SetInt(var0_7.playerPrefsname, var0_7.options[var12_7])
			arg0_7:JumpToCustomSetting(var0_7)
		end)
	end
end

function var0_0.SetPlayerPrefSetting(arg0_19, arg1_19)
	if arg0_19.graphicLevel == var4_0.Custom then
		return
	end

	for iter0_19, iter1_19 in ipairs(var3_0) do
		if arg1_19.Cname ~= iter1_19.Cname then
			local var0_19 = PlayerPrefs.SetInt(iter1_19.playerPrefsname, -1)
			local var1_19 = arg0_19.qualitySettingAsset[iter1_19.Cname]

			if iter1_19.settingType == var1_0.toggle then
				local var2_19 = var1_19 and 1 or 0

				PlayerPrefs.SetInt(iter1_19.playerPrefsname, var2_19)
			else
				local var3_19

				for iter2_19, iter3_19 in ipairs(iter1_19.options) do
					if iter3_19 == var1_19 then
						var3_19 = iter2_19
					end
				end

				PlayerPrefs.SetInt(iter1_19.playerPrefsname, iter1_19.options[var3_19])
			end
		end
	end
end

function var0_0.OnUpdate(arg0_20)
	if not arg0_20.init then
		return
	end

	arg0_20.playerSettingPlaySet = {}
	arg0_20.graphicLevel = PlayerPrefs.GetInt("dorm3d_graphics_settings_new", 4)
	arg0_20.customSetting = arg0_20.graphicLevel == 4

	local var0_20 = var2_0[arg0_20.graphicLevel]

	arg0_20.qualitySettingAsset = LoadAny("three3dquaitysettings/defaultsettings", var0_20)
	arg0_20.list, arg0_20.typeList = arg0_20:GetList()

	arg0_20.uilist:align(#arg0_20.list)
end

function var0_0.RefreshPanelByGraphcLevel(arg0_21)
	arg0_21:OnUpdate()
end

function var0_0.GetList(arg0_22)
	local var0_22 = {}
	local var1_22 = {}

	local function var2_22(arg0_23)
		local var0_23 = arg0_22:GetParentSetting(arg0_23.parentId)
		local var1_23 = false

		if var0_23 then
			local var2_23 = arg0_22.customSetting and PlayerPrefs.GetInt(var0_23.playerPrefsname, -1) or nil

			if not var2_23 or var2_23 == -1 then
				var2_23 = arg0_22.qualitySettingAsset[var0_23.Cname]
			end

			var1_23 = var2_23 == 0
		end

		return not (arg0_23.isShow == 0 or var1_23)
	end

	for iter0_22, iter1_22 in ipairs(var3_0) do
		if var2_22(iter1_22) then
			table.insert(var0_22, iter1_22)
			table.insert(var1_22, GraphicSettingConst.TYPE_GLOBAL_QUALITY)
		end
	end

	for iter2_22, iter3_22 in ipairs(GraphicSettingConst.volumeSettings) do
		if var2_22(iter3_22) then
			table.insert(var0_22, iter3_22)
			table.insert(var1_22, GraphicSettingConst.TYPE_VOLUME)
		end
	end

	return var0_22, var1_22
end

function var0_0.GetParentSetting(arg0_24, arg1_24)
	if not arg1_24 then
		return
	end

	for iter0_24, iter1_24 in ipairs(var3_0) do
		if iter0_24 == arg1_24 then
			iter1_24.hasChild = true

			return iter1_24
		end
	end

	return nil
end

return var0_0
