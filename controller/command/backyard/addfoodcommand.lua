local var0_0 = class("AddFoodCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = Item.getConfigData(var1_1)
	local var4_1 = getProxy(DormProxy)
	local var5_1 = var4_1:getData()
	local var6_1 = var5_1:getConfig("capacity") + var5_1.dorm_food_max

	if var6_1 < var5_1.food + var3_1.usage_arg[1] * var2_1 then
		var5_1.food = var6_1
	else
		var5_1.food = var5_1.food + var3_1.usage_arg[1] * var2_1
	end

	if var5_1.next_timestamp == 0 then
		var5_1:restNextTime()
	end

	var4_1:updateDrom(var5_1, BackYardConst.DORM_UPDATE_TYPE_USEFOOD)
	arg0_1:sendNotification(GAME.ADD_FOOD_DONE, {
		id = var1_1
	})
end

return var0_0
