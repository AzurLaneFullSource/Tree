local var0 = class("RefreshCommanderBoxesCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(CommanderProxy)

	pg.ConnectionMgr.GetInstance():Send(25034, {
		type = 0
	}, 25035, function(arg0)
		for iter0, iter1 in ipairs(arg0.box_list) do
			local var0 = CommanderBox.New(iter1, iter0)

			var1:updateBox(var0)
		end

		arg0:sendNotification(GAME.REFRESH_COMMANDER_BOXES_DONE)
	end)
end

return var0
