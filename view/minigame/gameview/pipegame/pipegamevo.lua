local var0_0 = class("PipeGameVo")

var0_0.game_id = nil
var0_0.hub_id = nil
var0_0.total_times = nil
var0_0.drop = nil
var0_0.menu_bgm = "story-richang-3"
var0_0.game_bgm = "story-richang-3"
var0_0.game_time = 2400000
var0_0.rule_tip = "pipe_minigame_help"
var0_0.rank_tip = "pipe_minigame_rank"
var0_0.game_drag_time = 300
var0_0.frameRate = Application.targetFrameRate or 60
var0_0.ui_atlas = "ui/minigameui/pipegameui_atlas"
var0_0.game_ui = "PipeGameUI"
var0_0.game_room_ui = "GameRoomPipeUI"
var0_0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0_0.SFX_SOUND_FIRE = "event:/ui/kaipao"
var0_0.SFX_SOUND_BOOM = "event:/ui/baozha3"
var0_0.SFX_SOUND_SKILL = "event:/ui/chongneng"
var0_0.SFX_SOUND_ITEM = "event:/ui/mini_shine"
var0_0.use_direct_round = nil
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

function var0_0.GetGameTimes()
	return var0_0.GetMiniGameHubData().count
end

function var0_0.GetGameUseTimes()
	return var0_0.GetMiniGameHubData().usedtime or 0
end

function var0_0.GetGameRound()
	if var0_0.use_direct_round ~= nil then
		return var0_0.use_direct_round
	end

	if var0_0.selectRound ~= nil then
		return var0_0.selectRound
	end

	local var0_4 = var0_0.GetGameUseTimes()
	local var1_4 = var0_0.GetGameTimes()

	if var1_4 and var1_4 > 0 then
		return var0_4 + 1
	end

	if var0_4 and var0_4 > 0 then
		return var0_4
	end

	return 1
end

function var0_0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0_0.game_id)
end

function var0_0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0_0.hub_id)
end

var0_0.scoreNum = 0
var0_0.roundData = nil
var0_0.selectRound = nil
var0_0.tplItemPool = {}
var0_0.draging = false
var0_0.dragScreenPos = Vector2(0, 0)
var0_0.dragItem = nil
var0_0.gameDragTime = nil
var0_0.startSettlement = false

function var0_0.Prepare()
	var0_0.gameTime = var0_0.game_time
	var0_0.gameDragTime = var0_0.game_drag_time
	var0_0.gameStepTime = 0
	var0_0.scoreNum = 0
	var0_0.draging = false
	var0_0.dragScreenPos = Vector2(0, 0)
	var0_0.dragItem = nil
	var0_0.roundData = PipeGameConst.game_round[var0_0.GetGameRound()]
	var0_0.sceneSpeed = Vector2(0, 0)
	var0_0.startSettlement = false
end

function var0_0.SetGameTpl(arg0_8)
	var0_0.tpl = arg0_8
end

function var0_0.GetTplItemFromPool(arg0_9, arg1_9)
	if not arg1_9 then
		return nil
	end

	if var0_0.tplItemPool[arg0_9] == nil then
		var0_0.tplItemPool[arg0_9] = {}
	end

	if #var0_0.tplItemPool[arg0_9] == 0 then
		local var0_9 = tf(instantiate(findTF(var0_0.tpl, arg0_9)))

		setParent(var0_9, arg1_9)

		return var0_9
	else
		return table.remove(var0_0.tplItemPool[arg0_9], #var0_0.tplItemPool[arg0_9])
	end
end

function var0_0.RetTplItem(arg0_10, arg1_10)
	if var0_0.tplItemPool[arg0_10] == nil then
		var0_0.tplItemPool[arg0_10] = {}
	end

	table.insert(var0_0.tplItemPool[arg0_10], arg1_10)
end

function var0_0.GetSprite(arg0_11)
	return GetSpriteFromAtlas(var0_0.ui_atlas, arg0_11)
end

function var0_0.GetResultLevel()
	if not var0_0.scoreNum or var0_0.scoreNum == 0 then
		return 1
	end

	for iter0_12 = #PipeGameConst.game_result_level, 1, -1 do
		if var0_0.scoreNum >= PipeGameConst.game_result_level[iter0_12] then
			return iter0_12
		end
	end

	return 1
end

function var0_0.GetRoundData()
	return var0_0.roundData
end

function var0_0.Clear()
	var0_0.tpl = nil
	var0_0.char = nil
end

return var0_0
