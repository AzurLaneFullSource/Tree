local var0_0 = class("GetBackYardDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.data
	local var2_1 = var0_1.isMine
	local var3_1
	local var4_1 = {}

	if var2_1 then
		var3_1 = Dorm.New(var1_1)

		for iter0_1, iter1_1 in ipairs(var1_1.ship_list or {}) do
			local var5_1 = DormShip.New(iter1_1)

			table.insert(var4_1, var5_1)
		end
	else
		var3_1 = FriendDorm.New(var1_1)

		for iter2_1, iter3_1 in ipairs(var1_1.ship_list or {}) do
			local var6_1 = FriendDormShip.New(iter3_1)

			table.insert(var4_1, var6_1)
		end
	end

	var3_1:SetShips(var4_1)

	local var7_1 = {}

	for iter4_1, iter5_1 in ipairs(var1_1.furniture_id_list) do
		local var8_1 = Furniture.New(iter5_1)

		var7_1[tonumber(var8_1.id)] = var8_1
	end

	var3_1:SetFurnitures(var7_1)

	for iter6_1 = 1, BackYardConst.MAX_FLOOR_CNT do
		var3_1:SetTheme(iter6_1, BackYardSelfThemeTemplate.New({
			id = -1,
			furniture_put_list = {}
		}, iter6_1))
	end

	for iter7_1, iter8_1 in ipairs(var1_1.furniture_put_list) do
		local var9_1 = {}

		for iter9_1, iter10_1 in ipairs(iter8_1.furniture_put_list) do
			local var10_1 = {}

			for iter11_1, iter12_1 in ipairs(iter10_1.child) do
				table.insert(var10_1, {
					id = iter12_1.id,
					x = iter12_1.x,
					y = iter12_1.y
				})
			end

			local var11_1 = {
				id = iter10_1.id,
				x = iter10_1.x,
				y = iter10_1.y,
				dir = iter10_1.dir,
				child = var10_1,
				parent = iter10_1.parent,
				shipId = iter10_1.shipId
			}

			table.insert(var9_1, var11_1)
		end

		var3_1:SetTheme(iter8_1.floor, BackYardSelfThemeTemplate.New({
			id = -1,
			furniture_put_list = var9_1
		}, iter8_1.floor))
	end

	local var12_1 = getProxy(DormProxy)

	if var2_1 then
		var12_1:addDorm(var3_1)
	else
		var12_1.friendData = var3_1
	end

	arg0_1:sendNotification(GAME.GET_BACKYARD_DATA_DONE, var3_1)
end

return var0_0
