local var0_0 = class("SailBoatGameVo")

var0_0.game_id = nil
var0_0.hub_id = nil
var0_0.total_times = nil
var0_0.drop = nil
var0_0.menu_bgm = "theme-SeaAndSun-image"
var0_0.game_bgm = "theme-tempest-up"
var0_0.game_time = 120
var0_0.rule_tip = "sail_boat_minigame_help"
var0_0.frameRate = Application.targetFrameRate or 60
var0_0.ui_atlas = "ui/minigameui/sailboatgameui_atlas"
var0_0.game_ui = "SailBoatGameUI"
var0_0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0_0.SFX_SOUND_FIRE = "event:/ui/kaipao"
var0_0.SFX_SOUND_BOOM = "event:/ui/baozha3"
var0_0.SFX_SOUND_SKILL = "event:/ui/chongneng"
var0_0.SFX_SOUND_ITEM = "event:/ui/mini_shine"
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

function var0_0.CheckRectCollider(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg0_7.x
	local var1_7 = arg0_7.y
	local var2_7 = arg2_7.width
	local var3_7 = arg2_7.height
	local var4_7 = arg1_7.x
	local var5_7 = arg1_7.y
	local var6_7 = arg3_7.width
	local var7_7 = arg3_7.height

	if var4_7 <= var0_7 and var0_7 >= var4_7 + var6_7 then
		return false
	elseif var0_7 <= var4_7 and var4_7 >= var0_7 + var2_7 then
		return false
	elseif var5_7 <= var1_7 and var1_7 >= var5_7 + var7_7 then
		return false
	elseif var1_7 <= var5_7 and var5_7 >= var1_7 + var3_7 then
		return false
	else
		return true
	end
end

var0_0.char_id = 1
var0_0.char_weapons = {
	{},
	{}
}
var0_0.char_start_pos = Vector2(0, 0)
var0_0.char_speed = Vector2(300, 300)
var0_0.char_speed_rate = 1
var0_0.scene_speed = 60
var0_0.scene_direct = Vector2(0, -1)
var0_0.scene_width = 1920
var0_0.scene_height = 1080
var0_0.fill_offsetX = 200
var0_0.fill_offsetY = 100
var0_0.skillTime = 10
var0_0.collider_time = 1
var0_0.colliderDamage = 5
var0_0.fire_step = 10
var0_0.bullet_step = 3
var0_0.item_move_speed = Vector2(1000, 0)
var0_0.scoreNum = 0
var0_0.joyStickData = nil
var0_0.moveAmount = nil
var0_0.roundData = nil
var0_0.sceneSpeed = nil
var0_0.equips = {}
var0_0.skill = 0
var0_0.selectRound = nil

function var0_0.Prepare()
	var0_0.gameTime = var0_0.game_time
	var0_0.gameStepTime = 0
	var0_0.scoreNum = 0
	var0_0.moveAmount = Vector2(var0_0.scene_direct.x * var0_0.scene_speed, var0_0.scene_direct.y * var0_0.scene_speed)
	var0_0.roundData = SailBoatGameConst.game_round[var0_0.GetGameRound()]
	var0_0.sceneSpeed = Vector2(0, 0)
	var0_0.skill = 1
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

function var0_0.GetBulletSprite(arg0_15)
	return GetSpriteFromAtlas(var0_0.ui_atlas, arg0_15)
end

function var0_0.GetEquipIcon(arg0_16)
	return GetSpriteFromAtlas(var0_0.ui_atlas, arg0_16)
end

function var0_0.GetBgIcon(arg0_17)
	return GetSpriteFromAtlas(var0_0.ui_atlas, arg0_17)
end

function var0_0.GetGameBullet()
	return tf(instantiate(findTF(var0_0.tpl, "bulletTpl")))
end

function var0_0.GetGameItems()
	return var0_0.items
end

function var0_0.SetGameEnemys(arg0_20)
	var0_0.enemys = arg0_20
end

function var0_0.GetGameEnemys()
	return var0_0.enemys
end

function var0_0.GetGameItemTf(arg0_22)
	return tf(instantiate(findTF(var0_0.tpl, arg0_22)))
end

function var0_0.GetGameEnemyTf(arg0_23)
	return tf(instantiate(findTF(var0_0.tpl, arg0_23)))
end

function var0_0.GetGameBgTf(arg0_24)
	return tf(instantiate(findTF(var0_0.tpl, arg0_24)))
end

function var0_0.GetGameCharTf(arg0_25)
	return tf(instantiate(findTF(var0_0.tpl, arg0_25)))
end

function var0_0.GetGameEffectTf(arg0_26)
	return tf(instantiate(findTF(var0_0.tpl, arg0_26)))
end

function var0_0.SetSceneSpeed(arg0_27)
	var0_0.sceneSpeed = arg0_27
end

function var0_0.GetSceneSpeed()
	return var0_0.sceneSpeed
end

function var0_0.AddSkill()
	var0_0.skill = var0_0.skill + 1
end

function var0_0.UseSkill()
	if var0_0.skill > 0 then
		var0_0.skill = var0_0.skill - 1

		return true
	end

	return false
end

function var0_0.GetSkill()
	return var0_0.skill
end

function var0_0.GetRoundData()
	return var0_0.roundData
end

function var0_0.GetRangePos(arg0_33, arg1_33)
	local var0_33 = Vector2(math.random(arg0_33[1], arg0_33[2]), math.random(arg1_33[1], arg1_33[2]))

	if var0_0.CheckDoublicat(var0_33) then
		local var1_33 = var0_33

		for iter0_33 = 1, 4 do
			var1_33.x = var1_33.x + 100

			if not var0_0.CheckDoublicat(var1_33) then
				return var1_33
			end
		end

		local var2_33 = var0_33

		for iter1_33 = 1, 4 do
			var1_33.x = var1_33.x - 100

			if not var0_0.CheckDoublicat(var1_33) then
				return var1_33
			end
		end

		return nil
	else
		return var0_33
	end
end

function var0_0.CheckDoublicat(arg0_34)
	local var0_34 = var0_0.GetGameItems()

	for iter0_34 = 1, #var0_34 do
		if var0_34[iter0_34]:checkPositionInRange(arg0_34) then
			return true
		end
	end

	local var1_34 = var0_0.GetGameEnemys()

	for iter1_34 = 1, #var1_34 do
		if var1_34[iter1_34]:checkPositionInRange(arg0_34) then
			return true
		end
	end

	return false
end

function var0_0.PointInRect1(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	local var0_35
	local var1_35
	local var2_35
	local var3_35
	local var4_35
	local var5_35
	local var6_35 = var0_0.Sign(arg0_35, arg1_35, arg2_35)
	local var7_35 = var0_0.Sign(arg0_35, arg2_35, arg3_35)
	local var8_35 = var0_0.Sign(arg0_35, arg3_35, arg4_35)
	local var9_35 = var0_0.Sign(arg0_35, arg4_35, arg1_35)
	local var10_35 = var6_35 < 0 or var7_35 < 0 or var8_35 < 0 or var9_35 < 0
	local var11_35 = var6_35 > 0 or var7_35 > 0 or var8_35 > 0 or var9_35 > 0

	return not var10_35 or not var11_35
end

function var0_0.PointInRect2(arg0_36, arg1_36, arg2_36)
	if arg0_36.x < arg1_36.x or arg0_36.y < arg1_36.y then
		return false
	end

	if arg0_36.x > arg2_36.x or arg0_36.y > arg2_36.y then
		return false
	end

	return true
end

function var0_0.Clear()
	var0_0.tpl = nil
	var0_0.char = nil
end

return var0_0
