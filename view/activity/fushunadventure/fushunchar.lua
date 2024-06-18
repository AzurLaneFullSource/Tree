local var0_0 = class("FushunChar")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.animator = arg0_1._go:GetComponent(typeof(Animator))
	arg0_1.animatorEvent = arg0_1._go:GetComponent(typeof(DftAniEvent))
	arg0_1.contactFilter2D = UnityEngine.ContactFilter2D.New()
	arg0_1.contactFilter2D.useTriggers = true
	arg0_1.keys = {}
	arg0_1.state = var1_0
	arg0_1.hp = 3
	arg0_1.harm = 0
	arg0_1.energy = 0
	arg0_1.exEnergyTarget = 100
	arg0_1.collider2D = arg0_1._go:GetComponent(typeof(UnityEngine.Collider2D))
	arg0_1.effectCollider2D = arg0_1._tf:Find("effect"):GetComponent(typeof(UnityEngine.Collider2D))

	arg0_1.animatorEvent:SetEndEvent(function()
		if arg0_1.state == var5_0 then
			return
		end

		arg0_1.state = var1_0

		if arg0_1.OnAttackFinish then
			arg0_1.OnAttackFinish()

			arg0_1.OnAttackFinish = nil
		end

		arg0_1.harm = 0

		if arg0_1.OnAnimEnd then
			arg0_1.OnAnimEnd()
		end
	end)
end

function var0_0.GetAttackPosition(arg0_3)
	return Vector3(FushunAdventureGameConst.FUSHUN_ATTACK_DISTANCE + arg0_3._tf.localPosition.x, arg0_3._tf.localPosition.y, 0)
end

function var0_0.ClearHarm(arg0_4)
	if arg0_4.state == var5_0 then
		return
	end

	arg0_4.harm = 0
end

function var0_0.GetHarm(arg0_5)
	return math.max(0, arg0_5.harm)
end

function var0_0.SetOnAnimEnd(arg0_6, arg1_6)
	arg0_6.OnAnimEnd = arg1_6
end

function var0_0.SetPosition(arg0_7, arg1_7)
	arg0_7._tf.localPosition = arg1_7
end

function var0_0.GetPosition(arg0_8)
	return arg0_8._tf.localPosition
end

function var0_0.InAttackState(arg0_9)
	return arg0_9.state == var2_0
end

function var0_0.TriggerAction(arg0_10, arg1_10, arg2_10)
	if arg0_10.state == var1_0 or arg0_10.state == var2_0 then
		arg0_10.state = var2_0
		arg0_10.harm = arg0_10.harm + 1
		arg0_10.OnAttackFinish = arg2_10

		arg0_10:StartAction(arg1_10)
	end
end

function var0_0.Miss(arg0_11)
	if arg0_11.state == var5_0 then
		return
	end

	if arg0_11.OnAttackFinish then
		arg0_11.OnAttackFinish = nil
	end

	arg0_11.state = var4_0

	arg0_11:StartAction("miss")
end

function var0_0.Hurt(arg0_12)
	if arg0_12.state == var5_0 then
		return
	end

	if arg0_12.OnAttackFinish then
		arg0_12.OnAttackFinish = nil
	end

	arg0_12.state = var3_0
	arg0_12.hp = arg0_12.hp - 1

	arg0_12:StartAction("damage")
end

function var0_0.AddEnergy(arg0_13, arg1_13)
	if arg0_13.state == var5_0 then
		return
	end

	arg0_13.energy = math.min(arg0_13.energy + arg1_13, arg0_13.exEnergyTarget)
end

function var0_0.StartAction(arg0_14, arg1_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.keys) do
		arg0_14.animator:ResetTrigger(iter0_14)
	end

	arg0_14.animator:SetTrigger(arg1_14)

	arg0_14.keys[arg1_14] = true
end

function var0_0.GetHp(arg0_15)
	return arg0_15.hp
end

function var0_0.IsDeath(arg0_16)
	return arg0_16.hp <= 0
end

function var0_0.Die(arg0_17)
	arg0_17:StartAction("down")
end

function var0_0.GetEnergy(arg0_18)
	return arg0_18.energy
end

function var0_0.GetEnergyTarget(arg0_19)
	return arg0_19.exEnergyTarget
end

function var0_0.ReduceEnergy(arg0_20, arg1_20)
	arg0_20.energy = arg0_20.energy - arg1_20
end

function var0_0.ShouldInvincible(arg0_21)
	return arg0_21.state ~= var5_0 and arg0_21.energy >= arg0_21.exEnergyTarget
end

function var0_0.ShouldVincible(arg0_22)
	if arg0_22.state == var5_0 and arg0_22.energy <= 0 then
		return true
	end

	return false
end

function var0_0.InvincibleState(arg0_23)
	return arg0_23.state == var5_0
end

function var0_0.Invincible(arg0_24)
	arg0_24.harm = 1
	arg0_24.state = var5_0
end

function var0_0.IsMissState(arg0_25)
	return arg0_25.state == var4_0
end

function var0_0.IsDamageState(arg0_26)
	return arg0_26.state == var3_0
end

function var0_0.Vincible(arg0_27)
	arg0_27:StartAction("EX_FINISH")

	arg0_27.harm = 0
	arg0_27.state = var1_0
end

function var0_0.Destory(arg0_28)
	arg0_28.animatorEvent:SetEndEvent(nil)
	Destroy(arg0_28._go)

	arg0_28._go = nil
	arg0_28.animator = nil
end

return var0_0
