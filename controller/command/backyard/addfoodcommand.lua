local var0 = class("AddFoodCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = Item.getConfigData(var1)
	local var4 = getProxy(DormProxy)
	local var5 = var4:getData()
	local var6 = var5:getConfig("capacity") + var5.dorm_food_max

	if var6 < var5.food + var3.usage_arg[1] * var2 then
		var5.food = var6
	else
		var5.food = var5.food + var3.usage_arg[1] * var2
	end

	if var5.next_timestamp == 0 then
		var5:restNextTime()
	end

	var4:updateDrom(var5, BackYardConst.DORM_UPDATE_TYPE_USEFOOD)
	arg0:sendNotification(GAME.ADD_FOOD_DONE, {
		id = var1
	})
end

return var0
