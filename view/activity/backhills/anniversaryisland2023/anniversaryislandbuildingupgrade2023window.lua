local var0_0 = class("AnniversaryIslandBuildingUpgrade2023Window", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryIslandBuildingUpgrade2023Window"
end

function var0_0.GetAtlasPath(arg0_2)
	return "ui/" .. arg0_2:getUIName() .. "_atlas"
end

function var0_0.init(arg0_3)
	arg0_3.window = arg0_3._tf:Find("Window")
	arg0_3.upgradeWindow = arg0_3.window:Find("Upgrade")
	arg0_3.displayWindow = arg0_3.window:Find("Display")

	setText(arg0_3.window:Find("Upgrade/MaterialsTitle"), i18n("workbench_need_materials"))
	setText(arg0_3.window:Find("Display/MaxTip"), i18n("workbench_tips6"))

	arg0_3.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_4)
	local var0_4 = arg0_4.contextData.buildingID

	onButton(arg0_4, arg0_4._tf:Find("BG"), function()
		arg0_4:onBackPressed()
	end)
	onButton(arg0_4, arg0_4.upgradeWindow:Find("Cancel"), function()
		arg0_4:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.upgradeWindow:Find("Upgrade"), function()
		if arg0_4.isMaxLevel then
			return
		elseif arg0_4.isOverAvg then
			pg.TipsMgr.GetInstance():ShowTips(i18n("haidaojudian_upgrade_limit"))
		elseif arg0_4.isLackMat then
			pg.TipsMgr.GetInstance():ShowTips(i18n("haidaojudian_building_tip"))
		else
			arg0_4:emit(BuildingUpgradeMediator.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg0_4.activityId,
				arg1 = var0_4
			})
		end
	end)
	onButton(arg0_4, arg0_4.displayWindow:Find("Confirm"), function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	arg0_4:UpdateView()
end

function var0_0.UpdateView(arg0_9)
	local var0_9 = arg0_9.contextData.buildingID
	local var1_9 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0_9.activityId = var1_9.id

	local var2_9 = var1_9:GetBuildingLevel(var0_9)
	local var3_9 = pg.activity_event_building[var0_9]
	local var4_9 = #var3_9.buff

	arg0_9.isMaxLevel = var4_9 <= var2_9
	arg0_9.isOverAvg = var2_9 > var1_9:GetTotalBuildingLevel()

	setActive(arg0_9.upgradeWindow, not arg0_9.isMaxLevel)
	setActive(arg0_9.displayWindow, arg0_9.isMaxLevel)

	local var5_9 = arg0_9.isMaxLevel and arg0_9.displayWindow or arg0_9.upgradeWindow
	local var6_9 = AnniversaryIsland2023Scene.Buildings[var0_9]

	arg0_9.loader:GetSpriteQuiet(arg0_9:GetAtlasPath(), var6_9, var5_9:Find("Title/BuildingName"), true)

	local var7_9 = 0

	;(function()
		arg0_9.loader:GetSpriteQuiet(arg0_9:GetAtlasPath(), var2_9, var5_9:Find("Title/LevelBefore"), true)

		local var0_10 = var3_9.buff[var2_9]
		local var1_10 = CommonBuff.New({
			id = var0_10
		})
		local var2_10 = string.split(var1_10:getConfig("desc"), "/")

		assert(var2_10)

		local var3_10, var4_10, var5_10 = string.find(var2_10[1], "([^%+]*)%+")
		local var6_10 = string.sub(var2_10[1], var4_10, #var2_10[1])
		local var7_10, var8_10, var9_10 = string.find(var2_10[2], "([^%+]*)%+")
		local var10_10 = string.sub(var2_10[2], var8_10, #var2_10[2])

		setText(var5_9:Find("Progress1/1/Desc"), var5_10)
		setText(var5_9:Find("Progress1/1/Value"), var6_10)
		setText(var5_9:Find("Progress2/1/Desc"), var9_10)
		setText(var5_9:Find("Progress2/1/Value"), var10_10)

		var7_9 = tonumber(var1_10:getConfig("benefit_effect"))
	end)()
	;(function()
		if var2_9 >= var4_9 then
			return
		end

		local var0_11 = var2_9 + 1

		arg0_9.loader:GetSpriteQuiet(arg0_9:GetAtlasPath(), var0_11, var5_9:Find("Title/LevelAfter"), true)

		local var1_11 = var3_9.buff[var0_11]
		local var2_11 = CommonBuff.New({
			id = var1_11
		})
		local var3_11 = string.split(var2_11:getConfig("desc"), "/")

		assert(var3_11)

		local var4_11, var5_11, var6_11 = string.find(var3_11[1], "([^%+]*)%+")
		local var7_11 = string.sub(var3_11[1], var5_11, #var3_11[1])
		local var8_11, var9_11, var10_11 = string.find(var3_11[2], "([^%+]*)%+")
		local var11_11 = string.sub(var3_11[2], var9_11, #var3_11[2])

		setText(var5_9:Find("Progress1/2/Desc"), var6_11)
		setText(var5_9:Find("Progress1/2/Value"), var7_11)
		setText(var5_9:Find("Progress2/2/Desc"), var10_11)
		setText(var5_9:Find("Progress2/2/Value"), var11_11)

		local var12_11 = tonumber(var2_11:getConfig("benefit_effect")) > var7_9

		setActive(var5_9:Find("Progress2/2/Up"), var12_11)
	end)()
	;(function()
		if var2_9 >= var4_9 then
			return
		end

		local var0_12 = var3_9.material[var2_9]
		local var1_12 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

		arg0_9.isLackMat = false

		UIItemList.StaticAlign(var5_9:Find("Materials"), var5_9:Find("Materials"):GetChild(0), #var0_12, function(arg0_13, arg1_13, arg2_13)
			if arg0_13 ~= UIItemList.EventUpdate then
				return
			end

			local var0_13 = var0_12[arg1_13 + 1]
			local var1_13 = {
				type = var0_13[1],
				id = var0_13[2],
				count = var0_13[3]
			}

			arg0_9:UpdateActivityDrop(arg2_13:Find("Icon"), var1_13)
			onButton(arg0_9, arg2_13:Find("Icon"), function()
				if var1_13.type == DROP_TYPE_WORKBENCH_DROP then
					arg0_9:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
						configId = var1_13.id,
						count = var1_13.count
					}))
				else
					arg0_9:emit(BaseUI.ON_DROP, var1_13)
				end
			end)

			local var2_13 = var0_13[2]
			local var3_13 = var0_13[3]
			local var4_13 = var1_12:getVitemNumber(var2_13)
			local var5_13 = var4_13 < var3_13

			setText(arg2_13:Find("Text"), setColorStr(var4_13, var5_13 and "#bb6754" or "#6b5a48") .. "/" .. var3_13)

			arg0_9.isLackMat = arg0_9.isLackMat or var5_13
		end)
	end)()
end

local var1_0 = "ui/AtelierCommonUI_atlas"

function var0_0.UpdateActivityDrop(arg0_15, arg1_15, arg2_15, arg3_15)
	updateDrop(arg1_15, arg2_15)
	SetCompomentEnabled(arg1_15:Find("icon_bg"), typeof(Image), false)
	setActive(arg1_15:Find("bg"), false)
	setActive(arg1_15:Find("icon_bg/frame"), false)
	setActive(arg1_15:Find("icon_bg/stars"), false)

	local var0_15 = arg2_15:getConfig("rarity")

	if arg2_15.type == DROP_TYPE_EQUIP or arg2_15.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_15 = var0_15 - 1
	end

	local var1_15 = "icon_frame_" .. var0_15

	if arg3_15 then
		var1_15 = var1_15 .. "_small"
	end

	arg0_15.loader:GetSpriteQuiet(var1_0, var1_15, arg1_15)
end

function var0_0.willExit(arg0_16)
	arg0_16.loader:Clear()
end

return var0_0
