local var0_0 = {
	"Your flagship's <color=#ff7d36>Aerial Support</color> is ready.",
	"Clear the battlefield! Get ready for <color=#ff7d36>air support</color>!",
	"Witness the power of our fighters! Use them when you need a leg up. They can also <color=#ff7d36>destroy enemy barrages</color>!"
}

return {
	id = "B002",
	events = {
		{
			alpha = 0.34,
			code = {
				"ShowSkill3"
			},
			hideui = {
				{
					ishide = false,
					path = "UICamera/Canvas/UIMain/CombatUI(Clone)/Weapon_button_container/Skill_3"
				}
			},
			style = {
				dir = 1,
				mode = 2,
				posY = 0,
				posX = 0,
				text = var0_0[1]
			}
		},
		{
			alpha = 0.34,
			code = {
				"ShowSkill3"
			},
			style = {
				dir = 1,
				mode = 2,
				posY = 0,
				posX = 0,
				text = var0_0[2]
			},
			ui = {
				path = "UICamera/Canvas/UIMain/CombatUI(Clone)/Weapon_button_container/Skill_3/ActCtl",
				triggerType = {
					3
				}
			}
		},
		{
			alpha = 0.34,
			code = {
				"ReleaseAfter"
			},
			style = {
				dir = 1,
				mode = 2,
				posY = 0,
				posX = 0,
				text = var0_0[3]
			}
		}
	}
}
