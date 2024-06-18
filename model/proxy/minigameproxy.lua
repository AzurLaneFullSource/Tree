local var0_0 = class("MiniGameProxy", import(".NetProxy"))

var0_0.ON_HUB_DATA_UPDATE = "on hub data update"
var0_0.ON_MINI_GAME_DATA_UPDATE = "on_mini_game_data_update"

function var0_0.register(arg0_1)
	arg0_1.miniGameHubDataDic = {}
	arg0_1.miniGameDataDic = {}
end

function var0_0.CheckHasHub(arg0_2, arg1_2)
	return arg0_2.miniGameHubDataDic[arg1_2] ~= nil
end

function var0_0.GetMiniGameData(arg0_3, arg1_3)
	if arg0_3.miniGameDataDic[arg1_3] == nil then
		local var0_3 = {
			id = arg1_3
		}

		arg0_3.miniGameDataDic[arg1_3] = MiniGameData.New(var0_3)
	end

	return arg0_3.miniGameDataDic[arg1_3]
end

function var0_0.GetMiniGameDataByType(arg0_4, arg1_4)
	for iter0_4, iter1_4 in pairs(arg0_4.miniGameDataDic) do
		if iter1_4:getConfig("type") == arg1_4 and iter1_4:CheckInTime() then
			return iter1_4
		end
	end
end

function var0_0.GetHubByHubId(arg0_5, arg1_5)
	if arg0_5.miniGameHubDataDic[arg1_5] == nil then
		local var0_5 = {
			id = arg1_5
		}

		arg0_5.miniGameHubDataDic[arg1_5] = MiniGameHubData.New(var0_5)
	end

	return arg0_5.miniGameHubDataDic[arg1_5]
end

function var0_0.GetHubByGameId(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetMiniGameData(arg1_6):getConfig("hub_id")

	if arg0_6.miniGameHubDataDic[var0_6] == nil then
		local var1_6 = {
			id = var0_6
		}

		arg0_6.miniGameHubDataDic[var0_6] = MiniGameHubData.New(var1_6)
	end

	return arg0_6.miniGameHubDataDic[var0_6]
end

function var0_0.UpdataHubData(arg0_7, arg1_7)
	local var0_7 = arg1_7.id
	local var1_7 = arg0_7:GetHubByHubId(var0_7)

	var1_7:UpdateData(arg1_7)
	arg0_7.facade:sendNotification(var0_0.ON_HUB_DATA_UPDATE, var1_7)
end

function var0_0.GetHighScore(arg0_8, arg1_8)
	return arg0_8:GetHubByGameId(arg1_8).highScores[arg1_8] or {}
end

function var0_0.UpdataHighScore(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetHubByGameId(arg1_9)
	local var1_9 = 0

	if var0_9.highScores[arg1_9] and var0_9.highScores[arg1_9][1] then
		var1_9 = var0_9.highScores[arg1_9][1]
	end

	if var1_9 <= arg2_9[1] then
		var0_9.highScores[arg1_9] = arg2_9

		arg0_9:UpdataHubData(var0_9)

		local var2_9 = {
			arg1_9
		}

		for iter0_9, iter1_9 in ipairs(arg2_9) do
			table.insert(var2_9, iter1_9)
		end

		arg0_9:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_9.id,
			cmd = MiniGameOPCommand.CMD_HIGH_SCORE,
			args1 = var2_9
		})
	end
end

function var0_0.GetRank(arg0_10, arg1_10)
	return arg0_10:GetMiniGameData(arg1_10):GetRank()
end

function var0_0.SetRank(arg0_11, arg1_11, arg2_11)
	arg0_11:GetMiniGameData(arg1_11):SetRank(arg2_11)
end

function var0_0.CanFetchRank(arg0_12, arg1_12)
	return arg0_12:GetMiniGameData(arg1_12):CanFetchRank()
end

function var0_0.RequestInitData(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13:GetMiniGameData(arg1_13)
	local var1_13 = var0_13:getConfig("request_data") == 1

	if arg2_13 and not var1_13 then
		return
	end

	if var0_13:CheckInTime() then
		local var2_13 = arg0_13:GetHubByGameId(arg1_13)
		local var3_13 = var0_13:getConfig("type")

		if (var3_13 == MiniGameConst.MG_TYPE_2 or var3_13 == MiniGameConst.MG_TYPE_3 or var3_13 == MiniGameConst.MG_TYPE_5) and not var0_13:GetRuntimeData("fetchData") then
			arg0_13:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var2_13.id,
				cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
				args1 = {
					var0_13.id,
					1
				}
			})
			var0_13:SetRuntimeData("fetchData", true)
		end
	end
end

function var0_0.remove(arg0_14)
	return
end

return var0_0
