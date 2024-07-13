local var0_0 = class("EnemyBossNavigator", import("view.miniGame.gameView.RyzaMiniGame.character.EnemyNavigator"))

var0_0.SkillDistance = 10

function var0_0.InitUI(arg0_1, arg1_1)
	var0_0.super.InitUI(arg0_1, arg1_1)

	arg0_1.hp = arg1_1.hp or 4
	arg0_1.hpMax = arg0_1.hp
	arg0_1.speed = arg1_1.speed or 4
	arg0_1.rate = arg1_1.rate or 2
	arg0_1.damageDic = {}
end

function var0_0.InitRegister(arg0_2, arg1_2)
	return
end

function var0_0.TimeTrigger(arg0_3, arg1_3)
	var0_0.super.TimeTrigger(arg0_3, arg1_3)

	for iter0_3, iter1_3 in ipairs(arg0_3.responder:CollideFire(arg0_3)) do
		if not arg0_3.damageDic[iter1_3] then
			arg0_3.damageDic[iter1_3] = true

			arg0_3:Hurt(1)
		end
	end
end

function var0_0.GetUIHeight(arg0_4)
	return 192
end

return var0_0
