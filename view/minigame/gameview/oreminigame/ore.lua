local var0 = class("Ore")

var0.TYPE_SMALL = 1
var0.TYPE_LA = 2
var0.FallTime = 1

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.binder = arg1
	arg0._tf = arg2
	arg0.collisionMgr = arg3
	arg0.id = arg4
	arg0.config = OreGameConfig.ORE_CONFIG[arg0.id]
	arg0.startPoint = arg5

	arg0:Init()
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_UPDATE_ORE_TARGET, function(arg0, arg1)
		if not arg0.isDestroy then
			setActive(findTF(arg0.effectTF, "Frame"), arg0.index == arg1.index)
		end

		arg0.isTarget = arg0.index == arg1.index
	end)
	arg0.binder:bind(OreGameConfig.EVENT_CHECK_CARRY, function(arg0, arg1)
		if not arg0.isDestroy and arg0.isTarget then
			if arg1.weight + arg0.config.weight > OreGameConfig.MAX_WEIGHT then
				setActive(findTF(arg0.effectTF, "Limit"), true)
				setActive(findTF(arg0.effectTF, "Full"), true)
			else
				arg0.binder:emit(OreGameConfig.EVENT_DO_CARRY, {
					weight = arg0.config.weight,
					point = arg0.config.score,
					type = arg0.config.type
				})
				arg0.animator:Play("Vanish")
				arg0.collisionMgr:RemoveOreObject(arg0.index, arg0)
			end
		end
	end)
end

function var0.AddDftAniEvent(arg0)
	findTF(arg0._tf, "main"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:Destroy()
	end)
	findTF(arg0._tf, "main/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:Destroy()
	end)
	findTF(arg0.effectTF, "Limit"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(findTF(arg0.effectTF, "Limit"), false)
	end)
	findTF(arg0.effectTF, "Full"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(findTF(arg0.effectTF, "Full"), false)
	end)
end

function var0.Init(arg0)
	setAnchoredPosition(arg0._tf, arg0.startPoint)

	arg0.effectTF = findTF(arg0._tf, "effect")
	arg0.animator = findTF(arg0._tf, "main/Image"):GetComponent(typeof(Animator))
	arg0.index = arg0._tf.name
	arg0.endPoint = findTF(arg0._tf.parent.parent, "pos/" .. arg0._tf.name).anchoredPosition

	local var0 = math.random() > 0.5 and -10 or 10

	arg0.centerPoint = Vector2(arg0.startPoint.x + var0, arg0.startPoint.y + 80)
	arg0.time = 0
	arg0.isFallEnd = false
	arg0.isTarget = false

	arg0:AddListener()
	arg0:AddDftAniEvent()
	arg0._tf:Find("main"):GetComponent(typeof(Animator)):Play("Initial")
	arg0._tf:Find("main/Image"):GetComponent(typeof(Animator)):Play("Fall")
	eachChild(arg0.effectTF, function(arg0)
		setActive(arg0, false)
	end)
end

function var0.FallEnd(arg0)
	arg0.animator:Play("Spawn")

	arg0.isFallEnd = true

	arg0.collisionMgr:AddOreObject(arg0.index, arg0)
end

function var0.PlayBlink(arg0)
	findTF(arg0._tf, "main"):GetComponent(typeof(Animator)):Play("Blink")
end

function var0.Destroy(arg0)
	if arg0.isDestroy then
		return
	end

	arg0.binder:emit(OreGameConfig.EVENT_ORE_DESTROY, {
		index = arg0.index,
		id = arg0.id
	})
	arg0.collisionMgr:RemoveOreObject(arg0.index, arg0)

	arg0.isDestroy = true
end

function var0.Dispose(arg0)
	arg0.isDestroy = true
end

function var0.OnTimer(arg0, arg1)
	if arg0.time < var0.FallTime then
		arg0.time = arg0.time + arg1

		local var0 = OreGameHelper.GetBeziersPoints(arg0.startPoint, arg0.endPoint, arg0.centerPoint, arg0.time)

		setAnchoredPosition(arg0._tf, var0)
	elseif not arg0.isFallEnd then
		arg0:FallEnd()
	end

	if arg0.isFallEnd then
		arg0.time = arg0.time + arg1

		if arg0.time > var0.FallTime + arg0.config.duration then
			arg0:PlayBlink()
		end
	end
end

function var0.GetAABB(arg0)
	if arg0.config.size == var0.TYPE_SMALL then
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

function var0.GetCollisionInfo(arg0)
	return {
		pos = arg0._tf.anchoredPosition,
		aabb = arg0:GetAABB()
	}
end

return var0
