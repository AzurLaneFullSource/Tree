local var0_0 = class("Match3Page", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.goBtn = arg0_1:findTF("go", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.drop = arg0_2.activity:getConfig("config_client").drop
	arg0_2.id = arg0_2.activity:getConfig("config_client").gameId
	arg0_2.day = #arg0_2.drop
end

function var0_0.OnFirstFlush(arg0_3)
	setActive(arg0_3.item, false)

	local var0_3 = getProxy(MiniGameProxy):GetHubByHubId(arg0_3.activity:getConfig("config_id"))

	setActive(arg0_3.item, false)
	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			local var0_4 = arg0_3:findTF("item", arg2_4)
			local var1_4 = arg0_3.drop[arg1_4 + 1]
			local var2_4 = {
				type = var1_4[1],
				id = var1_4[2],
				count = var1_4[3]
			}

			updateDrop(var0_4, var2_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var2_4)
			end, SFX_PANEL)
		elseif arg0_4 == UIItemList.EventUpdate then
			local var3_4 = arg0_3:findTF("got", arg2_4)
			local var4_4 = arg0_3:findTF("mask", arg2_4)

			setActive(var3_4, arg1_4 < var0_3.usedtime)
			setActive(var4_4, arg1_4 >= var0_3.usedtime + var0_3.count)
		end
	end)
	arg0_3.itemList:align(arg0_3.day)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg0_3.id)
	end)
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7.itemList:align(arg0_7.day)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
