local var0_0 = class("SailBoatChar")
local var1_0

var0_0.fire_cd = 0.1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._eventCallback = arg2_1
	arg0_1._collider = GetComponent(findTF(arg0_1._tf, "bound"), typeof(BoxCollider2D))
	arg0_1.imgTf = findTF(arg0_1._tf, "img")
	arg0_1._animator = GetComponent(arg0_1.imgTf, typeof(Animator))
	arg0_1._leftWeapons, arg0_1._rightWeapons = {}, {}
	arg0_1._hpTf = findTF(arg0_1._tf, "hp")
	arg0_1._hpSlider = GetComponent(findTF(arg0_1._tf, "hp"), typeof(Slider))

	setActive(arg0_1._tf, false)

	arg0_1._playerAnimator = GetComponent(arg0_1._tf, typeof(Animator))
end

function var0_0.setData(arg0_2, arg1_2)
	arg0_2._data = arg1_2
	arg0_2._baseSpeed = arg0_2:getConfig("speed")
	arg0_2._baseHp = arg0_2:getConfig("hp")
end

function var0_0.setWeapon(arg0_3, arg1_3, arg2_3)
	if arg0_3._leftWeapons and #arg0_3._leftWeapons > 0 then
		for iter0_3 = 1, #arg0_3._leftWeapons do
			arg0_3._leftWeapons[iter0_3]:clear()
		end
	end

	if arg0_3._rightWeapons and #arg0_3._rightWeapons > 0 then
		for iter1_3 = 1, #arg0_3._rightWeapons do
			arg0_3._rightWeapons[iter1_3]:clear()
		end
	end

	arg0_3._leftWeapons = arg1_3
	arg0_3._rightWeapons = arg2_3
	arg0_3._weaponMaxDistance = nil
end

function var0_0.setContent(arg0_4, arg1_4, arg2_4)
	arg0_4._content = arg1_4

	SetParent(arg0_4._tf, arg1_4)

	arg0_4._tf.anchoredPosition = arg2_4
end

function var0_0.changeDirect(arg0_5, arg1_5, arg2_5)
	arg0_5._directX = arg1_5
	arg0_5._directY = arg2_5

	if arg0_5._directX < 0 then
		arg0_5.imgTf.localEulerAngles = Vector3(0, 0, 3)
	elseif arg0_5._directX > 0 then
		arg0_5.imgTf.localEulerAngles = Vector3(0, 0, -3)
	else
		arg0_5.imgTf.localEulerAngles = Vector3(0, 0, 0)
	end
end

function var0_0.getWorld(arg0_6)
	return arg0_6._tf.position
end

function var0_0.start(arg0_7)
	arg0_7._directX = 0
	arg0_7._directY = 0

	setActive(arg0_7._tf, true)

	arg0_7._tf.anchoredPosition = Vector2(0, 0)

	for iter0_7 = 1, #arg0_7._leftWeapons do
		arg0_7._leftWeapons[iter0_7]:start()
	end

	for iter1_7 = 1, #arg0_7._rightWeapons do
		arg0_7._rightWeapons[iter1_7]:start()
	end

	arg0_7._speed = Vector2(0, 0)
	arg0_7._speed.x = arg0_7._baseSpeed.x + arg0_7:getEquipAttr("speed")
	arg0_7._speed.y = arg0_7._baseSpeed.y + arg0_7:getEquipAttr("speed")
	arg0_7._hp = arg0_7._baseHp + arg0_7:getEquipAttr("hp")
	arg0_7._hpSlider.minValue = 0
	arg0_7._hpSlider.maxValue = arg0_7._hp
	arg0_7._timeForDead = nil
	arg0_7._fireLeftCd = 0
	arg0_7._fireRightCd = 0
	arg0_7._skillTime = 0
	arg0_7.colliderDamageCd = 0
	arg0_7._hpSlider.value = arg0_7._hp
end

function var0_0.step(arg0_8, arg1_8)
	if arg0_8:getLife() then
		local var0_8 = arg0_8:getNextPosition(arg0_8._directX, arg0_8._directY)

		if math.abs(var0_8.x) > var1_0.scene_width / 2 + 50 or math.abs(var0_8.y) > var1_0.scene_height / 2 + 50 then
			-- block empty
		else
			arg0_8._tf.anchoredPosition = var0_8
		end

		for iter0_8 = #arg0_8._leftWeapons, 1, -1 do
			arg0_8._leftWeapons[iter0_8]:step(arg1_8)

			if arg0_8._skillTime and arg0_8._skillTime > 0 then
				arg0_8._leftWeapons[iter0_8]:skillStep(arg1_8)
			end
		end

		for iter1_8 = #arg0_8._rightWeapons, 1, -1 do
			arg0_8._rightWeapons[iter1_8]:step(arg1_8)

			if arg0_8._skillTime and arg0_8._skillTime > 0 then
				arg0_8._rightWeapons[iter1_8]:skillStep(arg1_8)
			end
		end
	end

	if arg0_8._skillTime and arg0_8._skillTime > 0 then
		arg0_8._skillTime = arg0_8._skillTime - arg1_8
	end

	if arg0_8.colliderDamageCd and arg0_8.colliderDamageCd > 0 then
		arg0_8.colliderDamageCd = arg0_8.colliderDamageCd - arg1_8
	end

	if arg0_8._timeForDead and arg0_8._timeForDead > 0 then
		arg0_8._timeForDead = arg0_8._timeForDead - arg1_8

		if arg0_8._timeForDead <= 0 then
			arg0_8._timeForDead = nil

			arg0_8._eventCallback(SailBoatGameEvent.PLAYER_DEAD)
		end
	end

	if arg0_8._fireLeftCd and arg0_8._fireLeftCd > 0 then
		arg0_8._fireLeftCd = arg0_8._fireLeftCd - arg1_8

		if arg0_8._fireLeftCd <= 0 then
			arg0_8._fireLeftCd = 0
		end
	end

	if arg0_8._fireRightCd and arg0_8._fireRightCd > 0 then
		arg0_8._fireRightCd = arg0_8._fireRightCd - arg1_8

		if arg0_8._fireRightCd <= 0 then
			arg0_8._fireRightCd = 0
		end
	end

	if math.abs(arg0_8._tf.anchoredPosition.x) > var1_0.scene_width / 2 + 50 or math.abs(arg0_8._tf.anchoredPosition.y) > var1_0.scene_height / 2 + 50 then
		arg0_8:damage({
			num = 999,
			position = Vector2(0, 0)
		})
	end
end

function var0_0.getHp(arg0_9)
	return arg0_9._hp
end

function var0_0.getHpPos(arg0_10)
	return arg0_10._hpTf.position
end

function var0_0.useSkill(arg0_11)
	arg0_11._skillTime = SailBoatGameVo.skillTime

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_SKILL)
end

function var0_0.getNextPosition(arg0_12, arg1_12, arg2_12)
	local var0_12 = 0

	if arg1_12 ~= 0 then
		var0_12 = arg0_12._speed.x * arg1_12 * var1_0.deltaTime
	end

	local var1_12 = 0

	if arg2_12 ~= 0 then
		var1_12 = arg0_12._speed.y * arg2_12 * var1_0.deltaTime
	end

	local var2_12 = arg0_12._tf.anchoredPosition

	if var0_12 ~= 0 or var1_12 ~= 0 then
		var2_12.x = var2_12.x + var0_12
		var2_12.y = var2_12.y + var1_12

		return var2_12
	end

	return var2_12
end

function var0_0.getWeapons(arg0_13)
	return arg0_13._leftWeapons, arg0_13._rightWeapons
end

function var0_0.getFirePos(arg0_14)
	if not arg0_14._leftFireTf then
		arg0_14._leftFireTf = findTF(arg0_14._tf, "leftFire")
	end

	if not arg0_14._rightFireTf then
		arg0_14._rightFireTf = findTF(arg0_14._tf, "rightFire")
	end

	return arg0_14._content:InverseTransformPoint(arg0_14._leftFireTf.position), arg0_14._content:InverseTransformPoint(arg0_14._rightFireTf.position)
end

function var0_0.getFireContent(arg0_15)
	return arg0_15._leftFireTf, arg0_15._rightFireTf
end

function var0_0.getWeaponMaxDistance(arg0_16)
	if not arg0_16._weaponMaxDistance then
		arg0_16._weaponMaxDistance = 0

		for iter0_16 = 1, #arg0_16._leftWeapons do
			local var0_16 = arg0_16._leftWeapons[iter0_16]

			if var0_16:getDistance() > arg0_16._weaponMaxDistance then
				arg0_16._weaponMaxDistance = var0_16:getDistance()
			end
		end

		for iter1_16 = 1, #arg0_16._rightWeapons do
			local var1_16 = arg0_16._rightWeapons[iter1_16]

			if var1_16:getDistance() > arg0_16._weaponMaxDistance then
				arg0_16._weaponMaxDistance = var1_16:getDistance()
			end
		end
	end

	return arg0_16._weaponMaxDistance
end

function var0_0.flash(arg0_17)
	arg0_17.colliderDamageCd = var1_0.collider_time

	arg0_17._playerAnimator:SetTrigger("flash")
end

function var0_0.move(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18._tf.anchoredPosition

	var0_18.x = var0_18.x + arg1_18
	var0_18.y = var0_18.y + arg2_18
	arg0_18._tf.anchoredPosition = var0_18
end

function var0_0.getMaxHp(arg0_19)
	return arg0_19._baseHp + arg0_19:getEquipAttr("hp")
end

function var0_0.getTf(arg0_20)
	return arg0_20._tf
end

function var0_0.clearEquipData(arg0_21)
	arg0_21._equipData = {}
end

function var0_0.setEquipData(arg0_22, arg1_22)
	table.insert(arg0_22._equipData, arg1_22)
end

function var0_0.getEquipAttr(arg0_23, arg1_23)
	local var0_23 = 0

	for iter0_23 = 1, #arg0_23._equipData do
		var0_23 = var0_23 + arg0_23._equipData[iter0_23][arg1_23]
	end

	return var0_23
end

function var0_0.getColliderData(arg0_24)
	local var0_24 = arg0_24._content:InverseTransformPoint(arg0_24._collider.bounds.min)

	if not arg0_24._boundData then
		local var1_24 = arg0_24._content:InverseTransformPoint(arg0_24._collider.bounds.max)

		arg0_24._boundData = {
			width = math.floor(var1_24.x - var0_24.x),
			height = math.floor(var1_24.y - var0_24.y)
		}
	end

	return var0_24, arg0_24._boundData
end

function var0_0.getWorldColliderData(arg0_25)
	local var0_25 = arg0_25._collider.bounds.min

	if not arg0_25._worldBoundData then
		local var1_25 = arg0_25._collider.bounds.max

		arg0_25._worldBoundData = {
			width = var1_25.x - var0_25.x,
			height = var1_25.y - var0_25.y
		}
	end

	return var0_25, arg0_25._worldBoundData
end

function var0_0.addHp(arg0_26, arg1_26)
	if arg0_26:getLife() then
		arg0_26._hp = arg0_26._hp + arg1_26

		local var0_26 = arg0_26:getMaxHp()

		if var0_26 < arg0_26._hp then
			arg0_26._hp = var0_26
		end
	end
end

function var0_0.getLife(arg0_27)
	return arg0_27._hp > 0
end

function var0_0.getColliderMinPosition(arg0_28)
	if not arg0_28._minPosition then
		arg0_28._minPosition = arg0_28._tf:InverseTransformPoint(arg0_28._collider.bounds.min)
	end

	return arg0_28._minPosition
end

function var0_0.getBoundData(arg0_29)
	local var0_29 = arg0_29._content:InverseTransformPoint(arg0_29._collider.bounds.min)

	if not arg0_29._boundData then
		local var1_29 = arg0_29._content:InverseTransformPoint(arg0_29._collider.bounds.max)

		arg0_29._boundData = {
			width = math.floor(var1_29.x - var0_29.x),
			height = math.floor(var1_29.y - var0_29.y)
		}
	end

	return arg0_29._boundData
end

function var0_0.getPosition(arg0_30)
	return arg0_30._tf.anchoredPosition
end

function var0_0.getGroup(arg0_31)
	return arg0_31:getConfig("group")
end

function var0_0.getHitGroup(arg0_32)
	return arg0_32:getConfig("hit_group")
end

function var0_0.inFireCd(arg0_33, arg1_33)
	if arg1_33 > 0 then
		return arg0_33._fireRightCd > 0
	else
		return arg0_33._fireLeftCd > 0
	end
end

function var0_0.fire(arg0_34, arg1_34)
	if arg1_34 > 0 then
		if arg0_34._fireRightCd <= 0 then
			arg0_34._fireRightCd = var0_0.fire_cd

			return true
		end

		return false
	else
		if arg0_34._fireLeftCd <= 0 then
			arg0_34._fireLeftCd = var0_0.fire_cd

			return true
		end

		return false
	end
end

function var0_0.clear(arg0_35)
	return
end

function var0_0.stop(arg0_36)
	return
end

function var0_0.checkColliderDamage(arg0_37)
	return arg0_37.colliderDamageCd <= 0
end

function var0_0.damage(arg0_38, arg1_38)
	if not arg0_38:getLife() then
		return
	end

	local var0_38 = arg1_38.position

	if var0_38 then
		if var0_38.x > arg0_38._tf.position.x then
			arg0_38:setInteger("damage_direct", 1)
		else
			arg0_38:setInteger("damage_direct", -1)
		end
	end

	arg0_38._hp = arg0_38._hp - arg1_38.num

	if arg0_38._hp <= 0 then
		arg0_38._hp = 0

		arg0_38:setTrigger("dead", true)

		arg0_38._timeForDead = 1
	elseif var0_38 then
		arg0_38:setTrigger("damage")
	end
end

function var0_0.setTrigger(arg0_39, arg1_39, arg2_39)
	if arg0_39:getLife() then
		arg0_39._animator:SetTrigger(arg1_39)
	elseif arg2_39 then
		arg0_39._animator:SetTrigger(arg1_39)
	end
end

function var0_0.setInteger(arg0_40, arg1_40, arg2_40)
	arg0_40._animator:SetInteger(arg1_40, arg2_40)
end

function var0_0.getMinMaxPosition(arg0_41)
	return arg0_41._collider.bounds.min, arg0_41._collider.bounds.max
end

function var0_0.getConfig(arg0_42, arg1_42)
	return arg0_42._data[arg1_42]
end

function var0_0.checkPositionInRange(arg0_43, arg1_43)
	local var0_43 = arg0_43._tf.anchoredPosition
	local var1_43 = math.abs(var0_43.x - arg1_43.x)
	local var2_43 = math.abs(var0_43.y - arg1_43.y)

	if var1_43 < 250 and var2_43 < 300 then
		return true
	end

	return false
end

function var0_0.dispose(arg0_44)
	return
end

return var0_0
