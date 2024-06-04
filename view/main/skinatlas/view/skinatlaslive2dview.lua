local var0 = class("SkinAtlasLive2dView")
local var1

function var0.Ctor(arg0, arg1, arg2, arg3)
	pg.DelegateInfo.New(arg0)

	arg0.ship = arg1
	arg0.paintingTr = arg2.parent
	arg0.live2dContainer = arg2
	arg0.canClick = false
	arg0.inited = false
	var1 = pg.AssistantInfo

	arg0:Init(arg3)
end

function var0.Init(arg0, arg1)
	local var0 = arg0.ship

	setActive(arg0.live2dContainer, true)

	local var1 = Live2D.GenerateData({
		ship = var0,
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -100),
		parent = arg0.live2dContainer
	})

	arg0.live2dChar = Live2D.New(var1, function(arg0)
		arg0.inited = true

		if arg1 then
			arg1()
		end
	end)
end

function var0.OpenClick(arg0)
	onButton(arg0, arg0.paintingTr, function()
		if not arg0.inited then
			return
		end

		arg0:OnClick()
	end)
end

function var0.CloseClick(arg0)
	removeOnButton(arg0.paintingTr)
end

function var0.OnClick(arg0)
	local var0

	if arg0.live2dChar and arg0.live2dChar.state == Live2D.STATE_INITED then
		if not Input.mousePosition then
			return
		end

		local var1 = arg0.live2dChar:GetTouchPart()

		if var1 > 0 then
			local var2 = arg0:GetTouchEvent(var1)

			var0 = var2[math.ceil(math.random(#var2))]
		else
			local var3 = arg0:GetIdleEvents()

			var0 = var3[math.floor(math.Random(0, #var3)) + 1]
		end
	end

	if var0 then
		arg0:TriggerEvent(var0)
	end
end

function var0.GetTouchEvent(arg0, arg1)
	return (var1.filterAssistantEvents(var1.getAssistantTouchEvents(arg1), arg0.ship.skinId, 0))
end

function var0.GetIdleEvents(arg0)
	return (var1.filterAssistantEvents(var1.IdleEvents, arg0.ship.skinId, 0))
end

function var0.GetEventConfig(arg0, arg1)
	return var1.assistantEvents[arg1]
end

function var0.TriggerEvent(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = arg0:GetEventConfig(arg1)

	local function var1()
		return
	end

	local var2, var3, var4, var5, var6, var7 = ShipWordHelper.GetCvDataForShip(arg0.ship, var0.dialog)

	if not var7 then
		arg0.live2dChar:TriggerAction(var0.action)
		var1()
	else
		arg0.live2dChar:TriggerAction(var0.action, nil, nil, var1)
	end
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0.live2dChar:Dispose()

	arg0.live2dChar = nil

	setActive(arg0.live2dContainer, false)
end

return var0
