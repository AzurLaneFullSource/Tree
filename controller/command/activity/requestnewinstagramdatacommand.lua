local var0_0 = class("RequestNewInstagramDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(InstagramProxy)

	if var1_1:IsReqNewInstagramData() then
		if var0_1.callback then
			var0_1.callback()
		end

		return
	end

	local var2_1 = var1_1:GetNewInstagramIds()

	pg.ConnectionMgr.GetInstance():Send(11705, {
		id_list = var2_1
	}, 11706, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.ins_message_list) do
			local var0_2 = Instagram.New(iter1_2)

			var1_1:AddInstagram(var0_2)
		end

		var1_1:MarkNewInstagramData()

		if var0_1.callback then
			var0_1.callback()
		end

		arg0_1:sendNotification(GAME.REQ_NEW_INSTAGRAM_DATA_DONE)
	end)
end

return var0_0
