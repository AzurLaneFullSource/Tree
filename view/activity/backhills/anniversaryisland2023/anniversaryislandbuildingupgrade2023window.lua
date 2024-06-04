local var0 = class("AnniversaryIslandBuildingUpgrade2023Window", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AnniversaryIslandBuildingUpgrade2023Window"
end

function var0.GetAtlasPath(arg0)
	return "ui/" .. arg0:getUIName() .. "_atlas"
end

function var0.init(arg0)
	arg0.window = arg0._tf:Find("Window")
	arg0.upgradeWindow = arg0.window:Find("Upgrade")
	arg0.displayWindow = arg0.window:Find("Display")

	setText(arg0.window:Find("Upgrade/MaterialsTitle"), i18n("workbench_need_materials"))
	setText(arg0.window:Find("Display/MaxTip"), i18n("workbench_tips6"))

	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	local var0 = arg0.contextData.buildingID

	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:onBackPressed()
	end)
	onButton(arg0, arg0.upgradeWindow:Find("Cancel"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0.upgradeWindow:Find("Upgrade"), function()
		if arg0.isMaxLevel then
			return
		elseif arg0.isOverAvg then
			pg.TipsMgr.GetInstance():ShowTips(i18n("haidaojudian_upgrade_limit"))
		elseif arg0.isLackMat then
			pg.TipsMgr.GetInstance():ShowTips(i18n("haidaojudian_building_tip"))
		else
			arg0:emit(BuildingUpgradeMediator.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg0.activityId,
				arg1 = var0
			})
		end
	end)
	onButton(arg0, arg0.displayWindow:Find("Confirm"), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = arg0.contextData.buildingID
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0.activityId = var1.id

	local var2 = var1:GetBuildingLevel(var0)
	local var3 = pg.activity_event_building[var0]
	local var4 = #var3.buff

	arg0.isMaxLevel = var4 <= var2
	arg0.isOverAvg = var2 > var1:GetTotalBuildingLevel()

	setActive(arg0.upgradeWindow, not arg0.isMaxLevel)
	setActive(arg0.displayWindow, arg0.isMaxLevel)

	local var5 = arg0.isMaxLevel and arg0.displayWindow or arg0.upgradeWindow
	local var6 = AnniversaryIsland2023Scene.Buildings[var0]

	arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), var6, var5:Find("Title/BuildingName"), true)

	local var7 = 0

	;(function()
		arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), var2, var5:Find("Title/LevelBefore"), true)

		local var0 = var3.buff[var2]
		local var1 = CommonBuff.New({
			id = var0
		})
		local var2 = string.split(var1:getConfig("desc"), "/")

		assert(var2)

		local var3, var4, var5 = string.find(var2[1], "([^%+]*)%+")
		local var6 = string.sub(var2[1], var4, #var2[1])
		local var7, var8, var9 = string.find(var2[2], "([^%+]*)%+")
		local var10 = string.sub(var2[2], var8, #var2[2])

		setText(var5:Find("Progress1/1/Desc"), var5)
		setText(var5:Find("Progress1/1/Value"), var6)
		setText(var5:Find("Progress2/1/Desc"), var9)
		setText(var5:Find("Progress2/1/Value"), var10)

		var7 = tonumber(var1:getConfig("benefit_effect"))
	end)()
	;(function()
		if var2 >= var4 then
			return
		end

		local var0 = var2 + 1

		arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), var0, var5:Find("Title/LevelAfter"), true)

		local var1 = var3.buff[var0]
		local var2 = CommonBuff.New({
			id = var1
		})
		local var3 = string.split(var2:getConfig("desc"), "/")

		assert(var3)

		local var4, var5, var6 = string.find(var3[1], "([^%+]*)%+")
		local var7 = string.sub(var3[1], var5, #var3[1])
		local var8, var9, var10 = string.find(var3[2], "([^%+]*)%+")
		local var11 = string.sub(var3[2], var9, #var3[2])

		setText(var5:Find("Progress1/2/Desc"), var6)
		setText(var5:Find("Progress1/2/Value"), var7)
		setText(var5:Find("Progress2/2/Desc"), var10)
		setText(var5:Find("Progress2/2/Value"), var11)

		local var12 = tonumber(var2:getConfig("benefit_effect")) > var7

		setActive(var5:Find("Progress2/2/Up"), var12)
	end)()
	;(function()
		if var2 >= var4 then
			return
		end

		local var0 = var3.material[var2]
		local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

		arg0.isLackMat = false

		UIItemList.StaticAlign(var5:Find("Materials"), var5:Find("Materials"):GetChild(0), #var0, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var0[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			arg0:UpdateActivityDrop(arg2:Find("Icon"), var1)
			onButton(arg0, arg2:Find("Icon"), function()
				if var1.type == DROP_TYPE_WORKBENCH_DROP then
					arg0:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
						configId = var1.id,
						count = var1.count
					}))
				else
					arg0:emit(BaseUI.ON_DROP, var1)
				end
			end)

			local var2 = var0[2]
			local var3 = var0[3]
			local var4 = var1:getVitemNumber(var2)
			local var5 = var4 < var3

			setText(arg2:Find("Text"), setColorStr(var4, var5 and "#bb6754" or "#6b5a48") .. "/" .. var3)

			arg0.isLackMat = arg0.isLackMat or var5
		end)
	end)()
end

local var1 = "ui/AtelierCommonUI_atlas"

function var0.UpdateActivityDrop(arg0, arg1, arg2, arg3)
	updateDrop(arg1, arg2)
	SetCompomentEnabled(arg1:Find("icon_bg"), typeof(Image), false)
	setActive(arg1:Find("bg"), false)
	setActive(arg1:Find("icon_bg/frame"), false)
	setActive(arg1:Find("icon_bg/stars"), false)

	local var0 = arg2:getConfig("rarity")

	if arg2.type == DROP_TYPE_EQUIP or arg2.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0 = var0 - 1
	end

	local var1 = "icon_frame_" .. var0

	if arg3 then
		var1 = var1 .. "_small"
	end

	arg0.loader:GetSpriteQuiet(var1, var1, arg1)
end

function var0.willExit(arg0)
	arg0.loader:Clear()
end

return var0
