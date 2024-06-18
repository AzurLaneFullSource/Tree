local var0_0 = class("OreEnemy")

var0_0.TYPE_RIGHT_TO_LEFT = 1
var0_0.TYPE_LEFT_TO_RIGHT = 2
var0_0.BORDER_X = 300
var0_0.ROAD_Y = {
	20,
	-28,
	-73
}
var0_0.CLASH_TIME = 0.5
var0_0.OFFSET_Y = {
	[9] = 17,
	[5] = 17
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1.collisionMgr = arg3_1
	arg0_1.id = arg4_1
	arg0_1.config = OreGameConfig.ENEMY_CONFIG[arg0_1.id]
	arg0_1.type = arg6_1
	arg0_1.roadID = arg5_1

	arg0_1:Init()
end

function var0_0.AddListener(arg0_2)
	arg0_2.binder:bind(OreGameConfig.EVENT_AKASHI_COLLISION, function(arg0_3, arg1_3)
		if arg0_2.isDestroy then
			return
		end

		if arg0_2 == arg1_3.b then
			local var0_3 = arg0_2.type == var0_0.TYPE_RIGHT_TO_LEFT and "W" or "E"

			arg0_2.binder:emit(OreGameConfig.EVENT_AKASHI_HIT, {
				dir = var0_3,
				class = arg0_2.config.class,
				y = arg0_2._tf.anchoredPosition.x
			})
		end
	end)
	arg0_2.binder:bind(OreGameConfig.EVENT_ENEMY_COLLISION, function(arg0_4, arg1_4)
		if arg0_2.isDestroy or arg0_2.clashTime then
			return
		end

		arg0_2:OnEnemyCollison(arg1_4.a, arg1_4.b)
	end)
end

function var0_0.AddDftAniEvent(arg0_5)
	eachChild(arg0_5._tf:Find("effect"), function(arg0_6)
		arg0_6:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_6, false)

			if arg0_6.name == "EF_Clash_Heavy" then
				arg0_5:Destroy()
			end
		end)
	end)
	arg0_5._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_5:Destroy()
	end)
end

function var0_0.Init(arg0_9)
	arg0_9:AddListener()
	arg0_9:AddDftAniEvent()

	arg0_9.index = tonumber(arg0_9._tf.name)

	if arg0_9.type == var0_0.TYPE_RIGHT_TO_LEFT then
		arg0_9.deltaX = -OreGameConfig.TIME_INTERVAL

		setLocalPosition(arg0_9._tf, Vector2(var0_0.BORDER_X, var0_0.ROAD_Y[arg0_9.roadID]))
		setLocalEulerAngles(arg0_9._tf, Vector3(0, 0, 0))
	else
		arg0_9.deltaX = OreGameConfig.TIME_INTERVAL

		setLocalPosition(arg0_9._tf, Vector2(-var0_0.BORDER_X, var0_0.ROAD_Y[arg0_9.roadID]))
		setLocalEulerAngles(arg0_9._tf, Vector3(0, 180, 0))
	end

	arg0_9.speed = arg0_9.config.speed

	arg0_9.collisionMgr:AddEnemyObject(arg0_9.roadID, arg0_9.index, arg0_9)

	arg0_9.aabbTF = arg0_9._tf:Find("Image/aabb")

	setActive(arg0_9.aabbTF, OreGameConfig.SHOW_AABB)

	arg0_9.aabb = OreGameHelper.GetAABBWithTF(arg0_9.aabbTF, arg0_9.type == var0_0.TYPE_LEFT_TO_RIGHT)

	setActive(arg0_9._tf:Find("Image"), true)
	arg0_9._tf:GetComponent(typeof(Animator)):Play("Initial")
	arg0_9._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Move")
	eachChild(arg0_9._tf:Find("effect"), function(arg0_10)
		setActive(arg0_10, false)
	end)

	arg0_9.posY = var0_0.ROAD_Y[arg0_9.roadID] + (var0_0.OFFSET_Y[arg0_9.id] or 0)
end

function var0_0.SetSpeed(arg0_11, arg1_11)
	arg0_11.speed = arg1_11
end

function var0_0.OnEnemyCollison(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12.type
	local var1_12
	local var2_12
	local var3_12 = arg1_12._tf.anchoredPosition.x
	local var4_12 = arg2_12._tf.anchoredPosition.x

	if var0_12 == var0_0.TYPE_RIGHT_TO_LEFT then
		var1_12 = var3_12 < var4_12 and arg1_12 or arg2_12
	else
		var1_12 = var4_12 < var3_12 and arg1_12 or arg2_12
	end

	local var5_12 = var1_12 == arg1_12 and arg2_12 or arg1_12
	local var6_12 = var1_12.config.class
	local var7_12 = var5_12.config.class

	if var6_12 < var7_12 then
		if arg0_12 == var1_12 then
			if var6_12 <= 3 and var7_12 <= 3 and math.abs(var6_12 - var7_12) <= 1 then
				arg0_12:PlayClashLightAnim()
			else
				arg0_12:PlayClashHeavyAnim()
			end
		end
	elseif arg0_12 == var5_12 then
		arg0_12:SetSpeed(var1_12.speed)
	end
end

function var0_0.PlayClashLightAnim(arg0_13)
	arg0_13.collisionMgr:RemoveEnemyObject(arg0_13.roadID, arg0_13.index, arg0_13)
	setActive(arg0_13._tf:Find("effect/EF_Clash_Light"), true)
	arg0_13._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Clash_Light")

	arg0_13.clashTime = 0
	arg0_13.startPoint = arg0_13._tf.anchoredPosition

	local var0_13 = arg0_13.type == var0_0.TYPE_RIGHT_TO_LEFT and -150 or 150

	arg0_13.endPoint = Vector2(arg0_13.startPoint.x + var0_13, arg0_13.startPoint.y)
	arg0_13.centerPoint = Vector2((arg0_13.startPoint.x + arg0_13.endPoint.x) / 2, arg0_13.startPoint.y + 50)
end

function var0_0.PlayClashHeavyAnim(arg0_14)
	arg0_14.collisionMgr:RemoveEnemyObject(arg0_14.roadID, arg0_14.index, arg0_14)
	setActive(arg0_14._tf:Find("Image"), false)
	setActive(arg0_14._tf:Find("effect/EF_Clash_Heavy"), true)
end

function var0_0.Destroy(arg0_15)
	if arg0_15.isDestroy then
		return arg0_15.isDestroy
	end

	arg0_15.isDestroy = true

	arg0_15.binder:emit(OreGameConfig.EVENT_ENEMY_DESTROY, {
		roadID = arg0_15.roadID,
		index = arg0_15.index,
		id = arg0_15.id
	})
	arg0_15.collisionMgr:RemoveEnemyObject(arg0_15.roadID, arg0_15.index, arg0_15)
end

function var0_0.Dispose(arg0_16)
	arg0_16.isDestroy = true
end

function var0_0.OnTimer(arg0_17, arg1_17)
	if arg0_17.clashTime then
		if arg0_17.clashTime < var0_0.CLASH_TIME then
			arg0_17.clashTime = arg0_17.clashTime + arg1_17

			local var0_17 = OreGameHelper.GetBeziersPoints(arg0_17.startPoint, arg0_17.endPoint, arg0_17.centerPoint, arg0_17.clashTime)

			setAnchoredPosition(arg0_17._tf, var0_17)
		else
			arg0_17._tf:GetComponent(typeof(Animator)):Play("fade_away")

			arg0_17.clashTime = nil
		end

		return
	end

	setLocalPosition(arg0_17._tf, {
		x = arg0_17._tf.anchoredPosition.x + arg0_17.deltaX * arg0_17.speed,
		y = arg0_17.posY
	})

	if (arg0_17._tf.anchoredPosition.x < -var0_0.BORDER_X - 10 or arg0_17._tf.anchoredPosition.x > var0_0.BORDER_X + 10) and not arg0_17.isDestroy then
		arg0_17:Destroy()
	end
end

function var0_0.GetAABB(arg0_18)
	return arg0_18.aabb
end

function var0_0.GetCarryTriggerOffset(arg0_19)
	return {
		0,
		10
	}
end

function var0_0.GetCollisionInfo(arg0_20)
	local var0_20 = 0

	if arg0_20.type == var0_0.TYPE_RIGHT_TO_LEFT then
		var0_20 = arg0_20._tf.anchoredPosition.x + arg0_20.aabbTF.anchoredPosition.x
	else
		var0_20 = arg0_20._tf.anchoredPosition.x - arg0_20.aabbTF.anchoredPosition.x
	end

	return {
		pos = {
			x = var0_20,
			y = arg0_20._tf.anchoredPosition.y + arg0_20.aabbTF.anchoredPosition.y
		},
		aabb = arg0_20:GetAABB(),
		carryOffset = arg0_20:GetCarryTriggerOffset()
	}
end

return var0_0
