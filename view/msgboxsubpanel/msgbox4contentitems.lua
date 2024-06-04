local var0 = class("Msgbox4ContentItems", import(".MsgboxSubPanel"))

function var0.getUIName(arg0)
	return "Msgbox4ContentItems"
end

function var0.OnRefresh(arg0, arg1)
	rtf(arg0.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	setText(arg0._tf:Find("content"), arg1.content)

	local var0 = arg0._tf:Find("list")
	local var1 = UIItemList.New(var0, var0:GetChild(0))

	var1:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			updateDrop(arg2, arg1.items[arg1])
			setActive(arg2:Find("name"), false)
			setActive(arg2:Find("name_mask"), false)
			setScrollText(arg2:Find("name_mask/name"), getText(arg2:Find("name")))
		end
	end)
	var1:align(#arg1.items)
end

return var0
