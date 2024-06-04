local var0 = class("AddBackYardThemeTemplateCommand", pm.SimpleCommand)

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
			shipId = 1,
			id = tostring(iter1.configId),
			x = iter1.x,
			y = iter1.y,
			dir = iter1.dir,
			child = var6,
			parent = iter1.parent
		})
	end

	local var7 = {
		pos = var0.id,
		name = var0.name,
		furniture_put_list = var5,
		icon_image_md5 = var0.iconMd5,
		image_md5 = var0.imageMd5
	}

	pg.ConnectionMgr.GetInstance():Send(19109, var7, 19110, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(DormProxy)
			local var1 = BackYardBaseThemeTemplate.BuildId(var0.id)

			var7.id = var1

			local var2 = BackYardSelfThemeTemplate.New(var7)

			var0:AddCustomThemeTemplate(var2)
			arg0:sendNotification(GAME.BACKYARD_SAVE_THEME_TEMPLATE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
