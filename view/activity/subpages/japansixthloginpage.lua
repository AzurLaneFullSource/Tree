local var0_0 = class("JapanSixthLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	setActive(arg0_1.item, false)
	arg0_1.itemList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg0_1:findTF("item", arg2_2)
			local var1_2 = arg0_1.config.front_drops[arg1_2 + 1]
			local var2_2 = {
				type = var1_2[1],
				id = var1_2[2],
				count = var1_2[3]
			}

			updateDrop(var0_2, var2_2)
			onButton(arg0_1, arg2_2, function()
				arg0_1:emit(BaseUI.ON_DROP, var2_2)
			end, SFX_PANEL)

			local var3_2 = arg0_1:findTF("got", arg2_2)

			setActive(var3_2, arg1_2 < arg0_1.nday)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)
	setText(arg0_4.bg:Find("Text"), arg0_4.nday .. "/" .. arg0_4.Day)
end

return var0_0
