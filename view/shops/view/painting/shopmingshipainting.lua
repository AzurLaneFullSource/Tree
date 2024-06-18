local var0_0 = class("ShopMingShiPainting")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._painting = arg1_1
	arg0_1.live2dContainer = findTF(arg0_1._painting, "live2d")

	setActive(arg0_1.live2dContainer, true)
end

function var0_0.Load(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = Live2D.GenerateData({
		ship = Ship.New({
			configId = 312011
		}),
		scale = Vector3(75, 75, 75),
		position = Vector3(0, 0, 0),
		parent = arg0_2.live2dContainer
	})

	Live2D.New(var0_2, function(arg0_3)
		arg0_2.live2dChar = arg0_3

		if arg0_2.cacheAnimationName then
			arg0_2:Action(arg0_2.cacheAnimationName)

			arg0_2.cacheAnimationName = nil
		end

		arg3_2()
	end)
end

function var0_0.Action(arg0_4, arg1_4)
	if arg0_4.live2dChar then
		arg0_4.live2dChar:TriggerAction(arg1_4, nil, true)
	else
		arg0_4.cacheAnimationName = arg1_4
	end
end

function var0_0.UnLoad(arg0_5)
	setActive(arg0_5.live2dContainer, false)

	if arg0_5.live2dChar then
		arg0_5.live2dChar:Dispose()

		arg0_5.live2dChar = nil
	end
end

return var0_0
