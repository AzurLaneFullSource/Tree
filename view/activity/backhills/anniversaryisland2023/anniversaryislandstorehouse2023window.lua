local var0_0 = class("AnniversaryIslandStoreHouse2023Window", import("view.base.BaseUI"))

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.loader = AutoLoader.New()
end

function var0_0.getUIName(arg0_2)
	return "AnniversaryIslandStoreHouse2023Window"
end

local var1_0 = "ui/AtelierCommonUI_atlas"

function var0_0.getResource(arg0_3)
	local var0_3 = var0_0.super.getResource(arg0_3)

	table.insert(var0_3, var1_0)

	return var0_3
end

function var0_0.preload(arg0_4, arg1_4)
	table.ParallelIpairsAsync({
		var1_0
	}, function(arg0_5, arg1_5, arg2_5)
		arg0_4.loader:LoadBundle(arg1_5, arg2_5)
	end, arg1_4)
end

function var0_0.init(arg0_6)
	arg0_6.storehouseRect = arg0_6._tf:Find("Window/ScrollView"):GetComponent("LScrollRect")

	setActive(arg0_6._tf:Find("Window/ScrollView/Item"), false)
end

function var0_0.SetActivity(arg0_7, arg1_7)
	arg0_7.items = arg1_7:GetAllVitems()
	arg0_7.itemList = {}

	table.Foreach(arg0_7.items, function(arg0_8, arg1_8)
		if arg1_8 <= 0 then
			return
		end

		table.insert(arg0_7.itemList, WorkBenchItem.New({
			configId = arg0_8,
			count = arg1_8
		}))
	end)
	table.sort(arg0_7.itemList, function(arg0_9, arg1_9)
		return arg0_9:GetConfigID() < arg1_9:GetConfigID()
	end)
end

function var0_0.didEnter(arg0_10)
	function arg0_10.storehouseRect.onUpdateItem(arg0_11, arg1_11)
		arg0_11 = arg0_11 + 1

		local var0_11 = tf(arg1_11)
		local var1_11 = arg0_10.itemList[arg0_11]

		arg0_10:UpdateItem(var0_11:Find("IconBG"), var1_11)
		setScrollText(var0_11:Find("NameBG/Rect/Name"), var1_11:GetName())
		onButton(arg0_10, var0_11, function()
			arg0_10:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, var1_11)
		end, SFX_PANEL)
	end

	onButton(arg0_10, arg0_10._tf:Find("Window/Close"), function()
		arg0_10:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10._tf:Find("BG"), function()
		arg0_10:onBackPressed()
	end)
	arg0_10:UpdateView()
end

function var0_0.UpdateView(arg0_15)
	local var0_15 = arg0_15.itemList

	setActive(arg0_15._tf:Find("Window/Empty"), #var0_15 == 0)
	setActive(arg0_15._tf:Find("Window/ScrollView"), #var0_15 > 0)
	arg0_15.storehouseRect:SetTotalCount(#var0_15)
end

function var0_0.UpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = "icon_frame_" .. arg2_16:GetRarity()

	arg0_16.loader:GetSpriteQuiet(var1_0, var0_16, arg1_16)
	arg0_16.loader:GetSpriteQuiet(arg2_16:GetIconPath(), "", arg1_16:Find("Icon"))

	if not IsNil(arg1_16:Find("Text")) then
		setText(arg1_16:Find("Text"), arg2_16.count)
	end
end

function var0_0.willExit(arg0_17)
	arg0_17.loader:Clear()
end

return var0_0
