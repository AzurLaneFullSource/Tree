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

		if Live2dConst.l2d_bound_open then
			arg0_4:CreateL2dDragBound(arg0_5)
		end

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

function var0_0.CreateL2dDragBound(arg0_10, arg1_10)
	if not arg1_10 then
		return
	end

	if not arg0_10._dragBoundsUI then
		arg0_10._dragBoundsUI = L2dBoundsUI.New()
	end

	arg1_10:SetLive2dPlayingCallback(function()
		if arg1_10 then
			arg0_10._dragBoundsUI:ActionChange(arg1_10)
		end
	end)
	arg0_10._dragBoundsUI:InitUI(nil, function()
		if arg0_10._dragBoundsUI and arg1_10 then
			local var0_12 = arg1_10:GetDragBounds()

			arg0_10._dragBoundsUI:SetData(var0_12, arg0_10.ship:getSkinId())
			arg0_10._dragBoundsUI:SetParent(arg0_10.container)
			arg0_10._dragBoundsUI:ActionChange(arg1_10:GetLive2DStateData())
		end
	end)
end

function var0_0.AddScreenChangeTimer(arg0_13)
	arg0_13:RemoveScreenChangeTimer()

	if not arg0_13:IslimitYPos() then
		return
	end

	arg0_13.screenTimer = Timer.New(function()
		if arg0_13.currentWidth ~= Screen.width or arg0_13.currentHeight ~= Screen.height then
			arg0_13.currentWidth = Screen.width
			arg0_13.currentHeight = Screen.height

			arg0_13:ResetContainerPosition()
			arg0_13:UpdateContainerPosition()
		end
	end, 0.5, -1)

	arg0_13.screenTimer:Start()
end

function var0_0.RemoveScreenChangeTimer(arg0_15)
	if arg0_15.screenTimer then
		arg0_15.screenTimer:Stop()

		arg0_15.screenTimer = nil
	end
end

function var0_0.UpdateContainerPosition(arg0_16)
	local var0_16

	if arg0_16._shift then
		var0_16 = arg0_16._shift:GetL2dShift()
	else
		var0_16 = arg0_16.live2dContainer.localPosition
	end

	if arg0_16:IslimitYPos() then
		var0_16.y = arg0_16:GetHalfBodyOffsetY()
	end

	arg0_16.live2dContainer.localPosition = var0_16
end

function var0_0.ResetContainerPosition(arg0_17)
	local var0_17

	if arg0_17._shift then
		var0_17 = arg0_17._shift:GetL2dShift()
	else
		var0_17 = arg0_17.live2dContainer.localPosition
		var0_17.z = 0
	end

	if arg0_17:IslimitYPos() then
		var0_17.y = arg0_17:GetHalfBodyOffsetY()
	end

	arg0_17.live2dContainer.localPosition = var0_17
end

function var0_0.OnUnload(arg0_18)
	if arg0_18.live2dChar then
		arg0_18:RemoveScreenChangeTimer()
		arg0_18:ResetContainerPosition()

		if arg0_18.isModifyOrder then
			arg0_18.isModifyOrder = false

			arg0_18:ResetOrderInLayer()
		end

		arg0_18.cg.blocksRaycasts = false

		arg0_18.live2dChar:saveLive2dData()
		arg0_18.live2dChar:Dispose()

		arg0_18.live2dChar = nil
	end

	if arg0_18._dragBoundsUI then
		arg0_18._dragBoundsUI:Dispose()

		arg0_18._dragBoundsUI = nil
	end
end

function var0_0.OnClick(arg0_19)
	local var0_19

	if arg0_19.live2dChar and arg0_19.live2dChar.state == Live2D.STATE_INITED and not arg0_19.live2dChar.ignoreReact then
		if not Input.mousePosition then
			return
		end

		local var1_19 = arg0_19.live2dChar:GetTouchPart()

		if var1_19 > 0 then
			local var2_19 = arg0_19:GetTouchEvent(var1_19)

			var0_19 = var2_19[math.ceil(math.random(#var2_19))]
		else
			local var3_19 = arg0_19:GetIdleEvents()

			var0_19 = var3_19[math.floor(math.Random(0, #var3_19)) + 1]
		end
	end

	if var0_19 then
		arg0_19:TriggerEvent(var0_19)
	end
end

function var0_0._TriggerEvent(arg0_20, arg1_20)
	if not arg0_20.cvLoaded then
		arg0_20.pretriggerEvent = arg1_20

		return
	end

	if not arg1_20 then
		return
	end

	if arg0_20.actionWaiting then
		return
	end

	local var0_20 = arg0_20:GetEventConfig(arg1_20)

	local function var1_20(arg0_21)
		if arg0_21 then
			if var0_20.dialog ~= "" then
				arg0_20:DisplayWord(var0_20.dialog)
			else
				arg0_20:TriggerNextEventAuto()
			end
		end

		arg0_20.actionWaiting = false
	end

	local var2_20, var3_20, var4_20, var5_20, var6_20, var7_20 = ShipWordHelper.GetCvDataForShip(arg0_20.ship, var0_20.dialog)
	local var8_20 = var0_20.action
	local var9_20 = var0_20.dialog
	local var10_20 = string.gsub(var9_20, "main_", "main")

	if arg0_20.ship.propose and pg.character_voice[var10_20] and arg0_20.shipGroup and arg0_20.shipGroup:VoiceReplayCodition(pg.character_voice[var10_20]) and arg0_20.live2dChar:checkActionExist(var8_20 .. "_ex") then
		var8_20 = var8_20 .. "_ex"
	end

	if not var7_20 then
		arg0_20.actionWaiting = true

		local var11_20 = arg0_20.live2dChar:TriggerAction(var8_20)

		var1_20(var11_20)
	else
		arg0_20.actionWaiting = true

		if not var4_20 or var4_20 == nil or var4_20 == "" or var4_20 == "nil" then
			arg0_20.actionWaiting = false

			var1_20(true)
		end

		if not arg0_20.live2dChar:TriggerAction(var8_20, nil, nil, var1_20) then
			arg0_20.actionWaiting = false
		end
	end
end

function var0_0.PlayCV(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	arg0_22:RemoveSeTimer()

	if arg1_22 then
		arg0_22.seTimer = Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. arg1_22[1])
		end, arg1_22[2], 1)

		arg0_22.seTimer:Start()
	end

	local var0_22 = ShipWordHelper.RawGetCVKey(arg0_22.ship:getSkinId())
	local var1_22 = pg.CriMgr.GetCVBankName(var0_22)

	arg0_22.cvLoader:Load(var1_22, arg3_22, arg2_22, arg4_22)
end

function var0_0.RemoveSeTimer(arg0_24)
	if arg0_24.seTimer then
		arg0_24.seTimer:Stop()

		arg0_24.seTimer = nil
	end
end

function var0_0.PlayChangeSkinActionIn(arg0_25, arg1_25)
	if arg0_25.live2dChar:IsLoaded() then
		if arg0_25.live2dChar:checkActionExist("change_in") then
			arg0_25:TriggerEvent("event_change_in")
		else
			arg0_25:TriggerEvent("event_login")
		end
	else
		arg0_25._initTriggerAction = {
			"event_change_in",
			"event_login"
		}
	end

	if arg1_25 and arg1_25.callback then
		arg1_25.callback({
			flag = true
		})
	end
end

function var0_0.PlayChangeSkinActionOut(arg0_26, arg1_26)
	if arg0_26.live2dChar:IsLoaded() and arg0_26.live2dChar:checkActionExist("change_out") then
		arg0_26:playSkinOut(arg1_26)
	elseif arg1_26 and arg1_26.callback then
		arg1_26.callback({
			flag = true
		})
	end
end

function var0_0.UpdateBound(arg0_27)
	if not arg0_27._dragBoundsUI and arg0_27.live2dChar then
		arg0_27:CreateL2dDragBound(arg0_27.live2dChar)
		arg0_27._dragBoundsUI:SetVisible(Live2dConst.l2d_bound_open)
	elseif arg0_27._dragBoundsUI then
		if arg0_27._dragBoundsUI:GetDragsCount() == 0 then
			local var0_27 = arg0_27.live2dChar:GetDragBounds()

			arg0_27._dragBoundsUI:SetData(var0_27, arg0_27.ship:getSkinId())
		end

		arg0_27._dragBoundsUI:SetVisible(Live2dConst.l2d_bound_open)
	end
end

function var0_0.playSkinOut(arg0_28, arg1_28)
	local function var0_28()
		if arg1_28 and arg1_28.callback then
			arg1_28.callback({
				flag = true
			})
		end
	end

	if not arg0_28.live2dChar:TriggerAction("change_out", function()
		return
	end, false, function()
		if var0_28 then
			var0_28()

			var0_28 = nil
		end
	end) and var0_28 then
		var0_28()

		var0_28 = nil
	end
end

function var0_0.OnDisplayWorld(arg0_32)
	return
end

function var0_0.OnPause(arg0_33)
	print("pause")
	arg0_33:RemoveScreenChangeTimer()
	arg0_33:ResetContainerPosition()

	arg0_33.actionWaiting = false

	arg0_33:OnUnload()
end

function var0_0.OnUpdateShip(arg0_34, arg1_34)
	if arg1_34 then
		arg0_34.live2dChar:updateShip(arg1_34)
	end
end

function var0_0.SetContainerVisible(arg0_35, arg1_35)
	return
end

function var0_0.IsLoaded(arg0_36)
	if not arg0_36.live2dChar then
		return false
	end

	return var0_0.super.IsLoaded(arg0_36)
end

function var0_0.OnResume(arg0_37)
	arg0_37:SetContainerVisible(true)
	arg0_37:AddScreenChangeTimer()
	arg0_37:UpdateContainerPosition()
	onNextTick(function()
		if arg0_37.ship then
			arg0_37:Load(arg0_37.ship)
		end
	end)
end

function var0_0.Dispose(arg0_39)
	var0_0.super.Dispose(arg0_39)
	arg0_39:RemoveSeTimer()
	arg0_39:RemoveScreenChangeTimer()

	if arg0_39._dragBoundsUI then
		arg0_39._dragBoundsUI:Dispose()

		arg0_39._dragBoundsUI = nil
	end

	if arg0_39.eventTrigger then
		ClearEventTrigger(arg0_39.eventTrigger)
	end
end

function var0_0.GetOffset(arg0_40)
	return arg0_40.live2dContainer.localPosition.x
end

function var0_0.GetCenterPos(arg0_41)
	return arg0_41.live2dContainer.position
end

function var0_0.IslimitYPos(arg0_42)
	return MainPaintingShift.IsLimitYPos(arg0_42.ship:getPainting())
end

return var0_0
