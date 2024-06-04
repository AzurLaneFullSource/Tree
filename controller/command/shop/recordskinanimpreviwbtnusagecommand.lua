local var0 = class("RecordSkinAnimPreviwBtnUsageCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().isOpen and 1 or 0

	pg.ConnectionMgr.GetInstance():Send(16203, {
		flag = var0
	}, 16204, function(arg0)
		if arg0.ret == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
