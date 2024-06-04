local var0 = class("XimuLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.items2 = arg0:findTF("items2", arg0.bg)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	removeAllChildren(arg0.items2)
	eachChild(arg0.items, function(arg0)
		local var0 = arg0:findTF("day/Text", arg0)

		setText(var0, setColorStr(getText(var0), arg0:GetSiblingIndex() < arg0.nday and COLOR_GREY or COLOR_WHITE))
	end)

	for iter0 = arg0.Day, 4, -1 do
		local var0 = arg0.items:GetChild(iter0 - 1)

		setParent(var0, arg0.items2, false)
		var0:SetAsFirstSibling()
	end
end

return var0
