local var0 = class("MiniGameProxy", import(".NetProxy"))

var0.ON_HUB_DATA_UPDATE = "on hub data update"
var0.ON_MINI_GAME_DATA_UPDATE = "on_mini_game_data_update"

function var0.register(arg0)
	arg0.miniGameHubDataDic = {}
	arg0.miniGameDataDic = {}
end

function var0.CheckHasHub(arg0, arg1)
	return arg0.miniGameHubDataDic[arg1] ~= nil
end

function var0.GetMiniGameData(arg0, arg1)
	if arg0.miniGameDataDic[arg1] == nil then
		local var0 = {
			id = arg1
		}

		arg0.miniGameDataDic[arg1] = MiniGameData.New(var0)
	end

	return arg0.miniGameDataDic[arg1]
end

function var0.GetMiniGameDataByType(arg0, arg1)
	for iter0, iter1 in pairs(arg0.miniGameDataDic) do
		if iter1:getConfig("type") == arg1 and iter1:CheckInTime() then
			return iter1
		end
	end
end

function var0.GetHubByHubId(arg0, arg1)
	if arg0.miniGameHubDataDic[arg1] == nil then
		local var0 = {
			id = arg1
		}

		arg0.miniGameHubDataDic[arg1] = MiniGameHubData.New(var0)
	end

	return arg0.miniGameHubDataDic[arg1]
end

function var0.GetHubByGameId(arg0, arg1)
	local var0 = arg0:GetMiniGameData(arg1):getConfig("hub_id")

	if arg0.miniGameHubDataDic[var0] == nil then
		local var1 = {
			id = var0
		}

		arg0.miniGameHubDataDic[var0] = MiniGameHubData.New(var1)
	end

	return arg0.miniGameHubDataDic[var0]
end

function var0.UpdataHubData(arg0, arg1)
	local var0 = arg1.id
	local var1 = arg0:GetHubByHubId(var0)

	var1:UpdateData(arg1)
	arg0.facade:sendNotification(var0.ON_HUB_DATA_UPDATE, var1)
end

function var0.GetHighScore(arg0, arg1)
	return arg0:GetHubByGameId(arg1).highScores[arg1] or {}
end

function var0.UpdataHighScore(arg0, arg1, arg2)
	local var0 = arg0:GetHubByGameId(arg1)
	local var1 = 0

	if var0.highScores[arg1] and var0.highScores[arg1][1] then
		var1 = var0.highScores[arg1][1]
	end

	if var1 <= arg2[1] then
		var0.highScores[arg1] = arg2

		arg0:UpdataHubData(var0)

		local var2 = {
			arg1
		}

		for iter0, iter1 in ipairs(arg2) do
			table.insert(var2, iter1)
		end

		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_HIGH_SCORE,
			args1 = var2
		})
	end
end

function var0.GetRank(arg0, arg1)
	return arg0:GetMiniGameData(arg1):GetRank()
end

function var0.SetRank(arg0, arg1, arg2)
	arg0:GetMiniGameData(arg1):SetRank(arg2)
end

function var0.CanFetchRank(arg0, arg1)
	return arg0:GetMiniGameData(arg1):CanFetchRank()
end

function var0.RequestInitData(arg0, arg1, arg2)
	local var0 = arg0:GetMiniGameData(arg1)
	local var1 = var0:getConfig("request_data") == 1

	if arg2 and not var1 then
		return
	end

	if var0:CheckInTime() then
		local var2 = arg0:GetHubByGameId(arg1)
		local var3 = var0:getConfig("type")

		if (var3 == MiniGameConst.MG_TYPE_2 or var3 == MiniGameConst.MG_TYPE_3 or var3 == MiniGameConst.MG_TYPE_5) and not var0:GetRuntimeData("fetchData") then
			arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var2.id,
				cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
				args1 = {
					var0.id,
					1
				}
			})
			var0:SetRuntimeData("fetchData", true)
		end
	end
end

function var0.remove(arg0)
	return
end

return var0
