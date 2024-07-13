local var0_0 = class("LaunchBallGameVo")

var0_0.game_id = nil
var0_0.hub_id = nil
var0_0.total_times = nil
var0_0.drop = nil
var0_0.game_bgm = "cw-story"
var0_0.game_time = 60000
var0_0.rule_tip = "launchball_minigame_help"
var0_0.frameRate = Application.targetFrameRate or 60
var0_0.ui_atlas = "ui/minigameui/launchballgameui_atlas"
var0_0.game_ui = "LaunchBallGameUI"
var0_0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0_0.launchball_minigame_select = "launchball_minigame_select"
var0_0.launchball_minigame_un_select = "launchball_minigame_un_select"
var0_0.SFX_PRESS_SKILL = "ui-maoudamashii"
var0_0.SFX_FIRE = "ui-mini_throw"
var0_0.SFX_ENEMY_REMOVE = "ui-mini_pigu"
var0_0.enemyToEndRate = nil
var0_0.gameTime = 0
var0_0.gameStepTime = 0
var0_0.deltaTime = 0

function var0_0.Init(arg0_1, arg1_1)
	var0_0.game_id = arg0_1
	var0_0.hub_id = arg1_1
	var0_0.total_times = pg.mini_game_hub[var0_0.hub_id]
	var0_0.drop = pg.mini_game[var0_0.game_id].simple_config_data.drop_ids
	var0_0.total_times = pg.mini_game_hub[var0_0.hub_id].reward_need
end

function var0_0.initRoundData(arg0_2, arg1_2)
	local var0_2 = LaunchBallGameConst.game_round

	for iter0_2, iter1_2 in pairs(var0_2) do
		if iter1_2.type == arg0_2 and iter1_2.type_index == arg1_2 then
			var0_0.gameRoundData = iter1_2

			if iter1_2.player_id then
				var0_0.SetPlayer(iter1_2.player_id)
			end
		end
	end
end

function var0_0.SetPlayer(arg0_3)
	var0_0.selectPlayer = arg0_3
end

function var0_0.GetGameTimes()
	return var0_0.GetMiniGameHubData().count
end

function var0_0.GetGameUseTimes()
	return var0_0.GetMiniGameHubData().usedtime or 0
end

function var0_0.GetGameRound()
	local var0_6 = var0_0.GetGameUseTimes()
	local var1_6 = var0_0.GetGameTimes()

	if var1_6 and var1_6 > 0 then
		return var0_6 + 1
	else
		return var0_6
	end
end

function var0_0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0_0.game_id)
end

function var0_0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0_0.hub_id)
end

var0_0.scoreNum = 0
var0_0.joyStickData = nil
var0_0.amulet = nil
var0_0.gameRoundData = nil
var0_0.selectPlayer = nil
var0_0.pressSkill = nil
var0_0.buffs = nil
var0_0.base_score = 10
var0_0.series_score = 10
var0_0.enemyColors = {}
var0_0.enemyStopTime = nil

function var0_0.Prepare()
	var0_0.gameTime = var0_0.game_time
	var0_0.gameStepTime = 0
	var0_0.scoreNum = 0
	var0_0.enemyStopTime = nil
	var0_0.gameResultData = {
		mix_count = 0,
		skill_count = 0,
		use_pass_skill = 0,
		pass_skill_count = 0,
		double_pass_skill_time = 0,
		many_count = 0,
		round = 0,
		player = 0,
		double_skill_time = 0,
		use_skill = 0,
		series_count = 0,
		split_count = 0,
		over_count = 0
	}
end

var0_0.result_split_count = "split_count"
var0_0.result_round = "round"
var0_0.result_player = "player"
var0_0.result_series_count = "series_count"
var0_0.result_over_count = "over_count"
var0_0.result_many_count = "many_count"
var0_0.result_mix_count = "mix_count"
var0_0.result_use_skill = "use_skill"
var0_0.result_use_pass_skill = "use_pass_skill"
var0_0.result_skill_count = "skill_count"
var0_0.result_pass_skill_count = "pass_skill_count"
var0_0.reuslt_double_skill_time = "double_skill_time"
var0_0.reuslt_double_pass_skill_time = "double_pass_skill_time"

function var0_0.UpdateGameResultData(arg0_10, arg1_10)
	print(arg0_10 .. "  update count  = " .. arg1_10)

	if arg0_10 == var0_0.reuslt_double_skill_time then
		arg1_10 = math.floor(arg1_10)

		if var0_0.gameResultData[arg0_10] ~= 0 then
			if arg1_10 < var0_0.gameResultData[arg0_10] then
				var0_0.gameResultData[arg0_10] = arg1_10
			end
		else
			var0_0.gameResultData[arg0_10] = arg1_10
		end
	elseif arg0_10 == var0_0.result_skill_count then
		if var0_0.gameResultData[arg0_10] and arg1_10 > var0_0.gameResultData[arg0_10] then
			var0_0.gameResultData[arg0_10] = arg1_10
		end
	else
		var0_0.gameResultData[arg0_10] = arg1_10
	end
end

function var0_0.AddGameResultData(arg0_11, arg1_11)
	var0_0.gameResultData[arg0_11] = var0_0.gameResultData[arg0_11] + arg1_11
end

function var0_0.GetBuff(arg0_12)
	if var0_0.buffs and #var0_0.buffs > 0 then
		for iter0_12, iter1_12 in ipairs(var0_0.buffs) do
			if iter1_12.data.type == arg0_12 then
				return iter1_12
			end
		end
	end

	return nil
end

function var0_0.GetScore(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = 0
	local var1_13 = arg0_13 * var0_0.base_score

	if arg3_13 and arg3_13 > 0 then
		var1_13 = var1_13 + arg3_13 * var0_0.base_score
	end

	if arg2_13 then
		var1_13 = var1_13 + var0_0.base_score
	end

	if arg0_13 > 3 then
		var1_13 = var1_13 + (arg0_13 - 3) * 10
	end

	if arg1_13 > 1 then
		var1_13 = var1_13 + (arg1_13 - 1) * var0_0.series_score
	end

	return var1_13
end

function var0_0.Sign(arg0_14, arg1_14, arg2_14)
	return (arg0_14.x - arg2_14.x) * (arg1_14.y - arg2_14.y) - (arg1_14.x - arg2_14.x) * (arg0_14.y - arg2_14.y)
end

function var0_0.PointInRect(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15
	local var1_15
	local var2_15
	local var3_15
	local var4_15
	local var5_15
	local var6_15 = var0_0.Sign(arg0_15, arg1_15, arg2_15)
	local var7_15 = var0_0.Sign(arg0_15, arg2_15, arg3_15)
	local var8_15 = var0_0.Sign(arg0_15, arg3_15, arg4_15)
	local var9_15 = var0_0.Sign(arg0_15, arg4_15, arg1_15)
	local var10_15 = var6_15 < 0 or var7_15 < 0 or var8_15 < 0 or var9_15 < 0
	local var11_15 = var6_15 > 0 or var7_15 > 0 or var8_15 > 0 or var9_15 > 0

	return not var10_15 or not var11_15
end

return var0_0
