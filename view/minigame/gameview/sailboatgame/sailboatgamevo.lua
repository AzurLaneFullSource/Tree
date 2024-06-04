local var0 = class("SailBoatGameVo")

var0.game_id = nil
var0.hub_id = nil
var0.total_times = nil
var0.drop = nil
var0.menu_bgm = "theme-SeaAndSun-image"
var0.game_bgm = "theme-tempest-up"
var0.game_time = 120
var0.rule_tip = "sail_boat_minigame_help"
var0.frameRate = Application.targetFrameRate or 60
var0.ui_atlas = "ui/minigameui/sailboatgameui_atlas"
var0.game_ui = "SailBoatGameUI"
var0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0.SFX_SOUND_FIRE = "event:/ui/kaipao"
var0.SFX_SOUND_BOOM = "event:/ui/baozha3"
var0.SFX_SOUND_SKILL = "event:/ui/chongneng"
var0.SFX_SOUND_ITEM = "event:/ui/mini_shine"
var0.use_direct_round = nil
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

function var0.CheckRectCollider(arg0, arg1, arg2, arg3)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = arg2.width
	local var3 = arg2.height
	local var4 = arg1.x
	local var5 = arg1.y
	local var6 = arg3.width
	local var7 = arg3.height

	if var4 <= var0 and var0 >= var4 + var6 then
		return false
	elseif var0 <= var4 and var4 >= var0 + var2 then
		return false
	elseif var5 <= var1 and var1 >= var5 + var7 then
		return false
	elseif var1 <= var5 and var5 >= var1 + var3 then
		return false
	else
		return true
	end
end

var0.char_id = 1
var0.char_weapons = {
	{},
	{}
}
var0.char_start_pos = Vector2(0, 0)
var0.char_speed = Vector2(300, 300)
var0.char_speed_rate = 1
var0.scene_speed = 60
var0.scene_direct = Vector2(0, -1)
var0.scene_width = 1920
var0.scene_height = 1080
var0.fill_offsetX = 200
var0.fill_offsetY = 100
var0.skillTime = 10
var0.collider_time = 1
var0.colliderDamage = 5
var0.fire_step = 10
var0.bullet_step = 3
var0.item_move_speed = Vector2(1000, 0)
var0.scoreNum = 0
var0.joyStickData = nil
var0.moveAmount = nil
var0.roundData = nil
var0.sceneSpeed = nil
var0.equips = {}
var0.skill = 0
var0.selectRound = nil

function var0.Prepare()
	var0.gameTime = var0.game_time
	var0.gameStepTime = 0
	var0.scoreNum = 0
	var0.moveAmount = Vector2(var0.scene_direct.x * var0.scene_speed, var0.scene_direct.y * var0.scene_speed)
	var0.roundData = SailBoatGameConst.game_round[var0.GetGameRound()]
	var0.sceneSpeed = Vector2(0, 0)
	var0.skill = 1
end

function var0.SetGameTpl(arg0)
	var0.tpl = arg0
end

function var0.SetGameBgs(arg0)
	var0.bg = arg0
end

function var0.GetGameBg(arg0)
	return var0.bg
end

function var0.SetGameChar(arg0)
	var0.char = arg0
end

function var0.GetGameChar()
	return var0.char
end

function var0.SetGameItems(arg0)
	var0.items = arg0
end

function var0.GetBulletSprite(arg0)
	return GetSpriteFromAtlas(var0.ui_atlas, arg0)
end

function var0.GetEquipIcon(arg0)
	return GetSpriteFromAtlas(var0.ui_atlas, arg0)
end

function var0.GetBgIcon(arg0)
	return GetSpriteFromAtlas(var0.ui_atlas, arg0)
end

function var0.GetGameBullet()
	return tf(instantiate(findTF(var0.tpl, "bulletTpl")))
end

function var0.GetGameItems()
	return var0.items
end

function var0.SetGameEnemys(arg0)
	var0.enemys = arg0
end

function var0.GetGameEnemys()
	return var0.enemys
end

function var0.GetGameItemTf(arg0)
	return tf(instantiate(findTF(var0.tpl, arg0)))
end

function var0.GetGameEnemyTf(arg0)
	return tf(instantiate(findTF(var0.tpl, arg0)))
end

function var0.GetGameBgTf(arg0)
	return tf(instantiate(findTF(var0.tpl, arg0)))
end

function var0.GetGameCharTf(arg0)
	return tf(instantiate(findTF(var0.tpl, arg0)))
end

function var0.GetGameEffectTf(arg0)
	return tf(instantiate(findTF(var0.tpl, arg0)))
end

function var0.SetSceneSpeed(arg0)
	var0.sceneSpeed = arg0
end

function var0.GetSceneSpeed()
	return var0.sceneSpeed
end

function var0.AddSkill()
	var0.skill = var0.skill + 1
end

function var0.UseSkill()
	if var0.skill > 0 then
		var0.skill = var0.skill - 1

		return true
	end

	return false
end

function var0.GetSkill()
	return var0.skill
end

function var0.GetRoundData()
	return var0.roundData
end

function var0.GetRangePos(arg0, arg1)
	local var0 = Vector2(math.random(arg0[1], arg0[2]), math.random(arg1[1], arg1[2]))

	if var0.CheckDoublicat(var0) then
		local var1 = var0

		for iter0 = 1, 4 do
			var1.x = var1.x + 100

			if not var0.CheckDoublicat(var1) then
				return var1
			end
		end

		local var2 = var0

		for iter1 = 1, 4 do
			var1.x = var1.x - 100

			if not var0.CheckDoublicat(var1) then
				return var1
			end
		end

		return nil
	else
		return var0
	end
end

function var0.CheckDoublicat(arg0)
	local var0 = var0.GetGameItems()

	for iter0 = 1, #var0 do
		if var0[iter0]:checkPositionInRange(arg0) then
			return true
		end
	end

	local var1 = var0.GetGameEnemys()

	for iter1 = 1, #var1 do
		if var1[iter1]:checkPositionInRange(arg0) then
			return true
		end
	end

	return false
end

function var0.PointInRect1(arg0, arg1, arg2, arg3, arg4)
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

function var0.PointInRect2(arg0, arg1, arg2)
	if arg0.x < arg1.x or arg0.y < arg1.y then
		return false
	end

	if arg0.x > arg2.x or arg0.y > arg2.y then
		return false
	end

	return true
end

function var0.Clear()
	var0.tpl = nil
	var0.char = nil
end

return var0
