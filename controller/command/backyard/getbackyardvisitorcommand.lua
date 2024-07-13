local var0_0 = class("GetBackYardVisitorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(19024, {
		type = 0
	}, 19025, function(arg0_2)
		if arg0_2.visitor and arg0_2.visitor.ship_template ~= 0 then
			local var0_2 = Ship.New({
				id = 99999999,
				template_id = arg0_2.visitor.ship_template,
				name = arg0_2.visitor.name,
				skin_id = arg0_2.visitor.ship_skin
			})

			getProxy(DormProxy):SetVisitorShip(var0_2)
		end

		if var0_1 then
			var0_1()
		end

		arg0_1:sendNotification(GAME.BACKYARD_GET_VISITOR_SHIP_DONE)
	end)
end

return var0_0
