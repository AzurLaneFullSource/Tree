local var0_0 = class("PacGameVo")
local var1_0 = 1.4

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._gameId = arg1_1
	arg0_1._hubId = pg.mini_game[arg0_1._gameId].hub_id
	arg0_1._drop = pg.mini_game[arg0_1._gameId].simple_config_data.drop_ids
	arg0_1._totalTimes = pg.mini_game_hub[arg0_1._hubId].reward_need
	arg0_1._mgData = getProxy(MiniGameProxy):GetMiniGameData(arg0_1._gameId)
	arg0_1._mgHubData = getProxy(MiniGameProxy):GetHubByHubId(arg0_1._hubId)
end

function var0_0.GetGameId(arg0_2)
	return arg0_2._gameId
end

function var0_0.SetEditor(arg0_3, arg1_3)
	arg0_3._editorFlag = arg1_3
end

function var0_0.GetEditor(arg0_4, arg1_4)
	return arg0_4._editorFlag
end

function var0_0.GetGameRound(arg0_5)
	if arg0_5._editorFlag then
		return PacGameConst.editor_chapter
	end

	if arg0_5.selectRound ~= nil then
		return arg0_5.selectRound
	end

	local var0_5 = arg0_5:GetGameUseTimes()
	local var1_5 = arg0_5:GetGameTimes()

	if var1_5 and var1_5 > 0 then
		return var0_5 + 1
	end

	if var0_5 and var0_5 > 0 then
		return var0_5
	end

	return 1
end

function var0_0.GetGameTimes(arg0_6)
	if arg0_6._mgHubData then
		return arg0_6._mgHubData.count or 0
	end

	return 0
end

function var0_0.GetGameUseTimes(arg0_7)
	if arg0_7._mgHubData then
		return arg0_7._mgHubData.usedtime or 0
	end

	return 0
end

function var0_0.GetUltimate(arg0_8)
	if arg0_8._mgHubData then
		return arg0_8._mgHubData.ultimate
	end

	return nil
end

function var0_0.GetTotalTimes(arg0_9)
	return arg0_9._totalTimes
end

function var0_0.GetHubId(arg0_10)
	return arg0_10._mgHubData.id
end

function var0_0.Prepare(arg0_11)
	arg0_11._gameTime = PacGameConst.game_time
	arg0_11._gameTimeInteger = math.floor(arg0_11._gameTime)
	arg0_11._gameStepTime = 0
	arg0_11._deltaTime = 0
	arg0_11._scoreNum = 0
	arg0_11._settlementFlag = false
	arg0_11._joyStickData = nil
end

function var0_0.Step(arg0_12, arg1_12)
	arg0_12._gameTime = arg0_12._gameTime - arg1_12
	arg0_12._gameTimeInteger = math.floor(arg0_12._gameTime)
	arg0_12._gameStepTime = arg0_12._gameStepTime + arg1_12
	arg0_12._gameStepTimeInteger = math.floor(arg0_12._gameStepTime)
	arg0_12._deltaTime = arg1_12
end

function var0_0.AddScore(arg0_13, arg1_13)
	arg0_13._scoreNum = arg0_13._scoreNum + arg1_13
end

function var0_0.GetScore(arg0_14)
	return arg0_14._scoreNum
end

function var0_0.SetSettlement(arg0_15, arg1_15)
	arg0_15._settlementFlag = arg1_15
end

function var0_0.IsSettlement(arg0_16)
	return arg0_16._settlementFlag
end

function var0_0.GetTime(arg0_17)
	return arg0_17._gameTime
end

function var0_0.GetTimeInteger(arg0_18)
	return arg0_18._gameTimeInteger
end

function var0_0.GetStepTimeInteger(arg0_19)
	return arg0_19._gameStepTimeInteger
end

function var0_0.GetDrop(arg0_20)
	return arg0_20._drop
end

function var0_0.GetConfig(arg0_21, arg1_21)
	return arg0_21._mgData:getConfig(arg1_21)
end

function var0_0.GetDeltaTime(arg0_22)
	return arg0_22._deltaTime
end

function var0_0.SetJoyStickData(arg0_23, arg1_23)
	arg0_23._joyStickData = arg1_23
end

function var0_0.GetJoyStickData(arg0_24)
	return arg0_24._joyStickData
end

function var0_0.Clear(arg0_25)
	arg0_25._drop = {}
	arg0_25._totalTimes = 0
	arg0_25._mgData = nil
	arg0_25._mgHubData = nil
end

return var0_0
