local var0_0 = class("GetBackYardVisitorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(19024, {
		type = 0
	}, 19025, function(arg0_2)
		local var0_2 = getProxy(DormProxy):getRawData()

		for iter0_2, iter1_2 in ipairs(arg0_2.furniture_put_list) do
			local var1_2 = {}

			for iter2_2, iter3_2 in ipairs(iter1_2.furniture_put_list) do
				local var2_2 = {}

				for iter4_2, iter5_2 in ipairs(iter3_2.child) do
					table.insert(var2_2, {
						id = iter5_2.id,
						x = iter5_2.x,
						y = iter5_2.y
					})
				end

				local var3_2 = {
					id = iter3_2.id,
					x = iter3_2.x,
					y = iter3_2.y,
					dir = iter3_2.dir,
					child = var2_2,
					parent = iter3_2.parent,
					shipId = iter3_2.shipId
				}

				table.insert(var1_2, var3_2)
			end

			var0_2:SetTheme(iter1_2.floor, BackYardSelfThemeTemplate.New({
				id = -1,
				furniture_put_list = var1_2
			}, iter1_2.floor))
		end

		if arg0_2.visitor and arg0_2.visitor.ship_template ~= 0 then
			local var4_2 = Ship.New({
				id = 99999999,
				template_id = arg0_2.visitor.ship_template,
				name = arg0_2.visitor.name,
				skin_id = arg0_2.visitor.ship_skin
			})

			getProxy(DormProxy):SetVisitorShip(var4_2)
		end

		if var0_1 then
			var0_1()
		end

		arg0_1:sendNotification(GAME.BACKYARD_GET_VISITOR_SHIP_DONE)
	end)
end

return var0_0
