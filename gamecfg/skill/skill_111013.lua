return {
	uiEffect = "",
	name = "",
	cd = 0,
	id = 111013,
	picture = "0",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillTeleport",
			target_choise = {
				"TargetPlayerFlagShip"
			},
			arg_list = {
				targetRelativeCorrdinate = {
					hrz = -500,
					vrt = 0
				}
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 801023
			}
		}
	}
}
