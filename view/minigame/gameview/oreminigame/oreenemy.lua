local var0 = class("OreEnemy")

var0.TYPE_RIGHT_TO_LEFT = 1
var0.TYPE_LEFT_TO_RIGHT = 2
var0.BORDER_X = 300
var0.ROAD_Y = {
	20,
	-28,
	-73
}
var0.CLASH_TIME = 0.5
var0.OFFSET_Y = {
	[9] = 17,
	[5] = 17
}

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0.binder = arg1
	arg0._tf = arg2
	arg0.collisionMgr = arg3
	arg0.id = arg4
	arg0.config = OreGameConfig.ENEMY_CONFIG[arg0.id]
	arg0.type = arg6
	arg0.roadID = arg5

	arg0:Init()
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_AKASHI_COLLISION, function(arg0, arg1)
		if arg0.isDestroy then
			return
		end

		if arg0 == arg1.b then
			local var0 = arg0.type == var0.TYPE_RIGHT_TO_LEFT and "W" or "E"

			arg0.binder:emit(OreGameConfig.EVENT_AKASHI_HIT, {
				dir = var0,
				class = arg0.config.class,
				y = arg0._tf.anchoredPosition.x
			})
		end
	end)
	arg0.binder:bind(OreGameConfig.EVENT_ENEMY_COLLISION, function(arg0, arg1)
		if arg0.isDestroy or arg0.clashTime then
			return
		end

		arg0:OnEnemyCollison(arg1.a, arg1.b)
	end)
end

function var0.AddDftAniEvent(arg0)
	eachChild(arg0._tf:Find("effect"), function(arg0)
		arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)

			if arg0.name == "EF_Clash_Heavy" then
				arg0:Destroy()
			end
		end)
	end)
	arg0._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:Destroy()
	end)
end

function var0.Init(arg0)
	arg0:AddListener()
	arg0:AddDftAniEvent()

	arg0.index = tonumber(arg0._tf.name)

	if arg0.type == var0.TYPE_RIGHT_TO_LEFT then
		arg0.deltaX = -OreGameConfig.TIME_INTERVAL

		setLocalPosition(arg0._tf, Vector2(var0.BORDER_X, var0.ROAD_Y[arg0.roadID]))
		setLocalEulerAngles(arg0._tf, Vector3(0, 0, 0))
	else
		arg0.deltaX = OreGameConfig.TIME_INTERVAL

		setLocalPosition(arg0._tf, Vector2(-var0.BORDER_X, var0.ROAD_Y[arg0.roadID]))
		setLocalEulerAngles(arg0._tf, Vector3(0, 180, 0))
	end

	arg0.speed = arg0.config.speed

	arg0.collisionMgr:AddEnemyObject(arg0.roadID, arg0.index, arg0)

	arg0.aabbTF = arg0._tf:Find("Image/aabb")

	setActive(arg0.aabbTF, OreGameConfig.SHOW_AABB)

	arg0.aabb = OreGameHelper.GetAABBWithTF(arg0.aabbTF, arg0.type == var0.TYPE_LEFT_TO_RIGHT)

	setActive(arg0._tf:Find("Image"), true)
	arg0._tf:GetComponent(typeof(Animator)):Play("Initial")
	arg0._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Move")
	eachChild(arg0._tf:Find("effect"), function(arg0)
		setActive(arg0, false)
	end)

	arg0.posY = var0.ROAD_Y[arg0.roadID] + (var0.OFFSET_Y[arg0.id] or 0)
end

function var0.SetSpeed(arg0, arg1)
	arg0.speed = arg1
end

function var0.OnEnemyCollison(arg0, arg1, arg2)
	local var0 = arg1.type
	local var1
	local var2
	local var3 = arg1._tf.anchoredPosition.x
	local var4 = arg2._tf.anchoredPosition.x

	if var0 == var0.TYPE_RIGHT_TO_LEFT then
		var1 = var3 < var4 and arg1 or arg2
	else
		var1 = var4 < var3 and arg1 or arg2
	end

	local var5 = var1 == arg1 and arg2 or arg1
	local var6 = var1.config.class
	local var7 = var5.config.class

	if var6 < var7 then
		if arg0 == var1 then
			if var6 <= 3 and var7 <= 3 and math.abs(var6 - var7) <= 1 then
				arg0:PlayClashLightAnim()
			else
				arg0:PlayClashHeavyAnim()
			end
		end
	elseif arg0 == var5 then
		arg0:SetSpeed(var1.speed)
	end
end

function var0.PlayClashLightAnim(arg0)
	arg0.collisionMgr:RemoveEnemyObject(arg0.roadID, arg0.index, arg0)
	setActive(arg0._tf:Find("effect/EF_Clash_Light"), true)
	arg0._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Clash_Light")

	arg0.clashTime = 0
	arg0.startPoint = arg0._tf.anchoredPosition

	local var0 = arg0.type == var0.TYPE_RIGHT_TO_LEFT and -150 or 150

	arg0.endPoint = Vector2(arg0.startPoint.x + var0, arg0.startPoint.y)
	arg0.centerPoint = Vector2((arg0.startPoint.x + arg0.endPoint.x) / 2, arg0.startPoint.y + 50)
end

function var0.PlayClashHeavyAnim(arg0)
	arg0.collisionMgr:RemoveEnemyObject(arg0.roadID, arg0.index, arg0)
	setActive(arg0._tf:Find("Image"), false)
	setActive(arg0._tf:Find("effect/EF_Clash_Heavy"), true)
end

function var0.Destroy(arg0)
	if arg0.isDestroy then
		return arg0.isDestroy
	end

	arg0.isDestroy = true

	arg0.binder:emit(OreGameConfig.EVENT_ENEMY_DESTROY, {
		roadID = arg0.roadID,
		index = arg0.index,
		id = arg0.id
	})
	arg0.collisionMgr:RemoveEnemyObject(arg0.roadID, arg0.index, arg0)
end

function var0.Dispose(arg0)
	arg0.isDestroy = true
end

function var0.OnTimer(arg0, arg1)
	if arg0.clashTime then
		if arg0.clashTime < var0.CLASH_TIME then
			arg0.clashTime = arg0.clashTime + arg1

			local var0 = OreGameHelper.GetBeziersPoints(arg0.startPoint, arg0.endPoint, arg0.centerPoint, arg0.clashTime)

			setAnchoredPosition(arg0._tf, var0)
		else
			arg0._tf:GetComponent(typeof(Animator)):Play("fade_away")

			arg0.clashTime = nil
		end

		return
	end

	setLocalPosition(arg0._tf, {
		x = arg0._tf.anchoredPosition.x + arg0.deltaX * arg0.speed,
		y = arg0.posY
	})

	if (arg0._tf.anchoredPosition.x < -var0.BORDER_X - 10 or arg0._tf.anchoredPosition.x > var0.BORDER_X + 10) and not arg0.isDestroy then
		arg0:Destroy()
	end
end

function var0.GetAABB(arg0)
	return arg0.aabb
end

function var0.GetCarryTriggerOffset(arg0)
	return {
		0,
		10
	}
end

function var0.GetCollisionInfo(arg0)
	local var0 = 0

	if arg0.type == var0.TYPE_RIGHT_TO_LEFT then
		var0 = arg0._tf.anchoredPosition.x + arg0.aabbTF.anchoredPosition.x
	else
		var0 = arg0._tf.anchoredPosition.x - arg0.aabbTF.anchoredPosition.x
	end

	return {
		pos = {
			x = var0,
			y = arg0._tf.anchoredPosition.y + arg0.aabbTF.anchoredPosition.y
		},
		aabb = arg0:GetAABB(),
		carryOffset = arg0:GetCarryTriggerOffset()
	}
end

return var0
