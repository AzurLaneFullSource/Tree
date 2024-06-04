local var0 = class("RandomFlagshipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.isOn
	local var2 = var0.callback

	print("random flag switcher state : ", var1)
	pg.ConnectionMgr.GetInstance():Send(12204, {
		flag = var1 and 1 or 0
	}, 12205, function(arg0)
		if arg0.result == 0 then
			if var2 then
				var2()
			end
		else
			if var2 then
				var2()
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
