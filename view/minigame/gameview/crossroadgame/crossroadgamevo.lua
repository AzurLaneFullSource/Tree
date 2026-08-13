local var0_0 = class("CrossRoadGameVo")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._gameId = arg1_1
	arg0_1._hubId = pg.mini_game[arg1_1].hub_id
	arg0_1._mgData = getProxy(MiniGameProxy):GetMiniGameData(arg0_1._gameId)
	arg0_1._mgHubData = getProxy(MiniGameProxy):GetHubByHubId(arg0_1._hubId)

	arg0_1:Prepare()
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
	arg0_11._gameTime = CrossRoadGameConst.GAME_TIME
	arg0_11._gameTimeInteger = math.floor(arg0_11._gameTime)
	arg0_11._gameStepTime = 0
	arg0_11._deltaTime = 0
	arg0_11._scoreNum = 0
	arg0_11._settlementFlag = false
	arg0_11._joyStickData = nil
	arg0_11._life = CrossRoadGameConst.LIFE_COUNT
	arg0_11._roleWentCnt = 0
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

function var0_0.GetLife(arg0_23)
	return arg0_23._life
end

function var0_0.changeLife(arg0_24, arg1_24)
	arg0_24._life = arg0_24._life + arg1_24
end

function var0_0.GetRoleCnt(arg0_25)
	return arg0_25._roleWentCnt
end

function var0_0.AddRoleCnt(arg0_26)
	arg0_26._roleWentCnt = arg0_26._roleWentCnt + 1
end

function var0_0.SetJoyStickData(arg0_27, arg1_27)
	arg0_27._joyStickData = arg1_27
end

function var0_0.GetJoyStickData(arg0_28)
	return arg0_28._joyStickData
end

function var0_0.Clear(arg0_29)
	arg0_29._drop = {}
	arg0_29._totalTimes = 0
	arg0_29._mgData = nil
	arg0_29._mgHubData = nil
end

return var0_0
