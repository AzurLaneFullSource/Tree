local var0_0 = class("Z46SkinPage", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	setActive(arg0_1.item, false)
	arg0_1.itemList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg0_1:findTF("item", arg2_2)
			local var1_2 = Drop.Create(arg0_1.config.front_drops[arg1_2 + 1])

			updateDrop(var0_2, var1_2)
			onButton(arg0_1, arg2_2, function()
				arg0_1:emit(BaseUI.ON_DROP, var1_2)
			end, SFX_PANEL)

			local var2_2 = arg0_1:findTF("got", arg2_2)

			setActive(var2_2, arg1_2 < arg0_1.nday)
		end
	end)
end

return var0_0
