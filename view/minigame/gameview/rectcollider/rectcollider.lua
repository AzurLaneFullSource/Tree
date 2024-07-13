local var0_0 = class("RectCollider")
local var1_0 = 1 / (Application.targetFrameRate or 60)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._animTf = findTF(arg1_1, "anim")
	arg0_1._config = arg2_1
	arg0_1._event = arg3_1
	arg0_1.scriptList = {}
	arg0_1._scripts = {}
	arg0_1._collisionInfo = RectCollisionInfo.New(arg0_1._config, arg0_1._tf)
	arg0_1._collisionInfo.frameRate = var1_0
	arg0_1._keyInfo = RectKeyInfo.New()

	arg0_1._keyInfo:setTriggerCallback(function(arg0_2, arg1_2)
		arg0_1:onKeyTrigger(arg0_2, arg1_2)
	end)

	arg0_1._keyTrigger = RectKeyTriggerController.New(arg0_1._keyInfo)
	arg0_1.initFlag = false
end

function var0_0.onInit(arg0_3)
	arg0_3._translateVelocity = Vector2(0, 0)
	arg0_3._collider2d = GetComponent(findTF(arg0_3._tf, "collider"), typeof(BoxCollider2D))
	arg0_3._origins = RectOriginsCom.New(arg0_3._collider2d)
	arg0_3.colliderController = RectColliderController.New(arg0_3._collisionInfo, arg0_3._origins)
end

function var0_0.clear(arg0_4)
	if arg0_4._collisionInfo.script then
		arg0_4._collisionInfo.script:active(false)
		arg0_4._collisionInfo:removeScript()
	end

	arg0_4._keyTrigger:destroy()
end

function var0_0.addScript(arg0_5, arg1_5)
	arg1_5:setData(arg0_5._collisionInfo, arg0_5._keyInfo, arg0_5._event)

	arg0_5.scriptList[arg1_5.__cname] = arg1_5

	table.insert(arg0_5._scripts, arg1_5)

	if #arg0_5._scripts >= 2 then
		table.sort(arg0_5._scripts, function(arg0_6, arg1_6)
			return arg0_6:getWeight() < arg1_6:getWeight()
		end)
	end
end

function var0_0.addScripts(arg0_7, arg1_7)
	for iter0_7 = 1, #arg1_7 do
		arg0_7:addScript(arg1_7[iter0_7])
	end
end

function var0_0.start(arg0_8)
	arg0_8._collisionInfo:removeScript()

	for iter0_8, iter1_8 in ipairs(arg0_8._scripts) do
		iter1_8:active(false)
	end
end

function var0_0.step(arg0_9)
	if not arg0_9.initFlag then
		arg0_9.initFlag = true

		arg0_9:onInit()
	end

	for iter0_9, iter1_9 in ipairs(arg0_9._scripts) do
		iter1_9:step()
	end

	local var0_9 = arg0_9._collisionInfo:getVelocity()

	arg0_9._translateVelocity.x = var0_9.x * arg0_9._collisionInfo.frameRate
	arg0_9._translateVelocity.y = var0_9.y * arg0_9._collisionInfo.frameRate

	arg0_9.colliderController:move(arg0_9._translateVelocity)
	arg0_9._tf:Translate(arg0_9._translateVelocity)
	arg0_9._collisionInfo:setPos(arg0_9._tf.anchoredPosition)

	if arg0_9._collisionInfo.directionalInput.x ~= 0 and math.sign(arg0_9._tf.localScale.x) ~= arg0_9._collisionInfo.directionalInput.x then
		arg0_9._tf.localScale = Vector3(arg0_9._tf.localScale.x * -1, arg0_9._tf.localScale.y, arg0_9._tf.localScale.z)
	end

	for iter2_9, iter3_9 in ipairs(arg0_9._scripts) do
		iter3_9:lateStep()
	end

	if arg0_9._collisionInfo.script and arg0_9._collisionInfo.scriptTime then
		arg0_9._collisionInfo.scriptTime = arg0_9._collisionInfo.scriptTime - arg0_9._collisionInfo.frameRate

		if arg0_9._collisionInfo.scriptTime <= 0 then
			arg0_9._collisionInfo.script:active(false)
			arg0_9._collisionInfo:removeScript()
		end
	end
end

function var0_0.onKeyTrigger(arg0_10, arg1_10, arg2_10)
	for iter0_10, iter1_10 in pairs(arg0_10.scriptList) do
		iter1_10:keyTrigger(arg1_10, arg2_10)
	end
end

function var0_0.getCollisionInfo(arg0_11)
	return arg0_11._collisionInfo
end

function var0_0.getScript(arg0_12, arg1_12)
	return arg0_12.scriptList[arg1_12.__cname] or nil
end

return var0_0
