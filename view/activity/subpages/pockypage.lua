local var0 = class("PockyPage", import(".TemplatePage.LoginTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.title = arg0:findTF("day", arg0.bg)
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
		elseif arg0 == UIItemList.EventUpdate then
			local var3 = arg0:findTF("got", arg2)

			setActive(var3, arg1 < arg0.nday)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data1

	setText(arg0.title, arg0.nday)
	arg0.itemList:align(arg0.Day)
end

return var0
