local var0_0 = class("EducateAddTaskProgressCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27037, {
		type_1 = var0_1.system,
		progresses = var0_1.progresses
	}, 27038, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate add task progress error: ", arg0_2.result))
		end
	end)
end

return var0_0
