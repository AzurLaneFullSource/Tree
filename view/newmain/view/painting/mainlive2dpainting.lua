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
	local var0_3 = arg0_3.container.parent
	local var1_3 = var0_3.rect.height * -0.5
	local var2_3 = var0_3:InverseTransformPoint(arg0_3.live2dContainer.position)
	local var3_3 = arg0_3.live2dContainer.localScale

	return var1_3 - (arg0_3.live2dContainer.rect.height * -0.5 * var3_3.y + var2_3.y)
end

function var0_0.OnLoad(arg0_4, arg1_4)
	local var0_4 = Live2D.GenerateData({
		loadPrefs = true,
		ship = arg0_4.ship,
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, 100),
		parent = arg0_4.live2dContainer
	})

	arg0_4.actionWaiting = false

	arg0_4:SetContainerVisible(true)

	arg0_4.cg.blocksRaycasts = true
	arg0_4.live2dChar = Live2D.New(var0_4, function(arg0_5)
		arg0_4:AdJustOrderInLayer(arg0_5)
		arg1_4()

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
	end)
	arg0_4.shipGroup = getProxy(CollectionProxy):getShipGroup(arg0_4.ship.groupId)

	arg0_4:UpdateContainerPosition()
	arg0_4:AddScreenChangeTimer()
end

function var0_0.ResetState(arg0_6)
	if not arg0_6.live2dChar then
		return
	end

	arg0_6.live2dChar:resetL2dData()
end

function var0_0.AdJustOrderInLayer(arg0_7, arg1_7)
	local var0_7 = arg0_7.container:GetComponent(typeof(Canvas))

	if var0_7 and var0_7.overrideSorting and var0_7.sortingOrder ~= 0 then
		local var1_7 = arg1_7._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
		local var2_7 = var0_7.sortingOrder
		local var3_7 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

		ReflectionHelp.RefSetProperty(var3_7, "SortingOrder", var1_7, var2_7)

		arg0_7.isModifyOrder = true
	end
end

function var0_0.ResetOrderInLayer(arg0_8)
	if not arg0_8.live2dChar then
		return
	end

	local var0_8 = arg0_8.live2dChar._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_8 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

	ReflectionHelp.RefSetProperty(var1_8, "SortingOrder", var0_8, 0)
end

function var0_0.AddScreenChangeTimer(arg0_9)
	arg0_9:RemoveScreenChangeTimer()

	if not arg0_9:IslimitYPos() then
		return
	end

	arg0_9.screenTimer = Timer.New(function()
		if arg0_9.currentWidth ~= Screen.width or arg0_9.currentHeight ~= Screen.height then
			arg0_9.currentWidth = Screen.width
			arg0_9.currentHeight = Screen.height

			arg0_9:ResetContainerPosition()
			arg0_9:UpdateContainerPosition()
		end
	end, 0.5, -1)

	arg0_9.screenTimer:Start()
end

function var0_0.RemoveScreenChangeTimer(arg0_11)
	if arg0_11.screenTimer then
		arg0_11.screenTimer:Stop()

		arg0_11.screenTimer = nil
	end
end

function var0_0.UpdateContainerPosition(arg0_12)
	local var0_12 = arg0_12:IslimitYPos() and arg0_12:GetHalfBodyOffsetY() or 0
	local var1_12 = arg0_12.live2dContainer.localPosition

	arg0_12.live2dContainer.localPosition = Vector3(var1_12.x, var0_12, var1_12.z)
end

function var0_0.ResetContainerPosition(arg0_13)
	local var0_13 = arg0_13.live2dContainer.localPosition

	arg0_13.live2dContainer.localPosition = Vector3(var0_13.x, 0, 0)
end

function var0_0.OnUnload(arg0_14)
	if arg0_14.live2dChar then
		arg0_14:RemoveScreenChangeTimer()
		arg0_14:ResetContainerPosition()

		if arg0_14.isModifyOrder then
			arg0_14.isModifyOrder = false

			arg0_14:ResetOrderInLayer()
		end

		arg0_14.cg.blocksRaycasts = false

		arg0_14.live2dChar:Dispose()

		arg0_14.live2dChar = nil
	end
end

function var0_0.OnClick(arg0_15)
	local var0_15

	if arg0_15.live2dChar and arg0_15.live2dChar.state == Live2D.STATE_INITED and not arg0_15.live2dChar.ignoreReact then
		if not Input.mousePosition then
			return
		end

		local var1_15 = arg0_15.live2dChar:GetTouchPart()

		if var1_15 > 0 then
			local var2_15 = arg0_15:GetTouchEvent(var1_15)

			var0_15 = var2_15[math.ceil(math.random(#var2_15))]
		else
			local var3_15 = arg0_15:GetIdleEvents()

			var0_15 = var3_15[math.floor(math.Random(0, #var3_15)) + 1]
		end
	end

	if var0_15 then
		arg0_15:TriggerEvent(var0_15)
	end
end

function var0_0._TriggerEvent(arg0_16, arg1_16)
	if not arg1_16 then
		return
	end

	if arg0_16.actionWaiting then
		return
	end

	local var0_16 = arg0_16:GetEventConfig(arg1_16)

	local function var1_16(arg0_17)
		if arg0_17 then
			if var0_16.dialog ~= "" then
				arg0_16:DisplayWord(var0_16.dialog)
			else
				arg0_16:TriggerNextEventAuto()
			end
		end

		arg0_16.actionWaiting = false
	end

	local var2_16, var3_16, var4_16, var5_16, var6_16, var7_16 = ShipWordHelper.GetCvDataForShip(arg0_16.ship, var0_16.dialog)
	local var8_16 = var0_16.action
	local var9_16 = var0_16.dialog
	local var10_16 = string.gsub(var9_16, "main_", "main")

	if arg0_16.ship.propose and pg.character_voice[var10_16] and arg0_16.shipGroup and arg0_16.shipGroup:VoiceReplayCodition(pg.character_voice[var10_16]) and arg0_16.live2dChar:checkActionExist(var8_16 .. "_ex") then
		var8_16 = var8_16 .. "_ex"
	end

	if not var7_16 then
		arg0_16.actionWaiting = true

		local var11_16 = arg0_16.live2dChar:TriggerAction(var8_16)

		var1_16(var11_16)
	else
		arg0_16.actionWaiting = true

		if not var4_16 or var4_16 == nil or var4_16 == "" or var4_16 == "nil" then
			arg0_16.actionWaiting = false

			var1_16(true)
		end

		if not arg0_16.live2dChar:TriggerAction(var8_16, nil, nil, var1_16) then
			arg0_16.actionWaiting = false
		end
	end
end

function var0_0.PlayCV(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	arg0_18:RemoveSeTimer()

	if arg1_18 then
		arg0_18.seTimer = Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. arg1_18[1])
		end, arg1_18[2], 1)

		arg0_18.seTimer:Start()
	end

	local var0_18 = ShipWordHelper.RawGetCVKey(arg0_18.ship.skinId)
	local var1_18 = pg.CriMgr.GetCVBankName(var0_18)

	arg0_18.cvLoader:Load(var1_18, arg3_18, arg2_18, arg4_18)
end

function var0_0.RemoveSeTimer(arg0_20)
	if arg0_20.seTimer then
		arg0_20.seTimer:Stop()

		arg0_20.seTimer = nil
	end
end

function var0_0.PlayChangeSkinActionIn(arg0_21, arg1_21)
	if arg0_21.live2dChar:IsLoaded() then
		if arg0_21.live2dChar:checkActionExist("change_in") then
			arg0_21:TriggerEvent("event_change_in")
		else
			arg0_21:TriggerEvent("event_login")
		end
	else
		arg0_21._initTriggerAction = {
			"event_change_in",
			"event_login"
		}
	end

	if arg1_21 and arg1_21.callback then
		arg1_21.callback({
			flag = true
		})
	end
end

function var0_0.PlayChangeSkinActionOut(arg0_22, arg1_22)
	if arg0_22.live2dChar:IsLoaded() and arg0_22.live2dChar:checkActionExist("change_out") then
		arg0_22:playSkinOut(arg1_22)
	elseif arg1_22 and arg1_22.callback then
		arg1_22.callback({
			flag = true
		})
	end
end

function var0_0.playSkinOut(arg0_23, arg1_23)
	local function var0_23()
		if arg1_23 and arg1_23.callback then
			arg1_23.callback({
				flag = true
			})
		end
	end

	if not arg0_23.live2dChar:TriggerAction("change_out", function()
		return
	end, false, function()
		if var0_23 then
			var0_23()

			var0_23 = nil
		end
	end) and var0_23 then
		var0_23()

		var0_23 = nil
	end
end

function var0_0.OnDisplayWorld(arg0_27)
	return
end

function var0_0.OnPuase(arg0_28)
	arg0_28:RemoveScreenChangeTimer()
	arg0_28:ResetContainerPosition()

	arg0_28.actionWaiting = false

	arg0_28.live2dChar:SetVisible(false)
end

function var0_0.OnUpdateShip(arg0_29, arg1_29)
	if arg1_29 then
		arg0_29.live2dChar:updateShip(arg1_29)
	end
end

function var0_0.SetContainerVisible(arg0_30, arg1_30)
	setActive(arg0_30.live2dContainer, arg1_30)
end

function var0_0.OnResume(arg0_31)
	arg0_31:SetContainerVisible(true)
	arg0_31:AddScreenChangeTimer()
	arg0_31:UpdateContainerPosition()
	arg0_31.live2dChar:SetVisible(true)
	arg0_31.live2dChar:UpdateAtomSource()
end

function var0_0.Dispose(arg0_32)
	var0_0.super.Dispose(arg0_32)
	arg0_32:RemoveSeTimer()
	arg0_32:RemoveScreenChangeTimer()

	if arg0_32.eventTrigger then
		ClearEventTrigger(arg0_32.eventTrigger)
	end
end

function var0_0.GetOffset(arg0_33)
	return arg0_33.live2dContainer.localPosition.x
end

function var0_0.GetCenterPos(arg0_34)
	return arg0_34.live2dContainer.position
end

function var0_0.IslimitYPos(arg0_35)
	local var0_35 = arg0_35.ship:getPainting()

	return var0_35 == "biaoqiang" or var0_35 == "z23" or var0_35 == "lafei" or var0_35 == "lingbo" or var0_35 == "mingshi" or var0_35 == "xuefeng"
end

return var0_0
