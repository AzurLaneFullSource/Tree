local var0_0 = class("PSSHei5Page", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.item = arg0_1.items:Find("item")
	arg0_1.btn = arg0_1.bg:Find("btn")
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.red = arg0_1.bg:Find("btn/red")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.config_client = arg0_2.activity:getConfig("config_client")[1]
	arg0_2.taskProxy = getProxy(TaskProxy)

	setActive(arg0_2.item, false)
	onButton(arg0_2, arg0_2.btn, function()
		arg0_2:emit(ActivityMediator.OPEN_LAYER, Context.New({
			mediator = PSSHei5Mediator,
			viewComponent = PSSHei5Scene
		}))
	end, SOUND_BACK)
	SetActive(arg0_2.red, #arg0_2.activity:GetHei5UnreceiveAward() > 0)
end

function var0_0.OnUpdateFlush(arg0_4)
	arg0_4.itemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			local var0_5 = arg2_5:Find("item")
			local var1_5 = Drop.Create({
				arg0_4.config_client[arg1_5 + 1][1],
				arg0_4.config_client[arg1_5 + 1][2],
				arg0_4.config_client[arg1_5 + 1][3]
			})

			updateDrop(var0_5, var1_5)
			onButton(arg0_4, arg2_5, function()
				arg0_4:emit(BaseUI.ON_DROP, var1_5)
			end, SFX_PANEL)
		end
	end)
	arg0_4.itemList:align(#arg0_4.config_client)
end

return var0_0
