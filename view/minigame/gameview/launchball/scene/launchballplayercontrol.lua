local var0_0 = class("LaunchBallPlayerControl")
local var1_0 = {
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
local var2_0 = 1
local var3_0 = "skill trigger"
local var4_0 = "skill passive"
local var5_0 = "skill type fire"
local var6_0 = "skill type press"
local var7_0 = "skill type passive"

var0_0.buff_amulet_back_time = 0.4
var0_0.buff_panic_fire_speed = 1
var0_0.buff_panic_enemy_rate = 5
var0_0.buff_sleep_butterfly_time = 2
var0_0.slash_split_time = 0.5
var0_0.stop_enemy_time = 10
var0_0.buff_amulet_back = 1
var0_0.buff_panic = 2
var0_0.buff_neglect = 3
var0_0.buff_sleep = 4
var0_0.buff_time_max = 5
var0_0.buff_time_slash = 6
var0_0.script_remove_all_enemys = "remove all enemys"
var0_0.script_stop_enemy = "script_stop_enemy"
var0_0.script_slash = "script_slash"
var0_0.player_skill = {
	{
		cd_time = 0.5,
		play_time = 0.25,
		weight = 1,
		name = "atk",
		type = var5_0,
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
		type = var6_0,
		buff = {
			{
				time = 10,
				type = var0_0.buff_amulet_back
			}
		}
	},
	{
		cd_time = 0,
		play_time = 0,
		weight = 0,
		name = "panic",
		type = var7_0,
		buff = {
			{
				time = 999999,
				type = var0_0.buff_panic
			}
		}
	},
	{
		cd_time = 0,
		play_time = 1,
		weight = 0,
		name = "neglect",
		type = var7_0,
		buff = {
			{
				time = 999999,
				type = var0_0.buff_neglect,
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
		type = var7_0,
		buff = {
			{
				time = 999999,
				type = var0_0.buff_sleep,
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
		type = var6_0,
		script = var0_0.script_remove_all_enemys,
		buff = {}
	},
	{
		cd_time = 22,
		play_time = 1.3,
		name = "player3SkillA",
		skill_direct = false,
		weight = 2,
		type = var6_0,
		script = var0_0.script_stop_enemy,
		buff = {}
	},
	{
		cd_time = 0,
		play_time = 0,
		weight = 0,
		name = "player3Time",
		type = var7_0,
		buff = {
			{
				time = 999999,
				type = var0_0.buff_time_max
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
		type = var6_0,
		script = var0_0.script_slash,
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
		type = var7_0,
		buff = {
			{
				time = 999999,
				type = var0_0.buff_time_slash
			}
		}
	}
}

local var8_0 = 270
local var9_0 = {
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
local var10_0 = "Idle"
local var11_0 = "Buff"
local var12_0 = "Panic"
local var13_0 = "Attack"
local var14_0 = "Skill_A"
local var15_0 = "Skill_B"
local var16_0 = {
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

local function var17_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2.playerTf = arg0_1
			arg0_2.animator = GetComponent(findTF(arg0_2.playerTf, "ad/anim"), typeof(Animator))
			arg0_2.data = arg1_1
			arg0_2.eventCall = arg2_1
			arg0_2.panicFlag = false
			arg0_2.directRange = Clone(var9_0)
			arg0_2.colors = Clone(var16_0)
			arg0_2.skills = {}

			for iter0_2 = 1, #arg1_1.skill do
				local var0_2 = var0_0.player_skill[arg1_1.skill[iter0_2]]

				table.insert(arg0_2.skills, {
					data = var0_2,
					time = var0_2.cd_time
				})
			end

			local var1_2 = findTF(arg0_2.playerTf, "ad/change")

			arg0_2.changeListener = GetOrAddComponent(var1_2, typeof(EventTriggerListener))

			arg0_2.changeListener:AddPointDownFunc(function(arg0_3, arg1_3)
				arg0_2.eventCall(LaunchBallGameScene.CHANGE_AMULET)
				arg0_2:changePlayerStopTime(0)
			end)
		end,
		getId = function(arg0_4)
			return arg0_4.data.id
		end,
		start = function(arg0_5)
			arg0_5.useSkillTime = nil
			arg0_5.buffs = {}
			arg0_5.angle = var8_0

			arg0_5:changePlaying(false)

			arg0_5.panicFlag = false
			arg0_5.idleAnimName = arg0_5:getIdleName()

			arg0_5:playAnim(arg0_5.idleAnimName)

			LaunchBallGameVo.pressSkill = arg0_5:getSkillByType(var6_0)
			LaunchBallGameVo.buffs = arg0_5.buffs

			for iter0_5 = 1, #arg0_5.skills do
				arg0_5.skills[iter0_5].time = arg0_5.skills[iter0_5].data.cd_time

				if arg0_5.skills[iter0_5].data.type == var7_0 then
					local var0_5 = arg0_5.skills[iter0_5].data.buff

					for iter1_5 = 1, #var0_5 do
						table.insert(arg0_5.buffs, {
							data = var0_5[iter1_5],
							time = var0_5[iter1_5].time
						})
					end
				end
			end

			arg0_5:changePlayerStopTime(0)
		end,
		step = function(arg0_6)
			if arg0_6.playTime and arg0_6.playTime > 0 then
				arg0_6.playTime = arg0_6.playTime - LaunchBallGameVo.deltaTime

				if arg0_6.playTime <= 0 then
					arg0_6:changePlaying(false)
				end
			end

			if arg0_6.randomFireTime and arg0_6.randomFireTime > 0 then
				arg0_6.randomFireTime = arg0_6.randomFireTime - LaunchBallGameVo.deltaTime

				if arg0_6.randomFireTime <= 0 then
					arg0_6.randomFireTime = nil

					arg0_6.eventCall(LaunchBallGameScene.RANDOM_FIRE, {
						num = 3,
						data = {
							[LaunchBallGameConst.amulet_buff_back] = true
						}
					})
				end
			end

			if arg0_6.sleepTimeTrigger and arg0_6.sleepTimeTrigger > 0 then
				arg0_6.sleepTimeTrigger = arg0_6.sleepTimeTrigger - LaunchBallGameVo.deltaTime

				if arg0_6.sleepTimeTrigger <= 0 then
					arg0_6.sleepTimeTrigger = nil

					arg0_6.eventCall(LaunchBallGameScene.SLEEP_TIME_TRIGGER)
				end
			end

			if not arg0_6.isPlaying then
				local var0_6 = arg0_6:getIdleName()

				if arg0_6.idleAnimName ~= var0_6 then
					arg0_6:playAnim(var0_6)

					arg0_6.idleAnimName = var0_6
				end
			end

			for iter0_6 = 1, #arg0_6.skills do
				if arg0_6.skills[iter0_6].time > 0 then
					arg0_6.skills[iter0_6].time = arg0_6.skills[iter0_6].time - LaunchBallGameVo.deltaTime

					if arg0_6.skills[iter0_6].time <= 0 then
						arg0_6.skills[iter0_6].time = 0
					end
				end
			end

			for iter1_6 = #arg0_6.buffs, 1, -1 do
				local var1_6 = arg0_6.buffs[iter1_6]

				if var1_6.time > 0 then
					var1_6.time = var1_6.time - LaunchBallGameVo.deltaTime

					if var1_6.time <= 0 then
						table.remove(arg0_6.buffs, iter1_6)
					end
				end
			end

			for iter2_6 = #arg0_6.buffs, 1, -1 do
				local var2_6 = arg0_6.buffs[iter2_6]

				if var2_6.data.type == var0_0.buff_panic then
					local var3_6 = false

					if LaunchBallGameVo.enemyToEndRate then
						for iter3_6 = 1, #LaunchBallGameVo.enemyToEndRate do
							if not var3_6 and LaunchBallGameVo.enemyToEndRate[iter3_6] > var0_0.buff_panic_enemy_rate then
								var3_6 = true
							end
						end
					end

					var2_6.active = var3_6

					if var2_6.active then
						local var4_6 = arg0_6:getSkillByType(var5_0)

						if var4_6.time > 0 then
							var4_6.time = var4_6.time - LaunchBallGameVo.deltaTime * var0_0.buff_panic_fire_speed
						end
					end
				elseif var2_6.data.type == var0_0.buff_neglect then
					arg0_6:updateBuffStopTime(var2_6)
				elseif var2_6.data.type == var0_0.buff_sleep then
					arg0_6:updateBuffStopTime(var2_6)
				else
					var2_6.active = true
				end
			end

			arg0_6:changePlayerStopTime(arg0_6.playerStopTime + LaunchBallGameVo.deltaTime)
		end,
		setPlayTime = function(arg0_7, arg1_7)
			if arg1_7 and arg1_7 > 0 then
				print("set play time " .. arg1_7)

				arg0_7.isPlaying = true
			else
				print("clear play time" .. arg1_7)

				arg0_7.isPlaying = false
			end

			arg0_7.playTime = arg1_7
		end,
		updateBuffStopTime = function(arg0_8, arg1_8)
			if not arg1_8.active and arg0_8.playerStopTime > arg1_8.data.active_rule.time then
				arg1_8.active = true

				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_pass_skill, 1)
				arg0_8:setPlayTime(arg1_8.data.active_rule.play_time)

				arg0_8.weight = arg1_8.data.active_rule.weight

				if arg1_8.data.type == var0_0.buff_neglect then
					arg0_8.randomFireTime = 1.5

					if arg0_8:getBuff(var0_0.buff_panic).active then
						arg0_8:playAnim("Skill_B_Panic_Start")
					else
						arg0_8:playAnim("Skill_B_Start")
					end
				elseif arg1_8.data.type == var0_0.buff_sleep then
					local var0_8 = "Trans_Sleep_" .. arg0_8:getDirectName(arg0_8.angle)

					arg0_8:playAnim(var0_8)
				end
			end

			if arg1_8.active and arg1_8.data.type == var0_0.buff_sleep and not arg0_8.sleepTimeTrigger then
				arg0_8.sleepTimeTrigger = var0_0.buff_sleep_butterfly_time
			end

			if arg1_8.active and arg0_8.playerStopTime < arg1_8.data.active_rule.time then
				arg1_8.active = false
			end
		end,
		split = function(arg0_9, arg1_9)
			if arg1_9.split and arg0_9:getBuff(var0_0.buff_time_slash) then
				local var0_9 = arg0_9:getSkillByType(var6_0)

				if var0_9 and var0_9.time > 0 then
					var0_9.time = var0_9.time - var0_0.slash_split_time
				end
			end
		end,
		changePlaying = function(arg0_10, arg1_10, arg2_10)
			if arg1_10 then
				arg0_10:setPlayTime(arg2_10.data.play_time)

				arg0_10.weight = arg2_10.data.weight
			else
				arg0_10:setPlayTime(0)

				arg0_10.weight = 0
			end

			if arg0_10.eventCall then
				arg0_10.eventCall(LaunchBallGameScene.PLAYING_CHANGE, arg1_10)
			end
		end,
		fire = function(arg0_11)
			local var0_11 = arg0_11:getSkillByType(var5_0)

			if arg0_11:checkSkillAble(var0_11) then
				arg0_11:changePlayerStopTime(0)

				if not LaunchBallGameVo.amulet then
					print("当前没有可以发射的符咒")

					return
				end

				arg0_11:appearSkill(var0_11)
			end
		end,
		getSkillByType = function(arg0_12, arg1_12)
			for iter0_12 = 1, #arg0_12.skills do
				local var0_12 = arg0_12.skills[iter0_12]

				if var0_12.data.type == arg1_12 then
					return var0_12
				end
			end

			return nil
		end,
		checkSkillAble = function(arg0_13, arg1_13)
			if arg1_13.time > 0 then
				print("还在cd中 cd = " .. arg1_13.time)

				return false
			end

			if arg0_13.isPlaying and arg1_13.data.weight <= arg0_13.weight then
				print("权重不够无法覆盖当前的技能")

				return false
			end

			return true
		end,
		appearSkill = function(arg0_14, arg1_14)
			arg0_14:changePlayerStopTime(0)
			arg0_14:changePlaying(true, arg1_14)

			arg1_14.time = arg1_14.data.cd_time

			if arg1_14.data.type == var5_0 then
				local var0_14 = LaunchBallGameVo.amulet.color
				local var1_14 = arg0_14:getSkillAnimName(arg1_14, var0_14)

				arg0_14:playAnim(var1_14)
				arg0_14.eventCall(LaunchBallGameScene.FIRE_AMULET)
			elseif arg1_14.data.type == var6_0 then
				print("使用了主动技能")

				local var2_14 = arg0_14:getSkillAnimName(arg1_14)

				arg0_14:playAnim(var2_14)

				arg0_14.idleAnimName = nil

				if arg0_14.useSkillTime then
					local var3_14 = LaunchBallGameVo.gameStepTime - arg0_14.useSkillTime

					LaunchBallGameVo.UpdateGameResultData(LaunchBallGameVo.reuslt_double_skill_time, var3_14)
				else
					arg0_14.useSkillTime = LaunchBallGameVo.gameStepTime
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_PRESS_SKILL)
				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_skill, 1)
			end

			local var4_14 = arg1_14.data.buff

			if var4_14 then
				for iter0_14 = 1, #var4_14 do
					local var5_14 = var4_14[iter0_14]
					local var6_14 = var5_14.time

					table.insert(arg0_14.buffs, {
						data = var5_14,
						time = var6_14
					})
				end
			end

			if arg1_14.data.script then
				if arg1_14.data.script == var0_0.script_remove_all_enemys then
					arg0_14.eventCall(LaunchBallGameScene.SPLIT_ALL_ENEMYS, {
						time = 1.3,
						effect = true
					})
				elseif arg1_14.data.script == var0_0.script_stop_enemy then
					arg0_14.eventCall(LaunchBallGameScene.STOP_ENEMY_TIME, {
						time = var0_0.stop_enemy_time
					})
				elseif arg1_14.data.script == var0_0.script_slash then
					arg0_14.eventCall(LaunchBallGameScene.SLASH_ENEMY, {
						time = arg1_14.data.script_time,
						direct = arg0_14:getDirectName(arg0_14.angle)
					})
					arg0_14.eventCall(LaunchBallGameScene.PLAYER_EFFECT, arg1_14.data.effect)
				end
			end
		end,
		getSkillAnimName = function(arg0_15, arg1_15, arg2_15)
			local var0_15 = ""
			local var1_15
			local var2_15
			local var3_15
			local var4_15
			local var5_15 = arg1_15.data

			if var5_15.type == var5_0 then
				local var6_15 = var13_0
				local var7_15 = arg0_15:getBuff(var0_0.buff_panic)

				if var7_15 and var7_15.active then
					var2_15 = var12_0
				end

				local var8_15 = arg0_15:getDirectName(arg0_15.angle)

				if arg2_15 then
					var4_15 = arg0_15:getColorName(arg2_15)
				end

				if var2_15 then
					var0_15 = var6_15 .. "_" .. var2_15 .. "_" .. var8_15 .. "_" .. var4_15
				else
					var0_15 = var6_15 .. "_" .. var8_15 .. "_" .. var4_15
				end
			elseif var5_15.type == var6_0 then
				var0_15 = var14_0

				if var5_15.skill_direct then
					local var9_15 = arg0_15:getDirectName(arg0_15.angle)

					var0_15 = var0_15 .. "_" .. var9_15
				end
			end

			return var0_15
		end,
		getBuff = function(arg0_16, arg1_16)
			for iter0_16 = 1, #arg0_16.buffs do
				if arg0_16.buffs[iter0_16].data.type == arg1_16 then
					return arg0_16.buffs[iter0_16]
				end
			end

			return nil
		end,
		getColorName = function(arg0_17, arg1_17)
			return arg0_17.colors[arg1_17].anim_name
		end,
		useSkill = function(arg0_18)
			local var0_18 = arg0_18:getSkillByType(var6_0)

			if not var0_18 then
				return
			end

			if arg0_18:checkSkillAble(var0_18) then
				arg0_18:appearSkill(var0_18)
			end
		end,
		clear = function(arg0_19)
			return
		end,
		setAngle = function(arg0_20, arg1_20)
			arg0_20:changePlayerStopTime(0)

			arg0_20.angle = (LaunchBallGameVo.joyStickData.angle + 360) % 360
		end,
		changePlayerStopTime = function(arg0_21, arg1_21)
			if arg0_21:getBuff(var0_0.buff_neglect) then
				if arg0_21:getBuff(var0_0.buff_neglect).active and arg0_21.playTime > 0 then
					return
				end
			elseif arg0_21:getBuff(var0_0.buff_sleep) and arg0_21:getBuff(var0_0.buff_sleep).active and arg0_21.playTime > 0 then
				return
			end

			arg0_21.playerStopTime = arg1_21
		end,
		playAnim = function(arg0_22, arg1_22)
			print("play anim is " .. arg1_22)
			arg0_22.animator:Play(arg1_22)
		end,
		getIdleName = function(arg0_23)
			local var0_23 = var10_0
			local var1_23
			local var2_23
			local var3_23
			local var4_23 = arg0_23:getDirectName(arg0_23.angle)
			local var5_23 = arg0_23:getBuff(var0_0.buff_amulet_back)
			local var6_23 = arg0_23:getBuff(var0_0.buff_panic)

			if var5_23 and var5_23.active then
				var3_23 = var11_0
			end

			if var6_23 and var6_23.active then
				var2_23 = var12_0
			end

			if var3_23 then
				var0_23 = var0_23 .. "_" .. var3_23
			elseif var2_23 then
				var0_23 = var0_23 .. "_" .. var2_23
			end

			if var4_23 then
				var0_23 = var0_23 .. "_" .. var4_23
			end

			return var0_23
		end,
		getDirectName = function(arg0_24, arg1_24)
			local var0_24
			local var1_24

			for iter0_24 = 1, #arg0_24.directRange do
				local var2_24 = arg0_24.directRange[iter0_24].range

				if arg1_24 >= var2_24[1] and arg1_24 < var2_24[2] then
					var0_24 = arg0_24.directRange[iter0_24].anim_name
					var1_24 = arg0_24.directRange[iter0_24].direct
				end
			end

			return var0_24, var1_24
		end,
		setContent = function(arg0_25, arg1_25, arg2_25)
			setParent(arg0_25.playerTf, arg1_25)
			setActive(arg0_25.playerTf, true)

			if arg2_25 then
				arg0_25.playerTf.anchoredPosition = arg2_25
			else
				arg0_25.playerTf.anchoredPosition = Vector2(0, 0)
			end
		end,
		dispose = function(arg0_26)
			if arg0_26.changeListener then
				ClearEventTrigger(arg0_26.changeListener)
			end

			if arg0_26.playerTf then
				Destroy(arg0_26.playerTf)

				arg0_26.playerTf = nil
			end
		end
	}

	var0_1:ctor()

	return var0_1
end

function var0_0.Ctor(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
	arg0_27._topContent = arg1_27
	arg0_27._content = arg2_27
	arg0_27._tpl = arg3_27
	arg0_27._eventCall = arg4_27
end

function var0_0.setPlayerData(arg0_28, arg1_28)
	if arg0_28.player and arg0_28.player:getId() ~= arg1_28.id then
		arg0_28.player:dispose()

		arg0_28.player = nil
		arg0_28.player = arg0_28:createPlayer(arg1_28)
	elseif not arg0_28.player then
		arg0_28.player = arg0_28:createPlayer(arg1_28)
	end
end

function var0_0.createPlayer(arg0_29, arg1_29)
	local var0_29 = tf(instantiate(findTF(arg0_29._tpl, arg1_29.tpl)))
	local var1_29 = var17_0(var0_29, arg1_29, arg0_29._eventCall)

	var1_29:setContent(arg0_29._content)

	return var1_29
end

function var0_0.start(arg0_30)
	arg0_30.playerId = LaunchBallGameVo.selectPlayer

	arg0_30:setPlayerData(var1_0[arg0_30.playerId])
	arg0_30.player:start()

	arg0_30.effects = {}
end

function var0_0.step(arg0_31)
	if LaunchBallGameVo.joyStickData and LaunchBallGameVo.joyStickData.active and LaunchBallGameVo.joyStickData.angle then
		arg0_31.player:setAngle(LaunchBallGameVo.joyStickData.angle)
	end

	if arg0_31.effects and #arg0_31.effects > 0 then
		for iter0_31 = #arg0_31.effects, 1, -1 do
			local var0_31 = arg0_31.effects[iter0_31].tf
			local var1_31 = arg0_31.effects[iter0_31].anim
			local var2_31 = arg0_31.effects[iter0_31].animName
			local var3_31 = arg0_31.effects[iter0_31].removeTime

			if arg0_31.effects[iter0_31].time and arg0_31.effects[iter0_31].time > 0 then
				arg0_31.effects[iter0_31].time = arg0_31.effects[iter0_31].time - LaunchBallGameVo.deltaTime

				if arg0_31.effects[iter0_31].time < 0 then
					arg0_31.effects[iter0_31].time = nil

					setActive(var0_31, false)
					setActive(var0_31, true)
					var1_31:Play(var2_31)
				end
			elseif arg0_31.effects[iter0_31].removeTime and arg0_31.effects[iter0_31].removeTime > 0 then
				arg0_31.effects[iter0_31].removeTime = arg0_31.effects[iter0_31].removeTime - LaunchBallGameVo.deltaTime

				if arg0_31.effects[iter0_31].removeTime < 0 then
					arg0_31.effects[iter0_31].removeTime = nil

					setActive(var0_31, false)
					table.remove(arg0_31.effects, iter0_31)
				end
			end
		end
	end

	arg0_31.player:step()
end

function var0_0.eventCall(arg0_32, arg1_32, arg2_32)
	if arg1_32 == LaunchBallGameScene.CHANGE_AMULET then
		-- block empty
	elseif arg1_32 == LaunchBallGameScene.PLAYER_EFFECT then
		local var0_32 = arg2_32

		if var0_32 then
			local var1_32
			local var2_32 = var0_32.name
			local var3_32 = findTF(arg0_32._topContent, "effect/" .. var2_32)
			local var4_32 = GetComponent(findTF(var3_32, "ad/anim"), typeof(Animator))
			local var5_32 = var0_32.anim
			local var6_32 = var0_32.distance
			local var7_32 = Vector2(0, 0)

			if var0_32.direct then
				local var8_32, var9_32 = arg0_32.player:getDirectName(arg0_32.player.angle)

				var5_32 = var5_32 .. "_" .. var8_32
				var3_32.anchoredPosition = Vector2(var9_32[1] * var6_32, var9_32[2] * var6_32)
			end

			table.insert(arg0_32.effects, {
				tf = var3_32,
				anim = var4_32,
				time = var0_32.time,
				removeTime = var0_32.remove_time,
				animName = var5_32
			})
		end
	elseif arg1_32 == LaunchBallGameScene.SPILT_ENEMY_SCORE then
		arg0_32.player:split(arg2_32)
	end
end

function var0_0.press(arg0_33, arg1_33)
	if arg1_33 == KeyCode.J and arg0_33.player then
		arg0_33.player:fire()
	end
end

function var0_0.joystickActive(arg0_34, arg1_34)
	if not arg1_34 and arg0_34.player then
		arg0_34.player:fire()
	end
end

function var0_0.useSkill(arg0_35)
	if arg0_35.player then
		arg0_35.player:useSkill()
	end
end

function var0_0.clear(arg0_36)
	arg0_36.player:clear()
end

return var0_0
