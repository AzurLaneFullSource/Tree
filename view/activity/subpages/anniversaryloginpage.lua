local var0_0 = class("AnniversaryLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("mask/items", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnUpdateFlush(arg0_2)
	var0_0.super.OnUpdateFlush(arg0_2)
	eachChild(arg0_2.items, function(arg0_3)
		local var0_3 = arg0_2:findTF("day/Text", arg0_3)

		setText(var0_3, arg0_3:GetSiblingIndex() + 1)
	end)
end

return var0_0
