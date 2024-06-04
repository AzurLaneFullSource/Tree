local var0 = class("SaveDormThemeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(DormProxy):getRawData()
	local var2 = var1.level
	local var3, var4 = CourtYardRawDataChecker.Check(var0.furnitureputList, var1:GetMapSize())

	if not var3 then
		pg.TipsMgr.GetInstance():ShowTips(var4)

		return
	end

	local var5 = {}

	for iter0, iter1 in pairs(var0.furnitureputList) do
		local var6 = {}

		for iter2, iter3 in pairs(iter1.child) do
			table.insert(var6, {
				id = tostring(iter2),
				x = iter3.x,
				y = iter3.y
			})
		end

		table.insert(var5, {
			shipId = 0,
			id = tostring(iter1.configId),
			x = iter1.x,
			y = iter1.y,
			dir = iter1.dir,
			child = var6,
			parent = iter1.parent
		})
	end

	local var7 = {
		id = var0.id,
		name = var0.name,
		furniture_put_list = var5
	}

	pg.ConnectionMgr.GetInstance():Send(19020, var7, 19021, function(arg0)
		if arg0.result == 0 then
			getProxy(DormProxy):AddTheme(var7)
			arg0:sendNotification(GAME.SAVE_DORMTHEME_DONE)
			pg.TipsMgr:GetInstance().ShowTips("Saved")
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
