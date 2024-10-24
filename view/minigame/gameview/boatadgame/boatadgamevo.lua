local var0_0 = class("BoatAdGameVo")

var0_0.game_id = nil
var0_0.hub_id = nil
var0_0.total_times = nil
var0_0.drop = nil
var0_0.menu_bgm = "theme-tempest"
var0_0.game_bgm = "story-temepest-2"
var0_0.rule_tip = "BoatAdGame_minigame_help"
var0_0.frameRate = Application.targetFrameRate or 60
var0_0.ui_atlas = "ui/minigameui/boatadgameui_atlas"
var0_0.game_ui = "BoatAdGameUI"
var0_0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0_0.SFX_SOUND_SHIBAI = "event:/ui/shibai"
var0_0.SFX_SOUND_GREAT = "event:/ui/mini_great"
var0_0.SFX_SOUND_PERFECT = "event:/ui/mini_perfect"
var0_0.SFX_SOUND_BATTLE = "event:/ui/minigame_hitwood"
var0_0.use_direct_round = nil
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

function var0_0.GetGameMaxTimes()
	return var0_0.GetMiniGameHubData():getConfig("reward_need")
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

	local var0_5 = var0_0.GetGameUseTimes()
	local var1_5 = var0_0.GetGameTimes()

	if var1_5 == 0 and var0_5 == 7 then
		return 8
	end

	if var1_5 and var1_5 > 0 then
		return var0_5 + 1
	end

	if var0_5 and var0_5 > 0 then
		return var0_5
	end

	return 1
end

function var0_0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0_0.game_id)
end

function var0_0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0_0.hub_id)
end

var0_0.char_id = 1
var0_0.scene_width = 1920
var0_0.scene_height = 1080
var0_0.collider_time = 1
var0_0.colliderDamage = 5
var0_0.scoreNum = 0
var0_0.joyStickData = nil
var0_0.roundData = nil
var0_0.selectRound = nil
var0_0.items = {}
var0_0.enemys = {}
var0_0.isEndLessRound = false

function var0_0.Prepare()
	local var0_8 = var0_0.GetGameRound()

	var0_0.gameTime = BoatAdGameConst.game_time[var0_8]
	var0_0.gameStepTime = 0
	var0_0.scoreNum = 0
	var0_0.isEndLessRound = var0_0.gameTime > 10000
	var0_0.roundData = BoatAdGameConst.game_round[var0_8]
end

function var0_0.SetGameTpl(arg0_9)
	var0_0.tpl = arg0_9
end

function var0_0.SetGameBgs(arg0_10)
	var0_0.bg = arg0_10
end

function var0_0.GetGameBg(arg0_11)
	return var0_0.bg
end

function var0_0.SetGameChar(arg0_12)
	var0_0.char = arg0_12
end

function var0_0.GetGameChar()
	return var0_0.char
end

function var0_0.SetGameItems(arg0_14)
	var0_0.items = arg0_14
end

function var0_0.GetGameItems()
	return var0_0.items
end

function var0_0.SetGameEnemys(arg0_16)
	var0_0.enemys = arg0_16
end

function var0_0.GetGameEnemys()
	return var0_0.enemys
end

function var0_0.GetGameTplTf(arg0_18)
	return tf(instantiate(findTF(var0_0.tpl, arg0_18)))
end

function var0_0.getUltimate(arg0_19, arg1_19)
	return arg1_19.ultimate
end

function var0_0.GetRoundData()
	return var0_0.roundData
end

function var0_0.PointInRect1(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	local var0_21
	local var1_21
	local var2_21
	local var3_21
	local var4_21
	local var5_21
	local var6_21 = var0_0.Sign(arg0_21, arg1_21, arg2_21)
	local var7_21 = var0_0.Sign(arg0_21, arg2_21, arg3_21)
	local var8_21 = var0_0.Sign(arg0_21, arg3_21, arg4_21)
	local var9_21 = var0_0.Sign(arg0_21, arg4_21, arg1_21)
	local var10_21 = var6_21 < 0 or var7_21 < 0 or var8_21 < 0 or var9_21 < 0
	local var11_21 = var6_21 > 0 or var7_21 > 0 or var8_21 > 0 or var9_21 > 0

	return not var10_21 or not var11_21
end

function var0_0.PointInRect2(arg0_22, arg1_22, arg2_22)
	if arg0_22.x < arg1_22.x or arg0_22.y < arg1_22.y then
		return false
	end

	if arg0_22.x > arg2_22.x or arg0_22.y > arg2_22.y then
		return false
	end

	return true
end

function var0_0.SetMovePoint(arg0_23, arg1_23, arg2_23, arg3_23)
	var0_0.lpt1 = arg0_23
	var0_0.lpt2 = arg1_23
	var0_0.rtp1 = arg2_23
	var0_0.rtp2 = arg3_23
end

function var0_0.CheckPointOutLeftLine(arg0_24)
	return var0_0.PointLeftLine(arg0_24, var0_0.lpt1, var0_0.lpt2)
end

function var0_0.CheckPointOutRightLine(arg0_25)
	return var0_0.PointRightLine(arg0_25, var0_0.rtp1, var0_0.rtp2)
end

function var0_0.PointLeftLine(arg0_26, arg1_26, arg2_26)
	return (arg2_26.x - arg1_26.x) * (arg0_26.y - arg1_26.y) - (arg2_26.y - arg1_26.y) * (arg0_26.x - arg1_26.x) < 0
end

function var0_0.PointRightLine(arg0_27, arg1_27, arg2_27)
	return (arg2_27.x - arg1_27.x) * (arg0_27.y - arg1_27.y) - (arg2_27.y - arg1_27.y) * (arg0_27.x - arg1_27.x) > 0
end

function var0_0.CheckRectCollider(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = arg0_28.x
	local var1_28 = arg0_28.y
	local var2_28 = arg2_28.width
	local var3_28 = arg2_28.height
	local var4_28 = arg1_28.x
	local var5_28 = arg1_28.y
	local var6_28 = arg3_28.width
	local var7_28 = arg3_28.height

	if var4_28 <= var0_28 and var0_28 >= var4_28 + var6_28 then
		return false
	elseif var0_28 <= var4_28 and var4_28 >= var0_28 + var2_28 then
		return false
	elseif var5_28 <= var1_28 and var1_28 >= var5_28 + var7_28 then
		return false
	elseif var1_28 <= var5_28 and var5_28 >= var1_28 + var3_28 then
		return false
	else
		return true
	end
end

function var0_0.Clear()
	var0_0.tpl = nil
	var0_0.char = nil
end

return var0_0
