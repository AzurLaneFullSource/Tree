local var0_0 = class("MiniGameOPCommand", pm.SimpleCommand)

var0_0.CMD_COMPLETE = 1
var0_0.CMD_ULTIMATE = 2
var0_0.CMD_SPECIAL_GAME = 3
var0_0.CMD_HIGH_SCORE = 4
var0_0.CMD_PLAY = 5
var0_0.CMD_SPECIAL_TRACK = 100

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id or 0
	local var2_1 = var0_1.hubid
	local var3_1 = var0_1.cmd
	local var4_1 = var0_1.args1
	local var5_1 = 3

	if var3_1 == var0_0.CMD_COMPLETE and var5_1 > #var4_1 then
		for iter0_1 = #var4_1, var5_1 - 1 do
			table.insert(var4_1, 0)
		end

		if var1_1 and var1_1 > 0 then
			var4_1[3] = var1_1
		end
	end

	local var6_1 = var0_1.cbFunc

	pg.ConnectionMgr.GetInstance():Send(26103, {
		hubid = var2_1,
		cmd = var3_1,
		args1 = var4_1
	}, 26104, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(MiniGameProxy)

			if arg0_2.hub.id > 0 then
				var0_2:UpdataHubData(arg0_2.hub)
			end

			if arg0_2.data.id > 0 then
				MiniGameDataCreator.DataCreateFunc(var3_1, var4_1, arg0_2.data.datas, arg0_2.data.date1_key_value_list)
			end

			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			print(var1_2)

			if var3_1 == var0_0.CMD_COMPLETE then
				local var2_2 = var0_2:GetHubByHubId(var2_1):getConfig("reward_target")

				if var2_2 ~= "" and var2_2 ~= 0 then
					local var3_2 = {
						count = 1,
						type = DROP_TYPE_VITEM,
						id = var2_2
					}

					table.insert(var1_2, var3_2)
				end
			end

			arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP_DONE, {
				awards = var1_2,
				hubid = var2_1,
				cmd = var3_1,
				argList = var4_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("mini game Error : " .. arg0_2.result)
		end
	end)
end

return var0_0
