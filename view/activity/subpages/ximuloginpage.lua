local var0_0 = class("XimuLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.items2 = arg0_1:findTF("items2", arg0_1.bg)
end

function var0_0.OnUpdateFlush(arg0_2)
	var0_0.super.OnUpdateFlush(arg0_2)
	removeAllChildren(arg0_2.items2)
	eachChild(arg0_2.items, function(arg0_3)
		local var0_3 = arg0_2:findTF("day/Text", arg0_3)

		setText(var0_3, setColorStr(getText(var0_3), arg0_3:GetSiblingIndex() < arg0_2.nday and COLOR_GREY or COLOR_WHITE))
	end)

	for iter0_2 = arg0_2.Day, 4, -1 do
		local var0_2 = arg0_2.items:GetChild(iter0_2 - 1)

		setParent(var0_2, arg0_2.items2, false)
		var0_2:SetAsFirstSibling()
	end
end

return var0_0
