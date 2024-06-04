local var0 = class("GetBackYardVisitorCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(19024, {
		type = 0
	}, 19025, function(arg0)
		if arg0.visitor and arg0.visitor.ship_template ~= 0 then
			local var0 = Ship.New({
				id = 99999999,
				template_id = arg0.visitor.ship_template,
				name = arg0.visitor.name,
				skin_id = arg0.visitor.ship_skin
			})

			getProxy(DormProxy):SetVisitorShip(var0)
		end

		if var0 then
			var0()
		end

		arg0:sendNotification(GAME.BACKYARD_GET_VISITOR_SHIP_DONE)
	end)
end

return var0
