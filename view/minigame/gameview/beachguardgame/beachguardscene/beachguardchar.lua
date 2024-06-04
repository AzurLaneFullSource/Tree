local var0 = class("BeachGuardChar")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0._config = arg2
	arg0._event = arg3
	arg0._tf.name = arg2.name
	arg0._rid = BeachGuardConst.getRid()
	arg0.animChar = BeachGuardAsset.getChar(arg0._config.name)
	arg0.pos = findTF(arg0._tf, "pos")

	setActive(arg0.animChar, true)
	setParent(arg0.animChar, arg0.pos)

	arg0.animChar.anchoredPosition = Vector2(0, 0)
	arg0.animTf = findTF(arg0.animChar, "anim")
	arg0.effectBackPos = findTF(arg0._tf, "effectBackPos")
	arg0.effectFrontPos = findTF(arg0._tf, "effectFrontPos")
	arg0.statusPos = findTF(arg0._tf, "statusPos")
	arg0.move = arg0._config.move
	arg0.defFlag = arg0._config.def and arg0._config.def > 0
	arg0.skillDatas = {}

	for iter0 = 1, #arg0._config.skill do
		local var0 = arg0._config.skill[iter0]
		local var1 = BeachGuardConst.skill[var0]

		table.insert(arg0.skillDatas, {
			skill = var1,
			cd = var1.cd,
			auto = var1.auto
		})
	end

	arg0.triggerData = {}
	arg0.animator = GetComponent(findTF(arg0.animChar, "anim"), typeof(Animator))
	arg0.point = findTF(arg0.animChar, "point")
	arg0.collider = findTF(arg0.animChar, "charCollider")
	arg0.minX = arg0.collider.rect.min.x
	arg0.minY = arg0.collider.rect.min.y
	arg0.maxX = arg0.collider.rect.max.x
	arg0.maxY = arg0.collider.rect.max.y
	arg0.bulletPos = findTF(arg0.animChar, "bullet")
	arg0.atkPos = findTF(arg0.animChar, "atk")

	local var2 = findTF(arg0._tf, "click")

	onButton(arg0._event, findTF(arg0._tf, "click"), function()
		if arg0.recycle then
			arg0:overLife()
			arg0:dead()
			arg0._event:emit(BeachGuardGameView.RECYCLES_CHAR_CANCEL)
		end
	end)
	arg0:prepareData()

	GetOrAddComponent(arg0.pos, typeof(CanvasGroup)).blocksRaycasts = false
end

function var0.setParent(arg0, arg1, arg2, arg3)
	setParent(arg0._tf, arg1)

	arg3 = arg3 or Vector2(0, 0)
	arg0._tf.anchoredPosition = arg3
	arg0.inGrid = arg2

	setActive(arg0._tf, true)
end

function var0.getId(arg0)
	return arg0:getConfig("id")
end

function var0.overLife(arg0)
	arg0.hp = 0
	arg0.def = 0
end

function var0.getConfig(arg0, arg1)
	return arg0._config[arg1]
end

function var0.prepareData(arg0)
	if arg0.defFlag then
		arg0:setStatusIndex(1)
	else
		arg0:setStatusIndex(0)
	end

	arg0.hp = arg0._config.hp or 1
	arg0.def = arg0._config.def or 0

	for iter0 = 1, #arg0.skillDatas do
		local var0 = arg0.skillDatas[iter0].skill

		arg0.skillDatas[iter0].cd = var0.cd
	end

	arg0.buffAtkRate = 1
	arg0.buffSpeedRate = 1
	arg0.triggerData = {}
	arg0.timeToPool = 0
	arg0._lineIndex = nil
	arg0._gridIndex = nil
	arg0.damageTime = 0
	arg0.recycle = false

	if arg0.buffs and #arg0.buffs > 0 then
		for iter1 = 1, #arg0.buffs do
			arg0:disposeBuff(arg0.buffs[iter1])
		end
	end

	arg0.craftNum = 0
	arg0.buffs = {}
end

function var0.SetSiblingIndex(arg0, arg1)
	arg0._tf:SetSiblingIndex(arg1)
end

function var0.start(arg0)
	arg0:prepareData()
end

function var0.step(arg0, arg1)
	if arg0.timeToPool > 0 then
		arg0.timeToPool = arg0.timeToPool - arg1

		if arg0.timeToPool <= 0 then
			arg0.timeToPool = 0

			arg0._event:emit(BeachGuardGameView.REMOVE_CHAR, arg0)
		end
	end

	if arg0:isAlife() then
		for iter0 = 1, #arg0.buffs do
			local var0 = arg0.buffs[iter0]

			var0.time = var0.time - arg1

			if var0.time <= 0 then
				var0.times = 0

				if var0.effectTfs then
					for iter1, iter2 in ipairs(var0.effectTfs) do
						setActive(iter2, false)
					end
				end

				if var0.triggerEffectTfs then
					for iter3, iter4 in ipairs(var0.triggerEffectTfs) do
						setActive(iter4, false)
					end
				end
			end
		end

		for iter5 = 1, #arg0.skillDatas do
			local var1 = arg0.skillDatas[iter5]
			local var2 = var1.skill
			local var3 = arg0.skillDatas[iter5].cd
			local var4 = arg0.skillDatas[iter5].auto

			if var3 ~= 0 then
				var3 = var3 - arg1

				if var3 < 0 then
					var3 = 0
				end

				arg0.skillDatas[iter5].cd = var3
			end

			if var3 == 0 then
				if var2.type == BeachGuardConst.skill_bullet and var4 and arg0.targetChar then
					arg0:useSkill(var1)
				elseif var2.type == BeachGuardConst.skill_melee and arg0.targetChar then
					arg0:useSkill(var1)
				elseif var2.type == BeachGuardConst.skill_craft then
					arg0:addCraft()
					arg0:useSkill(var1)
				end
			end
		end

		for iter6 = #arg0.triggerData, 1, -1 do
			local var5 = arg0.triggerData[iter6]

			var5.time = var5.time - arg1

			if var5.time <= 0 then
				arg0._event:emit(var5.event, var5.data)
				table.remove(arg0.triggerData, iter6)
			end
		end

		local var6, var7 = arg0:getSpeed(arg1)

		if arg0.damageTime ~= 0 then
			arg0.damageTime = arg0.damageTime - Time.deltaTime
			var6 = 0
			var7 = 0

			if arg0.damageTime <= 0 then
				arg0.damageTime = 0
			end
		elseif arg0.targetChar then
			var6 = 0
			var7 = 0
		end

		local var8 = var6 * arg0:getSpeedRate()

		arg0:moveChar(var8, var7)

		if arg0.speedX ~= var8 then
			arg0.speedX = var8

			if arg0.speedX ~= 0 then
				arg0.animator:SetBool("move", true)
				arg0.animator:SetBool("wait", false)
			else
				arg0.animator:SetBool("move", false)
				arg0.animator:SetBool("wait", true)
			end
		end

		if var8 and var8 ~= 0 and arg0._tf.anchoredPosition.x <= -500 then
			arg0:dead()
		end
	end

	arg0._anchoredPosition = nil
	arg0._position = nil
end

function var0.addCraft(arg0)
	arg0.craftNum = arg0.craftNum + 1

	if arg0.craftNum > 3 then
		arg0.craftNum = 0
	end

	for iter0 = 1, 3 do
		local var0 = findTF(arg0.animChar, "craft/" .. tostring(iter0))

		if var0 then
			setActive(var0, iter0 <= arg0.craftNum)
		end
	end
end

function var0.getPointWorld(arg0)
	return arg0.point.position
end

function var0.getSpeed(arg0, arg1)
	return arg0.move.x * arg1, arg0.move.y * arg1
end

function var0.moveChar(arg0, arg1, arg2)
	if arg1 == 0 and arg2 == 0 then
		return
	end

	local var0 = arg0._tf.anchoredPosition

	var0.x = var0.x + arg1
	var0.y = var0.y + arg2
	arg0._tf.anchoredPosition = var0
end

function var0.getSkillDistance(arg0)
	if not arg0.skillDistane then
		arg0.skillDistane = 0

		for iter0 = 1, #arg0.skillDatas do
			local var0 = arg0.skillDatas[iter0].skill.distance

			if var0 and var0 > arg0.skillDistane then
				arg0.skillDistane = var0 + 0.5
			end
		end
	end

	return arg0.skillDistane
end

function var0.inBulletBound(arg0)
	return arg0._tf.anchoredPosition.x < BeachGuardConst.enemy_bullet_width
end

function var0.setTarget(arg0, arg1)
	arg0.targetChar = arg1
end

function var0.getTarget(arg0, arg1)
	return arg0.targetChar
end

function var0.dead(arg0)
	arg0:overLife()
	arg0.animator:SetTrigger("dead")

	arg0.timeToPool = 0.5
	arg0.recycle = false
end

function var0.useSkill(arg0, arg1)
	if not arg0:isAlife() then
		return
	end

	local var0 = arg1.skill

	if BeachGuardConst.ignore_enemy_skill and arg0.camp == 2 then
		arg1.cd = var0.cd

		return
	end

	local var1 = var0.anim_type

	if var1 == BeachGuardConst.anim_atk then
		arg0.animator:SetTrigger("attack")
	elseif var1 == BeachGuardConst.anim_craft then
		arg0.animator:SetTrigger("create")
	end

	local var2 = arg0:createUseData(var0)

	table.insert(arg0.triggerData, {
		data = var2,
		time = var0.time,
		event = BeachGuardGameView.USE_SKILL
	})

	arg1.cd = var0.cd
end

function var0.setRecycleFlag(arg0, arg1)
	arg0.recycle = arg1
end

function var0.getRecycleFlag(arg0)
	return arg0.recycle
end

function var0.damage(arg0, arg1)
	if BeachGuardConst.ignore_damage then
		arg1 = 0
	end

	if arg0.def and arg0.def > 0 then
		arg0.def = arg0.def - arg1

		if arg0.def <= 0 then
			arg0.animator:SetTrigger("break")
			arg0:setStatusIndex(2)
		elseif #arg0.triggerData == 0 then
			arg0.animator:SetTrigger("damage")
		end
	elseif arg0.hp > 0 then
		arg0.hp = arg0.hp - arg1

		if arg0.hp <= 0 then
			arg0:dead()
		elseif #arg0.triggerData == 0 then
			arg0.animator:SetTrigger("damage")
		end
	end
end

function var0.isAlife(arg0)
	if arg0.def and arg0.def > 0 then
		return true
	end

	if arg0.hp and arg0.hp > 0 then
		return true
	end

	return false
end

function var0.setStatusIndex(arg0, arg1)
	arg0.animator:SetInteger("wait_index", arg1)
	arg0.animator:SetInteger("damage_index", arg1)
end

function var0.setCamp(arg0, arg1)
	arg0.camp = arg1
end

function var0.getCamp(arg0)
	return arg0.camp
end

function var0.getAnimPos(arg0)
	return arg0.animTf.position
end

function var0.createUseData(arg0, arg1)
	local var0 = {
		skill = arg1
	}

	if arg1.type == BeachGuardConst.skill_bullet then
		var0.position = arg0.bulletPos.position
	elseif arg1.type == BeachGuardConst.skill_melee then
		var0.position = arg0.animTf.position
	else
		var0.position = arg0._tf.position
	end

	var0.distanceVec = Vector2(arg0:getSkillDistance() * BeachGuardConst.part_width, 0)
	var0.direct = arg0._config.point or 1
	var0.rid = arg0._rid
	var0.target = arg0.targetChar
	var0.damage = arg1.damage
	var0.camp = arg0.camp
	var0.line = arg0._lineIndex
	var0.useChar = arg0
	var0.atkRate = arg0:getAtkRate()
	var0.speedRate = arg0:getSpeedRate()

	return var0
end

function var0.getAtkRate(arg0)
	local var0 = 1

	for iter0 = 1, #arg0.buffs do
		local var1 = arg0.buffs[iter0]

		if var1.config.type == BeachGuardConst.buff_type_speed_down then
			var0 = var0 - var1.config.rate * var1.times
		end
	end

	if var0 < 0 then
		var0 = 0
	end

	return var0
end

function var0.getSpeedRate(arg0)
	local var0 = 1

	for iter0 = 1, #arg0.buffs do
		local var1 = arg0.buffs[iter0]

		if var1.config.type == BeachGuardConst.buff_type_speed_down then
			var0 = var0 - var1.config.rate * var1.times
		end
	end

	if var0 < 0 then
		var0 = 0
	end

	return var0
end

function var0.clear(arg0)
	arg0:prepareData()
	setActive(arg0._tf, false)

	arg0.inGrid = false
	arg0.targetChar = nil
end

function var0.getDistance(arg0)
	return arg0._config.distance or 0
end

function var0.setLineIndex(arg0, arg1)
	arg0._lineIndex = arg1
end

function var0.getLineIndex(arg0)
	return arg0._lineIndex
end

function var0.getPos(arg0)
	if not arg0._anchoredPosition then
		arg0._anchoredPosition = arg0._tf.anchoredPosition
	end

	return arg0._anchoredPosition
end

function var0.setGridIndex(arg0, arg1)
	arg0._gridIndex = arg1
end

function var0.getGridIndex(arg0, arg1)
	return arg0._gridIndex
end

function var0.getWorldPos(arg0)
	if not arg0._position then
		arg0._position = arg0._tf.position
	end

	return arg0._position
end

function var0.getCollider(arg0)
	return arg0.collider
end

function var0.checkCollider(arg0, arg1, arg2)
	if not arg0:isAlife() then
		return
	end

	local var0 = arg0.animChar:InverseTransformPoint(arg1)

	if var0.x > arg0.minX and var0.x < arg0.maxX and arg2.x > arg0._tf.anchoredPosition.x then
		return true
	end

	return false
end

function var0.checkBulletCollider(arg0, arg1)
	if not arg0:isAlife() then
		return
	end

	local var0 = arg0.animChar:InverseTransformPoint(arg1)

	if var0.x > arg0.minX and var0.x < arg0.maxX and var0.y > arg0.minY and var0.y < arg0.maxY then
		return true
	end

	return false
end

function var0.setRaycast(arg0, arg1)
	GetComponent(findTF(arg0._tf, "click"), typeof(Image)).raycastTarget = arg1
end

function var0.addBuff(arg0, arg1)
	local var0 = arg1.id
	local var1 = arg0:getOrCreateBuff(var0)

	var1.time = arg1.time
	var1.times = var1.times + 1

	if var1.times > arg1.times then
		var1.times = arg1.times
	else
		for iter0, iter1 in ipairs(var1.triggerEffectTfs) do
			setActive(iter1, false)
			setActive(iter1, true)
		end
	end

	if var1.effectTfs then
		for iter2, iter3 in ipairs(var1.effectTfs) do
			setActive(iter3, false)
			setActive(iter3, true)
		end
	end
end

function var0.removeBuff(arg0, arg1)
	for iter0 = #arg0.buffs, 1, -1 do
		if arg0.buffs[iter0] == arg1 then
			local var0 = table.remove(arg0.buffs, iter0)

			arg0:disposeBuff(var0)
		end
	end
end

function var0.disposeBuff(arg0, arg1)
	if #arg1.effectTfs > 0 then
		for iter0 = 1, #arg1.effectTfs do
			Destroy(arg1.effectTfs[iter0])
		end
	end

	arg1.effectTfs = {}

	if #arg1.triggerEffectTfs > 0 then
		for iter1 = 1, #arg1.triggerEffectTfs do
			Destroy(arg1.triggerEffectTfs[iter1])
		end
	end

	arg1.triggerEffectTfs = {}
end

function var0.getOrCreateBuff(arg0, arg1)
	for iter0 = 1, #arg0.buffs do
		if arg0.buffs[iter0].config.id == arg1 then
			return arg0.buffs[iter0]
		end
	end

	local var0 = {}
	local var1 = BeachGuardConst.buff[arg1]

	var0.effectTfs = {}

	if var1.effect and #var1.effect > 0 then
		for iter1, iter2 in ipairs(var1.effect) do
			local var2 = BeachGuardConst.effect[iter2]
			local var3 = BeachGuardAsset.getEffect(var2.name)

			if var2.front then
				setParent(var3, arg0.effectFrontPos)
			else
				setParent(var3, arg0.effectBackPos)
			end

			setActive(var3, true)

			var3.anchoredPosition = Vector2(0, 0)

			table.insert(var0.effectTfs, var3)
		end
	end

	var0.triggerEffectTfs = {}

	if var1.trigger_effect and #var1.trigger_effect > 0 then
		for iter3, iter4 in ipairs(var1.trigger_effect) do
			local var4 = BeachGuardConst.effect[iter4]
			local var5 = BeachGuardAsset.getEffect(var4.name)

			if var4.front then
				setParent(var5, arg0.effectFrontPos)
			else
				setParent(var5, arg0.effectBackPos)
			end

			setActive(var5, true)

			var5.anchoredPosition = Vector2(0, 0)

			table.insert(var0.triggerEffectTfs, var5)
		end
	end

	var0.times = 0
	var0.time = 0
	var0.config = var1

	table.insert(arg0.buffs, var0)

	return var0
end

function var0.getScore(arg0)
	return arg0._config.score or 0
end

return var0
