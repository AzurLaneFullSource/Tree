local var0_0 = class("FlushMiniGameShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(26154, {
		type = 0
	}, 26155, function(arg0_2)
		local var0_2

		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
