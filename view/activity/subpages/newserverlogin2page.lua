local var0_0 = class("NewServerLogin2Page", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("scrollrect/items", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = pg.activity_7_day_sign[arg0_2.activity:getConfig("config_id")]
	arg0_2.Day = #arg0_2.config.front_drops
end

function var0_0.OnFirstFlush(arg0_3)
	setActive(arg0_3.item, false)
	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			local var0_4 = arg0_3:findTF("item", arg2_4)
			local var1_4 = arg0_3.config.front_drops[arg1_4 + 1]
			local var2_4 = {
				type = var1_4[1],
				id = var1_4[2],
				count = var1_4[3]
			}

			updateDrop(var0_4, var2_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var2_4)
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("ui/activityuipage/newserverlogin2page_atlas", arg1_4 + 1, arg0_3:findTF("day", arg2_4), true)
		elseif arg0_4 == UIItemList.EventUpdate then
			local var3_4 = arg0_3:findTF("got", arg2_4)

			setActive(var3_4, arg1_4 < arg0_3.nday)
		end
	end)
	onButton(arg0_3, arg0_3:findTF("go_btn", arg0_3.bg), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7.nday = arg0_7.activity.data1

	arg0_7.itemList:align(arg0_7.Day)
	setLocalPosition(arg0_7.items, Vector2(-185 - 106 * (arg0_7.nday - 1), 0))
end

function var0_0.OnDestroy(arg0_8)
	clearImageSprite(arg0_8.bg)
	removeAllChildren(arg0_8.items)
end

return var0_0
