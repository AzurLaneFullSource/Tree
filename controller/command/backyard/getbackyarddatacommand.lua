local var0_0 = class("GetBackYardDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.data
	local var2_1 = var0_1.isMine
	local var3_1

	if var2_1 then
		var3_1 = Dorm.New(var1_1)
	else
		var3_1 = FriendDorm.New(var1_1)
	end

	local var4_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_1.ship_id_list) do
		table.insert(var4_1, iter1_1)
	end

	var3_1:setShipIds(var4_1)

	local var5_1 = {}

	for iter2_1, iter3_1 in ipairs(var1_1.furniture_id_list) do
		local var6_1 = Furniture.New(iter3_1)

		var5_1[tonumber(var6_1.id)] = var6_1
	end

	var3_1:SetFurnitures(var5_1)

	for iter4_1 = 1, BackYardConst.MAX_FLOOR_CNT do
		var3_1:SetTheme(iter4_1, BackYardSelfThemeTemplate.New({
			id = -1,
			furniture_put_list = {}
		}, iter4_1))
	end

	for iter5_1, iter6_1 in ipairs(var1_1.furniture_put_list) do
		local var7_1 = {}

		for iter7_1, iter8_1 in ipairs(iter6_1.furniture_put_list) do
			local var8_1 = {}

			for iter9_1, iter10_1 in ipairs(iter8_1.child) do
				table.insert(var8_1, {
					id = iter10_1.id,
					x = iter10_1.x,
					y = iter10_1.y
				})
			end

			local var9_1 = {
				id = iter8_1.id,
				x = iter8_1.x,
				y = iter8_1.y,
				dir = iter8_1.dir,
				child = var8_1,
				parent = iter8_1.parent,
				shipId = iter8_1.shipId
			}

			table.insert(var7_1, var9_1)
		end

		var3_1:SetTheme(iter6_1.floor, BackYardSelfThemeTemplate.New({
			id = -1,
			furniture_put_list = var7_1
		}, iter6_1.floor))
	end

	local var10_1 = getProxy(DormProxy)

	if var2_1 then
		var10_1:addDorm(var3_1)
	else
		var10_1.friendData = var3_1
	end

	arg0_1:sendNotification(GAME.GET_BACKYARD_DATA_DONE, var3_1)
end

return var0_0
