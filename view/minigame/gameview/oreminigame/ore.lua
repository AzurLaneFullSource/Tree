local var0_0 = class("Ore")

var0_0.TYPE_SMALL = 1
var0_0.TYPE_LA = 2
var0_0.FallTime = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1.collisionMgr = arg3_1
	arg0_1.id = arg4_1
	arg0_1.config = OreGameConfig.ORE_CONFIG[arg0_1.id]
	arg0_1.startPoint = arg5_1

	arg0_1:Init()
end

function var0_0.AddListener(arg0_2)
	arg0_2.binder:bind(OreGameConfig.EVENT_UPDATE_ORE_TARGET, function(arg0_3, arg1_3)
		if not arg0_2.isDestroy then
			setActive(findTF(arg0_2.effectTF, "Frame"), arg0_2.index == arg1_3.index)
		end

		arg0_2.isTarget = arg0_2.index == arg1_3.index
	end)
	arg0_2.binder:bind(OreGameConfig.EVENT_CHECK_CARRY, function(arg0_4, arg1_4)
		if not arg0_2.isDestroy and arg0_2.isTarget then
			if arg1_4.weight + arg0_2.config.weight > OreGameConfig.MAX_WEIGHT then
				setActive(findTF(arg0_2.effectTF, "Limit"), true)
				setActive(findTF(arg0_2.effectTF, "Full"), true)
			else
				arg0_2.binder:emit(OreGameConfig.EVENT_DO_CARRY, {
					weight = arg0_2.config.weight,
					point = arg0_2.config.score,
					type = arg0_2.config.type
				})
				arg0_2.animator:Play("Vanish")
				arg0_2.collisionMgr:RemoveOreObject(arg0_2.index, arg0_2)
			end
		end
	end)
end

function var0_0.AddDftAniEvent(arg0_5)
	findTF(arg0_5._tf, "main"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_5:Destroy()
	end)
	findTF(arg0_5._tf, "main/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_5:Destroy()
	end)
	findTF(arg0_5.effectTF, "Limit"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(findTF(arg0_5.effectTF, "Limit"), false)
	end)
	findTF(arg0_5.effectTF, "Full"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(findTF(arg0_5.effectTF, "Full"), false)
	end)
end

function var0_0.Init(arg0_10)
	setAnchoredPosition(arg0_10._tf, arg0_10.startPoint)

	arg0_10.effectTF = findTF(arg0_10._tf, "effect")
	arg0_10.animator = findTF(arg0_10._tf, "main/Image"):GetComponent(typeof(Animator))
	arg0_10.index = arg0_10._tf.name
	arg0_10.endPoint = findTF(arg0_10._tf.parent.parent, "pos/" .. arg0_10._tf.name).anchoredPosition

	local var0_10 = math.random() > 0.5 and -10 or 10

	arg0_10.centerPoint = Vector2(arg0_10.startPoint.x + var0_10, arg0_10.startPoint.y + 80)
	arg0_10.time = 0
	arg0_10.isFallEnd = false
	arg0_10.isTarget = false

	arg0_10:AddListener()
	arg0_10:AddDftAniEvent()
	arg0_10._tf:Find("main"):GetComponent(typeof(Animator)):Play("Initial")
	arg0_10._tf:Find("main/Image"):GetComponent(typeof(Animator)):Play("Fall")
	eachChild(arg0_10.effectTF, function(arg0_11)
		setActive(arg0_11, false)
	end)
end

function var0_0.FallEnd(arg0_12)
	arg0_12.animator:Play("Spawn")

	arg0_12.isFallEnd = true

	arg0_12.collisionMgr:AddOreObject(arg0_12.index, arg0_12)
end

function var0_0.PlayBlink(arg0_13)
	findTF(arg0_13._tf, "main"):GetComponent(typeof(Animator)):Play("Blink")
end

function var0_0.Destroy(arg0_14)
	if arg0_14.isDestroy then
		return
	end

	arg0_14.binder:emit(OreGameConfig.EVENT_ORE_DESTROY, {
		index = arg0_14.index,
		id = arg0_14.id
	})
	arg0_14.collisionMgr:RemoveOreObject(arg0_14.index, arg0_14)

	arg0_14.isDestroy = true
end

function var0_0.Dispose(arg0_15)
	arg0_15.isDestroy = true
end

function var0_0.OnTimer(arg0_16, arg1_16)
	if arg0_16.time < var0_0.FallTime then
		arg0_16.time = arg0_16.time + arg1_16

		local var0_16 = OreGameHelper.GetBeziersPoints(arg0_16.startPoint, arg0_16.endPoint, arg0_16.centerPoint, arg0_16.time)

		setAnchoredPosition(arg0_16._tf, var0_16)
	elseif not arg0_16.isFallEnd then
		arg0_16:FallEnd()
	end

	if arg0_16.isFallEnd then
		arg0_16.time = arg0_16.time + arg1_16

		if arg0_16.time > var0_0.FallTime + arg0_16.config.duration then
			arg0_16:PlayBlink()
		end
	end
end

function var0_0.GetAABB(arg0_17)
	if arg0_17.config.size == var0_0.TYPE_SMALL then
		return {
			{
				-7,
				7
			},
			{
				7,
				-7
			}
		}
	else
		return {
			{
				-11,
				11
			},
			{
				13,
				-13
			}
		}
	end
end

function var0_0.GetCollisionInfo(arg0_18)
	return {
		pos = arg0_18._tf.anchoredPosition,
		aabb = arg0_18:GetAABB()
	}
end

return var0_0
