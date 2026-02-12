local var0_0 = class("SpringFestival2026FuboLoginPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.item = arg0_1.bg:GetChild(0)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = pg.activity_7_day_sign[arg0_2.activity:getConfig("config_id")]
	arg0_2.Day = #arg0_2.config.front_drops
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg2_4:Find("container/item")
			local var1_4 = arg0_3.config.front_drops[arg1_4 + 1]
			local var2_4 = Drop.Create(var1_4)

			updateDrop(var0_4, var2_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var2_4)
			end, SFX_PANEL)

			local var3_4 = arg2_4:Find("got")

			arg2_4:Find("container"):GetComponent(typeof(CanvasGroup)).alpha = arg1_4 < arg0_3.nday and 0.5 or 1

			setActive(var3_4, arg1_4 < arg0_3.nday)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6.nday = arg0_6.activity.data1

	arg0_6.itemList:align(arg0_6.Day)
end

return var0_0
