return {
	uiEffect = "",
	name = "大黄蜂-轰炸",
	cd = 0,
	painting = 1,
	id = 60010,
	picture = "0",
	aniEffect = "",
	desc = "轰炸",
	effect_list = {
		{
			type = "BattleSkillFire",
			target_choise = "TargetHarmRandom",
			targetAniEffect = "",
			arg_list = {
				weapon_id = 61001,
				delay = 4
			},
			casterAniEffect = {
				time = 1,
				effect = "feijiyingzi",
				posFun = function(arg0_1, arg1_1, arg2_1)
					return Vector3(-100, 0, arg1_1.z) - arg0_1
				end
			}
		},
		{
			type = "BattleSkillFire",
			casterAniEffect = "",
			target_choise = "TargetSameToLastEffect",
			targetAniEffect = "",
			arg_list = {
				weapon_id = 61002,
				delay = 4
			}
		}
	}
}
