local var0_0 = class("Msgbox4ContentItems", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "Msgbox4ContentItems"
end

function var0_0.OnRefresh(arg0_2, arg1_2)
	rtf(arg0_2.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	setText(arg0_2._tf:Find("content"), arg1_2.content)

	local var0_2 = arg0_2._tf:Find("list")
	local var1_2 = UIItemList.New(var0_2, var0_2:GetChild(0))

	var1_2:make(function(arg0_3, arg1_3, arg2_3)
		arg1_3 = arg1_3 + 1

		if arg0_3 == UIItemList.EventUpdate then
			updateDrop(arg2_3, arg1_2.items[arg1_3])
			setActive(arg2_3:Find("name"), false)
			setActive(arg2_3:Find("name_mask"), false)
			setScrollText(arg2_3:Find("name_mask/name"), getText(arg2_3:Find("name")))
		end
	end)
	var1_2:align(#arg1_2.items)
end

return var0_0
