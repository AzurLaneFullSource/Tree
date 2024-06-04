local var0 = class("RectCollider")
local var1 = 1 / (Application.targetFrameRate or 60)

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0._animTf = findTF(arg1, "anim")
	arg0._config = arg2
	arg0._event = arg3
	arg0.scriptList = {}
	arg0._scripts = {}
	arg0._collisionInfo = RectCollisionInfo.New(arg0._config, arg0._tf)
	arg0._collisionInfo.frameRate = var1
	arg0._keyInfo = RectKeyInfo.New()

	arg0._keyInfo:setTriggerCallback(function(arg0, arg1)
		arg0:onKeyTrigger(arg0, arg1)
	end)

	arg0._keyTrigger = RectKeyTriggerController.New(arg0._keyInfo)
	arg0.initFlag = false
end

function var0.onInit(arg0)
	arg0._translateVelocity = Vector2(0, 0)
	arg0._collider2d = GetComponent(findTF(arg0._tf, "collider"), typeof(BoxCollider2D))
	arg0._origins = RectOriginsCom.New(arg0._collider2d)
	arg0.colliderController = RectColliderController.New(arg0._collisionInfo, arg0._origins)
end

function var0.clear(arg0)
	if arg0._collisionInfo.script then
		arg0._collisionInfo.script:active(false)
		arg0._collisionInfo:removeScript()
	end

	arg0._keyTrigger:destroy()
end

function var0.addScript(arg0, arg1)
	arg1:setData(arg0._collisionInfo, arg0._keyInfo, arg0._event)

	arg0.scriptList[arg1.__cname] = arg1

	table.insert(arg0._scripts, arg1)

	if #arg0._scripts >= 2 then
		table.sort(arg0._scripts, function(arg0, arg1)
			return arg0:getWeight() < arg1:getWeight()
		end)
	end
end

function var0.addScripts(arg0, arg1)
	for iter0 = 1, #arg1 do
		arg0:addScript(arg1[iter0])
	end
end

function var0.start(arg0)
	arg0._collisionInfo:removeScript()

	for iter0, iter1 in ipairs(arg0._scripts) do
		iter1:active(false)
	end
end

function var0.step(arg0)
	if not arg0.initFlag then
		arg0.initFlag = true

		arg0:onInit()
	end

	for iter0, iter1 in ipairs(arg0._scripts) do
		iter1:step()
	end

	local var0 = arg0._collisionInfo:getVelocity()

	arg0._translateVelocity.x = var0.x * arg0._collisionInfo.frameRate
	arg0._translateVelocity.y = var0.y * arg0._collisionInfo.frameRate

	arg0.colliderController:move(arg0._translateVelocity)
	arg0._tf:Translate(arg0._translateVelocity)
	arg0._collisionInfo:setPos(arg0._tf.anchoredPosition)

	if arg0._collisionInfo.directionalInput.x ~= 0 and math.sign(arg0._tf.localScale.x) ~= arg0._collisionInfo.directionalInput.x then
		arg0._tf.localScale = Vector3(arg0._tf.localScale.x * -1, arg0._tf.localScale.y, arg0._tf.localScale.z)
	end

	for iter2, iter3 in ipairs(arg0._scripts) do
		iter3:lateStep()
	end

	if arg0._collisionInfo.script and arg0._collisionInfo.scriptTime then
		arg0._collisionInfo.scriptTime = arg0._collisionInfo.scriptTime - arg0._collisionInfo.frameRate

		if arg0._collisionInfo.scriptTime <= 0 then
			arg0._collisionInfo.script:active(false)
			arg0._collisionInfo:removeScript()
		end
	end
end

function var0.onKeyTrigger(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg0.scriptList) do
		iter1:keyTrigger(arg1, arg2)
	end
end

function var0.getCollisionInfo(arg0)
	return arg0._collisionInfo
end

function var0.getScript(arg0, arg1)
	return arg0.scriptList[arg1.__cname] or nil
end

return var0
