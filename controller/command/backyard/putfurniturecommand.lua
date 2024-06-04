local var0 = class("PutFurnitureCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.furnsPos
	local var2 = var0.tip
	local var3 = var0.callback
	local var4 = getProxy(DormProxy)

	if not var4 then
		return
	end

	local var5 = var0.floor or var4.floor

	assert(var5, "floor should exist")

	local var6 = var4:getRawData()
	local var7 = var6.level
	local var8, var9 = CourtYardRawDataChecker.Check(var1, var6:GetMapSize())

	if not var8 then
		if var3 then
			var3(false, var9)

			return
		end

		pg.TipsMgr.GetInstance():ShowTips(var9)

		return
	end

	local var10 = {}

	for iter0, iter1 in pairs(var1) do
		local var11 = {}

		for iter2, iter3 in pairs(iter1.child) do
			table.insert(var11, {
				id = tostring(iter2),
				x = iter3.x,
				y = iter3.y
			})
		end

		table.insert(var10, {
			shipId = 1,
			id = tostring(iter1.configId),
			x = iter1.x,
			y = iter1.y,
			dir = iter1.dir,
			child = var11,
			parent = iter1.parent
		})
	end

	var4:getRawData():SetTheme(var5, BackYardSelfThemeTemplate.New({
		id = -1,
		furniture_put_list = var10
	}, var5))
	pg.ConnectionMgr.GetInstance():Send(19008, {
		floor = var5,
		furniture_put_list = var10
	})

	if var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_putFurniture_ok"))
	end

	arg0:sendNotification(GAME.PUT_FURNITURE_DONE)

	if var3 then
		var3(true)
	end
end

return var0
