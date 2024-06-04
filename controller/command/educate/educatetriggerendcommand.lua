local var0 = class("EducateTriggerEndCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	local var2 = var0.id
	local var3 = pg.child_ending[var2].performance

	pg.ConnectionMgr.GetInstance():Send(27008, {
		ending_id = var0.id
	}, 27009, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):AddEnding(var0.id)
			pg.PerformMgr.GetInstance():PlayGroup(var3, function()
				pg.PerformMgr.GetInstance():PlayOne(EducateConst.AFTER_END_PERFORM, function()
					getProxy(EducateProxy):CheckGuide("EducateScene")
				end)
			end)
			arg0:sendNotification(GAME.EDUCATE_TRIGGER_END_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate trigger end error: ", arg0.result))
		end
	end)
end

return var0
