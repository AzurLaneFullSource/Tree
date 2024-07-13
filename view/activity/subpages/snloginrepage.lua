local var0_0 = class("SNLoginRePage", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.bar = arg0_1:findTF("bar", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	setActive(arg0_2.item, false)
	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventInit then
			local var0_3 = arg0_2:findTF("item", arg2_3)
			local var1_3 = arg0_2.config.front_drops[arg1_3 + 1]
			local var2_3 = {
				type = var1_3[1],
				id = var1_3[2],
				count = var1_3[3]
			}

			updateDrop(var0_3, var2_3)
			onButton(arg0_2, arg2_3, function()
				arg0_2:emit(BaseUI.ON_DROP, var2_3)
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("ui/activityuipage/snloginrepage_atlas", "DAY" .. arg1_3 + 1, arg0_2:findTF("day", arg2_3), true)
		elseif arg0_3 == UIItemList.EventUpdate then
			local var3_3 = arg1_3 < arg0_2.nday

			setActive(arg0_2:findTF("got", arg2_3), var3_3)
			setActive(arg0_2:findTF("get", arg2_3), var3_3)
			setActive(arg0_2:findTF("bg", arg2_3), not var3_3)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)
	setFillAmount(arg0_5.bar, arg0_5.nday / arg0_5.Day)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
