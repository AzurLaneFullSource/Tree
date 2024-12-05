local var0_0 = class("GMTProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:on(50115, function(arg0_2)
		pg.GMTMgr:GetInstance():showGMT(arg0_2.timestamp)
	end)
end

return var0_0
