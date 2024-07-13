local var0_0 = class("AnniversaryFiveLoginPage", import(".TemplatePage.LoginTemplatePage"))

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
	setActive(arg0_1.bg:Find("btn_more"), PLATFORM_CODE == PLATFORM_CH and LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI and pg.TimeMgr.GetInstance():inTime(arg0_1.activity:getConfig("config_client")[2]))
	onButton(arg0_1, arg0_1.bg:Find("btn_more"), function()
		Application.OpenURL(arg0_1.activity:getConfig("config_client")[1])
	end, SFX_CONFIRM)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)
	setText(arg0_5.bg:Find("Text"), arg0_5.nday .. "/" .. arg0_5.Day)
end

return var0_0
