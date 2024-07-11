local var0_0 = class("MiniGameProxy", import(".NetProxy"))

var0_0.ON_HUB_DATA_UPDATE = "on hub data update"
var0_0.ON_MINI_GAME_DATA_UPDATE = "on_mini_game_data_update"

function var0_0.register(arg0_1)
	arg0_1.miniGameHubDataDic = {}
	arg0_1.miniGameDataDic = {}
end

function var0_0.timeCall(arg0_2)
	return {
		[ProxyRegister.DayCall] = function(arg0_3)
			arg0_2:sendNotification(GAME.REQUEST_MINI_GAME, {
				type = MiniGameRequestCommand.REQUEST_HUB_DATA
			})

			local var0_3 = arg0_2:GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

			if var0_3 then
				local var1_3 = var0_3.id
				local var2_3 = arg0_2:GetHubByGameId(var1_3).id

				arg0_2:sendNotification(GAME.SEND_MINI_GAME_OP, {
					hubid = var2_3,
					cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
					args1 = {
						var1_3,
						1
					}
				})
			end
		end
	}
end

function var0_0.CheckHasHub(arg0_4, arg1_4)
	return arg0_4.miniGameHubDataDic[arg1_4] ~= nil
end

function var0_0.GetMiniGameData(arg0_5, arg1_5)
	if arg0_5.miniGameDataDic[arg1_5] == nil then
		local var0_5 = {
			id = arg1_5
		}

		arg0_5.miniGameDataDic[arg1_5] = MiniGameData.New(var0_5)
	end

	return arg0_5.miniGameDataDic[arg1_5]
end

function var0_0.GetMiniGameDataByType(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.miniGameDataDic) do
		if iter1_6:getConfig("type") == arg1_6 and iter1_6:CheckInTime() then
			return iter1_6
		end
	end
end

function var0_0.GetHubByHubId(arg0_7, arg1_7)
	if arg0_7.miniGameHubDataDic[arg1_7] == nil then
		local var0_7 = {
			id = arg1_7
		}

		arg0_7.miniGameHubDataDic[arg1_7] = MiniGameHubData.New(var0_7)
	end

	return arg0_7.miniGameHubDataDic[arg1_7]
end

function var0_0.GetHubByGameId(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetMiniGameData(arg1_8):getConfig("hub_id")

	if arg0_8.miniGameHubDataDic[var0_8] == nil then
		local var1_8 = {
			id = var0_8
		}

		arg0_8.miniGameHubDataDic[var0_8] = MiniGameHubData.New(var1_8)
	end

	return arg0_8.miniGameHubDataDic[var0_8]
end

function var0_0.UpdataHubData(arg0_9, arg1_9)
	local var0_9 = arg1_9.id
	local var1_9 = arg0_9:GetHubByHubId(var0_9)

	var1_9:UpdateData(arg1_9)
	arg0_9.facade:sendNotification(var0_0.ON_HUB_DATA_UPDATE, var1_9)
end

function var0_0.GetHighScore(arg0_10, arg1_10)
	return arg0_10:GetHubByGameId(arg1_10).highScores[arg1_10] or {}
end

function var0_0.UpdataHighScore(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:GetHubByGameId(arg1_11)
	local var1_11 = 0

	if var0_11.highScores[arg1_11] and var0_11.highScores[arg1_11][1] then
		var1_11 = var0_11.highScores[arg1_11][1]
	end

	if var1_11 <= arg2_11[1] then
		var0_11.highScores[arg1_11] = arg2_11

		arg0_11:UpdataHubData(var0_11)

		local var2_11 = {
			arg1_11
		}

		for iter0_11, iter1_11 in ipairs(arg2_11) do
			table.insert(var2_11, iter1_11)
		end

		arg0_11:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_11.id,
			cmd = MiniGameOPCommand.CMD_HIGH_SCORE,
			args1 = var2_11
		})
	end
end

function var0_0.GetRank(arg0_12, arg1_12)
	return arg0_12:GetMiniGameData(arg1_12):GetRank()
end

function var0_0.SetRank(arg0_13, arg1_13, arg2_13)
	arg0_13:GetMiniGameData(arg1_13):SetRank(arg2_13)
end

function var0_0.CanFetchRank(arg0_14, arg1_14)
	return arg0_14:GetMiniGameData(arg1_14):CanFetchRank()
end

function var0_0.RequestInitData(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15:GetMiniGameData(arg1_15)
	local var1_15 = var0_15:getConfig("request_data") == 1

	if arg2_15 and not var1_15 then
		return
	end

	if var0_15:CheckInTime() then
		local var2_15 = arg0_15:GetHubByGameId(arg1_15)
		local var3_15 = var0_15:getConfig("type")

		if (var3_15 == MiniGameConst.MG_TYPE_2 or var3_15 == MiniGameConst.MG_TYPE_3 or var3_15 == MiniGameConst.MG_TYPE_5) and not var0_15:GetRuntimeData("fetchData") then
			arg0_15:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var2_15.id,
				cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
				args1 = {
					var0_15.id,
					1
				}
			})
			var0_15:SetRuntimeData("fetchData", true)
		end
	end
end

function var0_0.remove(arg0_16)
	return
end

return var0_0
