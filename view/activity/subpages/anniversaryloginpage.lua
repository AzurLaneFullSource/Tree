local var0 = class("AnniversaryLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("mask/items", arg0.bg)
	arg0.itemList = UIItemList.New(arg0.items, arg0.item)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	eachChild(arg0.items, function(arg0)
		local var0 = arg0:findTF("day/Text", arg0)

		setText(var0, arg0:GetSiblingIndex() + 1)
	end)
end

return var0
