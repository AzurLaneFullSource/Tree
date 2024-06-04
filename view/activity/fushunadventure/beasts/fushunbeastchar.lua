local var0 = class("FushunBeastChar")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.index = arg2
	arg0.template_id = arg3.id
	arg0.name = arg3.name
	arg0.dir = -1
	arg0.maxHp = arg3.hp
	arg0.hp = arg3.hp
	arg0.attackDistance = arg3.attackDistance
	arg0.score = arg3.score
	arg0.energyScore = arg3.energyScore
	arg0.escape = false
	arg0.freeze = false
	arg0.attacking = false
	arg0.animator = arg0._go:GetComponent(typeof(Animator))
	arg0.animatorEvent = arg0._go:GetComponent(typeof(DftAniEvent))
	arg0.collider2D = arg0._tf:GetComponent(typeof(UnityEngine.Collider2D))
	arg0.effectCollider2D = arg0._tf:Find("effect"):GetComponent(typeof(UnityEngine.Collider2D))
	arg0.hpBar = UIItemList.New(arg1.transform:Find("hp"), arg1.transform:Find("hp/tpl"))
	arg0.fushunLoader = arg4

	arg0:MakeHpBar()
end

function var0.MakeHpBar(arg0)
	setActive(arg0.hpBar.container, true)
	arg0.hpBar:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("mark"), arg1 < arg0.hp)
		end
	end)
	arg0.hpBar:align(arg0.maxHp)
end

function var0.SetSpeed(arg0, arg1)
	arg0.speed = arg1
end

function var0.SetPosition(arg0, arg1)
	arg0._tf.localPosition = arg1
end

function var0.GetPosition(arg0)
	return arg0._tf.localPosition
end

function var0.GetAttackPosition(arg0)
	return arg0._tf.localPosition - Vector3(arg0.attackDistance, 0, 0)
end

function var0.Move(arg0)
	if arg0.attacking then
		return
	end

	arg0._tf:Translate(Vector3(-1 * arg0.speed * Time.deltaTime, 0, 0))
	arg0.animator:SetFloat("speed", arg0.speed)
end

function var0.Attack(arg0)
	arg0.animatorEvent:SetEndEvent(nil)
	arg0.animatorEvent:SetEndEvent(function()
		arg0.attacking = false

		arg0:Unfreeze()
		arg0:Die()
	end)
	arg0.animatorEvent:SetTriggerEvent(nil)
	arg0.animatorEvent:SetTriggerEvent(function()
		setActive(arg0.hpBar.container, false)
	end)

	arg0.attacking = true

	arg0.animator:SetTrigger("attack")
end

function var0.OnHit(arg0)
	arg0.escape = true

	arg0:Freeze()
end

function var0.IsEscape(arg0)
	return arg0.escape
end

function var0.Die(arg0)
	arg0:UpdateHp(0)
end

function var0.Hurt(arg0, arg1)
	if arg0:IsDeath() or arg0:IsEscape() then
		return
	end

	arg0:UpdateHp(arg0.hp - arg1)
end

function var0.UpdateHp(arg0, arg1)
	arg0.hp = math.max(arg1, 0)

	arg0.hpBar:align(arg0.maxHp)
end

function var0.IsFreeze(arg0)
	return arg0.freeze
end

function var0.Freeze(arg0)
	arg0.freeze = true
end

function var0.Unfreeze(arg0)
	arg0.freeze = false
end

function var0.IsDeath(arg0)
	return arg0.hp <= 0
end

function var0.WillDeath(arg0)
	return arg0:IsDeath() or arg0:IsEscape()
end

function var0.GetHp(arg0)
	return arg0.hp
end

function var0.Vanish(arg0)
	if arg0.vanish then
		return
	end

	if arg0:IsEscape() then
		arg0:Dispose()
	else
		arg0.vanish = true

		arg0.animatorEvent:SetEndEvent(nil)
		arg0.animatorEvent:SetEndEvent(function()
			arg0:Dispose()
		end)
		arg0.animator:SetTrigger("vanish")
	end

	setActive(arg0.hpBar.container, false)
end

function var0.GetScore(arg0)
	return arg0.score
end

function var0.GetEnergyScore(arg0)
	return arg0.energyScore
end

function var0.GetMaxHp(arg0)
	return arg0.maxHp
end

function var0.Dispose(arg0)
	arg0.animatorEvent:SetTriggerEvent(nil)
	arg0.animatorEvent:SetEndEvent(nil)
	arg0.fushunLoader:ReturnPrefab("FushunAdventure/" .. arg0.name, "", arg0._go, false)

	arg0._go = nil
	arg0._tf = nil
	arg0.animator = nil
end

return var0
