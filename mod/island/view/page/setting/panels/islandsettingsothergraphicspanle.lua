local var0_0 = class("IslandSettingsOtherGraphicsPanle", import("view.Setting.panels.SettingsBasePanel"))

var0_0.EVT_UPDTAE = "IslandSettingsOtherGraphicsPanle:EVT_UPDTAE"

local var1_0
local var2_0
local var3_0
local var4_0

function var0_0.GetUIName(arg0_1)
	return "IslandGraphicSettingsOther"
end

function var0_0.GetTitle(arg0_2)
	return i18n("grapihcs3d_setting_universal")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / STANDBY MODE SETTINGS"
end

function var0_0.InitTitle(arg0_4)
	setText(arg0_4._tf:Find("title/title_point/title_text"), arg0_4:GetTitle())
end

function var0_0.OnInit(arg0_5)
	var1_0 = GraphicSettingConst.SettingType
	var2_0 = GraphicSettingConst.assetPath
	var3_0 = GraphicSettingConst.settings
	var4_0 = GraphicSettingConst.SettingLevel
	arg0_5.init = true
	arg0_5.uilist = UIItemList.New(arg0_5._tf:Find("options"), arg0_5._tf:Find("options/notify_tpl"))

	arg0_5.uilist:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_5:UpdateItem(arg1_6 + 1, arg2_6)
		end
	end)
end

function var0_0.JumpToCustomSetting(arg0_7, arg1_7)
	if arg0_7.graphicLevel == var4_0.Custom then
		return
	end

	arg0_7:SetPlayerPrefSetting(arg1_7)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGraphics(4))
	PlayerPrefs.SetInt(GraphicSettingConst.PlayerGraphicLevelIsland, 4)
	pg.m02:sendNotification(IslandSettingsPage.SELECTCUSTOMGRAPHICSETTING)
end

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.list[arg1_8]
	local var1_8 = arg2_8:Find("mask/Text")

	setText(var1_8, i18n(var0_8.settingName))

	local var2_8 = var0_8.settingType == var1_0.toggle
	local var3_8 = arg2_8:Find("toggle")
	local var4_8 = arg2_8:Find("select")

	setActive(var3_8, var2_8)
	setActive(var4_8, not var2_8)

	if var2_8 then
		local function var5_8(arg0_9)
			local var0_9 = arg0_9 and 1 or 0

			PlayerPrefs.SetInt(var0_8.playerPrefsname .. "island", var0_9)
		end

		local var6_8 = arg2_8:Find("toggle/off")
		local var7_8 = arg2_8:Find("toggle/on")
		local var8_8

		local function var9_8(arg0_10)
			var8_8 = arg0_10

			SetActive(var6_8, not arg0_10)
			SetActive(var7_8, arg0_10)
		end

		onButton(arg0_8, var6_8, function()
			if var8_8 == true then
				return
			end

			if var0_8.tips then
				local var0_11 = {}

				table.insert(var0_11, function(arg0_12)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_NORMAL,
						content = i18n(var0_8.tips),
						onYes = function()
							arg0_12()
						end,
						onNo = function()
							return
						end
					})
				end)
				seriesAsync(var0_11, function()
					var9_8(true)
					var5_8(true)
					arg0_8:JumpToCustomSetting(var0_8)
				end)
			else
				var9_8(true)
				var5_8(true)

				if arg0_8.customSetting and var0_8.hasChild then
					pg.m02:sendNotification(IslandSettingsPage.SELECTCUSTOMGRAPHICSETTING)

					return
				end

				arg0_8:JumpToCustomSetting(var0_8)
			end
		end, SFX_CANCEL)
		onButton(arg0_8, var7_8, function()
			if var8_8 == false then
				return
			end

			var9_8(false)
			var5_8(false)

			if arg0_8.customSetting and var0_8.hasChild then
				pg.m02:sendNotification(IslandSettingsPage.SELECTCUSTOMGRAPHICSETTING)

				return
			end

			arg0_8:JumpToCustomSetting(var0_8)
		end, SFX_CANCEL)

		local var10_8
		local var11_8 = arg0_8.graphicLevel == var4_0.Custom and PlayerPrefs.GetInt(var0_8.playerPrefsname .. "island", -1) or nil

		if not var11_8 or var11_8 == -1 then
			var11_8 = var0_8.defaultValues[arg0_8.graphicLevel]
		end

		var9_8(var11_8 == 1 or var11_8 == true)
	else
		local var12_8
		local var13_8 = arg0_8.graphicLevel == var4_0.Custom and PlayerPrefs.GetInt(var0_8.playerPrefsname .. "island", -1) or nil

		if not var13_8 or var13_8 == -1 then
			var13_8 = var0_8.defaultValues[arg0_8.graphicLevel]
		end

		for iter0_8, iter1_8 in ipairs(var0_8.options) do
			if iter1_8 == var13_8 then
				var12_8 = iter0_8
			end
		end

		local function var14_8()
			local var0_17 = var12_8 == 1
			local var1_17 = var12_8 == #var0_8.optionNames

			setActive(var4_8:Find("leftbu"), not var0_17)
			setActive(var4_8:Find("leftline"), var0_17)
			setActive(var4_8:Find("rightbu"), not var1_17)
			setActive(var4_8:Find("rightline"), var1_17)
			setText(var4_8:Find("Text"), i18n(var0_8.optionNames[var12_8]))
		end

		var14_8()
		onButton(arg0_8, var4_8:Find("leftbu"), function()
			var12_8 = var12_8 - 1

			var14_8()
			PlayerPrefs.SetInt(var0_8.playerPrefsname .. "island", var0_8.options[var12_8])
			arg0_8:JumpToCustomSetting(var0_8)
		end)
		onButton(arg0_8, var4_8:Find("rightbu"), function()
			var12_8 = var12_8 + 1

			var14_8()
			PlayerPrefs.SetInt(var0_8.playerPrefsname .. "island", var0_8.options[var12_8])
			arg0_8:JumpToCustomSetting(var0_8)
		end)
	end
end

function var0_0.SetPlayerPrefSetting(arg0_20, arg1_20)
	if arg0_20.graphicLevel == var4_0.Custom then
		return
	end

	for iter0_20, iter1_20 in ipairs(var3_0) do
		if arg1_20.playerPrefsname .. "island" ~= iter1_20.playerPrefsname .. "island" then
			local var0_20 = iter1_20.defaultValues[arg0_20.graphicLevel]

			if iter1_20.settingType == var1_0.toggle then
				local var1_20 = var0_20 and 1 or 0

				PlayerPrefs.SetInt(iter1_20.playerPrefsname .. "island", var1_20)
			else
				local var2_20

				for iter2_20, iter3_20 in ipairs(iter1_20.options) do
					if iter3_20 == var0_20 then
						var2_20 = iter2_20
					end
				end

				PlayerPrefs.SetInt(iter1_20.playerPrefsname .. "island", iter1_20.options[var2_20])
			end
		end
	end
end

function var0_0.OnUpdate(arg0_21)
	if not arg0_21.init then
		return
	end

	arg0_21.playerSettingPlaySet = {}
	arg0_21.graphicLevel = PlayerPrefs.GetInt(GraphicSettingConst.PlayerGraphicLevelIsland, 4)
	arg0_21.customSetting = arg0_21.graphicLevel == 4

	local var0_21 = var2_0[arg0_21.graphicLevel]

	arg0_21.list = arg0_21:GetList()

	arg0_21.uilist:align(#arg0_21.list)
end

function var0_0.RefreshPanelByGraphcLevel(arg0_22)
	arg0_22:OnUpdate()
end

function var0_0.GetList(arg0_23)
	local var0_23 = {}

	local function var1_23(arg0_24)
		local var0_24 = arg0_23:GetParentSetting(arg0_24.parentId)
		local var1_24 = false

		if var0_24 then
			local var2_24 = arg0_23.customSetting and PlayerPrefs.GetInt(var0_24.playerPrefsname .. "island", -1) or nil

			if not var2_24 or var2_24 == -1 then
				var2_24 = var0_24.defaultValues[arg0_23.graphicLevel]
			end

			var1_24 = var2_24 == 0
		end

		return not (arg0_24.isShow == 0 or var1_24)
	end

	for iter0_23, iter1_23 in ipairs(var3_0) do
		if var1_23(iter1_23) then
			table.insert(var0_23, iter1_23)
		end
	end

	return var0_23
end

function var0_0.GetParentSetting(arg0_25, arg1_25)
	if not arg1_25 then
		return
	end

	for iter0_25, iter1_25 in ipairs(var3_0) do
		if iter0_25 == arg1_25 then
			iter1_25.hasChild = true

			return iter1_25
		end
	end

	return nil
end

return var0_0
