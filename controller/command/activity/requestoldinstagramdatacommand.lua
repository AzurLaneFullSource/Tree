local var0_0 = class("RequestOldInstagramDataCommand", pm.SimpleCommand)
local var1_0 = 30

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(InstagramProxy)

	if var1_1:IsReqOldInstagramData() then
		if var0_1.callback then
			var0_1.callback()
		end

		return
	end

	local var2_1 = var1_1:GetOldInstagramIds()
	local var3_1 = {}
	local var4_1 = math.ceil(#var2_1 / var1_0)

	for iter0_1 = 1, var4_1 do
		local var5_1 = {}

		for iter1_1 = 1 + (iter0_1 - 1) * var1_0, iter0_1 * var1_0 do
			table.insert(var5_1, var2_1[iter1_1])
		end

		table.insert(var3_1, function(arg0_2)
			arg0_1:Send(var5_1, arg0_2)
		end)
	end

	seriesAsync(var3_1, function()
		if var0_1.callback then
			var0_1.callback()
		end

		var1_1:MarkOldInstagramData()
		arg0_1:sendNotification(GAME.REQ_OLD_INSTAGRAM_DATA_DONE)
	end)
end

function var0_0.Send(arg0_4, arg1_4, arg2_4)
	local var0_4 = getProxy(InstagramProxy)

	pg.ConnectionMgr.GetInstance():Send(11705, {
		id_list = arg1_4
	}, 11706, function(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg0_5.ins_message_list) do
			local var0_5 = Instagram.New(iter1_5)

			var0_4:AddInstagram(var0_5)
		end

		arg2_4()
	end)
end

return var0_0
