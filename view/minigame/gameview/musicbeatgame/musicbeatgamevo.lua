local var0_0 = class("MusicBeatGameVo")

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
	local var1_4 = arg0_4:getGameTimes()

	if var1_4 and var1_4 > 0 then
		return var0_4 + 1
	end

	if var0_4 and var0_4 > 0 then
		return var0_4
	end

	return 1
end

function var0_0.prepare(arg0_5)
	arg0_5.gameTime = MusicBeatGameConst.game_time
	arg0_5.gameStepTime = 0
	arg0_5.deltaTime = 0
	arg0_5.scoreNum = 0
	arg0_5.startSettlement = false

	arg0_5:setBgmPlay(false)
	arg0_5:setCriInfo(nil)
	arg0_5:setMapData(MusicBeatGameConst.map_data[1])
end

function var0_0.setMapData(arg0_6, arg1_6)
	arg0_6._mapData = arg1_6
	arg0_6._nodeData = arg0_6:getMusicNode(arg0_6._mapData.node_lua)
end

function var0_0.getMapData(arg0_7)
	return Clone(arg0_7._mapData)
end

function var0_0.getNodeData(arg0_8)
	return Clone(arg0_8._nodeData)
end

function var0_0.getMusicNode(arg0_9, arg1_9)
	local var0_9 = "view/miniGame/gameView/musicbeatgame/beat/" .. arg1_9

	return require(var0_9)
end

function var0_0.setCriInfo(arg0_10, arg1_10)
	arg0_10._criInfo = arg1_10
end

function var0_0.getCriInfo(arg0_11)
	return arg0_11._criInfo
end

function var0_0.getCriInfoTime(arg0_12)
	if arg0_12._criInfo then
		return arg0_12._criInfo:GetTime()
	end

	return -1
end

function var0_0.setBgmPlay(arg0_13, arg1_13)
	arg0_13._bgmPlayFlag = arg1_13
end

function var0_0.isBgmPlaying(arg0_14)
	return arg0_14._bgmPlayFlag
end

function var0_0.setGameTpl(arg0_15, arg1_15)
	arg0_15.tpl = arg1_15
end

function var0_0.getTplItemFromPool(arg0_16, arg1_16, arg2_16)
	if not arg1_16 or arg1_16 == "" then
		return nil
	end

	if not arg2_16 then
		return nil
	end

	if arg0_16.tplItemPool[arg1_16] == nil then
		arg0_16.tplItemPool[arg1_16] = {}
	end

	if #arg0_16.tplItemPool[arg1_16] == 0 then
		local var0_16 = tf(instantiate(findTF(arg0_16.tpl, arg1_16)))

		setParent(var0_16, arg2_16)

		return var0_16, true
	else
		return table.remove(arg0_16.tplItemPool[arg1_16], #arg0_16.tplItemPool[arg1_16]), false
	end

	return nil, nil
end

function var0_0.returnTplItem(arg0_17, arg1_17, arg2_17)
	if not arg2_17 or not arg1_17 then
		return
	end

	setActive(arg2_17, false)
	table.insert(arg0_17.tplItemPool[arg1_17], arg2_17)
end

function var0_0.clear(arg0_18)
	arg0_18.tpl = nil
	arg0_18.tplItemPool = nil
end

return var0_0
