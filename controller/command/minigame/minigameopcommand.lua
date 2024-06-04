local var0 = class("MiniGameOPCommand", pm.SimpleCommand)

var0.CMD_COMPLETE = 1
var0.CMD_ULTIMATE = 2
var0.CMD_SPECIAL_GAME = 3
var0.CMD_HIGH_SCORE = 4
var0.CMD_PLAY = 5
var0.CMD_SPECIAL_TRACK = 100

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id or 0
	local var2 = var0.hubid
	local var3 = var0.cmd
	local var4 = var0.args1
	local var5 = 3

	if var3 == var0.CMD_COMPLETE and var5 > #var4 then
		for iter0 = #var4, var5 - 1 do
			table.insert(var4, 0)
		end

		if var1 and var1 > 0 then
			var4[3] = var1
		end
	end

	local var6 = var0.cbFunc

	pg.ConnectionMgr.GetInstance():Send(26103, {
		hubid = var2,
		cmd = var3,
		args1 = var4
	}, 26104, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(MiniGameProxy)

			if arg0.hub.id > 0 then
				var0:UpdataHubData(arg0.hub)
			end

			if arg0.data.id > 0 then
				MiniGameDataCreator.DataCreateFunc(var3, var4, arg0.data.datas, arg0.data.date1_key_value_list)
			end

			local var1 = PlayerConst.addTranDrop(arg0.award_list)

			print(var1)

			if var3 == var0.CMD_COMPLETE then
				local var2 = var0:GetHubByHubId(var2):getConfig("reward_target")

				if var2 ~= "" and var2 ~= 0 then
					local var3 = {
						count = 1,
						type = DROP_TYPE_VITEM,
						id = var2
					}

					table.insert(var1, var3)
				end
			end

			arg0:sendNotification(GAME.SEND_MINI_GAME_OP_DONE, {
				awards = var1,
				hubid = var2,
				cmd = var3,
				argList = var4
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("mini game Error : " .. arg0.result)
		end
	end)
end

return var0
