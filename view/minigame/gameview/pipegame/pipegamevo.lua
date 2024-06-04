local var0 = class("PipeGameVo")

var0.game_id = nil
var0.hub_id = nil
var0.total_times = nil
var0.drop = nil
var0.menu_bgm = "story-richang-3"
var0.game_bgm = "story-richang-3"
var0.game_time = 2400000
var0.rule_tip = "pipe_minigame_help"
var0.rank_tip = "pipe_minigame_rank"
var0.game_drag_time = 300
var0.frameRate = Application.targetFrameRate or 60
var0.ui_atlas = "ui/pipegameui_atlas"
var0.game_ui = "PipeGameUI"
var0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0.SFX_SOUND_FIRE = "event:/ui/kaipao"
var0.SFX_SOUND_BOOM = "event:/ui/baozha3"
var0.SFX_SOUND_SKILL = "event:/ui/chongneng"
var0.SFX_SOUND_ITEM = "event:/ui/mini_shine"
var0.use_direct_round = nil
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

function var0.GetGameTimes()
	return var0.GetMiniGameHubData().count
end

function var0.GetGameUseTimes()
	return var0.GetMiniGameHubData().usedtime or 0
end

function var0.GetGameRound()
	if var0.use_direct_round ~= nil then
		return var0.use_direct_round
	end

	if var0.selectRound ~= nil then
		return var0.selectRound
	end

	local var0 = var0.GetGameUseTimes()
	local var1 = var0.GetGameTimes()

	if var1 and var1 > 0 then
		return var0 + 1
	end

	if var0 and var0 > 0 then
		return var0
	end

	return 1
end

function var0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0.game_id)
end

function var0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0.hub_id)
end

var0.scoreNum = 0
var0.roundData = nil
var0.selectRound = nil
var0.tplItemPool = {}
var0.draging = false
var0.dragScreenPos = Vector2(0, 0)
var0.dragItem = nil
var0.gameDragTime = nil
var0.startSettlement = false

function var0.Prepare()
	var0.gameTime = var0.game_time
	var0.gameDragTime = var0.game_drag_time
	var0.gameStepTime = 0
	var0.scoreNum = 0
	var0.draging = false
	var0.dragScreenPos = Vector2(0, 0)
	var0.dragItem = nil
	var0.roundData = PipeGameConst.game_round[var0.GetGameRound()]
	var0.sceneSpeed = Vector2(0, 0)
	var0.startSettlement = false
end

function var0.SetGameTpl(arg0)
	var0.tpl = arg0
end

function var0.GetTplItemFromPool(arg0, arg1)
	if not arg1 then
		return nil
	end

	if var0.tplItemPool[arg0] == nil then
		var0.tplItemPool[arg0] = {}
	end

	if #var0.tplItemPool[arg0] == 0 then
		local var0 = tf(instantiate(findTF(var0.tpl, arg0)))

		setParent(var0, arg1)

		return var0
	else
		return table.remove(var0.tplItemPool[arg0], #var0.tplItemPool[arg0])
	end
end

function var0.RetTplItem(arg0, arg1)
	if var0.tplItemPool[arg0] == nil then
		var0.tplItemPool[arg0] = {}
	end

	table.insert(var0.tplItemPool[arg0], arg1)
end

function var0.GetSprite(arg0)
	return GetSpriteFromAtlas(var0.ui_atlas, arg0)
end

function var0.GetResultLevel()
	if not var0.scoreNum or var0.scoreNum == 0 then
		return 1
	end

	for iter0 = #PipeGameConst.game_result_level, 1, -1 do
		if var0.scoreNum >= PipeGameConst.game_result_level[iter0] then
			return iter0
		end
	end

	return 1
end

function var0.GetRoundData()
	return var0.roundData
end

function var0.Clear()
	var0.tpl = nil
	var0.char = nil
end

return var0
