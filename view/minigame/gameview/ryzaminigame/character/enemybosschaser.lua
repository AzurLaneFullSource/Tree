local var0_0 = class("EnemyBossChaser", import("view.miniGame.gameView.RyzaMiniGame.character.EnemyChaser"))

var0_0.WeaponName = "Laser"
var0_0.ConfigSkillCD = 10
var0_0.StatusOffset = setmetatable({}, {
	__index = function(arg0_1, arg1_1)
		return {
			0,
			0
		}
	end
})

function var0_0.InitUI(arg0_2, arg1_2)
	var0_0.super.InitUI(arg0_2, arg1_2)

	arg0_2.hp = arg1_2.hp or 4
	arg0_2.hpMax = arg0_2.hp
	arg0_2.speed = arg1_2.speed or 3
	arg0_2.damageDic = {}
end

function var0_0.InitRegister(arg0_3, arg1_3)
	return
end

function var0_0.TimeTrigger(arg0_4, arg1_4)
	var0_0.super.TimeTrigger(arg0_4, arg1_4)

	for iter0_4, iter1_4 in ipairs(arg0_4.responder:CollideFire(arg0_4)) do
		if not arg0_4.damageDic[iter1_4] then
			arg0_4.damageDic[iter1_4] = true

			arg0_4:Hurt(1)
		end
	end
end

function var0_0.GetUIHeight(arg0_5)
	return 192
end

return var0_0
