local var0 = class("Match3Page", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.goBtn = arg0:findTF("go", arg0.bg)
	arg0.itemList = UIItemList.New(arg0.items, arg0.item)
end

function var0.OnDataSetting(arg0)
	arg0.drop = arg0.activity:getConfig("config_client").drop
	arg0.id = arg0.activity:getConfig("config_client").gameId
	arg0.day = #arg0.drop
end

function var0.OnFirstFlush(arg0)
	setActive(arg0.item, false)

	local var0 = getProxy(MiniGameProxy):GetHubByHubId(arg0.activity:getConfig("config_id"))

	setActive(arg0.item, false)
	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg0:findTF("item", arg2)
			local var1 = arg0.drop[arg1 + 1]
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
			local var4 = arg0:findTF("mask", arg2)

			setActive(var3, arg1 < var0.usedtime)
			setActive(var4, arg1 >= var0.usedtime + var0.count)
		end
	end)
	arg0.itemList:align(arg0.day)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg0.id)
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0.itemList:align(arg0.day)
end

function var0.OnDestroy(arg0)
	return
end

return var0
