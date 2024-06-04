local var0 = class("EducateRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27000, {
		type = 1
	}, 27001, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):initData(arg0)

			if var1 then
				var1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate request error: ", arg0.result))
		end
	end)
end

return var0
