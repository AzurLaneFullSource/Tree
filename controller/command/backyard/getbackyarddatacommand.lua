local var0 = class("GetBackYardDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.data
	local var2 = var0.isMine
	local var3

	if var2 then
		var3 = Dorm.New(var1)
	else
		var3 = FriendDorm.New(var1)
	end

	local var4 = {}

	for iter0, iter1 in ipairs(var1.ship_id_list) do
		table.insert(var4, iter1)
	end

	var3:setShipIds(var4)

	local var5 = {}

	for iter2, iter3 in ipairs(var1.furniture_id_list) do
		local var6 = Furniture.New(iter3)

		var5[tonumber(var6.id)] = var6
	end

	var3:SetFurnitures(var5)

	for iter4 = 1, BackYardConst.MAX_FLOOR_CNT do
		var3:SetTheme(iter4, BackYardSelfThemeTemplate.New({
			id = -1,
			furniture_put_list = {}
		}, iter4))
	end

	for iter5, iter6 in ipairs(var1.furniture_put_list) do
		local var7 = {}

		for iter7, iter8 in ipairs(iter6.furniture_put_list) do
			local var8 = {}

			for iter9, iter10 in ipairs(iter8.child) do
				table.insert(var8, {
					id = iter10.id,
					x = iter10.x,
					y = iter10.y
				})
			end

			local var9 = {
				id = iter8.id,
				x = iter8.x,
				y = iter8.y,
				dir = iter8.dir,
				child = var8,
				parent = iter8.parent,
				shipId = iter8.shipId
			}

			table.insert(var7, var9)
		end

		var3:SetTheme(iter6.floor, BackYardSelfThemeTemplate.New({
			id = -1,
			furniture_put_list = var7
		}, iter6.floor))
	end

	local var10 = getProxy(DormProxy)

	if var2 then
		var10:addDorm(var3)
	else
		var10.friendData = var3
	end

	arg0:sendNotification(GAME.GET_BACKYARD_DATA_DONE, var3)
end

return var0
