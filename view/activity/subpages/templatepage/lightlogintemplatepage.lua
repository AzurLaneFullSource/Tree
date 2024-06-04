local var0 = class("LightLoginTemplatePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.bar = arg0:findTF("bar", arg0.bg)
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
		if arg0 == UIItemList.EventInit then
			local var0 = arg0:findTF("item", arg2)
			local var1 = Drop.Create(arg0.config.front_drops[arg1 + 1])

			updateDrop(var0, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("ui/share/light_login_atlas", "DAY" .. arg1 + 1, arg0:findTF("day", arg2), true)
		elseif arg0 == UIItemList.EventUpdate then
			local var2 = arg1 < arg0.nday

			setActive(arg0:findTF("got", arg2), var2)
			setActive(arg0:findTF("get", arg2), var2)
			setActive(arg0:findTF("bg", arg2), not var2)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data1

	arg0.itemList:align(arg0.Day)
	setFillAmount(arg0.bar, arg0.nday / arg0.Day)
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)
	removeAllChildren(arg0.items)
end

return var0
