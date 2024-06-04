local var0 = class("BeginStageCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().system

	pg.ConnectionMgr.GetInstance():Send(40005, {
		system = var0
	}, 40006, function(arg0)
		if arg0.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("stage_beginStage", arg0.result))
		end
	end)
end

return var0
