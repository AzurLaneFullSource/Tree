local var0_0 = class("SkinAtlasLive2dView")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.ship = arg1_1
	arg0_1.paintingTr = arg2_1.parent
	arg0_1.live2dContainer = arg2_1
	arg0_1.canClick = false
	arg0_1.inited = false
	var1_0 = pg.AssistantInfo

	arg0_1:Init(arg3_1)
end

function var0_0.Init(arg0_2, arg1_2)
	local var0_2 = arg0_2.ship

	setActive(arg0_2.live2dContainer, true)

	local var1_2 = Live2D.GenerateData({
		ship = var0_2,
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -100),
		parent = arg0_2.live2dContainer
	})

	arg0_2.live2dChar = Live2D.New(var1_2, function(arg0_3)
		arg0_2.inited = true

		if arg1_2 then
			arg1_2()
		end
	end)
end

function var0_0.OpenClick(arg0_4)
	onButton(arg0_4, arg0_4.paintingTr, function()
		if not arg0_4.inited then
			return
		end

		arg0_4:OnClick()
	end)
end

function var0_0.CloseClick(arg0_6)
	removeOnButton(arg0_6.paintingTr)
end

function var0_0.OnClick(arg0_7)
	local var0_7

	if arg0_7.live2dChar and arg0_7.live2dChar.state == Live2D.STATE_INITED then
		if not Input.mousePosition then
			return
		end

		local var1_7 = arg0_7.live2dChar:GetTouchPart()

		if var1_7 > 0 then
			local var2_7 = arg0_7:GetTouchEvent(var1_7)

			var0_7 = var2_7[math.ceil(math.random(#var2_7))]
		else
			local var3_7 = arg0_7:GetIdleEvents()

			var0_7 = var3_7[math.floor(math.Random(0, #var3_7)) + 1]
		end
	end

	if var0_7 then
		arg0_7:TriggerEvent(var0_7)
	end
end

function var0_0.GetTouchEvent(arg0_8, arg1_8)
	return (var1_0.filterAssistantEvents(var1_0.getAssistantTouchEvents(arg1_8), arg0_8.ship.skinId, 0))
end

function var0_0.GetIdleEvents(arg0_9)
	return (var1_0.filterAssistantEvents(var1_0.IdleEvents, arg0_9.ship.skinId, 0))
end

function var0_0.GetEventConfig(arg0_10, arg1_10)
	return var1_0.assistantEvents[arg1_10]
end

function var0_0.TriggerEvent(arg0_11, arg1_11)
	if not arg1_11 then
		return
	end

	local var0_11 = arg0_11:GetEventConfig(arg1_11)

	local function var1_11()
		return
	end

	local var2_11, var3_11, var4_11, var5_11, var6_11, var7_11 = ShipWordHelper.GetCvDataForShip(arg0_11.ship, var0_11.dialog)

	if not var7_11 then
		arg0_11.live2dChar:TriggerAction(var0_11.action)
		var1_11()
	else
		arg0_11.live2dChar:TriggerAction(var0_11.action, nil, nil, var1_11)
	end
end

function var0_0.Dispose(arg0_13)
	pg.DelegateInfo.Dispose(arg0_13)
	arg0_13.live2dChar:Dispose()

	arg0_13.live2dChar = nil

	setActive(arg0_13.live2dContainer, false)
end

return var0_0
