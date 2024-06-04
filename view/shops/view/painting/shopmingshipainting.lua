local var0 = class("ShopMingShiPainting")

function var0.Ctor(arg0, arg1)
	arg0._painting = arg1
	arg0.live2dContainer = findTF(arg0._painting, "live2d")

	setActive(arg0.live2dContainer, true)
end

function var0.Load(arg0, arg1, arg2, arg3)
	local var0 = Live2D.GenerateData({
		ship = Ship.New({
			configId = 312011
		}),
		scale = Vector3(75, 75, 75),
		position = Vector3(0, 0, 0),
		parent = arg0.live2dContainer
	})

	Live2D.New(var0, function(arg0)
		arg0.live2dChar = arg0

		if arg0.cacheAnimationName then
			arg0:Action(arg0.cacheAnimationName)

			arg0.cacheAnimationName = nil
		end

		arg3()
	end)
end

function var0.Action(arg0, arg1)
	if arg0.live2dChar then
		arg0.live2dChar:TriggerAction(arg1, nil, true)
	else
		arg0.cacheAnimationName = arg1
	end
end

function var0.UnLoad(arg0)
	setActive(arg0.live2dContainer, false)

	if arg0.live2dChar then
		arg0.live2dChar:Dispose()

		arg0.live2dChar = nil
	end
end

return var0
