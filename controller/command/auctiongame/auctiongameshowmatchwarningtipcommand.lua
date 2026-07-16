local var0_0 = class("AuctionGameShowMatchWarningTipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23424, {
		arg = 1
	}, 23425, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(AuctionGameBaseProxy):SetMatchWarning()
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
