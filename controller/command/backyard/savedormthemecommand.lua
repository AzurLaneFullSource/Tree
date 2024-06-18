local var0_0 = class("SaveDormThemeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(DormProxy):getRawData()
	local var2_1 = var1_1.level
	local var3_1, var4_1 = CourtYardRawDataChecker.Check(var0_1.furnitureputList, var1_1:GetMapSize())

	if not var3_1 then
		pg.TipsMgr.GetInstance():ShowTips(var4_1)

		return
	end

	local var5_1 = {}

	for iter0_1, iter1_1 in pairs(var0_1.furnitureputList) do
		local var6_1 = {}

		for iter2_1, iter3_1 in pairs(iter1_1.child) do
			table.insert(var6_1, {
				id = tostring(iter2_1),
				x = iter3_1.x,
				y = iter3_1.y
			})
		end

		table.insert(var5_1, {
			shipId = 0,
			id = tostring(iter1_1.configId),
			x = iter1_1.x,
			y = iter1_1.y,
			dir = iter1_1.dir,
			child = var6_1,
			parent = iter1_1.parent
		})
	end

	local var7_1 = {
		id = var0_1.id,
		name = var0_1.name,
		furniture_put_list = var5_1
	}

	pg.ConnectionMgr.GetInstance():Send(19020, var7_1, 19021, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(DormProxy):AddTheme(var7_1)
			arg0_1:sendNotification(GAME.SAVE_DORMTHEME_DONE)
			pg.TipsMgr:GetInstance().ShowTips("Saved")
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
