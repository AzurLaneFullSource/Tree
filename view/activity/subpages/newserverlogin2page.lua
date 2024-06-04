local var0 = class("NewServerLogin2Page", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("scrollrect/items", arg0.bg)
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
			GetImageSpriteFromAtlasAsync("ui/activityuipage/newserverlogin2page_atlas", arg1 + 1, arg0:findTF("day", arg2), true)
		elseif arg0 == UIItemList.EventUpdate then
			local var3 = arg0:findTF("got", arg2)

			setActive(var3, arg1 < arg0.nday)
		end
	end)
	onButton(arg0, arg0:findTF("go_btn", arg0.bg), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data1

	arg0.itemList:align(arg0.Day)
	setLocalPosition(arg0.items, Vector2(-185 - 106 * (arg0.nday - 1), 0))
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)
	removeAllChildren(arg0.items)
end

return var0
