ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillPlaySFX", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillPlaySFX = var1
var1.__name = "BattleSkillPlaySFX"

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._SFXID = arg0._tempData.arg_list.sound_effect
end

function var1.DoDataEffect(arg0, arg1, arg2)
	arg0:playSound()
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:playSound()
end

function var1.playSound(arg0)
	var0.Battle.PlayBattleSFX(arg0._SFXID)
end
