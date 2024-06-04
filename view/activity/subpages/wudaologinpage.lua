local var0 = class("WudaoLoginPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.labelDay = arg0:findTF("days")
	arg0.items = arg0:findTF("items")
	arg0.item = arg0:findTF("item")
end

function var0.OnDataSetting(arg0)
	arg0.config = pg.activity_7_day_sign[arg0.activity:getConfig("config_id")]
end

function var0.OnFirstFlush(arg0)
	setActive(arg0.item, false)

	for iter0 = 1, 8 do
		local var0 = cloneTplTo(arg0.item, arg0.items:Find("layout"))
		local var1 = arg0:findTF("item", var0)
		local var2 = arg0.config.front_drops[iter0]
		local var3 = {
			type = var2[1],
			id = var2[2],
			count = var2[3]
		}

		updateDrop(var1, var3)
		onButton(arg0, var0, function()
			arg0:emit(BaseUI.ON_DROP, var3)
		end, SFX_PANEL)
	end
end

function var0.OnUpdateFlush(arg0)
	for iter0 = 1, 8 do
		local var0 = arg0.items:Find("layout"):GetChild(iter0 - 1)
		local var1 = iter0 <= arg0.activity.data1

		GetImageSpriteFromAtlasAsync("ui/activityuipage/wudaologinpage_atlas", string.format("number%d", iter0), arg0:findTF("day", var0), true)
		setActive(arg0:findTF("got", var0), var1)
	end
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)
	removeAllChildren(arg0.items)
end

return var0
