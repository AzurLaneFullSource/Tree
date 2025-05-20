return {
	uiEffect = "",
	name = "路障盾牌",
	cd = 0,
	painting = 1,
	id = 151200,
	picture = "0",
	castCV = "skill",
	desc = "",
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
			type = "BattleSkillProjectShelter",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				duration = 60,
				effect = "yongqi_hudun",
				count = 12,
				box = {
					4,
					10,
					15
				},
				offset = {
					6,
					0,
					-9
				}
			}
		},
		{
			type = "BattleSkillProjectShelter",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				duration = 60,
				effect = "yongqi_hudun",
				count = 12,
				box = {
					4,
					10,
					15
				},
				offset = {
					8,
					0,
					3
				}
			}
		},
		{
			type = "BattleSkillProjectShelter",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				duration = 60,
				effect = "yongqi_hudun",
				count = 12,
				box = {
					4,
					10,
					15
				},
				offset = {
					4,
					0,
					-21
				}
			}
		}
	}
}
