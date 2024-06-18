local var0_0 = class("RandomFlagshipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.isOn
	local var2_1 = var0_1.callback

	print("random flag switcher state : ", var1_1)
	pg.ConnectionMgr.GetInstance():Send(12204, {
		flag = var1_1 and 1 or 0
	}, 12205, function(arg0_2)
		if arg0_2.result == 0 then
			if var2_1 then
				var2_1()
			end
		else
			if var2_1 then
				var2_1()
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
