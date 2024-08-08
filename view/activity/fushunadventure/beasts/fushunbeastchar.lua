local var0_0 = class("FushunBeastChar")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.index = arg2_1
	arg0_1.template_id = arg3_1.id
	arg0_1.name = arg3_1.name
	arg0_1.dir = -1
	arg0_1.maxHp = arg3_1.hp
	arg0_1.hp = arg3_1.hp
	arg0_1.attackDistance = arg3_1.attackDistance
	arg0_1.score = arg3_1.score
	arg0_1.energyScore = arg3_1.energyScore
	arg0_1.escape = false
	arg0_1.freeze = false
	arg0_1.attacking = false
	arg0_1.animator = arg0_1._go:GetComponent(typeof(Animator))
	arg0_1.animatorEvent = arg0_1._go:GetComponent(typeof(DftAniEvent))
	arg0_1.collider2D = arg0_1._tf:GetComponent(typeof(UnityEngine.Collider2D))
	arg0_1.effectCollider2D = arg0_1._tf:Find("effect"):GetComponent(typeof(UnityEngine.Collider2D))
	arg0_1.hpBar = UIItemList.New(arg1_1.transform:Find("hp"), arg1_1.transform:Find("hp/tpl"))

	arg0_1:MakeHpBar()
end

function var0_0.MakeHpBar(arg0_2)
	setActive(arg0_2.hpBar.container, true)
	arg0_2.hpBar:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			setActive(arg2_3:Find("mark"), arg1_3 < arg0_2.hp)
		end
	end)
	arg0_2.hpBar:align(arg0_2.maxHp)
end

function var0_0.SetSpeed(arg0_4, arg1_4)
	arg0_4.speed = arg1_4
end

function var0_0.SetPosition(arg0_5, arg1_5)
	arg0_5._tf.localPosition = arg1_5
end

function var0_0.GetPosition(arg0_6)
	return arg0_6._tf.localPosition
end

function var0_0.GetAttackPosition(arg0_7)
	return arg0_7._tf.localPosition - Vector3(arg0_7.attackDistance, 0, 0)
end

function var0_0.Move(arg0_8)
	if arg0_8.attacking then
		return
	end

	arg0_8._tf:Translate(Vector3(-1 * arg0_8.speed * Time.deltaTime, 0, 0))
	arg0_8.animator:SetFloat("speed", arg0_8.speed)
end

function var0_0.Attack(arg0_9)
	arg0_9.animatorEvent:SetEndEvent(nil)
	arg0_9.animatorEvent:SetEndEvent(function()
		arg0_9.attacking = false

		arg0_9:Unfreeze()
		arg0_9:Die()
	end)
	arg0_9.animatorEvent:SetTriggerEvent(nil)
	arg0_9.animatorEvent:SetTriggerEvent(function()
		setActive(arg0_9.hpBar.container, false)
	end)

	arg0_9.attacking = true

	arg0_9.animator:SetTrigger("attack")
end

function var0_0.OnHit(arg0_12)
	arg0_12.escape = true

	arg0_12:Freeze()
end

function var0_0.IsEscape(arg0_13)
	return arg0_13.escape
end

function var0_0.Die(arg0_14)
	arg0_14:UpdateHp(0)
end

function var0_0.Hurt(arg0_15, arg1_15)
	if arg0_15:IsDeath() or arg0_15:IsEscape() then
		return
	end

	arg0_15:UpdateHp(arg0_15.hp - arg1_15)
end

function var0_0.UpdateHp(arg0_16, arg1_16)
	arg0_16.hp = math.max(arg1_16, 0)

	arg0_16.hpBar:align(arg0_16.maxHp)
end

function var0_0.IsFreeze(arg0_17)
	return arg0_17.freeze
end

function var0_0.Freeze(arg0_18)
	arg0_18.freeze = true
end

function var0_0.Unfreeze(arg0_19)
	arg0_19.freeze = false
end

function var0_0.IsDeath(arg0_20)
	return arg0_20.hp <= 0
end

function var0_0.WillDeath(arg0_21)
	return arg0_21:IsDeath() or arg0_21:IsEscape()
end

function var0_0.GetHp(arg0_22)
	return arg0_22.hp
end

function var0_0.Vanish(arg0_23)
	if arg0_23.vanish then
		return
	end

	if arg0_23:IsEscape() then
		arg0_23:Dispose()
	else
		arg0_23.vanish = true

		arg0_23.animatorEvent:SetEndEvent(nil)
		arg0_23.animatorEvent:SetEndEvent(function()
			arg0_23:Dispose()
		end)
		arg0_23.animator:SetTrigger("vanish")
	end

	setActive(arg0_23.hpBar.container, false)
end

function var0_0.GetScore(arg0_25)
	return arg0_25.score
end

function var0_0.GetEnergyScore(arg0_26)
	return arg0_26.energyScore
end

function var0_0.GetMaxHp(arg0_27)
	return arg0_27.maxHp
end

function var0_0.Dispose(arg0_28)
	arg0_28.animatorEvent:SetTriggerEvent(nil)
	arg0_28.animatorEvent:SetEndEvent(nil)

	if arg0_28._go then
		Destroy(arg0_28._go)
	end

	arg0_28._go = nil
	arg0_28._tf = nil
	arg0_28.animator = nil
end

return var0_0
