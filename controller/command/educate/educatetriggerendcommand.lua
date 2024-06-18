local var0_0 = class("EducateTriggerEndCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	local var2_1 = var0_1.id
	local var3_1 = pg.child_ending[var2_1].performance

	pg.ConnectionMgr.GetInstance():Send(27008, {
		ending_id = var0_1.id
	}, 27009, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):AddEnding(var0_1.id)
			pg.PerformMgr.GetInstance():PlayGroup(var3_1, function()
				pg.PerformMgr.GetInstance():PlayOne(EducateConst.AFTER_END_PERFORM, function()
					getProxy(EducateProxy):CheckGuide("EducateScene")
				end)
			end)
			arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_END_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger end error: ", arg0_2.result))
		end
	end)
end

return var0_0
