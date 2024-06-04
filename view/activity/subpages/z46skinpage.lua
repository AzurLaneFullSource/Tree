local var0 = class("Z46SkinPage", import(".TemplatePage.LoginTemplatePage"))

function var0.OnFirstFlush(arg0)
	setActive(arg0.item, false)
	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("item", arg2)
			local var1 = Drop.Create(arg0.config.front_drops[arg1 + 1])

			updateDrop(var0, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)

			local var2 = arg0:findTF("got", arg2)

			setActive(var2, arg1 < arg0.nday)
		end
	end)
end

return var0
