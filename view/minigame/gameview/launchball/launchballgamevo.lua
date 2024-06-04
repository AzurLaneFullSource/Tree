local var0 = class("LaunchBallGameVo")

var0.game_id = nil
var0.hub_id = nil
var0.total_times = nil
var0.drop = nil
var0.game_bgm = "cw-story"
var0.game_time = 60000
var0.rule_tip = "launchball_minigame_help"
var0.frameRate = Application.targetFrameRate or 60
var0.ui_atlas = "ui/minigameui/launchballgameui_atlas"
var0.game_ui = "LaunchBallGameUI"
var0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0.launchball_minigame_select = "launchball_minigame_select"
var0.launchball_minigame_un_select = "launchball_minigame_un_select"
var0.SFX_PRESS_SKILL = "ui-maoudamashii"
var0.SFX_FIRE = "ui-mini_throw"
var0.SFX_ENEMY_REMOVE = "ui-mini_pigu"
var0.enemyToEndRate = nil
var0.gameTime = 0
var0.gameStepTime = 0
var0.deltaTime = 0

function var0.Init(arg0, arg1)
	var0.game_id = arg0
	var0.hub_id = arg1
	var0.total_times = pg.mini_game_hub[var0.hub_id]
	var0.drop = pg.mini_game[var0.game_id].simple_config_data.drop_ids
	var0.total_times = pg.mini_game_hub[var0.hub_id].reward_need
end

function var0.initRoundData(arg0, arg1)
	local var0 = LaunchBallGameConst.game_round

	for iter0, iter1 in pairs(var0) do
		if iter1.type == arg0 and iter1.type_index == arg1 then
			var0.gameRoundData = iter1

			if iter1.player_id then
				var0.SetPlayer(iter1.player_id)
			end
		end
	end
end

function var0.SetPlayer(arg0)
	var0.selectPlayer = arg0
end

function var0.GetGameTimes()
	return var0.GetMiniGameHubData().count
end

function var0.GetGameUseTimes()
	return var0.GetMiniGameHubData().usedtime or 0
end

function var0.GetGameRound()
	local var0 = var0.GetGameUseTimes()
	local var1 = var0.GetGameTimes()

	if var1 and var1 > 0 then
		return var0 + 1
	else
		return var0
	end
end

function var0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0.game_id)
end

function var0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0.hub_id)
end

var0.scoreNum = 0
var0.joyStickData = nil
var0.amulet = nil
var0.gameRoundData = nil
var0.selectPlayer = nil
var0.pressSkill = nil
var0.buffs = nil
var0.base_score = 10
var0.series_score = 10
var0.enemyColors = {}
var0.enemyStopTime = nil

function var0.Prepare()
	var0.gameTime = var0.game_time
	var0.gameStepTime = 0
	var0.scoreNum = 0
	var0.enemyStopTime = nil
	var0.gameResultData = {
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

var0.result_split_count = "split_count"
var0.result_round = "round"
var0.result_player = "player"
var0.result_series_count = "series_count"
var0.result_over_count = "over_count"
var0.result_many_count = "many_count"
var0.result_mix_count = "mix_count"
var0.result_use_skill = "use_skill"
var0.result_use_pass_skill = "use_pass_skill"
var0.result_skill_count = "skill_count"
var0.result_pass_skill_count = "pass_skill_count"
var0.reuslt_double_skill_time = "double_skill_time"
var0.reuslt_double_pass_skill_time = "double_pass_skill_time"

function var0.UpdateGameResultData(arg0, arg1)
	print(arg0 .. "  update count  = " .. arg1)

	if arg0 == var0.reuslt_double_skill_time then
		arg1 = math.floor(arg1)

		if var0.gameResultData[arg0] ~= 0 then
			if arg1 < var0.gameResultData[arg0] then
				var0.gameResultData[arg0] = arg1
			end
		else
			var0.gameResultData[arg0] = arg1
		end
	elseif arg0 == var0.result_skill_count then
		if var0.gameResultData[arg0] and arg1 > var0.gameResultData[arg0] then
			var0.gameResultData[arg0] = arg1
		end
	else
		var0.gameResultData[arg0] = arg1
	end
end

function var0.AddGameResultData(arg0, arg1)
	var0.gameResultData[arg0] = var0.gameResultData[arg0] + arg1
end

function var0.GetBuff(arg0)
	if var0.buffs and #var0.buffs > 0 then
		for iter0, iter1 in ipairs(var0.buffs) do
			if iter1.data.type == arg0 then
				return iter1
			end
		end
	end

	return nil
end

function var0.GetScore(arg0, arg1, arg2, arg3)
	local var0 = 0
	local var1 = arg0 * var0.base_score

	if arg3 and arg3 > 0 then
		var1 = var1 + arg3 * var0.base_score
	end

	if arg2 then
		var1 = var1 + var0.base_score
	end

	if arg0 > 3 then
		var1 = var1 + (arg0 - 3) * 10
	end

	if arg1 > 1 then
		var1 = var1 + (arg1 - 1) * var0.series_score
	end

	return var1
end

function var0.Sign(arg0, arg1, arg2)
	return (arg0.x - arg2.x) * (arg1.y - arg2.y) - (arg1.x - arg2.x) * (arg0.y - arg2.y)
end

function var0.PointInRect(arg0, arg1, arg2, arg3, arg4)
	local var0
	local var1
	local var2
	local var3
	local var4
	local var5
	local var6 = var0.Sign(arg0, arg1, arg2)
	local var7 = var0.Sign(arg0, arg2, arg3)
	local var8 = var0.Sign(arg0, arg3, arg4)
	local var9 = var0.Sign(arg0, arg4, arg1)
	local var10 = var6 < 0 or var7 < 0 or var8 < 0 or var9 < 0
	local var11 = var6 > 0 or var7 > 0 or var8 > 0 or var9 > 0

	return not var10 or not var11
end

return var0
