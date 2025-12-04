local var0_0 = class("MainLive2dPainting", import(".MainBasePainting"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.live2dContainer = arg1_1:Find("live2d")
	arg0_1.cg = arg0_1.live2dContainer:GetComponent(typeof(CanvasGroup))
	arg0_1.currentWidth = Screen.width
	arg0_1.currentHeight = Screen.height
	arg0_1.isModifyOrder = false
	arg0_1.actionWaiting = false
	arg0_1.eventTrigger = GetOrAddComponent(arg0_1.live2dContainer, typeof(EventTriggerListener))

	arg0_1.eventTrigger:AddPointClickFunc(function()
		arg0_1:OnClick()
		arg0_1:TriggerPersonalTask(arg0_1.ship.groupId)
	end)
end

function var0_0.GetHalfBodyOffsetY(arg0_3)
	if not arg0_3:IslimitYPos() then
		return 0
	end

	return MainPaintingShift.GetHalfBodyOffsetY(arg0_3.container.parent, arg0_3.live2dContainer)
end

function var0_0.OnLoad(arg0_4, arg1_4)
	if arg0_4.live2dChar then
		arg0_4.live2dChar:Dispose()

		arg0_4.live2dChar = nil
	end

	local var0_4 = Live2D.GenerateData({
		loadPrefs = true,
		ship = arg0_4.ship,
		position = Vector3(0, 0, 100),
		parent = arg0_4.live2dContainer
	})

	arg0_4.actionWaiting = false

	arg0_4:SetContainerVisible(true)

	arg0_4.cg.blocksRaycasts = true
	arg0_4.live2dChar = Live2D.New(var0_4, function(arg0_5)
		arg0_4:AdJustOrderInLayer(arg0_5)

		if arg0_4._initTriggerAction then
			for iter0_5, iter1_5 in ipairs(arg0_4._initTriggerAction) do
				local var0_5 = pg.AssistantInfo.assistantEvents[iter1_5].action

				if arg0_4.live2dChar:checkActionExist(var0_5) then
					arg0_4.live2dChar:TriggerAction(var0_5)

					arg0_4._initTriggerAction = nil

					break
				end
			end

			arg0_4._initTriggerAction = nil
		end

		arg1_4()
	end)
	arg0_4.shipGroup = getProxy(CollectionProxy):getShipGroup(arg0_4.ship.groupId)

	arg0_4:UpdateContainerPosition()
	arg0_4:AddScreenChangeTimer()

	arg0_4.cvLoaded = false

	arg0_4:preloadCv(function()
		arg0_4.cvLoaded = true

		if arg0_4.pretriggerEvent then
			arg0_4:_TriggerEvent(arg0_4.pretriggerEvent)

			arg0_4.pretriggerEvent = nil
		end
	end)
end

function var0_0.ResetState(arg0_7)
	if not arg0_7.live2dChar then
		return
	end

	arg0_7.live2dChar:resetL2dData()
end

function var0_0.AdJustOrderInLayer(arg0_8, arg1_8)
	arg1_8:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
end

function var0_0.ResetOrderInLayer(arg0_9)
	if not arg0_9.live2dChar then
		return
	end

	local var0_9 = arg0_9.live2dChar._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_9 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

	ReflectionHelp.RefSetProperty(var1_9, "SortingOrder", var0_9, 0)
end

function var0_0.AddScreenChangeTimer(arg0_10)
	arg0_10:RemoveScreenChangeTimer()

	if not arg0_10:IslimitYPos() then
		return
	end

	arg0_10.screenTimer = Timer.New(function()
		if arg0_10.currentWidth ~= Screen.width or arg0_10.currentHeight ~= Screen.height then
			arg0_10.currentWidth = Screen.width
			arg0_10.currentHeight = Screen.height

			arg0_10:ResetContainerPosition()
			arg0_10:UpdateContainerPosition()
		end
	end, 0.5, -1)

	arg0_10.screenTimer:Start()
end

function var0_0.RemoveScreenChangeTimer(arg0_12)
	if arg0_12.screenTimer then
		arg0_12.screenTimer:Stop()

		arg0_12.screenTimer = nil
	end
end

function var0_0.UpdateContainerPosition(arg0_13)
	local var0_13

	if arg0_13._shift then
		var0_13 = arg0_13._shift:GetL2dShift()
	else
		var0_13 = arg0_13.live2dContainer.localPosition
	end

	if arg0_13:IslimitYPos() then
		var0_13.y = arg0_13:GetHalfBodyOffsetY()
	end

	arg0_13.live2dContainer.localPosition = var0_13
end

function var0_0.ResetContainerPosition(arg0_14)
	local var0_14

	if arg0_14._shift then
		var0_14 = arg0_14._shift:GetL2dShift()
	else
		var0_14 = arg0_14.live2dContainer.localPosition
		var0_14.z = 0
	end

	if arg0_14:IslimitYPos() then
		var0_14.y = arg0_14:GetHalfBodyOffsetY()
	end

	arg0_14.live2dContainer.localPosition = var0_14
end

function var0_0.OnUnload(arg0_15)
	if arg0_15.live2dChar then
		arg0_15:RemoveScreenChangeTimer()
		arg0_15:ResetContainerPosition()

		if arg0_15.isModifyOrder then
			arg0_15.isModifyOrder = false

			arg0_15:ResetOrderInLayer()
		end

		arg0_15.cg.blocksRaycasts = false

		arg0_15.live2dChar:saveLive2dData()
		arg0_15.live2dChar:Dispose()

		arg0_15.live2dChar = nil
	end
end

function var0_0.OnClick(arg0_16)
	local var0_16

	if arg0_16.live2dChar and arg0_16.live2dChar.state == Live2D.STATE_INITED and not arg0_16.live2dChar.ignoreReact then
		if not Input.mousePosition then
			return
		end

		local var1_16 = arg0_16.live2dChar:GetTouchPart()

		if var1_16 > 0 then
			local var2_16 = arg0_16:GetTouchEvent(var1_16)

			var0_16 = var2_16[math.ceil(math.random(#var2_16))]
		else
			local var3_16 = arg0_16:GetIdleEvents()

			var0_16 = var3_16[math.floor(math.Random(0, #var3_16)) + 1]
		end
	end

	if var0_16 then
		arg0_16:TriggerEvent(var0_16)
	end
end

function var0_0._TriggerEvent(arg0_17, arg1_17)
	if not arg0_17.cvLoaded then
		arg0_17.pretriggerEvent = arg1_17

		return
	end

	if not arg1_17 then
		return
	end

	if arg0_17.actionWaiting then
		return
	end

	local var0_17 = arg0_17:GetEventConfig(arg1_17)

	local function var1_17(arg0_18)
		if arg0_18 then
			if var0_17.dialog ~= "" then
				arg0_17:DisplayWord(var0_17.dialog)
			else
				arg0_17:TriggerNextEventAuto()
			end
		end

		arg0_17.actionWaiting = false
	end

	local var2_17, var3_17, var4_17, var5_17, var6_17, var7_17 = ShipWordHelper.GetCvDataForShip(arg0_17.ship, var0_17.dialog)
	local var8_17 = var0_17.action
	local var9_17 = var0_17.dialog
	local var10_17 = string.gsub(var9_17, "main_", "main")

	if arg0_17.ship.propose and pg.character_voice[var10_17] and arg0_17.shipGroup and arg0_17.shipGroup:VoiceReplayCodition(pg.character_voice[var10_17]) and arg0_17.live2dChar:checkActionExist(var8_17 .. "_ex") then
		var8_17 = var8_17 .. "_ex"
	end

	if not var7_17 then
		arg0_17.actionWaiting = true

		local var11_17 = arg0_17.live2dChar:TriggerAction(var8_17)

		var1_17(var11_17)
	else
		arg0_17.actionWaiting = true

		if not var4_17 or var4_17 == nil or var4_17 == "" or var4_17 == "nil" then
			arg0_17.actionWaiting = false

			var1_17(true)
		end

		if not arg0_17.live2dChar:TriggerAction(var8_17, nil, nil, var1_17) then
			arg0_17.actionWaiting = false
		end
	end
end

function var0_0.PlayCV(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg0_19:RemoveSeTimer()

	if arg1_19 then
		arg0_19.seTimer = Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. arg1_19[1])
		end, arg1_19[2], 1)

		arg0_19.seTimer:Start()
	end

	local var0_19 = ShipWordHelper.RawGetCVKey(arg0_19.ship:getSkinId())
	local var1_19 = pg.CriMgr.GetCVBankName(var0_19)

	arg0_19.cvLoader:Load(var1_19, arg3_19, arg2_19, arg4_19)
end

function var0_0.RemoveSeTimer(arg0_21)
	if arg0_21.seTimer then
		arg0_21.seTimer:Stop()

		arg0_21.seTimer = nil
	end
end

function var0_0.PlayChangeSkinActionIn(arg0_22, arg1_22)
	if arg0_22.live2dChar:IsLoaded() then
		if arg0_22.live2dChar:checkActionExist("change_in") then
			arg0_22:TriggerEvent("event_change_in")
		else
			arg0_22:TriggerEvent("event_login")
		end
	else
		arg0_22._initTriggerAction = {
			"event_change_in",
			"event_login"
		}
	end

	if arg1_22 and arg1_22.callback then
		arg1_22.callback({
			flag = true
		})
	end
end

function var0_0.PlayChangeSkinActionOut(arg0_23, arg1_23)
	if arg0_23.live2dChar:IsLoaded() and arg0_23.live2dChar:checkActionExist("change_out") then
		arg0_23:playSkinOut(arg1_23)
	elseif arg1_23 and arg1_23.callback then
		arg1_23.callback({
			flag = true
		})
	end
end

function var0_0.playSkinOut(arg0_24, arg1_24)
	local function var0_24()
		if arg1_24 and arg1_24.callback then
			arg1_24.callback({
				flag = true
			})
		end
	end

	if not arg0_24.live2dChar:TriggerAction("change_out", function()
		return
	end, false, function()
		if var0_24 then
			var0_24()

			var0_24 = nil
		end
	end) and var0_24 then
		var0_24()

		var0_24 = nil
	end
end

function var0_0.OnDisplayWorld(arg0_28)
	return
end

function var0_0.OnPause(arg0_29)
	print("pause")
	arg0_29:RemoveScreenChangeTimer()
	arg0_29:ResetContainerPosition()

	arg0_29.actionWaiting = false

	arg0_29:OnUnload()
end

function var0_0.OnUpdateShip(arg0_30, arg1_30)
	if arg1_30 then
		arg0_30.live2dChar:updateShip(arg1_30)
	end
end

function var0_0.SetContainerVisible(arg0_31, arg1_31)
	return
end

function var0_0.IsLoaded(arg0_32)
	if not arg0_32.live2dChar then
		return false
	end

	return var0_0.super.IsLoaded(arg0_32)
end

function var0_0.OnResume(arg0_33)
	arg0_33:SetContainerVisible(true)
	arg0_33:AddScreenChangeTimer()
	arg0_33:UpdateContainerPosition()
	onNextTick(function()
		if arg0_33.ship then
			arg0_33:Load(arg0_33.ship)
		end
	end)
end

function var0_0.Dispose(arg0_35)
	var0_0.super.Dispose(arg0_35)
	arg0_35:RemoveSeTimer()
	arg0_35:RemoveScreenChangeTimer()

	if arg0_35.eventTrigger then
		ClearEventTrigger(arg0_35.eventTrigger)
	end
end

function var0_0.GetOffset(arg0_36)
	return arg0_36.live2dContainer.localPosition.x
end

function var0_0.GetCenterPos(arg0_37)
	return arg0_37.live2dContainer.position
end

function var0_0.IslimitYPos(arg0_38)
	return MainPaintingShift.IsLimitYPos(arg0_38.ship:getPainting())
end

return var0_0
