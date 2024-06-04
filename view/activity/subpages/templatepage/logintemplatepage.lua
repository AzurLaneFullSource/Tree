local var0 = class("LoginTemplatePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.itemList = UIItemList.New(arg0.items, arg0.item)
end

function var0.OnDataSetting(arg0)
	arg0.config = pg.activity_7_day_sign[arg0.activity:getConfig("config_id")]
	arg0.Day = #arg0.config.front_drops
end

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

			local var3 = arg0:findTF("day/Text", arg2)

			setText(var3, arg1 < arg0.nday and i18n("word_status_inEventFinished") or i18n("which_day_2", arg1 + 1))
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data1

	arg0.itemList:align(arg0.Day)
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)
	removeAllChildren(arg0.items)
end

return var0
