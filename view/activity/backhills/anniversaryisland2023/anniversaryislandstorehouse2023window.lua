local var0_0 = class("AnniversaryIslandStoreHouse2023Window", import("view.base.BaseUI"))

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.loader = AutoLoader.New()
end

function var0_0.getUIName(arg0_2)
	return "AnniversaryIslandStoreHouse2023Window"
end

local var1_0 = "ui/AtelierCommonUI_atlas"

function var0_0.preload(arg0_3, arg1_3)
	table.ParallelIpairsAsync({
		var1_0
	}, function(arg0_4, arg1_4, arg2_4)
		arg0_3.loader:LoadBundle(arg1_4, arg2_4)
	end, arg1_3)
end

function var0_0.init(arg0_5)
	arg0_5.storehouseRect = arg0_5._tf:Find("Window/ScrollView"):GetComponent("LScrollRect")

	setActive(arg0_5._tf:Find("Window/ScrollView/Item"), false)
end

function var0_0.SetActivity(arg0_6, arg1_6)
	arg0_6.items = arg1_6:GetAllVitems()
	arg0_6.itemList = {}

	table.Foreach(arg0_6.items, function(arg0_7, arg1_7)
		if arg1_7 <= 0 then
			return
		end

		table.insert(arg0_6.itemList, WorkBenchItem.New({
			configId = arg0_7,
			count = arg1_7
		}))
	end)
	table.sort(arg0_6.itemList, function(arg0_8, arg1_8)
		return arg0_8:GetConfigID() < arg1_8:GetConfigID()
	end)
end

function var0_0.didEnter(arg0_9)
	function arg0_9.storehouseRect.onUpdateItem(arg0_10, arg1_10)
		arg0_10 = arg0_10 + 1

		local var0_10 = tf(arg1_10)
		local var1_10 = arg0_9.itemList[arg0_10]

		arg0_9:UpdateItem(var0_10:Find("IconBG"), var1_10)
		setScrollText(var0_10:Find("NameBG/Rect/Name"), var1_10:GetName())
		onButton(arg0_9, var0_10, function()
			arg0_9:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, var1_10)
		end, SFX_PANEL)
	end

	onButton(arg0_9, arg0_9._tf:Find("Window/Close"), function()
		arg0_9:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9._tf:Find("BG"), function()
		arg0_9:onBackPressed()
	end)
	arg0_9:UpdateView()
end

function var0_0.UpdateView(arg0_14)
	local var0_14 = arg0_14.itemList

	setActive(arg0_14._tf:Find("Window/Empty"), #var0_14 == 0)
	setActive(arg0_14._tf:Find("Window/ScrollView"), #var0_14 > 0)
	arg0_14.storehouseRect:SetTotalCount(#var0_14)
end

function var0_0.UpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = "icon_frame_" .. arg2_15:GetRarity()

	arg0_15.loader:GetSpriteQuiet(var1_0, var0_15, arg1_15)
	arg0_15.loader:GetSpriteQuiet(arg2_15:GetIconPath(), "", arg1_15:Find("Icon"))

	if not IsNil(arg1_15:Find("Text")) then
		setText(arg1_15:Find("Text"), arg2_15.count)
	end
end

function var0_0.willExit(arg0_16)
	arg0_16.loader:Clear()
end

return var0_0
