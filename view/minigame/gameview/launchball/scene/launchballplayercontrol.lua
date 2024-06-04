local var0 = class("LaunchBallPlayerControl")
local var1 = {
	{
		id = 1,
		name = "Hatsuduki",
		tpl = "Hatsuduki",
		skill = {
			1,
			2,
			3,
			4
		}
	},
	{
		id = 2,
		name = "Shinano",
		tpl = "Shinano",
		skill = {
			1,
			5,
			6
		}
	},
	{
		id = 3,
		name = "Yura",
		tpl = "Yura",
		skill = {
			1,
			7,
			8
		}
	},
	{
		id = 4,
		name = "Shimakaze",
		tpl = "Shimakaze",
		skill = {
			1,
			9,
			10
		}
	}
}
local var2 = 1
local var3 = "skill trigger"
local var4 = "skill passive"
local var5 = "skill type fire"
local var6 = "skill type press"
local var7 = "skill type passive"

var0.buff_amulet_back_time = 0.4
var0.buff_panic_fire_speed = 1
var0.buff_panic_enemy_rate = 5
var0.buff_sleep_butterfly_time = 2
var0.slash_split_time = 0.5
var0.stop_enemy_time = 10
var0.buff_amulet_back = 1
var0.buff_panic = 2
var0.buff_neglect = 3
var0.buff_sleep = 4
var0.buff_time_max = 5
var0.buff_time_slash = 6
var0.script_remove_all_enemys = "remove all enemys"
var0.script_stop_enemy = "script_stop_enemy"
var0.script_slash = "script_slash"
var0.player_skill = {
	{
		cd_time = 0.5,
		play_time = 0.25,
		weight = 1,
		name = "atk",
		type = var5,
		color = {
			1,
			2,
			3,
			4,
			5,
			6,
			7
		}
	},
	{
		cd_time = 20,
		play_time = 0.7,
		name = "player1skillA",
		skill_direct = false,
		weight = 2,
		type = var6,
		buff = {
			{
				time = 10,
				type = var0.buff_amulet_back
			}
		}
	},
	{
		cd_time = 0,
		play_time = 0,
		weight = 0,
		name = "panic",
		type = var7,
		buff = {
			{
				time = 999999,
				type = var0.buff_panic
			}
		}
	},
	{
		cd_time = 0,
		play_time = 1,
		weight = 0,
		name = "neglect",
		type = var7,
		buff = {
			{
				time = 999999,
				type = var0.buff_neglect,
				active_rule = {
					time = 10,
					play_time = 3.5,
					weight = 10
				}
			}
		}
	},
	{
		cd_time = 0,
		play_time = 1,
		weight = 0,
		name = "sleep",
		type = var7,
		buff = {
			{
				time = 999999,
				type = var0.buff_sleep,
				active_rule = {
					time = 10,
					play_time = 3,
					weight = 10
				}
			}
		}
	},
	{
		cd_time = 60,
		play_time = 1.3,
		name = "player2SkillA",
		skill_direct = false,
		weight = 2,
		type = var6,
		script = var0.script_remove_all_enemys,
		buff = {}
	},
	{
		cd_time = 22,
		play_time = 1.3,
		name = "player3SkillA",
		skill_direct = false,
		weight = 2,
		type = var6,
		script = var0.script_stop_enemy,
		buff = {}
	},
	{
		cd_time = 0,
		play_time = 0,
		weight = 0,
		name = "player3Time",
		type = var7,
		buff = {
			{
				time = 999999,
				type = var0.buff_time_max
			}
		}
	},
	{
		cd_time = 20,
		name = "player4SkillA",
		play_time = 1,
		skill_direct = true,
		script_time = 0.5,
		weight = 2,
		type = var6,
		script = var0.script_slash,
		effect = {
			distance = 200,
			name = "Slash",
			time = 0.7,
			direct = true,
			remove_time = 0.5,
			anim = "Slash"
		}
	},
	{
		cd_time = 0,
		play_time = 0,
		weight = 0,
		name = "player4SlashTime",
		type = var7,
		buff = {
			{
				time = 999999,
				type = var0.buff_time_slash
			}
		}
	}
}

local var8 = 270
local var9 = {
	{
		anim_name = "E",
		range = {
			0,
			45
		},
		direct = {
			1,
			0
		}
	},
	{
		anim_name = "N",
		range = {
			45,
			135
		},
		direct = {
			0,
			1
		}
	},
	{
		anim_name = "W",
		range = {
			135,
			225
		},
		direct = {
			-1,
			0
		}
	},
	{
		anim_name = "S",
		range = {
			225,
			315
		},
		direct = {
			0,
			-1
		}
	},
	{
		anim_name = "E",
		range = {
			315,
			360
		},
		direct = {
			1,
			0
		}
	}
}
local var10 = "Idle"
local var11 = "Buff"
local var12 = "Panic"
local var13 = "Attack"
local var14 = "Skill_A"
local var15 = "Skill_B"
local var16 = {
	{
		anim_name = "01_Yellow"
	},
	{
		anim_name = "02_Green"
	},
	{
		anim_name = "03_White"
	},
	{
		anim_name = "04_Red"
	},
	{
		anim_name = "05_Blue"
	},
	{
		anim_name = "06_Black"
	},
	{
		anim_name = "07_Purple"
	}
}

local function var17(arg0, arg1, arg2)
	local var0 = {
		ctor = function(arg0)
			arg0.playerTf = arg0
			arg0.animator = GetComponent(findTF(arg0.playerTf, "ad/anim"), typeof(Animator))
			arg0.data = arg1
			arg0.eventCall = arg2
			arg0.panicFlag = false
			arg0.directRange = Clone(var9)
			arg0.colors = Clone(var16)
			arg0.skills = {}

			for iter0 = 1, #arg1.skill do
				local var0 = var0.player_skill[arg1.skill[iter0]]

				table.insert(arg0.skills, {
					data = var0,
					time = var0.cd_time
				})
			end

			local var1 = findTF(arg0.playerTf, "ad/change")

			arg0.changeListener = GetOrAddComponent(var1, typeof(EventTriggerListener))

			arg0.changeListener:AddPointDownFunc(function(arg0, arg1)
				arg0.eventCall(LaunchBallGameScene.CHANGE_AMULET)
				arg0:changePlayerStopTime(0)
			end)
		end,
		getId = function(arg0)
			return arg0.data.id
		end,
		start = function(arg0)
			arg0.useSkillTime = nil
			arg0.buffs = {}
			arg0.angle = var8

			arg0:changePlaying(false)

			arg0.panicFlag = false
			arg0.idleAnimName = arg0:getIdleName()

			arg0:playAnim(arg0.idleAnimName)

			LaunchBallGameVo.pressSkill = arg0:getSkillByType(var6)
			LaunchBallGameVo.buffs = arg0.buffs

			for iter0 = 1, #arg0.skills do
				arg0.skills[iter0].time = arg0.skills[iter0].data.cd_time

				if arg0.skills[iter0].data.type == var7 then
					local var0 = arg0.skills[iter0].data.buff

					for iter1 = 1, #var0 do
						table.insert(arg0.buffs, {
							data = var0[iter1],
							time = var0[iter1].time
						})
					end
				end
			end

			arg0:changePlayerStopTime(0)
		end,
		step = function(arg0)
			if arg0.playTime and arg0.playTime > 0 then
				arg0.playTime = arg0.playTime - LaunchBallGameVo.deltaTime

				if arg0.playTime <= 0 then
					arg0:changePlaying(false)
				end
			end

			if arg0.randomFireTime and arg0.randomFireTime > 0 then
				arg0.randomFireTime = arg0.randomFireTime - LaunchBallGameVo.deltaTime

				if arg0.randomFireTime <= 0 then
					arg0.randomFireTime = nil

					arg0.eventCall(LaunchBallGameScene.RANDOM_FIRE, {
						num = 3,
						data = {
							[LaunchBallGameConst.amulet_buff_back] = true
						}
					})
				end
			end

			if arg0.sleepTimeTrigger and arg0.sleepTimeTrigger > 0 then
				arg0.sleepTimeTrigger = arg0.sleepTimeTrigger - LaunchBallGameVo.deltaTime

				if arg0.sleepTimeTrigger <= 0 then
					arg0.sleepTimeTrigger = nil

					arg0.eventCall(LaunchBallGameScene.SLEEP_TIME_TRIGGER)
				end
			end

			if not arg0.isPlaying then
				local var0 = arg0:getIdleName()

				if arg0.idleAnimName ~= var0 then
					arg0:playAnim(var0)

					arg0.idleAnimName = var0
				end
			end

			for iter0 = 1, #arg0.skills do
				if arg0.skills[iter0].time > 0 then
					arg0.skills[iter0].time = arg0.skills[iter0].time - LaunchBallGameVo.deltaTime

					if arg0.skills[iter0].time <= 0 then
						arg0.skills[iter0].time = 0
					end
				end
			end

			for iter1 = #arg0.buffs, 1, -1 do
				local var1 = arg0.buffs[iter1]

				if var1.time > 0 then
					var1.time = var1.time - LaunchBallGameVo.deltaTime

					if var1.time <= 0 then
						table.remove(arg0.buffs, iter1)
					end
				end
			end

			for iter2 = #arg0.buffs, 1, -1 do
				local var2 = arg0.buffs[iter2]

				if var2.data.type == var0.buff_panic then
					local var3 = false

					if LaunchBallGameVo.enemyToEndRate then
						for iter3 = 1, #LaunchBallGameVo.enemyToEndRate do
							if not var3 and LaunchBallGameVo.enemyToEndRate[iter3] > var0.buff_panic_enemy_rate then
								var3 = true
							end
						end
					end

					var2.active = var3

					if var2.active then
						local var4 = arg0:getSkillByType(var5)

						if var4.time > 0 then
							var4.time = var4.time - LaunchBallGameVo.deltaTime * var0.buff_panic_fire_speed
						end
					end
				elseif var2.data.type == var0.buff_neglect then
					arg0:updateBuffStopTime(var2)
				elseif var2.data.type == var0.buff_sleep then
					arg0:updateBuffStopTime(var2)
				else
					var2.active = true
				end
			end

			arg0:changePlayerStopTime(arg0.playerStopTime + LaunchBallGameVo.deltaTime)
		end,
		setPlayTime = function(arg0, arg1)
			if arg1 and arg1 > 0 then
				print("set play time " .. arg1)

				arg0.isPlaying = true
			else
				print("clear play time" .. arg1)

				arg0.isPlaying = false
			end

			arg0.playTime = arg1
		end,
		updateBuffStopTime = function(arg0, arg1)
			if not arg1.active and arg0.playerStopTime > arg1.data.active_rule.time then
				arg1.active = true

				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_pass_skill, 1)
				arg0:setPlayTime(arg1.data.active_rule.play_time)

				arg0.weight = arg1.data.active_rule.weight

				if arg1.data.type == var0.buff_neglect then
					arg0.randomFireTime = 1.5

					if arg0:getBuff(var0.buff_panic).active then
						arg0:playAnim("Skill_B_Panic_Start")
					else
						arg0:playAnim("Skill_B_Start")
					end
				elseif arg1.data.type == var0.buff_sleep then
					local var0 = "Trans_Sleep_" .. arg0:getDirectName(arg0.angle)

					arg0:playAnim(var0)
				end
			end

			if arg1.active and arg1.data.type == var0.buff_sleep and not arg0.sleepTimeTrigger then
				arg0.sleepTimeTrigger = var0.buff_sleep_butterfly_time
			end

			if arg1.active and arg0.playerStopTime < arg1.data.active_rule.time then
				arg1.active = false
			end
		end,
		split = function(arg0, arg1)
			if arg1.split and arg0:getBuff(var0.buff_time_slash) then
				local var0 = arg0:getSkillByType(var6)

				if var0 and var0.time > 0 then
					var0.time = var0.time - var0.slash_split_time
				end
			end
		end,
		changePlaying = function(arg0, arg1, arg2)
			if arg1 then
				arg0:setPlayTime(arg2.data.play_time)

				arg0.weight = arg2.data.weight
			else
				arg0:setPlayTime(0)

				arg0.weight = 0
			end

			if arg0.eventCall then
				arg0.eventCall(LaunchBallGameScene.PLAYING_CHANGE, arg1)
			end
		end,
		fire = function(arg0)
			local var0 = arg0:getSkillByType(var5)

			if arg0:checkSkillAble(var0) then
				arg0:changePlayerStopTime(0)

				if not LaunchBallGameVo.amulet then
					print("当前没有可以发射的符咒")

					return
				end

				arg0:appearSkill(var0)
			end
		end,
		getSkillByType = function(arg0, arg1)
			for iter0 = 1, #arg0.skills do
				local var0 = arg0.skills[iter0]

				if var0.data.type == arg1 then
					return var0
				end
			end

			return nil
		end,
		checkSkillAble = function(arg0, arg1)
			if arg1.time > 0 then
				print("还在cd中 cd = " .. arg1.time)

				return false
			end

			if arg0.isPlaying and arg1.data.weight <= arg0.weight then
				print("权重不够无法覆盖当前的技能")

				return false
			end

			return true
		end,
		appearSkill = function(arg0, arg1)
			arg0:changePlayerStopTime(0)
			arg0:changePlaying(true, arg1)

			arg1.time = arg1.data.cd_time

			if arg1.data.type == var5 then
				local var0 = LaunchBallGameVo.amulet.color
				local var1 = arg0:getSkillAnimName(arg1, var0)

				arg0:playAnim(var1)
				arg0.eventCall(LaunchBallGameScene.FIRE_AMULET)
			elseif arg1.data.type == var6 then
				print("使用了主动技能")

				local var2 = arg0:getSkillAnimName(arg1)

				arg0:playAnim(var2)

				arg0.idleAnimName = nil

				if arg0.useSkillTime then
					local var3 = LaunchBallGameVo.gameStepTime - arg0.useSkillTime

					LaunchBallGameVo.UpdateGameResultData(LaunchBallGameVo.reuslt_double_skill_time, var3)
				else
					arg0.useSkillTime = LaunchBallGameVo.gameStepTime
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_PRESS_SKILL)
				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_skill, 1)
			end

			local var4 = arg1.data.buff

			if var4 then
				for iter0 = 1, #var4 do
					local var5 = var4[iter0]
					local var6 = var5.time

					table.insert(arg0.buffs, {
						data = var5,
						time = var6
					})
				end
			end

			if arg1.data.script then
				if arg1.data.script == var0.script_remove_all_enemys then
					arg0.eventCall(LaunchBallGameScene.SPLIT_ALL_ENEMYS, {
						time = 1.3,
						effect = true
					})
				elseif arg1.data.script == var0.script_stop_enemy then
					arg0.eventCall(LaunchBallGameScene.STOP_ENEMY_TIME, {
						time = var0.stop_enemy_time
					})
				elseif arg1.data.script == var0.script_slash then
					arg0.eventCall(LaunchBallGameScene.SLASH_ENEMY, {
						time = arg1.data.script_time,
						direct = arg0:getDirectName(arg0.angle)
					})
					arg0.eventCall(LaunchBallGameScene.PLAYER_EFFECT, arg1.data.effect)
				end
			end
		end,
		getSkillAnimName = function(arg0, arg1, arg2)
			local var0 = ""
			local var1
			local var2
			local var3
			local var4
			local var5 = arg1.data

			if var5.type == var5 then
				local var6 = var13
				local var7 = arg0:getBuff(var0.buff_panic)

				if var7 and var7.active then
					var2 = var12
				end

				local var8 = arg0:getDirectName(arg0.angle)

				if arg2 then
					var4 = arg0:getColorName(arg2)
				end

				if var2 then
					var0 = var6 .. "_" .. var2 .. "_" .. var8 .. "_" .. var4
				else
					var0 = var6 .. "_" .. var8 .. "_" .. var4
				end
			elseif var5.type == var6 then
				var0 = var14

				if var5.skill_direct then
					local var9 = arg0:getDirectName(arg0.angle)

					var0 = var0 .. "_" .. var9
				end
			end

			return var0
		end,
		getBuff = function(arg0, arg1)
			for iter0 = 1, #arg0.buffs do
				if arg0.buffs[iter0].data.type == arg1 then
					return arg0.buffs[iter0]
				end
			end

			return nil
		end,
		getColorName = function(arg0, arg1)
			return arg0.colors[arg1].anim_name
		end,
		useSkill = function(arg0)
			local var0 = arg0:getSkillByType(var6)

			if not var0 then
				return
			end

			if arg0:checkSkillAble(var0) then
				arg0:appearSkill(var0)
			end
		end,
		clear = function(arg0)
			return
		end,
		setAngle = function(arg0, arg1)
			arg0:changePlayerStopTime(0)

			arg0.angle = (LaunchBallGameVo.joyStickData.angle + 360) % 360
		end,
		changePlayerStopTime = function(arg0, arg1)
			if arg0:getBuff(var0.buff_neglect) then
				if arg0:getBuff(var0.buff_neglect).active and arg0.playTime > 0 then
					return
				end
			elseif arg0:getBuff(var0.buff_sleep) and arg0:getBuff(var0.buff_sleep).active and arg0.playTime > 0 then
				return
			end

			arg0.playerStopTime = arg1
		end,
		playAnim = function(arg0, arg1)
			print("play anim is " .. arg1)
			arg0.animator:Play(arg1)
		end,
		getIdleName = function(arg0)
			local var0 = var10
			local var1
			local var2
			local var3
			local var4 = arg0:getDirectName(arg0.angle)
			local var5 = arg0:getBuff(var0.buff_amulet_back)
			local var6 = arg0:getBuff(var0.buff_panic)

			if var5 and var5.active then
				var3 = var11
			end

			if var6 and var6.active then
				var2 = var12
			end

			if var3 then
				var0 = var0 .. "_" .. var3
			elseif var2 then
				var0 = var0 .. "_" .. var2
			end

			if var4 then
				var0 = var0 .. "_" .. var4
			end

			return var0
		end,
		getDirectName = function(arg0, arg1)
			local var0
			local var1

			for iter0 = 1, #arg0.directRange do
				local var2 = arg0.directRange[iter0].range

				if arg1 >= var2[1] and arg1 < var2[2] then
					var0 = arg0.directRange[iter0].anim_name
					var1 = arg0.directRange[iter0].direct
				end
			end

			return var0, var1
		end,
		setContent = function(arg0, arg1, arg2)
			setParent(arg0.playerTf, arg1)
			setActive(arg0.playerTf, true)

			if arg2 then
				arg0.playerTf.anchoredPosition = arg2
			else
				arg0.playerTf.anchoredPosition = Vector2(0, 0)
			end
		end,
		dispose = function(arg0)
			if arg0.changeListener then
				ClearEventTrigger(arg0.changeListener)
			end

			if arg0.playerTf then
				Destroy(arg0.playerTf)

				arg0.playerTf = nil
			end
		end
	}

	var0:ctor()

	return var0
end

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._topContent = arg1
	arg0._content = arg2
	arg0._tpl = arg3
	arg0._eventCall = arg4
end

function var0.setPlayerData(arg0, arg1)
	if arg0.player and arg0.player:getId() ~= arg1.id then
		arg0.player:dispose()

		arg0.player = nil
		arg0.player = arg0:createPlayer(arg1)
	elseif not arg0.player then
		arg0.player = arg0:createPlayer(arg1)
	end
end

function var0.createPlayer(arg0, arg1)
	local var0 = tf(instantiate(findTF(arg0._tpl, arg1.tpl)))
	local var1 = var17(var0, arg1, arg0._eventCall)

	var1:setContent(arg0._content)

	return var1
end

function var0.start(arg0)
	arg0.playerId = LaunchBallGameVo.selectPlayer

	arg0:setPlayerData(var1[arg0.playerId])
	arg0.player:start()

	arg0.effects = {}
end

function var0.step(arg0)
	if LaunchBallGameVo.joyStickData and LaunchBallGameVo.joyStickData.active and LaunchBallGameVo.joyStickData.angle then
		arg0.player:setAngle(LaunchBallGameVo.joyStickData.angle)
	end

	if arg0.effects and #arg0.effects > 0 then
		for iter0 = #arg0.effects, 1, -1 do
			local var0 = arg0.effects[iter0].tf
			local var1 = arg0.effects[iter0].anim
			local var2 = arg0.effects[iter0].animName
			local var3 = arg0.effects[iter0].removeTime

			if arg0.effects[iter0].time and arg0.effects[iter0].time > 0 then
				arg0.effects[iter0].time = arg0.effects[iter0].time - LaunchBallGameVo.deltaTime

				if arg0.effects[iter0].time < 0 then
					arg0.effects[iter0].time = nil

					setActive(var0, false)
					setActive(var0, true)
					var1:Play(var2)
				end
			elseif arg0.effects[iter0].removeTime and arg0.effects[iter0].removeTime > 0 then
				arg0.effects[iter0].removeTime = arg0.effects[iter0].removeTime - LaunchBallGameVo.deltaTime

				if arg0.effects[iter0].removeTime < 0 then
					arg0.effects[iter0].removeTime = nil

					setActive(var0, false)
					table.remove(arg0.effects, iter0)
				end
			end
		end
	end

	arg0.player:step()
end

function var0.eventCall(arg0, arg1, arg2)
	if arg1 == LaunchBallGameScene.CHANGE_AMULET then
		-- block empty
	elseif arg1 == LaunchBallGameScene.PLAYER_EFFECT then
		local var0 = arg2

		if var0 then
			local var1
			local var2 = var0.name
			local var3 = findTF(arg0._topContent, "effect/" .. var2)
			local var4 = GetComponent(findTF(var3, "ad/anim"), typeof(Animator))
			local var5 = var0.anim
			local var6 = var0.distance
			local var7 = Vector2(0, 0)

			if var0.direct then
				local var8, var9 = arg0.player:getDirectName(arg0.player.angle)

				var5 = var5 .. "_" .. var8
				var3.anchoredPosition = Vector2(var9[1] * var6, var9[2] * var6)
			end

			table.insert(arg0.effects, {
				tf = var3,
				anim = var4,
				time = var0.time,
				removeTime = var0.remove_time,
				animName = var5
			})
		end
	elseif arg1 == LaunchBallGameScene.SPILT_ENEMY_SCORE then
		arg0.player:split(arg2)
	end
end

function var0.press(arg0, arg1)
	if arg1 == KeyCode.J and arg0.player then
		arg0.player:fire()
	end
end

function var0.joystickActive(arg0, arg1)
	if not arg1 and arg0.player then
		arg0.player:fire()
	end
end

function var0.useSkill(arg0)
	if arg0.player then
		arg0.player:useSkill()
	end
end

function var0.clear(arg0)
	arg0.player:clear()
end

return var0
