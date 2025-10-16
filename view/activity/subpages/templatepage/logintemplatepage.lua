local var0_0 = class("LoginTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = pg.activity_7_day_sign[arg0_2.activity:getConfig("config_id")]
	arg0_2.Day = #arg0_2.config.front_drops
end

function var0_0.OnFirstFlush(arg0_3)
	setActive(arg0_3.item, false)
	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg2_4:Find("item")
			local var1_4 = Drop.Create(arg0_3.config.front_drops[arg1_4 + 1])

			updateDrop(var0_4, var1_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var1_4)
			end, SFX_PANEL)

			local var2_4 = arg2_4:Find("got")

			setActive(var2_4, arg1_4 < arg0_3.nday)

			local var3_4 = arg2_4:Find("day/Text")

			setText(var3_4, arg1_4 < arg0_3.nday and i18n("word_status_inEventFinished") or i18n("which_day_2", arg1_4 + 1))
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6.nday = arg0_6.activity.data1

	arg0_6.itemList:align(arg0_6.Day)
end

function var0_0.OnDestroy(arg0_7)
	clearImageSprite(arg0_7.bg)
	removeAllChildren(arg0_7.items)
end

return var0_0
