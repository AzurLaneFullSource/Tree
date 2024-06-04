local var0 = class("EnemyBossConductor", import("view.miniGame.gameView.RyzaMiniGame.character.EnemyConductor"))

var0.ConfigShildList = {
	4,
	0,
	0,
	0
}
var0.BlockRange = 2

function var0.InitUI(arg0, arg1)
	var0.super.InitUI(arg0, arg1)

	arg0.hp = arg1.hp or 4
	arg0.hpMax = arg0.hp
	arg0.speed = arg1.speed or 4
	arg0.damageDic = {}
end

function var0.InitRegister(arg0, arg1)
	var0.super.InitRegister(arg0, arg1)
	arg0:Deregister("burn")
end

function var0.TimeTrigger(arg0, arg1)
	var0.super.TimeTrigger(arg0, arg1)

	for iter0, iter1 in ipairs(arg0.responder:CollideFire(arg0)) do
		if not arg0.damageDic[iter1] then
			arg0.damageDic[iter1] = true

			arg0:Hurt(1)
		end
	end
end

function var0.GetUIHeight(arg0)
	return 192
end

return var0
