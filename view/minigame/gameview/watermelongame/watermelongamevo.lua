local var0_0 = class("WatermelonGameVo")
local var1_0 = 1.4

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.gameId = arg1_1
	arg0_1.hubId = pg.mini_game[arg0_1.gameId].hub_id
	arg0_1.drop = pg.mini_game[arg0_1.gameId].simple_config_data.drop_ids
	arg0_1.totalTimes = pg.mini_game_hub[arg0_1.hubId].reward_need
	arg0_1.mgData = getProxy(MiniGameProxy):GetMiniGameData(arg0_1.gameId)
	arg0_1.mgHubData = getProxy(MiniGameProxy):GetHubByHubId(arg0_1.hubId)
	arg0_1.tplItemPool = {}
end

function var0_0.getGameTimes(arg0_2)
	if arg0_2.mgHubData then
		return arg0_2.mgHubData.count or 0
	end

	return 0
end

function var0_0.getGameUseTimes(arg0_3)
	if arg0_3.mgHubData then
		return arg0_3.mgHubData.usedtime or 0
	end

	return 0
end

function var0_0.GetGameRound(arg0_4)
	if arg0_4.selectRound ~= nil then
		return arg0_4.selectRound
	end

	local var0_4 = arg0_4:getGameUseTimes()
	local var1_4 = arg0_4:GetGameTimes()

	if var1_4 and var1_4 > 0 then
		return var0_4 + 1
	end

	if var0_4 and var0_4 > 0 then
		return var0_4
	end

	return 1
end

function var0_0.prepare(arg0_5)
	arg0_5.gameTime = WatermelonGameConst.game_time
	arg0_5.gameStepTime = 0
	arg0_5.deltaTime = 0
	arg0_5.scoreNum = 0
	arg0_5.startSettlement = false
	arg0_5._joyStickData = nil
	arg0_5.createBallCd = var1_0
end

function var0_0.setJoyStickData(arg0_6, arg1_6)
	arg0_6._joyStickData = arg1_6
end

function var0_0.getJoyStickData(arg0_7)
	return arg0_7._joyStickData
end

function var0_0.setGameTpl(arg0_8, arg1_8)
	arg0_8.tpl = arg1_8
end

function var0_0.getTplItemFromPool(arg0_9, arg1_9, arg2_9)
	if not arg1_9 or arg1_9 == "" then
		return nil
	end

	if not arg2_9 then
		return nil
	end

	if arg0_9.tplItemPool[arg1_9] == nil then
		arg0_9.tplItemPool[arg1_9] = {}
	end

	if #arg0_9.tplItemPool[arg1_9] == 0 then
		local var0_9 = tf(instantiate(findTF(arg0_9.tpl, arg1_9)))

		setParent(var0_9, arg2_9)

		return var0_9, true
	else
		return table.remove(arg0_9.tplItemPool[arg1_9], #arg0_9.tplItemPool[arg1_9]), false
	end

	return nil, nil
end

function var0_0.returnTplItem(arg0_10, arg1_10, arg2_10)
	if not arg2_10 or not arg1_10 then
		return
	end

	setActive(arg2_10, false)
	table.insert(arg0_10.tplItemPool[arg1_10], arg2_10)
end

function var0_0.clear(arg0_11)
	arg0_11.tpl = nil
	arg0_11.tplItemPool = nil
end

return var0_0
