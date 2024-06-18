local var0_0 = class("SailBoatEnemy")
local var1_0

var0_0.fire_cd = 0.2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._collider = GetComponent(findTF(arg0_1._tf, "bound"), typeof(BoxCollider2D))
	arg0_1._animator = GetComponent(findTF(arg0_1._tf, "img"), typeof(Animator))
	arg0_1._leftWeapons, arg0_1._rightWeapons = {}, {}
end

function var0_0.setData(arg0_2, arg1_2)
	arg0_2._data = arg1_2
end

function var0_0.start(arg0_3)
	arg0_3._removeFlag = false
	arg0_3._sceneWidth, arg0_3._sceneHeight = var1_0.scene_width, var1_0.scene_height
	arg0_3._maxRemoveHeight = -arg0_3._sceneHeight
	arg0_3._maxRemoveWidth = arg0_3._sceneWidth
	arg0_3._speed = arg0_3:getConfig("speed")
	arg0_3._targetX = nil
	arg0_3._targetY = nil
	arg0_3._targetIndex = 1
	arg0_3._hp = arg0_3:getConfig("hp")

	arg0_3:updateTarget()

	arg0_3._destroyFlag = false

	arg0_3:setInteger("dead_type", arg0_3:getConfig("dead_type") or 0)
	arg0_3:setVisible(true)

	arg0_3._stopFlag = false
	arg0_3._fireCd = var0_0.fire_cd
end

function var0_0.step(arg0_4, arg1_4)
	local var0_4 = arg0_4._tf.anchoredPosition
	local var1_4 = var1_0.GetSceneSpeed()
	local var2_4
	local var3_4
	local var4_4
	local var5_4

	if arg0_4._targetIndex > 1 and arg0_4:getLife() and not arg0_4._targetX and not arg0_4._targetY and (arg0_4._targetListX and arg0_4._targetIndex <= #arg0_4._targetListX or arg0_4._targetListY and arg0_4._targetIndex <= #arg0_4._targetListY) then
		arg0_4:updateTarget()
	end

	local var6_4 = false

	if arg0_4._targetX then
		local var7_4 = var0_4.x >= arg0_4._targetX and -1 or 1

		var2_4 = arg0_4._targetSpeed[1] * arg1_4 * var7_4

		if var7_4 ~= (var0_4.x + var2_4 >= arg0_4._targetX and -1 or 1) then
			arg0_4._targetX = nil

			if arg0_4._targetIndex > #arg0_4._targetListX then
				arg0_4:setTrigger("enter_end")
			end
		end
	else
		var2_4 = arg0_4._speed.x * arg1_4 + var1_4.x
	end

	if arg0_4._targetY then
		local var8_4 = var0_4.y >= arg0_4._targetY and -1 or 1

		var3_4 = arg0_4._targetSpeed[2] * arg1_4 * var8_4

		if var8_4 ~= (var0_4.y + var3_4 >= arg0_4._targetY and -1 or 1) then
			arg0_4._targetY = nil
		end
	else
		var3_4 = arg0_4._speed.y * arg1_4 + var1_4.y
	end

	var0_4.x = var0_4.x + var2_4
	var0_4.y = var0_4.y + var3_4
	arg0_4._tf.anchoredPosition = var0_4

	if not arg0_4._removeFlag then
		if var0_4.y < arg0_4._maxRemoveHeight then
			arg0_4._removeFlag = true
		elseif math.abs(var0_4.x) > arg0_4._maxRemoveWidth then
			arg0_4._removeFlag = true
		end
	end

	if arg0_4._removeTime and arg0_4._removeTime > 0 then
		arg0_4._removeTime = arg0_4._removeTime - arg1_4

		if arg0_4._removeTime <= 0 then
			arg0_4._removeTime = nil
			arg0_4._removeFlag = true
		end
	end

	for iter0_4 = 1, #arg0_4._leftWeapons do
		arg0_4._leftWeapons[iter0_4]:step(arg1_4)
	end

	for iter1_4 = 1, #arg0_4._rightWeapons do
		arg0_4._rightWeapons[iter1_4]:step(arg1_4)
	end

	if arg0_4._fireCd and arg0_4._fireCd > 0 then
		arg0_4._fireCd = arg0_4._fireCd - arg1_4

		if arg0_4._fireCd <= 0 then
			arg0_4._fireCd = 0
		end
	end
end

function var0_0.setWeapon(arg0_5, arg1_5, arg2_5)
	if arg0_5._leftWeapons and #arg0_5._leftWeapons > 0 then
		for iter0_5 = 1, #arg0_5._leftWeapons do
			arg0_5._leftWeapons[iter0_5]:clear()
		end
	end

	if arg0_5._rightWeapons and #arg0_5._rightWeapons > 0 then
		for iter1_5 = 1, #arg0_5._rightWeapons do
			arg0_5._rightWeapons[iter1_5]:clear()
		end
	end

	arg0_5._leftWeapons = arg1_5
	arg0_5._rightWeapons = arg2_5
end

function var0_0.setTarget(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6._targetListX = arg1_6
	arg0_6._targetListY = arg2_6
	arg0_6._targetSpeed = arg3_6
end

function var0_0.updateTarget(arg0_7)
	if arg0_7._targetX or arg0_7._targetY then
		return
	end

	if arg0_7._targetListX and not arg0_7._targetX and arg0_7._targetIndex <= #arg0_7._targetListX then
		local var0_7 = arg0_7._targetListX[arg0_7._targetIndex]

		arg0_7._targetX = math.random(var0_7[1], var0_7[2])

		if arg0_7:getConfig("tpl") == "Enemys/Enemy_S" or arg0_7:getConfig("tpl") == "Enemys/Enemy_SS" then
			local var1_7 = arg0_7._tf.anchoredPosition.x < arg0_7._targetX and 1 or -1

			arg0_7:setInteger("direct_x", var1_7)
			arg0_7:setTrigger("enter")
		end
	end

	if arg0_7._targetListY and not arg0_7._targetY and arg0_7._targetIndex <= #arg0_7._targetListY then
		local var2_7 = arg0_7._targetListY[arg0_7._targetIndex]

		arg0_7._targetY = math.random(var2_7[1], var2_7[2])
	end

	arg0_7._targetIndex = arg0_7._targetIndex + 1
end

function var0_0.setTrigger(arg0_8, arg1_8, arg2_8)
	if arg0_8:getLife() then
		arg0_8._animator:SetTrigger(arg1_8)
	elseif arg2_8 then
		arg0_8._animator:ResetTrigger("enter")
		arg0_8._animator:ResetTrigger("enter_end")
		arg0_8._animator:ResetTrigger("reset")
		arg0_8._animator:SetTrigger(arg1_8)
	end
end

function var0_0.setInteger(arg0_9, arg1_9, arg2_9)
	arg0_9._animator:SetInteger(arg1_9, arg2_9)
end

function var0_0.getDestroyData(arg0_10)
	return {
		score = arg0_10:getConfig("score"),
		boom = arg0_10:getConfig("boom"),
		position = arg0_10._tf.anchoredPosition,
		range = arg0_10:getConfig("range")
	}
end

function var0_0.damage(arg0_11, arg1_11)
	if arg0_11._hp == 0 then
		return
	end

	arg0_11._hp = arg0_11._hp - arg1_11.num

	if arg0_11._hp <= 0 then
		arg0_11:setTrigger("dead", true)

		arg0_11._hp = 0
		arg0_11._targetX = nil
		arg0_11._targetY = nil

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_BOOM)

		if arg0_11:getConfig("remove_time") then
			arg0_11._removeTime = arg0_11:getConfig("remove_time")

			return true
		end
	end

	return false
end

function var0_0.getLife(arg0_12)
	return arg0_12._hp > 0
end

function var0_0.getDestroyFlag(arg0_13)
	return arg0_13._destroyFlag
end

function var0_0.getSpeed(arg0_14)
	return arg0_14._speed
end

function var0_0.setContent(arg0_15, arg1_15)
	arg0_15._content = arg1_15

	SetParent(arg0_15._tf, arg1_15)
end

function var0_0.getId(arg0_16)
	return arg0_16._data.id
end

function var0_0.setVisible(arg0_17, arg1_17)
	setActive(arg0_17._tf, arg1_17)
end

function var0_0.setPosition(arg0_18, arg1_18)
	arg0_18._tf.anchoredPosition = arg1_18
end

function var0_0.getPosition(arg0_19)
	return arg0_19._tf.anchoredPosition
end

function var0_0.getWorld(arg0_20)
	return arg0_20._tf.position
end

function var0_0.clear(arg0_21)
	arg0_21:setVisible(false)
end

function var0_0.setRemoveFlag(arg0_22, arg1_22)
	arg0_22._removeFlag = arg1_22
end

function var0_0.getGroup(arg0_23)
	return arg0_23:getConfig("group")
end

function var0_0.getHitGroup(arg0_24)
	return arg0_24:getConfig("hit_group")
end

function var0_0.getTargetFlag(arg0_25)
	return arg0_25._targetX or arg0_25._targetY
end

function var0_0.getTf(arg0_26)
	return arg0_26._tf
end

function var0_0.getRemoveFlag(arg0_27)
	return arg0_27._removeFlag
end

function var0_0.getRuleConfig(arg0_28, arg1_28)
	return arg0_28._rule[arg1_28]
end

function var0_0.dispose(arg0_29)
	var1_0 = nil
end

function var0_0.getColliderData(arg0_30)
	local var0_30 = arg0_30._content:InverseTransformPoint(arg0_30._collider.bounds.min)

	if not arg0_30._boundData then
		local var1_30 = arg0_30._content:InverseTransformPoint(arg0_30._collider.bounds.max)

		arg0_30._boundData = {
			width = math.floor(var1_30.x - var0_30.x),
			height = math.floor(var1_30.y - var0_30.y)
		}
	end

	return var0_30, arg0_30._boundData
end

function var0_0.getWorldColliderData(arg0_31)
	local var0_31 = arg0_31._collider.bounds.min

	if not arg0_31._worldBoundData then
		local var1_31 = arg0_31._collider.bounds.max

		arg0_31._worldBoundData = {
			width = var1_31.x - var0_31.x,
			height = var1_31.y - var0_31.y
		}
	end

	return var0_31, arg0_31._worldBoundData
end

function var0_0.getStop(arg0_32)
	return arg0_32._stopFlag
end

function var0_0.stopTarget(arg0_33, arg1_33)
	if arg0_33._stopFlag then
		return
	end

	if arg0_33._targetX then
		arg0_33._targetX = nil
	end

	if arg0_33._targetY then
		arg0_33._targetY = nil
	end

	arg0_33._stopFlag = true

	arg0_33._animator:ResetTrigger("enter")
	arg0_33._animator:ResetTrigger("enter_end")
	arg0_33:setTrigger("reset")

	arg0_33._speed = arg1_33
end

function var0_0.getMinMaxPosition(arg0_34)
	return arg0_34._collider.bounds.min, arg0_34._collider.bounds.max
end

function var0_0.checkPositionInRange(arg0_35, arg1_35)
	local var0_35 = arg0_35._tf.anchoredPosition
	local var1_35 = math.abs(var0_35.x - arg1_35.x)
	local var2_35 = math.abs(var0_35.y - arg1_35.y)
	local var3_35 = arg0_35:getConfig("range")

	if var1_35 < var3_35.x and var2_35 < var3_35.y then
		return true
	end

	return false
end

function var0_0.getWeaponMaxDistance(arg0_36)
	if not arg0_36._weaponMaxDistance then
		arg0_36._weaponMaxDistance = 0

		for iter0_36 = 1, #arg0_36._leftWeapons do
			local var0_36 = arg0_36._leftWeapons[iter0_36]

			if var0_36:getDistance() > arg0_36._weaponMaxDistance then
				arg0_36._weaponMaxDistance = var0_36:getDistance()
			end
		end

		for iter1_36 = 1, #arg0_36._rightWeapons do
			local var1_36 = arg0_36._rightWeapons[iter1_36]

			if var1_36:getDistance() > arg0_36._weaponMaxDistance then
				arg0_36._weaponMaxDistance = var1_36:getDistance()
			end
		end
	end

	return arg0_36._weaponMaxDistance
end

function var0_0.getWeapons(arg0_37)
	return arg0_37._leftWeapons, arg0_37._rightWeapons
end

function var0_0.canFire(arg0_38)
	return #arg0_38._leftWeapons > 0 or #arg0_38._rightWeapons > 0
end

function var0_0.inFireCd(arg0_39)
	return arg0_39._fireCd > 0
end

function var0_0.fire(arg0_40)
	if arg0_40._fireCd <= 0 then
		arg0_40._fireCd = var0_0.fire_cd

		return true
	end

	return false
end

function var0_0.getFirePos(arg0_41)
	if not arg0_41._leftFireTf then
		arg0_41._leftFireTf = findTF(arg0_41._tf, "leftFire")
	end

	if not arg0_41._rightFireTf then
		arg0_41._rightFireTf = findTF(arg0_41._tf, "rightFire")
	end

	return arg0_41._content:InverseTransformPoint(arg0_41._leftFireTf.position), arg0_41._content:InverseTransformPoint(arg0_41._rightFireTf.position)
end

function var0_0.getFireContent(arg0_42)
	return arg0_42._leftFireTf, arg0_42._rightFireTf
end

function var0_0.getConfig(arg0_43, arg1_43)
	return arg0_43._data[arg1_43]
end

return var0_0
