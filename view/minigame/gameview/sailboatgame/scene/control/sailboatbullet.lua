local var0 = class("SailBoatBullet")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._eventCall = arg2
	arg0._collider = GetComponent(findTF(arg0._tf, "bound"), typeof(BoxCollider2D))
	arg0._img = GetComponent(findTF(arg0._tf, "img"), typeof(Image))
	arg0._weaponData = nil
end

function var0.setData(arg0, arg1)
	arg0._data = arg1
end

function var0.start(arg0)
	arg0._removeFlag = false

	arg0:setSprite(var1.GetBulletSprite(arg0._data.image))
	arg0:setVisible(true)

	arg0._moveDistance = 0
	arg0._lifeTime = 0

	arg0:setPosition(arg0._fireData.pos)
	arg0:setMove(arg0._fireData.move)
	arg0:setHitGroup(arg0._fireData.hit)

	local var0 = arg0._fireData.content

	if var0 then
		arg0:setContent(var0)
	end

	if arg0:getConfig("fire_effect") then
		local var1 = arg0:getConfig("fire_effect")
		local var2 = arg0._fireData.effect_content
		local var3 = arg0._fireData.effect_pos

		arg0._eventCall(SailBoatGameEvent.CREATE_EFFECT, {
			effect = var1,
			direct = Vector3(arg0._move.x, 1, 1),
			position = var3,
			content = var2
		})
	end
end

function var0.getWorld(arg0)
	return arg0._tf.position
end

function var0.step(arg0, arg1)
	local var0 = arg0._tf.anchoredPosition

	var0.x = var0.x + arg0._move.x * arg1 * arg0._speed
	var0.y = var0.y + arg0._move.y * arg1 * arg0._speed
	arg0._tf.anchoredPosition = var0

	if arg0._life and arg0._life > 0 then
		arg0._life = arg0._life - arg1

		if arg0._life <= 0 then
			arg0._life = 0

			arg0:setRemoveFlag(true)
		end
	end

	if math.abs(var0.x) > SailBoatGameVo.scene_width then
		arg0._removeFlag = true
	elseif math.abs(var0.y) > SailBoatGameVo.scene_height then
		arg0._removeFlag = true
	end
end

function var0.getDamage(arg0)
	return {
		num = arg0._weaponData.damage,
		position = arg0._tf.position
	}
end

function var0.setMove(arg0, arg1)
	arg0._move = arg1
end

function var0.setPosition(arg0, arg1)
	arg0._tf.anchoredPosition = arg1
end

function var0.hit(arg0)
	if arg0:getConfig("hit_effect") then
		local var0 = arg0:getConfig("hit_effect")

		arg0._eventCall(SailBoatGameEvent.CREATE_EFFECT, {
			effect = var0,
			direct = Vector3(1, 1, 1),
			position = arg0._tf.anchoredPosition
		})
	end

	arg0._removeFlag = true
end

function var0.setHitGroup(arg0, arg1)
	arg0._hitGroup = arg1
end

function var0.getHitGroup(arg0)
	if not arg0._hitGroup then
		arg0._hitGroup = {}
	end

	return arg0._hitGroup
end

function var0.setSprite(arg0, arg1)
	arg0._img.sprite = arg1

	arg0._img:SetNativeSize()
end

function var0.getSpeed(arg0)
	return arg0._speed
end

function var0.setFireData(arg0, arg1)
	arg0._fireData = arg1
end

function var0.setWeapon(arg0, arg1)
	arg0._weaponData = arg1
	arg0._speed = arg0._weaponData.speed
	arg0._damage = arg0._weaponData.damage
	arg0._life = arg0._weaponData.life
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

function var0.clear(arg0)
	arg0:setVisible(false)
end

function var0.setRemoveFlag(arg0, arg1)
	arg0._removeFlag = arg1
end

function var0.getRemoveFlag(arg0)
	return arg0._removeFlag
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

function var0.getPosition(arg0)
	return arg0._tf.anchoredPosition
end

function var0.getConfig(arg0, arg1)
	return arg0._data[arg1]
end

function var0.getWeaponConfig(arg0, arg1)
	return arg0._weaponData[arg1]
end

return var0
