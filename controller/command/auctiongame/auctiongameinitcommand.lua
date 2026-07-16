local var0_0 = class("AuctionGameInitCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if getProxy(AuctionGameBaseProxy):GetNeedInitFlag() == false then
		existCall(var0_1.callback)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(23430, {
		arg = 1
	}, 23431, function(arg0_2)
		local var0_2 = getProxy(AuctionGameBaseProxy)

		var0_2:UpdateData(arg0_2)
		var0_2:SetNeedInitFlag(false)
		existCall(var0_1.callback)
		arg0_1:sendNotification(ActivityProxy.UPDATED_TIP)
	end)
end

return var0_0
