local var0_0 = class("Day7LoginPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg")
	arg0_1.labelDay = arg0_1:findTF("days")
	arg0_1.items = arg0_1:findTF("items")
	arg0_1.item = arg0_1:findTF("item")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = pg.activity_7_day_sign[arg0_2.activity:getConfig("config_id")]
end

function var0_0.OnFirstFlush(arg0_3)
	setActive(arg0_3.item, false)

	for iter0_3 = 1, 7 do
		local var0_3 = cloneTplTo(arg0_3.item, arg0_3.items)
		local var1_3 = arg0_3:findTF("item", var0_3)
		local var2_3 = Drop.Create(arg0_3.config.front_drops[iter0_3])

		updateDrop(var1_3, var2_3)
		onButton(arg0_3, var0_3, function()
			arg0_3:emit(BaseUI.ON_DROP, var2_3)
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateFlush(arg0_5)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/day7_login_atlas", string.format("0%d", math.max(arg0_5.activity.data1, 1)), arg0_5.labelDay, true)

	for iter0_5 = 1, 7 do
		local var0_5 = arg0_5.items:GetChild(iter0_5 - 1)
		local var1_5 = iter0_5 <= arg0_5.activity.data1

		GetImageSpriteFromAtlasAsync("ui/activityuipage/day7_login_atlas", string.format("day%d", iter0_5) .. (var1_5 and "_sel" or ""), arg0_5:findTF("day", var0_5), true)
		setActive(arg0_5:findTF("got", var0_5), var1_5)
	end
end

function var0_0.OnDestroy(arg0_6)
	clearImageSprite(arg0_6.bg)
	removeAllChildren(arg0_6.items)
end

return var0_0
