local var0 = class("SailBoatEnemy")
local var1

var0.fire_cd = 0.2

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._eventCall = arg2
	arg0._collider = GetComponent(findTF(arg0._tf, "bound"), typeof(BoxCollider2D))
	arg0._animator = GetComponent(findTF(arg0._tf, "img"), typeof(Animator))
	arg0._leftWeapons, arg0._rightWeapons = {}, {}
end

function var0.setData(arg0, arg1)
	arg0._data = arg1
end

function var0.start(arg0)
	arg0._removeFlag = false
	arg0._sceneWidth, arg0._sceneHeight = var1.scene_width, var1.scene_height
	arg0._maxRemoveHeight = -arg0._sceneHeight
	arg0._maxRemoveWidth = arg0._sceneWidth
	arg0._speed = arg0:getConfig("speed")
	arg0._targetX = nil
	arg0._targetY = nil
	arg0._targetIndex = 1
	arg0._hp = arg0:getConfig("hp")

	arg0:updateTarget()

	arg0._destroyFlag = false

	arg0:setInteger("dead_type", arg0:getConfig("dead_type") or 0)
	arg0:setVisible(true)

	arg0._stopFlag = false
	arg0._fireCd = var0.fire_cd
end

function var0.step(arg0, arg1)
	local var0 = arg0._tf.anchoredPosition
	local var1 = var1.GetSceneSpeed()
	local var2
	local var3
	local var4
	local var5

	if arg0._targetIndex > 1 and arg0:getLife() and not arg0._targetX and not arg0._targetY and (arg0._targetListX and arg0._targetIndex <= #arg0._targetListX or arg0._targetListY and arg0._targetIndex <= #arg0._targetListY) then
		arg0:updateTarget()
	end

	local var6 = false

	if arg0._targetX then
		local var7 = var0.x >= arg0._targetX and -1 or 1

		var2 = arg0._targetSpeed[1] * arg1 * var7

		if var7 ~= (var0.x + var2 >= arg0._targetX and -1 or 1) then
			arg0._targetX = nil

			if arg0._targetIndex > #arg0._targetListX then
				arg0:setTrigger("enter_end")
			end
		end
	else
		var2 = arg0._speed.x * arg1 + var1.x
	end

	if arg0._targetY then
		local var8 = var0.y >= arg0._targetY and -1 or 1

		var3 = arg0._targetSpeed[2] * arg1 * var8

		if var8 ~= (var0.y + var3 >= arg0._targetY and -1 or 1) then
			arg0._targetY = nil
		end
	else
		var3 = arg0._speed.y * arg1 + var1.y
	end

	var0.x = var0.x + var2
	var0.y = var0.y + var3
	arg0._tf.anchoredPosition = var0

	if not arg0._removeFlag then
		if var0.y < arg0._maxRemoveHeight then
			arg0._removeFlag = true
		elseif math.abs(var0.x) > arg0._maxRemoveWidth then
			arg0._removeFlag = true
		end
	end

	if arg0._removeTime and arg0._removeTime > 0 then
		arg0._removeTime = arg0._removeTime - arg1

		if arg0._removeTime <= 0 then
			arg0._removeTime = nil
			arg0._removeFlag = true
		end
	end

	for iter0 = 1, #arg0._leftWeapons do
		arg0._leftWeapons[iter0]:step(arg1)
	end

	for iter1 = 1, #arg0._rightWeapons do
		arg0._rightWeapons[iter1]:step(arg1)
	end

	if arg0._fireCd and arg0._fireCd > 0 then
		arg0._fireCd = arg0._fireCd - arg1

		if arg0._fireCd <= 0 then
			arg0._fireCd = 0
		end
	end
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
end

function var0.setTarget(arg0, arg1, arg2, arg3)
	arg0._targetListX = arg1
	arg0._targetListY = arg2
	arg0._targetSpeed = arg3
end

function var0.updateTarget(arg0)
	if arg0._targetX or arg0._targetY then
		return
	end

	if arg0._targetListX and not arg0._targetX and arg0._targetIndex <= #arg0._targetListX then
		local var0 = arg0._targetListX[arg0._targetIndex]

		arg0._targetX = math.random(var0[1], var0[2])

		if arg0:getConfig("tpl") == "Enemys/Enemy_S" or arg0:getConfig("tpl") == "Enemys/Enemy_SS" then
			local var1 = arg0._tf.anchoredPosition.x < arg0._targetX and 1 or -1

			arg0:setInteger("direct_x", var1)
			arg0:setTrigger("enter")
		end
	end

	if arg0._targetListY and not arg0._targetY and arg0._targetIndex <= #arg0._targetListY then
		local var2 = arg0._targetListY[arg0._targetIndex]

		arg0._targetY = math.random(var2[1], var2[2])
	end

	arg0._targetIndex = arg0._targetIndex + 1
end

function var0.setTrigger(arg0, arg1, arg2)
	if arg0:getLife() then
		arg0._animator:SetTrigger(arg1)
	elseif arg2 then
		arg0._animator:ResetTrigger("enter")
		arg0._animator:ResetTrigger("enter_end")
		arg0._animator:ResetTrigger("reset")
		arg0._animator:SetTrigger(arg1)
	end
end

function var0.setInteger(arg0, arg1, arg2)
	arg0._animator:SetInteger(arg1, arg2)
end

function var0.getDestroyData(arg0)
	return {
		score = arg0:getConfig("score"),
		boom = arg0:getConfig("boom"),
		position = arg0._tf.anchoredPosition,
		range = arg0:getConfig("range")
	}
end

function var0.damage(arg0, arg1)
	if arg0._hp == 0 then
		return
	end

	arg0._hp = arg0._hp - arg1.num

	if arg0._hp <= 0 then
		arg0:setTrigger("dead", true)

		arg0._hp = 0
		arg0._targetX = nil
		arg0._targetY = nil

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1.SFX_SOUND_BOOM)

		if arg0:getConfig("remove_time") then
			arg0._removeTime = arg0:getConfig("remove_time")

			return true
		end
	end

	return false
end

function var0.getLife(arg0)
	return arg0._hp > 0
end

function var0.getDestroyFlag(arg0)
	return arg0._destroyFlag
end

function var0.getSpeed(arg0)
	return arg0._speed
end

function var0.setContent(arg0, arg1)
	arg0._content = arg1

	SetParent(arg0._tf, arg1)
end

function var0.getId(arg0)
	return arg0._data.id
end

function var0.setVisible(arg0, arg1)
	setActive(arg0._tf, arg1)
end

function var0.setPosition(arg0, arg1)
	arg0._tf.anchoredPosition = arg1
end

function var0.getPosition(arg0)
	return arg0._tf.anchoredPosition
end

function var0.getWorld(arg0)
	return arg0._tf.position
end

function var0.clear(arg0)
	arg0:setVisible(false)
end

function var0.setRemoveFlag(arg0, arg1)
	arg0._removeFlag = arg1
end

function var0.getGroup(arg0)
	return arg0:getConfig("group")
end

function var0.getHitGroup(arg0)
	return arg0:getConfig("hit_group")
end

function var0.getTargetFlag(arg0)
	return arg0._targetX or arg0._targetY
end

function var0.getTf(arg0)
	return arg0._tf
end

function var0.getRemoveFlag(arg0)
	return arg0._removeFlag
end

function var0.getRuleConfig(arg0, arg1)
	return arg0._rule[arg1]
end

function var0.dispose(arg0)
	var1 = nil
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

function var0.getStop(arg0)
	return arg0._stopFlag
end

function var0.stopTarget(arg0, arg1)
	if arg0._stopFlag then
		return
	end

	if arg0._targetX then
		arg0._targetX = nil
	end

	if arg0._targetY then
		arg0._targetY = nil
	end

	arg0._stopFlag = true

	arg0._animator:ResetTrigger("enter")
	arg0._animator:ResetTrigger("enter_end")
	arg0:setTrigger("reset")

	arg0._speed = arg1
end

function var0.getMinMaxPosition(arg0)
	return arg0._collider.bounds.min, arg0._collider.bounds.max
end

function var0.checkPositionInRange(arg0, arg1)
	local var0 = arg0._tf.anchoredPosition
	local var1 = math.abs(var0.x - arg1.x)
	local var2 = math.abs(var0.y - arg1.y)
	local var3 = arg0:getConfig("range")

	if var1 < var3.x and var2 < var3.y then
		return true
	end

	return false
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

function var0.getWeapons(arg0)
	return arg0._leftWeapons, arg0._rightWeapons
end

function var0.canFire(arg0)
	return #arg0._leftWeapons > 0 or #arg0._rightWeapons > 0
end

function var0.inFireCd(arg0)
	return arg0._fireCd > 0
end

function var0.fire(arg0)
	if arg0._fireCd <= 0 then
		arg0._fireCd = var0.fire_cd

		return true
	end

	return false
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

function var0.getConfig(arg0, arg1)
	return arg0._data[arg1]
end

return var0
