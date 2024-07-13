local var0_0 = class("SailBoatBullet")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._collider = GetComponent(findTF(arg0_1._tf, "bound"), typeof(BoxCollider2D))
	arg0_1._img = GetComponent(findTF(arg0_1._tf, "img"), typeof(Image))
	arg0_1._weaponData = nil
end

function var0_0.setData(arg0_2, arg1_2)
	arg0_2._data = arg1_2
end

function var0_0.start(arg0_3)
	arg0_3._removeFlag = false

	arg0_3:setSprite(var1_0.GetBulletSprite(arg0_3._data.image))
	arg0_3:setVisible(true)

	arg0_3._moveDistance = 0
	arg0_3._lifeTime = 0

	arg0_3:setPosition(arg0_3._fireData.pos)
	arg0_3:setMove(arg0_3._fireData.move)
	arg0_3:setHitGroup(arg0_3._fireData.hit)

	local var0_3 = arg0_3._fireData.content

	if var0_3 then
		arg0_3:setContent(var0_3)
	end

	if arg0_3:getConfig("fire_effect") then
		local var1_3 = arg0_3:getConfig("fire_effect")
		local var2_3 = arg0_3._fireData.effect_content
		local var3_3 = arg0_3._fireData.effect_pos

		arg0_3._eventCall(SailBoatGameEvent.CREATE_EFFECT, {
			effect = var1_3,
			direct = Vector3(arg0_3._move.x, 1, 1),
			position = var3_3,
			content = var2_3
		})
	end
end

function var0_0.getWorld(arg0_4)
	return arg0_4._tf.position
end

function var0_0.step(arg0_5, arg1_5)
	local var0_5 = arg0_5._tf.anchoredPosition

	var0_5.x = var0_5.x + arg0_5._move.x * arg1_5 * arg0_5._speed
	var0_5.y = var0_5.y + arg0_5._move.y * arg1_5 * arg0_5._speed
	arg0_5._tf.anchoredPosition = var0_5

	if arg0_5._life and arg0_5._life > 0 then
		arg0_5._life = arg0_5._life - arg1_5

		if arg0_5._life <= 0 then
			arg0_5._life = 0

			arg0_5:setRemoveFlag(true)
		end
	end

	if math.abs(var0_5.x) > SailBoatGameVo.scene_width then
		arg0_5._removeFlag = true
	elseif math.abs(var0_5.y) > SailBoatGameVo.scene_height then
		arg0_5._removeFlag = true
	end
end

function var0_0.getDamage(arg0_6)
	return {
		num = arg0_6._weaponData.damage,
		position = arg0_6._tf.position
	}
end

function var0_0.setMove(arg0_7, arg1_7)
	arg0_7._move = arg1_7
end

function var0_0.setPosition(arg0_8, arg1_8)
	arg0_8._tf.anchoredPosition = arg1_8
end

function var0_0.hit(arg0_9)
	if arg0_9:getConfig("hit_effect") then
		local var0_9 = arg0_9:getConfig("hit_effect")

		arg0_9._eventCall(SailBoatGameEvent.CREATE_EFFECT, {
			effect = var0_9,
			direct = Vector3(1, 1, 1),
			position = arg0_9._tf.anchoredPosition
		})
	end

	arg0_9._removeFlag = true
end

function var0_0.setHitGroup(arg0_10, arg1_10)
	arg0_10._hitGroup = arg1_10
end

function var0_0.getHitGroup(arg0_11)
	if not arg0_11._hitGroup then
		arg0_11._hitGroup = {}
	end

	return arg0_11._hitGroup
end

function var0_0.setSprite(arg0_12, arg1_12)
	arg0_12._img.sprite = arg1_12

	arg0_12._img:SetNativeSize()
end

function var0_0.getSpeed(arg0_13)
	return arg0_13._speed
end

function var0_0.setFireData(arg0_14, arg1_14)
	arg0_14._fireData = arg1_14
end

function var0_0.setWeapon(arg0_15, arg1_15)
	arg0_15._weaponData = arg1_15
	arg0_15._speed = arg0_15._weaponData.speed
	arg0_15._damage = arg0_15._weaponData.damage
	arg0_15._life = arg0_15._weaponData.life
end

function var0_0.setContent(arg0_16, arg1_16)
	arg0_16._content = arg1_16

	SetParent(arg0_16._tf, arg1_16)
end

function var0_0.getId(arg0_17)
	return arg0_17._data.id
end

function var0_0.setVisible(arg0_18, arg1_18)
	setActive(arg0_18._tf, arg1_18)
end

function var0_0.setPosition(arg0_19, arg1_19)
	arg0_19._tf.anchoredPosition = arg1_19
end

function var0_0.clear(arg0_20)
	arg0_20:setVisible(false)
end

function var0_0.setRemoveFlag(arg0_21, arg1_21)
	arg0_21._removeFlag = arg1_21
end

function var0_0.getRemoveFlag(arg0_22)
	return arg0_22._removeFlag
end

function var0_0.dispose(arg0_23)
	var1_0 = nil
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

function var0_0.checkPositionInRange(arg0_25, arg1_25)
	local var0_25 = arg0_25._tf.anchoredPosition
	local var1_25 = math.abs(var0_25.x - arg1_25.x)
	local var2_25 = math.abs(var0_25.y - arg1_25.y)
	local var3_25 = arg0_25:getConfig("range")

	if var1_25 < var3_25.x and var2_25 < var3_25.y then
		return true
	end

	return false
end

function var0_0.getPosition(arg0_26)
	return arg0_26._tf.anchoredPosition
end

function var0_0.getConfig(arg0_27, arg1_27)
	return arg0_27._data[arg1_27]
end

function var0_0.getWeaponConfig(arg0_28, arg1_28)
	return arg0_28._weaponData[arg1_28]
end

return var0_0
