local var0 = class("EducateAddTaskProgressCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27037, {
		type_1 = var0.system,
		progresses = var0.progresses
	}, 27038, function(arg0)
		if arg0.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate add task progress error: ", arg0.result))
		end
	end)
end

return var0
