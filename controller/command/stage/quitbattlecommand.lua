local var0_0 = class("BeginStageCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().system

	pg.ConnectionMgr.GetInstance():Send(40005, {
		system = var0_1
	}, 40006, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_beginStage", arg0_2.result))
		end
	end)
end

return var0_0
