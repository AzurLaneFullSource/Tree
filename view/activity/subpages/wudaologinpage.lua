local var0_0 = class("WudaoLoginPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.labelDay = arg0_1:findTF("days")
	arg0_1.items = arg0_1:findTF("items")
	arg0_1.item = arg0_1:findTF("item")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = pg.activity_7_day_sign[arg0_2.activity:getConfig("config_id")]
end

function var0_0.OnFirstFlush(arg0_3)
	setActive(arg0_3.item, false)

	for iter0_3 = 1, 8 do
		local var0_3 = cloneTplTo(arg0_3.item, arg0_3.items:Find("layout"))
		local var1_3 = arg0_3:findTF("item", var0_3)
		local var2_3 = arg0_3.config.front_drops[iter0_3]
		local var3_3 = {
			type = var2_3[1],
			id = var2_3[2],
			count = var2_3[3]
		}

		updateDrop(var1_3, var3_3)
		onButton(arg0_3, var0_3, function()
			arg0_3:emit(BaseUI.ON_DROP, var3_3)
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateFlush(arg0_5)
	for iter0_5 = 1, 8 do
		local var0_5 = arg0_5.items:Find("layout"):GetChild(iter0_5 - 1)
		local var1_5 = iter0_5 <= arg0_5.activity.data1

		GetImageSpriteFromAtlasAsync("ui/activityuipage/wudaologinpage_atlas", string.format("number%d", iter0_5), arg0_5:findTF("day", var0_5), true)
		setActive(arg0_5:findTF("got", var0_5), var1_5)
	end
end

function var0_0.OnDestroy(arg0_6)
	clearImageSprite(arg0_6.bg)
	removeAllChildren(arg0_6.items)
end

return var0_0
