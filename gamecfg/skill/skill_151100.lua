return {
	uiEffect = "",
	name = "奥列格主炮弹幕",
	cd = 0,
	painting = 0,
	id = 151100,
	picture = "0",
	desc = "奥列格主炮弹幕",
	aniEffect = {
		effect = "jineng",
		offset = {
			0,
			-2,
			0
		}
	},
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 151102
			}
		}
	}
}
