local var0 = class("JiuJiuExpeditionCollectionMediator", import("...base.ContextMediator"))

var0.ON_GET = "JiuJiuExpeditionCollectionMediator:ON_GET"

local var1 = 691

function var0.register(arg0)
	if PLATFORM_CODE == PLATFORM_JP then
		arg0:bind(var0.ON_GET, function(arg0, arg1)
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 4,
				activity_id = var1
			})
		end)
	end

	local var0, var1, var2, var3 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

	arg0.viewComponent:SetData(var0, var1, var2, var3)
end

function var0.GetCollectionData()
	local var0 = 1
	local var1 = pg.activity_event_adventure[var0]
	local var2 = var1.boss_list
	local var3 = {}
	local var4 = getProxy(ActivityProxy):getActivityById(var1)
	local var5 = var4.data1
	local var6 = var4.data1_list
	local var7 = var4:getConfig("config_data")

	if var5 == 0 then
		var5 = #var7 + 1
	end

	for iter0 = 1, #var7 do
		local var8 = pg.activity_event_chequer[var7[iter0]].list_boss

		if iter0 < var5 then
			for iter1 = 1, #var8 do
				table.insert(var3, var8[iter1])
			end
		elseif iter0 == var5 and var6 and #var6 > 0 then
			for iter2 = 1, #var6 do
				local var9 = var6[iter2]

				if bit.band(var9, ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 and bit.band(var9, ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
					local var10 = bit.rshift(var9, 4)

					table.insert(var3, var10)
				end
			end
		end
	end

	local var11 = 0

	for iter3 = 1, #var1.boss_list do
		local var12 = var1.boss_list[iter3]
		local var13 = 0

		for iter4 = 1, #var12 do
			if table.contains(var3, var12[iter4]) then
				var13 = var13 + 1
			end
		end

		if var13 == #var12 then
			var11 = var11 + 1
		end
	end

	local var14 = var4.data2_list[1] or var11

	return var2, var3, var11, var14
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED and var1.id == var1 then
		local var2, var3, var4, var5 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

		arg0.viewComponent:SetData(var2, var3, var4, var5)
		arg0.viewComponent:updateBooks()
		arg0.viewComponent:UpdateTip()
		arg0.viewComponent:OpenBook(var5 + 1)
	end
end

return var0
