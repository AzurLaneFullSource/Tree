local var0_0 = class("ToLoveGameVo")

var0_0.game_id = nil
var0_0.hub_id = nil
var0_0.total_times = nil
var0_0.drop = nil
var0_0.story = nil
var0_0.frameRate = Application.targetFrameRate or 60
var0_0.gameTime = 0
var0_0.gameStepTime = 0
var0_0.doTime = 0
var0_0.gameArrowTime = 0
var0_0.gameMoveTime = 0
var0_0.gameBombTime = 0
var0_0.gameBombBlastTime = 0
var0_0.deltaTime = 0
var0_0.score = 0
var0_0.startSettlement = false
var0_0.showArrowFlag = true
var0_0.playerMoveFlag = false
var0_0.waitingFlag = false
var0_0.currentPlayerPosition = {
	3,
	3
}
var0_0.previousPlayerPosition = {
	3,
	3
}
var0_0.safeCellPosition = {
	3,
	3
}
var0_0.arrowList = {}
var0_0.safeList = {}
var0_0.nowArrowIndex = 1
var0_0.nowBombIndex = 999
var0_0.hasDone = false
var0_0.canMove = false
var0_0.bombBlast = false
var0_0.highestScore = 0
var0_0.combo = 0
var0_0.buffIndex = 0
var0_0.shieldCount = 0
var0_0.shieldGetCombo = 0
var0_0.arrowVideoCount = 2
var0_0.moveCount = 2

function var0_0.Init(arg0_1, arg1_1)
	var0_0.game_id = arg0_1
	var0_0.hub_id = arg1_1
	var0_0.total_times = pg.mini_game_hub[var0_0.hub_id].reward_need
	var0_0.drop = pg.mini_game[var0_0.game_id].simple_config_data.drop_ids
	var0_0.story = pg.mini_game[var0_0.game_id].simple_config_data.story
end

function var0_0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0_0.game_id)
end

function var0_0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0_0.hub_id)
end

function var0_0.Prepare()
	var0_0.buffIndex = PlayerPrefs.GetInt("ToLoveGameBuff", 0)
	var0_0.gameTime = ToLoveGameConst.gameTime

	if var0_0.buffIndex == 3 or var0_0.buffIndex == 6 or var0_0.buffIndex == 7 then
		var0_0.gameTime = ToLoveGameConst.gameTime + ToLoveGameConst.addTime
	end

	var0_0.gameStepTime = 0
	var0_0.doTime = var0_0.GetDoTime()
	var0_0.gameArrowTime = 0
	var0_0.gameMoveTime = 0
	var0_0.gameBombTime = 0
	var0_0.gameBombBlastTime = 0
	var0_0.score = 0
	var0_0.startSettlement = false
	var0_0.showArrowFlag = false
	var0_0.playerMoveFlag = true
	var0_0.waitingFlag = false

	var0_0.ChangeMotion()

	var0_0.currentPlayerPosition = {
		3,
		3
	}
	var0_0.previousPlayerPosition = {
		3,
		3
	}
	var0_0.safeCellPosition = {
		3,
		3
	}
	var0_0.hasDone = false
	var0_0.canMove = false
	var0_0.nowArrowIndex = 1
	var0_0.nowBombIndex = 999
	var0_0.bombBlast = false
	var0_0.combo = 0
	var0_0.shieldCount = 0

	if var0_0.buffIndex == 1 or var0_0.buffIndex == 4 or var0_0.buffIndex == 7 then
		var0_0.shieldCount = 1
	end

	var0_0.shieldGetCombo = 0
	var0_0.arrowVideoCount = 2
	var0_0.moveCount = 2
end

function var0_0.ChangeMotion()
	if var0_0.showArrowFlag then
		var0_0.gameMoveTime = var0_0.doTime
		var0_0.gameBombTime = 0
		var0_0.nowBombIndex = 1
		var0_0.safeList = var0_0.arrowList
		var0_0.showArrowFlag = false
		var0_0.playerMoveFlag = true
		var0_0.waitingFlag = false
		var0_0.hasDone = false
	elseif var0_0.playerMoveFlag then
		var0_0.showArrowFlag = false
		var0_0.playerMoveFlag = false
		var0_0.waitingFlag = true
	elseif var0_0.waitingFlag then
		local var0_5 = var0_0.GetArrowNum()

		var0_0.SetRandomArrawList(var0_5)

		var0_0.doTime = var0_0.GetDoTime()
		var0_0.gameArrowTime = var0_0.doTime
		var0_0.nowArrowIndex = 1
		var0_0.arrowVideoCount = var0_5
		var0_0.moveCount = var0_5
		var0_0.showArrowFlag = true
		var0_0.playerMoveFlag = false
		var0_0.waitingFlag = false
		var0_0.hasDone = false
	end
end

function var0_0.GetArrowNum()
	local var0_6 = 2

	for iter0_6, iter1_6 in ipairs(ToLoveGameConst.remainingTimeToArrowNumber) do
		if var0_0.gameTime >= ToLoveGameConst.remainingTimeToArrowTime[iter0_6] then
			return iter1_6
		end
	end
end

function var0_0.GetDoTime()
	return ToLoveGameConst.motionTime / var0_0.GetArrowNum()
end

function var0_0.SetRandomArrawList(arg0_8)
	var0_0.arrowList = {}

	for iter0_8 = 1, arg0_8 do
		local var0_8 = 4 * math.random()

		if var0_8 < 1 then
			table.insert(var0_0.arrowList, ToLoveGameConst.arrowUp)
		elseif var0_8 < 2 then
			table.insert(var0_0.arrowList, ToLoveGameConst.arrowDown)
		elseif var0_8 < 3 then
			table.insert(var0_0.arrowList, ToLoveGameConst.arrowLeft)
		else
			table.insert(var0_0.arrowList, ToLoveGameConst.arrowRight)
		end
	end
end

function var0_0.GetSafeCellPosition(arg0_9)
	local var0_9 = Clone(var0_0.previousPlayerPosition)

	if arg0_9 == ToLoveGameConst.arrowUp then
		var0_9[1] = var0_0.previousPlayerPosition[1] - 1

		if var0_9[1] == 0 then
			var0_9[1] = 5
		end
	elseif arg0_9 == ToLoveGameConst.arrowDown then
		var0_9[1] = var0_0.previousPlayerPosition[1] + 1

		if var0_9[1] == 6 then
			var0_9[1] = 1
		end
	elseif arg0_9 == ToLoveGameConst.arrowLeft then
		var0_9[2] = var0_0.previousPlayerPosition[2] - 1

		if var0_9[2] == 0 then
			var0_9[2] = 5
		end
	elseif arg0_9 == ToLoveGameConst.arrowRight then
		var0_9[2] = var0_0.previousPlayerPosition[2] + 1

		if var0_9[2] == 6 then
			var0_9[2] = 1
		end
	end

	return var0_9
end

function var0_0.GetBuffList(arg0_10)
	local var0_10 = Clone(ToLoveGameConst.buffList)

	var0_10[1][1] = i18n("tolovegame_buff_name_1")
	var0_10[2][1] = i18n("tolovegame_buff_name_2")
	var0_10[3][1] = i18n("tolovegame_buff_name_3")
	var0_10[4][1] = i18n("tolovegame_buff_name_4")
	var0_10[5][1] = i18n("tolovegame_buff_name_5")
	var0_10[6][1] = i18n("tolovegame_buff_name_6")
	var0_10[7][1] = i18n("tolovegame_buff_name_7")

	table.insert(var0_10[1], i18n("tolovegame_buff_desc_1"))
	table.insert(var0_10[2], i18n("tolovegame_buff_desc_2"))
	table.insert(var0_10[3], i18n("tolovegame_buff_desc_3"))
	table.insert(var0_10[4], i18n("tolovegame_buff_desc_4"))
	table.insert(var0_10[5], i18n("tolovegame_buff_desc_5"))
	table.insert(var0_10[6], i18n("tolovegame_buff_desc_6"))
	table.insert(var0_10[7], i18n("tolovegame_buff_desc_7"))

	local var1_10 = arg0_10:getConfig("act_id")
	local var2_10 = pg.activity_template[var1_10].time

	if type(var2_10) == "table" then
		local var3_10 = pg.TimeMgr.GetInstance():GetServerTime()
		local var4_10 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var2_10[2])
		local var5_10 = 3600
		local var6_10 = 86400

		for iter0_10 = 1, #var0_10 do
			local var7_10 = math.floor((var4_10 + (iter0_10 - 1) * var6_10 - var3_10) / var6_10)
			local var8_10 = math.floor((var4_10 + (iter0_10 - 1) * var6_10 - var3_10) % var6_10 / var5_10)

			if var4_10 + (iter0_10 - 1) * var6_10 - var3_10 > 0 then
				if var7_10 > 0 then
					table.insert(var0_10[iter0_10], i18n("tolovegame_lock_1", var7_10, var8_10))
				else
					table.insert(var0_10[iter0_10], i18n("tolovegame_lock_2", var8_10))
				end
			else
				table.insert(var0_10[iter0_10], "")
			end
		end
	else
		for iter1_10 = 1, #var0_10 do
			table.insert(var0_10[iter1_10], "")
		end
	end

	return var0_10
end

function var0_0.GetScoreMultiplyRate()
	local var0_11 = 1

	for iter0_11, iter1_11 in ipairs(ToLoveGameConst.scoreMultiplyRate) do
		if var0_0.gameTime >= ToLoveGameConst.scoreMultiplyTimes[iter0_11] then
			return iter1_11
		end
	end
end

function var0_0.ShouldShowTip()
	local var0_12 = getProxy(MiniGameProxy):GetHubByGameId(69)
	local var1_12 = var0_12.count > 0
	local var2_12 = false
	local var3_12 = 0
	local var4_12 = var0_0.GetBuffList(var0_12)

	for iter0_12, iter1_12 in ipairs(var4_12) do
		if iter1_12[3] == "" then
			var3_12 = var3_12 + 1
		end
	end

	if var3_12 ~= PlayerPrefs.GetInt("toLoveGameBuffCount", 0) then
		var2_12 = true
	end

	local var5_12 = false
	local var6_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.TOLOVE_MINIGAME_TASK_ID):getConfig("config_client").task_ids

	for iter2_12, iter3_12 in pairs(var6_12) do
		if getProxy(TaskProxy):getTaskVO(iter3_12):getTaskStatus() == 1 then
			var5_12 = true

			break
		end
	end

	if var1_12 or var2_12 or var5_12 then
		return true
	end

	return false
end

return var0_0
