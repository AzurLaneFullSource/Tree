local var0 = class("AnniversaryIslandStoreHouse2023Window", import("view.base.BaseUI"))

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)

	arg0.loader = AutoLoader.New()
end

function var0.getUIName(arg0)
	return "AnniversaryIslandStoreHouse2023Window"
end

local var1 = "ui/AtelierCommonUI_atlas"

function var0.preload(arg0, arg1)
	table.ParallelIpairsAsync({
		var1
	}, function(arg0, arg1, arg2)
		arg0.loader:LoadBundle(arg1, arg2)
	end, arg1)
end

function var0.init(arg0)
	arg0.storehouseRect = arg0._tf:Find("Window/ScrollView"):GetComponent("LScrollRect")

	setActive(arg0._tf:Find("Window/ScrollView/Item"), false)
end

function var0.SetActivity(arg0, arg1)
	arg0.items = arg1:GetAllVitems()
	arg0.itemList = {}

	table.Foreach(arg0.items, function(arg0, arg1)
		if arg1 <= 0 then
			return
		end

		table.insert(arg0.itemList, WorkBenchItem.New({
			configId = arg0,
			count = arg1
		}))
	end)
	table.sort(arg0.itemList, function(arg0, arg1)
		return arg0:GetConfigID() < arg1:GetConfigID()
	end)
end

function var0.didEnter(arg0)
	function arg0.storehouseRect.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		local var0 = tf(arg1)
		local var1 = arg0.itemList[arg0]

		arg0:UpdateItem(var0:Find("IconBG"), var1)
		setScrollText(var0:Find("NameBG/Rect/Name"), var1:GetName())
		onButton(arg0, var0, function()
			arg0:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, var1)
		end, SFX_PANEL)
	end

	onButton(arg0, arg0._tf:Find("Window/Close"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:onBackPressed()
	end)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = arg0.itemList

	setActive(arg0._tf:Find("Window/Empty"), #var0 == 0)
	setActive(arg0._tf:Find("Window/ScrollView"), #var0 > 0)
	arg0.storehouseRect:SetTotalCount(#var0)
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = "icon_frame_" .. arg2:GetRarity()

	arg0.loader:GetSpriteQuiet(var1, var0, arg1)
	arg0.loader:GetSpriteQuiet(arg2:GetIconPath(), "", arg1:Find("Icon"))

	if not IsNil(arg1:Find("Text")) then
		setText(arg1:Find("Text"), arg2.count)
	end
end

function var0.willExit(arg0)
	arg0.loader:Clear()
end

return var0
