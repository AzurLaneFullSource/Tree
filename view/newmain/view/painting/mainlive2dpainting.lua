local var0 = class("MainLive2dPainting", import(".MainBasePainting"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.live2dContainer = arg1:Find("live2d")
	arg0.cg = arg0.live2dContainer:GetComponent(typeof(CanvasGroup))
	arg0.currentWidth = Screen.width
	arg0.currentHeight = Screen.height
	arg0.isModifyOrder = false
	arg0.actionWaiting = false
	arg0.eventTrigger = GetOrAddComponent(arg0.live2dContainer, typeof(EventTriggerListener))

	arg0.eventTrigger:AddPointClickFunc(function()
		arg0:OnClick()
		arg0:TriggerPersonalTask(arg0.ship.groupId)
	end)
end

function var0.GetHalfBodyOffsetY(arg0)
	local var0 = arg0.container.parent
	local var1 = var0.rect.height * -0.5
	local var2 = var0:InverseTransformPoint(arg0.live2dContainer.position)
	local var3 = arg0.live2dContainer.localScale

	return var1 - (arg0.live2dContainer.rect.height * -0.5 * var3.y + var2.y)
end

function var0.OnLoad(arg0, arg1)
	local var0 = Live2D.GenerateData({
		loadPrefs = true,
		ship = arg0.ship,
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, 100),
		parent = arg0.live2dContainer
	})

	arg0:SetContainerVisible(true)

	arg0.cg.blocksRaycasts = true
	arg0.live2dChar = Live2D.New(var0, function(arg0)
		arg0:AdJustOrderInLayer(arg0)
		arg1()
	end)
	arg0.shipGroup = getProxy(CollectionProxy):getShipGroup(arg0.ship.groupId)

	arg0:UpdateContainerPosition()
	arg0:AddScreenChangeTimer()
end

function var0.ResetState(arg0)
	if not arg0.live2dChar then
		return
	end

	arg0.live2dChar:resetL2dData()
end

function var0.AdJustOrderInLayer(arg0, arg1)
	local var0 = arg0.container:GetComponent(typeof(Canvas))

	if var0 and var0.overrideSorting and var0.sortingOrder ~= 0 then
		local var1 = arg1._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
		local var2 = var0.sortingOrder
		local var3 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

		ReflectionHelp.RefSetProperty(var3, "SortingOrder", var1, var2)

		arg0.isModifyOrder = true
	end
end

function var0.ResetOrderInLayer(arg0)
	if not arg0.live2dChar then
		return
	end

	local var0 = arg0.live2dChar._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

	ReflectionHelp.RefSetProperty(var1, "SortingOrder", var0, 0)
end

function var0.AddScreenChangeTimer(arg0)
	arg0:RemoveScreenChangeTimer()

	if not arg0:IslimitYPos() then
		return
	end

	arg0.screenTimer = Timer.New(function()
		if arg0.currentWidth ~= Screen.width or arg0.currentHeight ~= Screen.height then
			arg0.currentWidth = Screen.width
			arg0.currentHeight = Screen.height

			arg0:ResetContainerPosition()
			arg0:UpdateContainerPosition()
		end
	end, 0.5, -1)

	arg0.screenTimer:Start()
end

function var0.RemoveScreenChangeTimer(arg0)
	if arg0.screenTimer then
		arg0.screenTimer:Stop()

		arg0.screenTimer = nil
	end
end

function var0.UpdateContainerPosition(arg0)
	local var0 = arg0:IslimitYPos() and arg0:GetHalfBodyOffsetY() or 0
	local var1 = arg0.live2dContainer.localPosition

	arg0.live2dContainer.localPosition = Vector3(var1.x, var0, var1.z)
end

function var0.ResetContainerPosition(arg0)
	local var0 = arg0.live2dContainer.localPosition

	arg0.live2dContainer.localPosition = Vector3(var0.x, 0, 0)
end

function var0.OnUnload(arg0)
	if arg0.live2dChar then
		arg0:RemoveScreenChangeTimer()
		arg0:ResetContainerPosition()

		if arg0.isModifyOrder then
			arg0.isModifyOrder = false

			arg0:ResetOrderInLayer()
		end

		arg0.cg.blocksRaycasts = false

		arg0.live2dChar:Dispose()

		arg0.live2dChar = nil
	end
end

function var0.OnClick(arg0)
	local var0

	if arg0.live2dChar and arg0.live2dChar.state == Live2D.STATE_INITED and not arg0.live2dChar.ignoreReact then
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

function var0._TriggerEvent(arg0, arg1)
	if not arg1 then
		return
	end

	if arg0.actionWaiting then
		return
	end

	local var0 = arg0:GetEventConfig(arg1)

	local function var1(arg0)
		if arg0 then
			if var0.dialog ~= "" then
				arg0:DisplayWord(var0.dialog)
			else
				arg0:TriggerNextEventAuto()
			end
		end

		arg0.actionWaiting = false
	end

	local var2, var3, var4, var5, var6, var7 = ShipWordHelper.GetCvDataForShip(arg0.ship, var0.dialog)
	local var8 = var0.action
	local var9 = var0.dialog
	local var10 = string.gsub(var9, "main_", "main")

	if arg0.ship.propose and pg.character_voice[var10] and arg0.shipGroup and arg0.shipGroup:VoiceReplayCodition(pg.character_voice[var10]) and arg0.live2dChar:checkActionExist(var8 .. "_ex") then
		var8 = var8 .. "_ex"
	end

	if not var7 then
		arg0.actionWaiting = true

		arg0.live2dChar:TriggerAction(var8)
		var1(true)
	else
		arg0.actionWaiting = true

		if not var4 or var4 == nil or var4 == "" or var4 == "nil" then
			arg0.actionWaiting = false

			var1(true)
		end

		arg0.live2dChar:TriggerAction(var8, nil, nil, var1)
	end
end

function var0.PlayCV(arg0, arg1, arg2, arg3, arg4)
	arg0:RemoveSeTimer()

	if arg1 then
		arg0.seTimer = Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. arg1[1])
		end, arg1[2], 1)

		arg0.seTimer:Start()
	end

	local var0 = ShipWordHelper.RawGetCVKey(arg0.ship.skinId)
	local var1 = pg.CriMgr.GetCVBankName(var0)

	arg0.cvLoader:Load(var1, arg3, arg2, arg4)
end

function var0.RemoveSeTimer(arg0)
	if arg0.seTimer then
		arg0.seTimer:Stop()

		arg0.seTimer = nil
	end
end

function var0.OnDisplayWorld(arg0)
	return
end

function var0.OnPuase(arg0)
	arg0:RemoveScreenChangeTimer()
	arg0:ResetContainerPosition()

	arg0.actionWaiting = false

	arg0.live2dChar:SetVisible(false)
end

function var0.OnUpdateShip(arg0, arg1)
	if arg1 then
		arg0.live2dChar:updateShip(arg1)
	end
end

function var0.SetContainerVisible(arg0, arg1)
	setActive(arg0.live2dContainer, arg1)
end

function var0.OnResume(arg0)
	arg0:SetContainerVisible(true)
	arg0:AddScreenChangeTimer()
	arg0:UpdateContainerPosition()
	arg0.live2dChar:SetVisible(true)
	arg0.live2dChar:UpdateAtomSource()
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:RemoveSeTimer()
	arg0:RemoveScreenChangeTimer()

	if arg0.eventTrigger then
		ClearEventTrigger(arg0.eventTrigger)
	end
end

function var0.GetOffset(arg0)
	return arg0.live2dContainer.localPosition.x
end

function var0.GetCenterPos(arg0)
	return arg0.live2dContainer.position
end

function var0.IslimitYPos(arg0)
	local var0 = arg0.ship:getPainting()

	return var0 == "biaoqiang" or var0 == "z23" or var0 == "lafei" or var0 == "lingbo" or var0 == "mingshi" or var0 == "xuefeng"
end

return var0
