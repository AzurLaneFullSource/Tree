local var0_0 = class("JiuJiuExpeditionCollectionMediator", import("...base.ContextMediator"))

var0_0.ON_GET = "JiuJiuExpeditionCollectionMediator:ON_GET"

local var1_0 = 691

function var0_0.register(arg0_1)
	if PLATFORM_CODE == PLATFORM_JP then
		arg0_1:bind(var0_0.ON_GET, function(arg0_2, arg1_2)
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 4,
				activity_id = var1_0
			})
		end)
	end

	local var0_1, var1_1, var2_1, var3_1 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

	arg0_1.viewComponent:SetData(var0_1, var1_1, var2_1, var3_1)
end

function var0_0.GetCollectionData()
	local var0_3 = 1
	local var1_3 = pg.activity_event_adventure[var0_3]
	local var2_3 = var1_3.boss_list
	local var3_3 = {}
	local var4_3 = getProxy(ActivityProxy):getActivityById(var1_0)
	local var5_3 = var4_3.data1
	local var6_3 = var4_3.data1_list
	local var7_3 = var4_3:getConfig("config_data")

	if var5_3 == 0 then
		var5_3 = #var7_3 + 1
	end

	for iter0_3 = 1, #var7_3 do
		local var8_3 = pg.activity_event_chequer[var7_3[iter0_3]].list_boss

		if iter0_3 < var5_3 then
			for iter1_3 = 1, #var8_3 do
				table.insert(var3_3, var8_3[iter1_3])
			end
		elseif iter0_3 == var5_3 and var6_3 and #var6_3 > 0 then
			for iter2_3 = 1, #var6_3 do
				local var9_3 = var6_3[iter2_3]

				if bit.band(var9_3, ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 and bit.band(var9_3, ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
					local var10_3 = bit.rshift(var9_3, 4)

					table.insert(var3_3, var10_3)
				end
			end
		end
	end

	local var11_3 = 0

	for iter3_3 = 1, #var1_3.boss_list do
		local var12_3 = var1_3.boss_list[iter3_3]
		local var13_3 = 0

		for iter4_3 = 1, #var12_3 do
			if table.contains(var3_3, var12_3[iter4_3]) then
				var13_3 = var13_3 + 1
			end
		end

		if var13_3 == #var12_3 then
			var11_3 = var11_3 + 1
		end
	end

	local var14_3 = var4_3.data2_list[1] or var11_3

	return var2_3, var3_3, var11_3, var14_3
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_UPDATED and var1_5.id == var1_0 then
		local var2_5, var3_5, var4_5, var5_5 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

		arg0_5.viewComponent:SetData(var2_5, var3_5, var4_5, var5_5)
		arg0_5.viewComponent:updateBooks()
		arg0_5.viewComponent:UpdateTip()
		arg0_5.viewComponent:OpenBook(var5_5 + 1)
	end
end

return var0_0
