local var0_0 = class("RefreshCommanderBoxesCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(CommanderProxy)

	pg.ConnectionMgr.GetInstance():Send(25034, {
		type = 0
	}, 25035, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.box_list) do
			local var0_2 = CommanderBox.New(iter1_2, iter0_2)

			var1_1:updateBox(var0_2)
		end

		arg0_1:sendNotification(GAME.REFRESH_COMMANDER_BOXES_DONE)
	end)
end

return var0_0
