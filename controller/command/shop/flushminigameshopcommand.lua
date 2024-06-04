local var0 = class("FlushMiniGameShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(26154, {
		type = 0
	}, 26155, function(arg0)
		local var0

		if arg0.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
