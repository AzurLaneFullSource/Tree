local var0 = class("AnniversaryUSFiveLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0.OnFirstFlush(arg0)
	setActive(arg0.item, false)
	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("item", arg2)
			local var1 = arg0.config.front_drops[arg1 + 1]
			local var2 = {
				type = var1[1],
				id = var1[2],
				count = var1[3]
			}

			updateDrop(var0, var2)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var2)
			end, SFX_PANEL)

			local var3 = arg0:findTF("got", arg2)

			setActive(var3, arg1 < arg0.nday)

			local var4 = arg0:findTF("day/Text", arg2)

			if not IsNil(var4) then
				setText(var4, arg1 < arg0.nday and i18n("word_status_inEventFinished") or i18n("which_day_2", arg1 + 1))
			end
		end
	end)
end

return var0
