local var0_0 = class("FourthAnniversarySignPageKR", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("mask/items", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.initItems = {}
end

function var0_0.OnFirstFlush(arg0_2)
	setActive(arg0_2.item, false)
	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			if not table.contains(arg0_2.initItems, arg1_3) then
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
				table.insert(arg0_2.initItems, arg1_3)
			end

			local var3_3 = arg0_2:findTF("got", arg2_3)

			setActive(var3_3, arg1_3 < arg0_2.nday)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)
	eachChild(arg0_5.items, function(arg0_6)
		return
	end)
end

return var0_0
