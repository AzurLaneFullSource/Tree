local var0 = class("FushunChar")
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = 6

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.animator = arg0._go:GetComponent(typeof(Animator))
	arg0.animatorEvent = arg0._go:GetComponent(typeof(DftAniEvent))
	arg0.contactFilter2D = UnityEngine.ContactFilter2D.New()
	arg0.contactFilter2D.useTriggers = true
	arg0.keys = {}
	arg0.state = var1
	arg0.hp = 3
	arg0.harm = 0
	arg0.energy = 0
	arg0.exEnergyTarget = 100
	arg0.collider2D = arg0._go:GetComponent(typeof(UnityEngine.Collider2D))
	arg0.effectCollider2D = arg0._tf:Find("effect"):GetComponent(typeof(UnityEngine.Collider2D))

	arg0.animatorEvent:SetEndEvent(function()
		if arg0.state == var5 then
			return
		end

		arg0.state = var1

		if arg0.OnAttackFinish then
			arg0.OnAttackFinish()

			arg0.OnAttackFinish = nil
		end

		arg0.harm = 0

		if arg0.OnAnimEnd then
			arg0.OnAnimEnd()
		end
	end)
end

function var0.GetAttackPosition(arg0)
	return Vector3(FushunAdventureGameConst.FUSHUN_ATTACK_DISTANCE + arg0._tf.localPosition.x, arg0._tf.localPosition.y, 0)
end

function var0.ClearHarm(arg0)
	if arg0.state == var5 then
		return
	end

	arg0.harm = 0
end

function var0.GetHarm(arg0)
	return math.max(0, arg0.harm)
end

function var0.SetOnAnimEnd(arg0, arg1)
	arg0.OnAnimEnd = arg1
end

function var0.SetPosition(arg0, arg1)
	arg0._tf.localPosition = arg1
end

function var0.GetPosition(arg0)
	return arg0._tf.localPosition
end

function var0.InAttackState(arg0)
	return arg0.state == var2
end

function var0.TriggerAction(arg0, arg1, arg2)
	if arg0.state == var1 or arg0.state == var2 then
		arg0.state = var2
		arg0.harm = arg0.harm + 1
		arg0.OnAttackFinish = arg2

		arg0:StartAction(arg1)
	end
end

function var0.Miss(arg0)
	if arg0.state == var5 then
		return
	end

	if arg0.OnAttackFinish then
		arg0.OnAttackFinish = nil
	end

	arg0.state = var4

	arg0:StartAction("miss")
end

function var0.Hurt(arg0)
	if arg0.state == var5 then
		return
	end

	if arg0.OnAttackFinish then
		arg0.OnAttackFinish = nil
	end

	arg0.state = var3
	arg0.hp = arg0.hp - 1

	arg0:StartAction("damage")
end

function var0.AddEnergy(arg0, arg1)
	if arg0.state == var5 then
		return
	end

	arg0.energy = math.min(arg0.energy + arg1, arg0.exEnergyTarget)
end

function var0.StartAction(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.keys) do
		arg0.animator:ResetTrigger(iter0)
	end

	arg0.animator:SetTrigger(arg1)

	arg0.keys[arg1] = true
end

function var0.GetHp(arg0)
	return arg0.hp
end

function var0.IsDeath(arg0)
	return arg0.hp <= 0
end

function var0.Die(arg0)
	arg0:StartAction("down")
end

function var0.GetEnergy(arg0)
	return arg0.energy
end

function var0.GetEnergyTarget(arg0)
	return arg0.exEnergyTarget
end

function var0.ReduceEnergy(arg0, arg1)
	arg0.energy = arg0.energy - arg1
end

function var0.ShouldInvincible(arg0)
	return arg0.state ~= var5 and arg0.energy >= arg0.exEnergyTarget
end

function var0.ShouldVincible(arg0)
	if arg0.state == var5 and arg0.energy <= 0 then
		return true
	end

	return false
end

function var0.InvincibleState(arg0)
	return arg0.state == var5
end

function var0.Invincible(arg0)
	arg0.harm = 1
	arg0.state = var5
end

function var0.IsMissState(arg0)
	return arg0.state == var4
end

function var0.IsDamageState(arg0)
	return arg0.state == var3
end

function var0.Vincible(arg0)
	arg0:StartAction("EX_FINISH")

	arg0.harm = 0
	arg0.state = var1
end

function var0.Destory(arg0)
	arg0.animatorEvent:SetEndEvent(nil)
	Destroy(arg0._go)

	arg0._go = nil
	arg0.animator = nil
end

return var0
