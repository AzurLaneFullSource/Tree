local var0_0 = class("AnniversaryNineLoginPage", import("view.activity.CorePage.templatePage.CoreLoginSignTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.itemGroup = arg0_1.bg:Find("bg_item")
	arg0_1.item = arg0_1.itemGroup:Find("item")
	arg0_1.items = arg0_1.itemGroup:Find("items")
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnMore = arg0_1.bg:Find("btn_more")
end

function var0_0.OnFirstFlush(arg0_2)
	setActive(arg0_2.item, false)
	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg2_3:Find("item")
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

			local var3_3 = arg2_3:Find("got")

			setActive(var3_3, arg1_3 < arg0_2.nday)
		end
	end)
	onButton(arg0_2, arg0_2.btnMore, function()
		Application.OpenURL(arg0_2.activity:getConfig("config_client")[1])
	end, SFX_CONFIRM)
end

function var0_0.OnUpdateFlush(arg0_6)
	var0_0.super.OnUpdateFlush(arg0_6)
	setText(arg0_6.itemGroup:Find("Text"), arg0_6.nday .. "/" .. arg0_6.Day)
end

return var0_0
