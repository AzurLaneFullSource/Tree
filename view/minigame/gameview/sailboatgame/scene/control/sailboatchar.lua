local var0 = class("SailBoatChar")
local var1

var0.fire_cd = 0.1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._eventCallback = arg2
	arg0._collider = GetComponent(findTF(arg0._tf, "bound"), typeof(BoxCollider2D))
	arg0.imgTf = findTF(arg0._tf, "img")
	arg0._animator = GetComponent(arg0.imgTf, typeof(Animator))
	arg0._leftWeapons, arg0._rightWeapons = {}, {}
	arg0._hpTf = findTF(arg0._tf, "hp")
	arg0._hpSlider = GetComponent(findTF(arg0._tf, "hp"), typeof(Slider))

	setActive(arg0._tf, false)

	arg0._playerAnimator = GetComponent(arg0._tf, typeof(Animator))
end

function var0.setData(arg0, arg1)
	arg0._data = arg1
	arg0._baseSpeed = arg0:getConfig("speed")
	arg0._baseHp = arg0:getConfig("hp")
end

function var0.setWeapon(arg0, arg1, arg2)
	if arg0._leftWeapons and #arg0._leftWeapons > 0 then
		for iter0 = 1, #arg0._leftWeapons do
			arg0._leftWeapons[iter0]:clear()
		end
	end

	if arg0._rightWeapons and #arg0._rightWeapons > 0 then
		for iter1 = 1, #arg0._rightWeapons do
			arg0._rightWeapons[iter1]:clear()
		end
	end

	arg0._leftWeapons = arg1
	arg0._rightWeapons = arg2
	arg0._weaponMaxDistance = nil
end

function var0.setContent(arg0, arg1, arg2)
	arg0._content = arg1

	SetParent(arg0._tf, arg1)

	arg0._tf.anchoredPosition = arg2
end

function var0.changeDirect(arg0, arg1, arg2)
	arg0._directX = arg1
	arg0._directY = arg2

	if arg0._directX < 0 then
		arg0.imgTf.localEulerAngles = Vector3(0, 0, 3)
	elseif arg0._directX > 0 then
		arg0.imgTf.localEulerAngles = Vector3(0, 0, -3)
	else
		arg0.imgTf.localEulerAngles = Vector3(0, 0, 0)
	end
end

function var0.getWorld(arg0)
	return arg0._tf.position
end

function var0.start(arg0)
	arg0._directX = 0
	arg0._directY = 0

	setActive(arg0._tf, true)

	arg0._tf.anchoredPosition = Vector2(0, 0)

	for iter0 = 1, #arg0._leftWeapons do
		arg0._leftWeapons[iter0]:start()
	end

	for iter1 = 1, #arg0._rightWeapons do
		arg0._rightWeapons[iter1]:start()
	end

	arg0._speed = Vector2(0, 0)
	arg0._speed.x = arg0._baseSpeed.x + arg0:getEquipAttr("speed")
	arg0._speed.y = arg0._baseSpeed.y + arg0:getEquipAttr("speed")
	arg0._hp = arg0._baseHp + arg0:getEquipAttr("hp")
	arg0._hpSlider.minValue = 0
	arg0._hpSlider.maxValue = arg0._hp
	arg0._timeForDead = nil
	arg0._fireLeftCd = 0
	arg0._fireRightCd = 0
	arg0._skillTime = 0
	arg0.colliderDamageCd = 0
	arg0._hpSlider.value = arg0._hp
end

function var0.step(arg0, arg1)
	if arg0:getLife() then
		local var0 = arg0:getNextPosition(arg0._directX, arg0._directY)

		if math.abs(var0.x) > var1.scene_width / 2 + 50 or math.abs(var0.y) > var1.scene_height / 2 + 50 then
			-- block empty
		else
			arg0._tf.anchoredPosition = var0
		end

		for iter0 = #arg0._leftWeapons, 1, -1 do
			arg0._leftWeapons[iter0]:step(arg1)

			if arg0._skillTime and arg0._skillTime > 0 then
				arg0._leftWeapons[iter0]:skillStep(arg1)
			end
		end

		for iter1 = #arg0._rightWeapons, 1, -1 do
			arg0._rightWeapons[iter1]:step(arg1)

			if arg0._skillTime and arg0._skillTime > 0 then
				arg0._rightWeapons[iter1]:skillStep(arg1)
			end
		end
	end

	if arg0._skillTime and arg0._skillTime > 0 then
		arg0._skillTime = arg0._skillTime - arg1
	end

	if arg0.colliderDamageCd and arg0.colliderDamageCd > 0 then
		arg0.colliderDamageCd = arg0.colliderDamageCd - arg1
	end

	if arg0._timeForDead and arg0._timeForDead > 0 then
		arg0._timeForDead = arg0._timeForDead - arg1

		if arg0._timeForDead <= 0 then
			arg0._timeForDead = nil

			arg0._eventCallback(SailBoatGameEvent.PLAYER_DEAD)
		end
	end

	if arg0._fireLeftCd and arg0._fireLeftCd > 0 then
		arg0._fireLeftCd = arg0._fireLeftCd - arg1

		if arg0._fireLeftCd <= 0 then
			arg0._fireLeftCd = 0
		end
	end

	if arg0._fireRightCd and arg0._fireRightCd > 0 then
		arg0._fireRightCd = arg0._fireRightCd - arg1

		if arg0._fireRightCd <= 0 then
			arg0._fireRightCd = 0
		end
	end

	if math.abs(arg0._tf.anchoredPosition.x) > var1.scene_width / 2 + 50 or math.abs(arg0._tf.anchoredPosition.y) > var1.scene_height / 2 + 50 then
		arg0:damage({
			num = 999,
			position = Vector2(0, 0)
		})
	end
end

function var0.getHp(arg0)
	return arg0._hp
end

function var0.getHpPos(arg0)
	return arg0._hpTf.position
end

function var0.useSkill(arg0)
	arg0._skillTime = SailBoatGameVo.skillTime

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1.SFX_SOUND_SKILL)
end

function var0.getNextPosition(arg0, arg1, arg2)
	local var0 = 0

	if arg1 ~= 0 then
		var0 = arg0._speed.x * arg1 * var1.deltaTime
	end

	local var1 = 0

	if arg2 ~= 0 then
		var1 = arg0._speed.y * arg2 * var1.deltaTime
	end

	local var2 = arg0._tf.anchoredPosition

	if var0 ~= 0 or var1 ~= 0 then
		var2.x = var2.x + var0
		var2.y = var2.y + var1

		return var2
	end

	return var2
end

function var0.getWeapons(arg0)
	return arg0._leftWeapons, arg0._rightWeapons
end

function var0.getFirePos(arg0)
	if not arg0._leftFireTf then
		arg0._leftFireTf = findTF(arg0._tf, "leftFire")
	end

	if not arg0._rightFireTf then
		arg0._rightFireTf = findTF(arg0._tf, "rightFire")
	end

	return arg0._content:InverseTransformPoint(arg0._leftFireTf.position), arg0._content:InverseTransformPoint(arg0._rightFireTf.position)
end

function var0.getFireContent(arg0)
	return arg0._leftFireTf, arg0._rightFireTf
end

function var0.getWeaponMaxDistance(arg0)
	if not arg0._weaponMaxDistance then
		arg0._weaponMaxDistance = 0

		for iter0 = 1, #arg0._leftWeapons do
			local var0 = arg0._leftWeapons[iter0]

			if var0:getDistance() > arg0._weaponMaxDistance then
				arg0._weaponMaxDistance = var0:getDistance()
			end
		end

		for iter1 = 1, #arg0._rightWeapons do
			local var1 = arg0._rightWeapons[iter1]

			if var1:getDistance() > arg0._weaponMaxDistance then
				arg0._weaponMaxDistance = var1:getDistance()
			end
		end
	end

	return arg0._weaponMaxDistance
end

function var0.flash(arg0)
	arg0.colliderDamageCd = var1.collider_time

	arg0._playerAnimator:SetTrigger("flash")
end

function var0.move(arg0, arg1, arg2)
	local var0 = arg0._tf.anchoredPosition

	var0.x = var0.x + arg1
	var0.y = var0.y + arg2
	arg0._tf.anchoredPosition = var0
end

function var0.getMaxHp(arg0)
	return arg0._baseHp + arg0:getEquipAttr("hp")
end

function var0.getTf(arg0)
	return arg0._tf
end

function var0.clearEquipData(arg0)
	arg0._equipData = {}
end

function var0.setEquipData(arg0, arg1)
	table.insert(arg0._equipData, arg1)
end

function var0.getEquipAttr(arg0, arg1)
	local var0 = 0

	for iter0 = 1, #arg0._equipData do
		var0 = var0 + arg0._equipData[iter0][arg1]
	end

	return var0
end

function var0.getColliderData(arg0)
	local var0 = arg0._content:InverseTransformPoint(arg0._collider.bounds.min)

	if not arg0._boundData then
		local var1 = arg0._content:InverseTransformPoint(arg0._collider.bounds.max)

		arg0._boundData = {
			width = math.floor(var1.x - var0.x),
			height = math.floor(var1.y - var0.y)
		}
	end

	return var0, arg0._boundData
end

function var0.getWorldColliderData(arg0)
	local var0 = arg0._collider.bounds.min

	if not arg0._worldBoundData then
		local var1 = arg0._collider.bounds.max

		arg0._worldBoundData = {
			width = var1.x - var0.x,
			height = var1.y - var0.y
		}
	end

	return var0, arg0._worldBoundData
end

function var0.addHp(arg0, arg1)
	if arg0:getLife() then
		arg0._hp = arg0._hp + arg1

		local var0 = arg0:getMaxHp()

		if var0 < arg0._hp then
			arg0._hp = var0
		end
	end
end

function var0.getLife(arg0)
	return arg0._hp > 0
end

function var0.getColliderMinPosition(arg0)
	if not arg0._minPosition then
		arg0._minPosition = arg0._tf:InverseTransformPoint(arg0._collider.bounds.min)
	end

	return arg0._minPosition
end

function var0.getBoundData(arg0)
	local var0 = arg0._content:InverseTransformPoint(arg0._collider.bounds.min)

	if not arg0._boundData then
		local var1 = arg0._content:InverseTransformPoint(arg0._collider.bounds.max)

		arg0._boundData = {
			width = math.floor(var1.x - var0.x),
			height = math.floor(var1.y - var0.y)
		}
	end

	return arg0._boundData
end

function var0.getPosition(arg0)
	return arg0._tf.anchoredPosition
end

function var0.getGroup(arg0)
	return arg0:getConfig("group")
end

function var0.getHitGroup(arg0)
	return arg0:getConfig("hit_group")
end

function var0.inFireCd(arg0, arg1)
	if arg1 > 0 then
		return arg0._fireRightCd > 0
	else
		return arg0._fireLeftCd > 0
	end
end

function var0.fire(arg0, arg1)
	if arg1 > 0 then
		if arg0._fireRightCd <= 0 then
			arg0._fireRightCd = var0.fire_cd

			return true
		end

		return false
	else
		if arg0._fireLeftCd <= 0 then
			arg0._fireLeftCd = var0.fire_cd

			return true
		end

		return false
	end
end

function var0.clear(arg0)
	return
end

function var0.stop(arg0)
	return
end

function var0.checkColliderDamage(arg0)
	return arg0.colliderDamageCd <= 0
end

function var0.damage(arg0, arg1)
	if not arg0:getLife() then
		return
	end

	local var0 = arg1.position

	if var0 then
		if var0.x > arg0._tf.position.x then
			arg0:setInteger("damage_direct", 1)
		else
			arg0:setInteger("damage_direct", -1)
		end
	end

	arg0._hp = arg0._hp - arg1.num

	if arg0._hp <= 0 then
		arg0._hp = 0

		arg0:setTrigger("dead", true)

		arg0._timeForDead = 1
	elseif var0 then
		arg0:setTrigger("damage")
	end
end

function var0.setTrigger(arg0, arg1, arg2)
	if arg0:getLife() then
		arg0._animator:SetTrigger(arg1)
	elseif arg2 then
		arg0._animator:SetTrigger(arg1)
	end
end

function var0.setInteger(arg0, arg1, arg2)
	arg0._animator:SetInteger(arg1, arg2)
end

function var0.getMinMaxPosition(arg0)
	return arg0._collider.bounds.min, arg0._collider.bounds.max
end

function var0.getConfig(arg0, arg1)
	return arg0._data[arg1]
end

function var0.checkPositionInRange(arg0, arg1)
	local var0 = arg0._tf.anchoredPosition
	local var1 = math.abs(var0.x - arg1.x)
	local var2 = math.abs(var0.y - arg1.y)

	if var1 < 250 and var2 < 300 then
		return true
	end

	return false
end

function var0.dispose(arg0)
	return
end

return var0
