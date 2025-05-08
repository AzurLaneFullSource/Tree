local var0_0 = class("IslandUpgradeDisplayPage", import("...base.IslandBasePage"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "IslandUpgradeDisplayUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.panels = {
		[var1_0] = arg0_2:findTF("single"),
		[var2_0] = arg0_2:findTF("multi")
	}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.GetPanelType(arg0_5, arg1_5)
	if #arg1_5:GetUnlockBuildingList() > 0 then
		return var2_0
	else
		return var1_0
	end
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	local var0_6 = getProxy(IslandProxy):GetIsland()
	local var1_6 = arg0_6:GetPanelType(var0_6)

	arg0_6:InitPanel(var0_6, arg1_6, var1_6)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_6._tf, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.Hide(arg0_7)
	var0_0.super.Hide(arg0_7)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7._tf, arg0_7._parentTf)
end

function var0_0.InitPanel(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg0_8.panels[arg3_8]

	for iter0_8, iter1_8 in pairs(arg0_8.panels) do
		setActive(iter1_8, arg3_8 == iter0_8)
	end

	if var2_0 == arg3_8 then
		arg0_8:UpdateMultiPanel(arg1_8, arg2_8, var0_8)
	elseif var1_0 == arg3_8 then
		arg0_8:UpdateSinglePanel(arg1_8, arg2_8, var0_8)
	end
end

local function var3_0(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetLevel()

	setText(arg2_9:Find("prev"), "Lv.<size=50>" .. var0_9 - 1 .. "</size>")
	setText(arg2_9:Find("next"), "Lv.<size=50>" .. var0_9 .. "</size>")

	local var1_9 = UIItemList.New(arg2_9:Find("award/content"), arg2_9:Find("award/content/tpl"))

	var1_9:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg1_9[arg1_10 + 1]

			updateDrop(arg2_10, var0_10)
		end
	end)
	var1_9:align(#arg1_9)
end

function var0_0.UpdateMultiPanel(arg0_11, arg1_11, arg2_11, arg3_11)
	var3_0(arg1_11, arg2_11, arg3_11)

	local var0_11 = arg1_11:GetUnlockBuildingList()
	local var1_11 = UIItemList.New(arg3_11:Find("unlock/content"), arg3_11:Find("award/content/tpl"))

	var1_11:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var0_11[arg1_12 + 1]
			local var1_12 = Drop.Create(var0_12)

			updateDrop(arg2_12, var1_12)
		end
	end)
	var1_11:align(#var0_11)
end

function var0_0.UpdateSinglePanel(arg0_13, arg1_13, arg2_13, arg3_13)
	var3_0(arg1_13, arg2_13, arg3_13)
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0
