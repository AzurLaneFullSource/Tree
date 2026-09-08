local var0_0 = class("ShiningMagicJPLoginPage", import("view.activity.CorePage.templatePage.CoreLoginSignTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.itemGroup = arg0_1.bg:Find("bg_item")
	arg0_1.item = arg0_1.itemGroup:Find("item")
	arg0_1.items = arg0_1.itemGroup:Find("items")
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnClick = arg0_1.bg:Find("btn_get")
	arg0_1.red = arg0_1.btnClick:Find("red")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.nday = arg0_2.activity.data1

	setActive(arg0_2.item, false)
	onButton(arg0_2, arg0_2.btnClick, function()
		if arg0_2.activity:readyToAchieve() == false then
			return
		end

		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.activity.id
		})
	end, SFX_CONFIRM)
	arg0_2.itemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg2_4:Find("item")
			local var1_4 = arg0_2.config.front_drops[arg1_4 + 1]
			local var2_4 = {
				type = var1_4[1],
				id = var1_4[2],
				count = var1_4[3]
			}

			updateDrop(var0_4, var2_4)
			onButton(arg0_2, arg2_4, function()
				arg0_2:emit(BaseUI.ON_DROP, var2_4)
			end, SFX_PANEL)

			local var3_4 = arg2_4:Find("got")

			setActive(var3_4, arg1_4 < arg0_2.nday)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6.nday = arg0_6.activity.data1

	local var0_6 = arg0_6.activity:readyToAchieve()

	setActive(arg0_6.red, var0_6)
	setGray(arg0_6.btnClick, not var0_6)
	setText(arg0_6.itemGroup:Find("Text"), arg0_6.nday .. "/" .. arg0_6.Day)
	arg0_6.itemList:align(arg0_6.Day)
end

return var0_0
