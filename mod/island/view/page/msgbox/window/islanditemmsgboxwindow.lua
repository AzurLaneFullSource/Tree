local var0_0 = class("IslandItemMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxWithItems"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.uiItemList = UIItemList.New(arg0_2._tf:Find("items"), arg0_2._tf:Find("items/tpl"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)
	arg0_3:FlushItems(arg0_3.settings)
end

function var0_0.FlushItems(arg0_4, arg1_4)
	local var0_4 = arg1_4.drops

	assert(var0_4)
	arg0_4.uiItemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = var0_4[arg1_5 + 1]

			updateCustomDrop(arg2_5, var0_5)
		end
	end)
	arg0_4.uiItemList:align(#var0_4)
end

return var0_0
