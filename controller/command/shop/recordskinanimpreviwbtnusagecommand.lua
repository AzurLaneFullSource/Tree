local var0_0 = class("RecordSkinAnimPreviwBtnUsageCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().isOpen and 1 or 0

	pg.ConnectionMgr.GetInstance():Send(16203, {
		flag = var0_1
	}, 16204, function(arg0_2)
		if arg0_2.ret == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
