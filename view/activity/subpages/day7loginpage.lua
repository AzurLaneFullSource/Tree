local var0_0 = class("Day7LoginPage", import("...base.BaseActivityPage"))

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/activityuipage/day7_login_atlas"
	}

	table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))

	return var0_1
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.labelDay = arg0_2._tf:Find("days")
	arg0_2.items = arg0_2._tf:Find("items")
	arg0_2.item = arg0_2._tf:Find("item")
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.config = pg.activity_7_day_sign[arg0_3.activity:getConfig("config_id")]
end

function var0_0.OnFirstFlush(arg0_4)
	setActive(arg0_4.item, false)

	for iter0_4 = 1, 7 do
		local var0_4 = cloneTplTo(arg0_4.item, arg0_4.items)
		local var1_4 = var0_4:Find("item")
		local var2_4 = Drop.Create(arg0_4.config.front_drops[iter0_4])

		updateDrop(var1_4, var2_4)
		onButton(arg0_4, var0_4, function()
			arg0_4:emit(BaseUI.ON_DROP, var2_4)
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateFlush(arg0_6)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/day7_login_atlas", string.format("0%d", math.max(arg0_6.activity.data1, 1)), arg0_6.labelDay, true)

	for iter0_6 = 1, 7 do
		local var0_6 = arg0_6.items:GetChild(iter0_6 - 1)
		local var1_6 = iter0_6 <= arg0_6.activity.data1

		GetImageSpriteFromAtlasAsync("ui/activityuipage/day7_login_atlas", string.format("day%d", iter0_6) .. (var1_6 and "_sel" or ""), var0_6:Find("day"), true)
		setActive(var0_6:Find("got"), var1_6)
	end
end

function var0_0.OnDestroy(arg0_7)
	clearImageSprite(arg0_7.bg)
	removeAllChildren(arg0_7.items)
end

return var0_0
