﻿ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillPlaySFX", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillPlaySFX = var1_0
var1_0.__name = "BattleSkillPlaySFX"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._SFXID = arg0_1._tempData.arg_list.sound_effect
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	arg0_2:playSound()
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:playSound()
end

function var1_0.playSound(arg0_4)
	var0_0.Battle.PlayBattleSFX(arg0_4._SFXID)
end