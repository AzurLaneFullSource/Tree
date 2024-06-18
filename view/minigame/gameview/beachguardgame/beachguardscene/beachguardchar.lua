local var0_0 = class("BeachGuardChar")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._config = arg2_1
	arg0_1._event = arg3_1
	arg0_1._tf.name = arg2_1.name
	arg0_1._rid = BeachGuardConst.getRid()
	arg0_1.animChar = BeachGuardAsset.getChar(arg0_1._config.name)
	arg0_1.pos = findTF(arg0_1._tf, "pos")

	setActive(arg0_1.animChar, true)
	setParent(arg0_1.animChar, arg0_1.pos)

	arg0_1.animChar.anchoredPosition = Vector2(0, 0)
	arg0_1.animTf = findTF(arg0_1.animChar, "anim")
	arg0_1.effectBackPos = findTF(arg0_1._tf, "effectBackPos")
	arg0_1.effectFrontPos = findTF(arg0_1._tf, "effectFrontPos")
	arg0_1.statusPos = findTF(arg0_1._tf, "statusPos")
	arg0_1.move = arg0_1._config.move
	arg0_1.defFlag = arg0_1._config.def and arg0_1._config.def > 0
	arg0_1.skillDatas = {}

	for iter0_1 = 1, #arg0_1._config.skill do
		local var0_1 = arg0_1._config.skill[iter0_1]
		local var1_1 = BeachGuardConst.skill[var0_1]

		table.insert(arg0_1.skillDatas, {
			skill = var1_1,
			cd = var1_1.cd,
			auto = var1_1.auto
		})
	end

	arg0_1.triggerData = {}
	arg0_1.animator = GetComponent(findTF(arg0_1.animChar, "anim"), typeof(Animator))
	arg0_1.point = findTF(arg0_1.animChar, "point")
	arg0_1.collider = findTF(arg0_1.animChar, "charCollider")
	arg0_1.minX = arg0_1.collider.rect.min.x
	arg0_1.minY = arg0_1.collider.rect.min.y
	arg0_1.maxX = arg0_1.collider.rect.max.x
	arg0_1.maxY = arg0_1.collider.rect.max.y
	arg0_1.bulletPos = findTF(arg0_1.animChar, "bullet")
	arg0_1.atkPos = findTF(arg0_1.animChar, "atk")

	local var2_1 = findTF(arg0_1._tf, "click")

	onButton(arg0_1._event, findTF(arg0_1._tf, "click"), function()
		if arg0_1.recycle then
			arg0_1:overLife()
			arg0_1:dead()
			arg0_1._event:emit(BeachGuardGameView.RECYCLES_CHAR_CANCEL)
		end
	end)
	arg0_1:prepareData()

	GetOrAddComponent(arg0_1.pos, typeof(CanvasGroup)).blocksRaycasts = false
end

function var0_0.setParent(arg0_3, arg1_3, arg2_3, arg3_3)
	setParent(arg0_3._tf, arg1_3)

	arg3_3 = arg3_3 or Vector2(0, 0)
	arg0_3._tf.anchoredPosition = arg3_3
	arg0_3.inGrid = arg2_3

	setActive(arg0_3._tf, true)
end

function var0_0.getId(arg0_4)
	return arg0_4:getConfig("id")
end

function var0_0.overLife(arg0_5)
	arg0_5.hp = 0
	arg0_5.def = 0
end

function var0_0.getConfig(arg0_6, arg1_6)
	return arg0_6._config[arg1_6]
end

function var0_0.prepareData(arg0_7)
	if arg0_7.defFlag then
		arg0_7:setStatusIndex(1)
	else
		arg0_7:setStatusIndex(0)
	end

	arg0_7.hp = arg0_7._config.hp or 1
	arg0_7.def = arg0_7._config.def or 0

	for iter0_7 = 1, #arg0_7.skillDatas do
		local var0_7 = arg0_7.skillDatas[iter0_7].skill

		arg0_7.skillDatas[iter0_7].cd = var0_7.cd
	end

	arg0_7.buffAtkRate = 1
	arg0_7.buffSpeedRate = 1
	arg0_7.triggerData = {}
	arg0_7.timeToPool = 0
	arg0_7._lineIndex = nil
	arg0_7._gridIndex = nil
	arg0_7.damageTime = 0
	arg0_7.recycle = false

	if arg0_7.buffs and #arg0_7.buffs > 0 then
		for iter1_7 = 1, #arg0_7.buffs do
			arg0_7:disposeBuff(arg0_7.buffs[iter1_7])
		end
	end

	arg0_7.craftNum = 0
	arg0_7.buffs = {}
end

function var0_0.SetSiblingIndex(arg0_8, arg1_8)
	arg0_8._tf:SetSiblingIndex(arg1_8)
end

function var0_0.start(arg0_9)
	arg0_9:prepareData()
end

function var0_0.step(arg0_10, arg1_10)
	if arg0_10.timeToPool > 0 then
		arg0_10.timeToPool = arg0_10.timeToPool - arg1_10

		if arg0_10.timeToPool <= 0 then
			arg0_10.timeToPool = 0

			arg0_10._event:emit(BeachGuardGameView.REMOVE_CHAR, arg0_10)
		end
	end

	if arg0_10:isAlife() then
		for iter0_10 = 1, #arg0_10.buffs do
			local var0_10 = arg0_10.buffs[iter0_10]

			var0_10.time = var0_10.time - arg1_10

			if var0_10.time <= 0 then
				var0_10.times = 0

				if var0_10.effectTfs then
					for iter1_10, iter2_10 in ipairs(var0_10.effectTfs) do
						setActive(iter2_10, false)
					end
				end

				if var0_10.triggerEffectTfs then
					for iter3_10, iter4_10 in ipairs(var0_10.triggerEffectTfs) do
						setActive(iter4_10, false)
					end
				end
			end
		end

		for iter5_10 = 1, #arg0_10.skillDatas do
			local var1_10 = arg0_10.skillDatas[iter5_10]
			local var2_10 = var1_10.skill
			local var3_10 = arg0_10.skillDatas[iter5_10].cd
			local var4_10 = arg0_10.skillDatas[iter5_10].auto

			if var3_10 ~= 0 then
				var3_10 = var3_10 - arg1_10

				if var3_10 < 0 then
					var3_10 = 0
				end

				arg0_10.skillDatas[iter5_10].cd = var3_10
			end

			if var3_10 == 0 then
				if var2_10.type == BeachGuardConst.skill_bullet and var4_10 and arg0_10.targetChar then
					arg0_10:useSkill(var1_10)
				elseif var2_10.type == BeachGuardConst.skill_melee and arg0_10.targetChar then
					arg0_10:useSkill(var1_10)
				elseif var2_10.type == BeachGuardConst.skill_craft then
					arg0_10:addCraft()
					arg0_10:useSkill(var1_10)
				end
			end
		end

		for iter6_10 = #arg0_10.triggerData, 1, -1 do
			local var5_10 = arg0_10.triggerData[iter6_10]

			var5_10.time = var5_10.time - arg1_10

			if var5_10.time <= 0 then
				arg0_10._event:emit(var5_10.event, var5_10.data)
				table.remove(arg0_10.triggerData, iter6_10)
			end
		end

		local var6_10, var7_10 = arg0_10:getSpeed(arg1_10)

		if arg0_10.damageTime ~= 0 then
			arg0_10.damageTime = arg0_10.damageTime - Time.deltaTime
			var6_10 = 0
			var7_10 = 0

			if arg0_10.damageTime <= 0 then
				arg0_10.damageTime = 0
			end
		elseif arg0_10.targetChar then
			var6_10 = 0
			var7_10 = 0
		end

		local var8_10 = var6_10 * arg0_10:getSpeedRate()

		arg0_10:moveChar(var8_10, var7_10)

		if arg0_10.speedX ~= var8_10 then
			arg0_10.speedX = var8_10

			if arg0_10.speedX ~= 0 then
				arg0_10.animator:SetBool("move", true)
				arg0_10.animator:SetBool("wait", false)
			else
				arg0_10.animator:SetBool("move", false)
				arg0_10.animator:SetBool("wait", true)
			end
		end

		if var8_10 and var8_10 ~= 0 and arg0_10._tf.anchoredPosition.x <= -500 then
			arg0_10:dead()
		end
	end

	arg0_10._anchoredPosition = nil
	arg0_10._position = nil
end

function var0_0.addCraft(arg0_11)
	arg0_11.craftNum = arg0_11.craftNum + 1

	if arg0_11.craftNum > 3 then
		arg0_11.craftNum = 0
	end

	for iter0_11 = 1, 3 do
		local var0_11 = findTF(arg0_11.animChar, "craft/" .. tostring(iter0_11))

		if var0_11 then
			setActive(var0_11, iter0_11 <= arg0_11.craftNum)
		end
	end
end

function var0_0.getPointWorld(arg0_12)
	return arg0_12.point.position
end

function var0_0.getSpeed(arg0_13, arg1_13)
	return arg0_13.move.x * arg1_13, arg0_13.move.y * arg1_13
end

function var0_0.moveChar(arg0_14, arg1_14, arg2_14)
	if arg1_14 == 0 and arg2_14 == 0 then
		return
	end

	local var0_14 = arg0_14._tf.anchoredPosition

	var0_14.x = var0_14.x + arg1_14
	var0_14.y = var0_14.y + arg2_14
	arg0_14._tf.anchoredPosition = var0_14
end

function var0_0.getSkillDistance(arg0_15)
	if not arg0_15.skillDistane then
		arg0_15.skillDistane = 0

		for iter0_15 = 1, #arg0_15.skillDatas do
			local var0_15 = arg0_15.skillDatas[iter0_15].skill.distance

			if var0_15 and var0_15 > arg0_15.skillDistane then
				arg0_15.skillDistane = var0_15 + 0.5
			end
		end
	end

	return arg0_15.skillDistane
end

function var0_0.inBulletBound(arg0_16)
	return arg0_16._tf.anchoredPosition.x < BeachGuardConst.enemy_bullet_width
end

function var0_0.setTarget(arg0_17, arg1_17)
	arg0_17.targetChar = arg1_17
end

function var0_0.getTarget(arg0_18, arg1_18)
	return arg0_18.targetChar
end

function var0_0.dead(arg0_19)
	arg0_19:overLife()
	arg0_19.animator:SetTrigger("dead")

	arg0_19.timeToPool = 0.5
	arg0_19.recycle = false
end

function var0_0.useSkill(arg0_20, arg1_20)
	if not arg0_20:isAlife() then
		return
	end

	local var0_20 = arg1_20.skill

	if BeachGuardConst.ignore_enemy_skill and arg0_20.camp == 2 then
		arg1_20.cd = var0_20.cd

		return
	end

	local var1_20 = var0_20.anim_type

	if var1_20 == BeachGuardConst.anim_atk then
		arg0_20.animator:SetTrigger("attack")
	elseif var1_20 == BeachGuardConst.anim_craft then
		arg0_20.animator:SetTrigger("create")
	end

	local var2_20 = arg0_20:createUseData(var0_20)

	table.insert(arg0_20.triggerData, {
		data = var2_20,
		time = var0_20.time,
		event = BeachGuardGameView.USE_SKILL
	})

	arg1_20.cd = var0_20.cd
end

function var0_0.setRecycleFlag(arg0_21, arg1_21)
	arg0_21.recycle = arg1_21
end

function var0_0.getRecycleFlag(arg0_22)
	return arg0_22.recycle
end

function var0_0.damage(arg0_23, arg1_23)
	if BeachGuardConst.ignore_damage then
		arg1_23 = 0
	end

	if arg0_23.def and arg0_23.def > 0 then
		arg0_23.def = arg0_23.def - arg1_23

		if arg0_23.def <= 0 then
			arg0_23.animator:SetTrigger("break")
			arg0_23:setStatusIndex(2)
		elseif #arg0_23.triggerData == 0 then
			arg0_23.animator:SetTrigger("damage")
		end
	elseif arg0_23.hp > 0 then
		arg0_23.hp = arg0_23.hp - arg1_23

		if arg0_23.hp <= 0 then
			arg0_23:dead()
		elseif #arg0_23.triggerData == 0 then
			arg0_23.animator:SetTrigger("damage")
		end
	end
end

function var0_0.isAlife(arg0_24)
	if arg0_24.def and arg0_24.def > 0 then
		return true
	end

	if arg0_24.hp and arg0_24.hp > 0 then
		return true
	end

	return false
end

function var0_0.setStatusIndex(arg0_25, arg1_25)
	arg0_25.animator:SetInteger("wait_index", arg1_25)
	arg0_25.animator:SetInteger("damage_index", arg1_25)
end

function var0_0.setCamp(arg0_26, arg1_26)
	arg0_26.camp = arg1_26
end

function var0_0.getCamp(arg0_27)
	return arg0_27.camp
end

function var0_0.getAnimPos(arg0_28)
	return arg0_28.animTf.position
end

function var0_0.createUseData(arg0_29, arg1_29)
	local var0_29 = {
		skill = arg1_29
	}

	if arg1_29.type == BeachGuardConst.skill_bullet then
		var0_29.position = arg0_29.bulletPos.position
	elseif arg1_29.type == BeachGuardConst.skill_melee then
		var0_29.position = arg0_29.animTf.position
	else
		var0_29.position = arg0_29._tf.position
	end

	var0_29.distanceVec = Vector2(arg0_29:getSkillDistance() * BeachGuardConst.part_width, 0)
	var0_29.direct = arg0_29._config.point or 1
	var0_29.rid = arg0_29._rid
	var0_29.target = arg0_29.targetChar
	var0_29.damage = arg1_29.damage
	var0_29.camp = arg0_29.camp
	var0_29.line = arg0_29._lineIndex
	var0_29.useChar = arg0_29
	var0_29.atkRate = arg0_29:getAtkRate()
	var0_29.speedRate = arg0_29:getSpeedRate()

	return var0_29
end

function var0_0.getAtkRate(arg0_30)
	local var0_30 = 1

	for iter0_30 = 1, #arg0_30.buffs do
		local var1_30 = arg0_30.buffs[iter0_30]

		if var1_30.config.type == BeachGuardConst.buff_type_speed_down then
			var0_30 = var0_30 - var1_30.config.rate * var1_30.times
		end
	end

	if var0_30 < 0 then
		var0_30 = 0
	end

	return var0_30
end

function var0_0.getSpeedRate(arg0_31)
	local var0_31 = 1

	for iter0_31 = 1, #arg0_31.buffs do
		local var1_31 = arg0_31.buffs[iter0_31]

		if var1_31.config.type == BeachGuardConst.buff_type_speed_down then
			var0_31 = var0_31 - var1_31.config.rate * var1_31.times
		end
	end

	if var0_31 < 0 then
		var0_31 = 0
	end

	return var0_31
end

function var0_0.clear(arg0_32)
	arg0_32:prepareData()
	setActive(arg0_32._tf, false)

	arg0_32.inGrid = false
	arg0_32.targetChar = nil
end

function var0_0.getDistance(arg0_33)
	return arg0_33._config.distance or 0
end

function var0_0.setLineIndex(arg0_34, arg1_34)
	arg0_34._lineIndex = arg1_34
end

function var0_0.getLineIndex(arg0_35)
	return arg0_35._lineIndex
end

function var0_0.getPos(arg0_36)
	if not arg0_36._anchoredPosition then
		arg0_36._anchoredPosition = arg0_36._tf.anchoredPosition
	end

	return arg0_36._anchoredPosition
end

function var0_0.setGridIndex(arg0_37, arg1_37)
	arg0_37._gridIndex = arg1_37
end

function var0_0.getGridIndex(arg0_38, arg1_38)
	return arg0_38._gridIndex
end

function var0_0.getWorldPos(arg0_39)
	if not arg0_39._position then
		arg0_39._position = arg0_39._tf.position
	end

	return arg0_39._position
end

function var0_0.getCollider(arg0_40)
	return arg0_40.collider
end

function var0_0.checkCollider(arg0_41, arg1_41, arg2_41)
	if not arg0_41:isAlife() then
		return
	end

	local var0_41 = arg0_41.animChar:InverseTransformPoint(arg1_41)

	if var0_41.x > arg0_41.minX and var0_41.x < arg0_41.maxX and arg2_41.x > arg0_41._tf.anchoredPosition.x then
		return true
	end

	return false
end

function var0_0.checkBulletCollider(arg0_42, arg1_42)
	if not arg0_42:isAlife() then
		return
	end

	local var0_42 = arg0_42.animChar:InverseTransformPoint(arg1_42)

	if var0_42.x > arg0_42.minX and var0_42.x < arg0_42.maxX and var0_42.y > arg0_42.minY and var0_42.y < arg0_42.maxY then
		return true
	end

	return false
end

function var0_0.setRaycast(arg0_43, arg1_43)
	GetComponent(findTF(arg0_43._tf, "click"), typeof(Image)).raycastTarget = arg1_43
end

function var0_0.addBuff(arg0_44, arg1_44)
	local var0_44 = arg1_44.id
	local var1_44 = arg0_44:getOrCreateBuff(var0_44)

	var1_44.time = arg1_44.time
	var1_44.times = var1_44.times + 1

	if var1_44.times > arg1_44.times then
		var1_44.times = arg1_44.times
	else
		for iter0_44, iter1_44 in ipairs(var1_44.triggerEffectTfs) do
			setActive(iter1_44, false)
			setActive(iter1_44, true)
		end
	end

	if var1_44.effectTfs then
		for iter2_44, iter3_44 in ipairs(var1_44.effectTfs) do
			setActive(iter3_44, false)
			setActive(iter3_44, true)
		end
	end
end

function var0_0.removeBuff(arg0_45, arg1_45)
	for iter0_45 = #arg0_45.buffs, 1, -1 do
		if arg0_45.buffs[iter0_45] == arg1_45 then
			local var0_45 = table.remove(arg0_45.buffs, iter0_45)

			arg0_45:disposeBuff(var0_45)
		end
	end
end

function var0_0.disposeBuff(arg0_46, arg1_46)
	if #arg1_46.effectTfs > 0 then
		for iter0_46 = 1, #arg1_46.effectTfs do
			Destroy(arg1_46.effectTfs[iter0_46])
		end
	end

	arg1_46.effectTfs = {}

	if #arg1_46.triggerEffectTfs > 0 then
		for iter1_46 = 1, #arg1_46.triggerEffectTfs do
			Destroy(arg1_46.triggerEffectTfs[iter1_46])
		end
	end

	arg1_46.triggerEffectTfs = {}
end

function var0_0.getOrCreateBuff(arg0_47, arg1_47)
	for iter0_47 = 1, #arg0_47.buffs do
		if arg0_47.buffs[iter0_47].config.id == arg1_47 then
			return arg0_47.buffs[iter0_47]
		end
	end

	local var0_47 = {}
	local var1_47 = BeachGuardConst.buff[arg1_47]

	var0_47.effectTfs = {}

	if var1_47.effect and #var1_47.effect > 0 then
		for iter1_47, iter2_47 in ipairs(var1_47.effect) do
			local var2_47 = BeachGuardConst.effect[iter2_47]
			local var3_47 = BeachGuardAsset.getEffect(var2_47.name)

			if var2_47.front then
				setParent(var3_47, arg0_47.effectFrontPos)
			else
				setParent(var3_47, arg0_47.effectBackPos)
			end

			setActive(var3_47, true)

			var3_47.anchoredPosition = Vector2(0, 0)

			table.insert(var0_47.effectTfs, var3_47)
		end
	end

	var0_47.triggerEffectTfs = {}

	if var1_47.trigger_effect and #var1_47.trigger_effect > 0 then
		for iter3_47, iter4_47 in ipairs(var1_47.trigger_effect) do
			local var4_47 = BeachGuardConst.effect[iter4_47]
			local var5_47 = BeachGuardAsset.getEffect(var4_47.name)

			if var4_47.front then
				setParent(var5_47, arg0_47.effectFrontPos)
			else
				setParent(var5_47, arg0_47.effectBackPos)
			end

			setActive(var5_47, true)

			var5_47.anchoredPosition = Vector2(0, 0)

			table.insert(var0_47.triggerEffectTfs, var5_47)
		end
	end

	var0_47.times = 0
	var0_47.time = 0
	var0_47.config = var1_47

	table.insert(arg0_47.buffs, var0_47)

	return var0_47
end

function var0_0.getScore(arg0_48)
	return arg0_48._config.score or 0
end

return var0_0
