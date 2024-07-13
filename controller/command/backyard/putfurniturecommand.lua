local var0_0 = class("PutFurnitureCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.furnsPos
	local var2_1 = var0_1.tip
	local var3_1 = var0_1.callback
	local var4_1 = getProxy(DormProxy)

	if not var4_1 then
		return
	end

	local var5_1 = var0_1.floor or var4_1.floor

	assert(var5_1, "floor should exist")

	local var6_1 = var4_1:getRawData()
	local var7_1 = var6_1.level
	local var8_1, var9_1 = CourtYardRawDataChecker.Check(var1_1, var6_1:GetMapSize())

	if not var8_1 then
		if var3_1 then
			var3_1(false, var9_1)

			return
		end

		pg.TipsMgr.GetInstance():ShowTips(var9_1)

		return
	end

	local var10_1 = {}

	for iter0_1, iter1_1 in pairs(var1_1) do
		local var11_1 = {}

		for iter2_1, iter3_1 in pairs(iter1_1.child) do
			table.insert(var11_1, {
				id = tostring(iter2_1),
				x = iter3_1.x,
				y = iter3_1.y
			})
		end

		table.insert(var10_1, {
			shipId = 1,
			id = tostring(iter1_1.configId),
			x = iter1_1.x,
			y = iter1_1.y,
			dir = iter1_1.dir,
			child = var11_1,
			parent = iter1_1.parent
		})
	end

	var4_1:getRawData():SetTheme(var5_1, BackYardSelfThemeTemplate.New({
		id = -1,
		furniture_put_list = var10_1
	}, var5_1))
	pg.ConnectionMgr.GetInstance():Send(19008, {
		floor = var5_1,
		furniture_put_list = var10_1
	})

	if var2_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_putFurniture_ok"))
	end

	arg0_1:sendNotification(GAME.PUT_FURNITURE_DONE)

	if var3_1 then
		var3_1(true)
	end
end

return var0_0
