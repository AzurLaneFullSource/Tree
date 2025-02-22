local var0_0 = class("MainSpinePainting", import(".MainBasePainting"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.bgTr = arg3_1
	arg0_1.spTF = findTF(arg1_1, "spinePainting")
	arg0_1.spBg = findTF(arg3_1, "spinePainting")
	arg0_1.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
end

function var0_0.GetCenterPos(arg0_2)
	return arg0_2.spTF.position
end

function var0_0.OnLoad(arg0_3, arg1_3)
	local var0_3 = SpinePainting.GenerateData({
		ship = arg0_3.ship,
		position = Vector3(0, 0, 0),
		parent = arg0_3.spTF,
		effectParent = arg0_3.spBg
	})

	arg0_3.spinePainting = SpinePainting.New(var0_3, function(arg0_4)
		arg0_3:AdJustOrderInLayer(arg0_4)
		arg0_3:InitSpecialTouch()
		arg1_3()

		if arg0_3._initTriggerEvent then
			arg0_3:TriggerEvent(arg0_3._initTriggerEvent)

			arg0_3._initTriggerEvent = nil
		end
	end)
end

function var0_0.AdJustOrderInLayer(arg0_5, arg1_5)
	local var0_5 = 0
	local var1_5 = arg0_5.container:GetComponent(typeof(Canvas))

	if var1_5 and var1_5.overrideSorting and var1_5.sortingOrder ~= 0 then
		local var2_5 = arg0_5.spTF:GetComponentsInChildren(typeof(Canvas))

		for iter0_5 = 1, var2_5.Length do
			local var3_5 = var2_5[iter0_5 - 1]

			var3_5.overrideSorting = true
			var0_5 = var3_5.sortingOrder - var1_5.sortingOrder
			var3_5.sortingOrder = var1_5.sortingOrder
		end
	end

	local var4_5 = arg0_5.bgTr:GetComponent(typeof(Canvas))

	if var4_5 and var4_5.overrideSorting and var4_5.sortingOrder ~= 0 then
		local var5_5 = arg0_5.spBg:GetComponentsInChildren(typeof(Canvas))

		for iter1_5 = 1, var5_5.Length do
			local var6_5 = var5_5[iter1_5 - 1]

			var6_5.overrideSorting = true
			var6_5.sortingOrder = var6_5.sortingOrder - var0_5
		end

		local var7_5 = arg0_5.spBg:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter2_5 = 1, var7_5.Length do
			local var8_5 = var7_5[iter2_5 - 1]
			local var9_5 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var8_5) - var0_5

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var8_5, var9_5)
		end
	end
end

function var0_0.InitSpecialTouch(arg0_6)
	arg0_6.specialClickDic = {}

	local var0_6 = findTF(arg0_6.spTF:GetChild(0), "hitArea")

	if not var0_6 then
		return
	end

	eachChild(var0_6, function(arg0_7)
		if arg0_7.name == "drag" then
			arg0_6.dragEvent = GetOrAddComponent(arg0_7, typeof(EventTriggerListener))

			arg0_6.dragEvent:AddPointDownFunc(function(arg0_8, arg1_8)
				arg0_6.dragActive = true
				arg0_6.dragStart = arg1_8.position
			end)
			arg0_6.dragEvent:AddPointUpFunc(function(arg0_9, arg1_9)
				if arg0_6.dragActive then
					arg0_6.dragActive = false
					arg0_6.dragOffset = Vector2(arg0_6.dragStart.x - arg1_9.position.x, arg0_6.dragStart.y - arg1_9.position.y)

					if math.abs(arg0_6.dragOffset.x) < 200 or math.abs(arg0_6.dragOffset.y) < 200 then
						arg0_6.dragUp = arg1_9.position

						if arg0_6.spinePainting:isInAction() then
							return
						end

						if not arg0_6.spinePainting:DoDragClick() then
							local var0_9 = arg0_6.uiCam:ScreenToWorldPoint(arg1_9.position)

							for iter0_9 = 1, #arg0_6.specialClickDic do
								local var1_9 = arg0_6.specialClickDic[iter0_9]
								local var2_9 = var1_9.tf:InverseTransformPoint(var0_9)

								if math.abs(var2_9.x) < var1_9.bound.x / 2 and math.abs(var2_9.y) < var1_9.bound.y / 2 then
									arg0_6:PrepareTriggerAction(var1_9.name)
									arg0_6:TriggerPersonalTask(var1_9.task)
								end
							end
						end
					end
				end
			end)
			arg0_6.dragEvent:AddDragFunc(function(arg0_10, arg1_10)
				if arg0_6.dragActive then
					if arg0_6.isDragAndZoomState then
						arg0_6.dragActive = false

						return
					end

					if arg0_6.chatting then
						arg0_6.dragActive = false

						return
					end

					arg0_6.dragOffset = Vector2(arg0_6.dragStart.x - arg1_10.position.x, arg0_6.dragStart.y - arg1_10.position.y)

					if math.abs(arg0_6.dragOffset.x) > 200 or math.abs(arg0_6.dragOffset.y) > 200 then
						arg0_6.dragActive = false

						arg0_6.spinePainting:DoDragTouch()
					end
				end
			end)
		else
			local var0_7 = arg0_6:GetSpecialTouchEvent(arg0_7.name)

			if var0_7 then
				table.insert(arg0_6.specialClickDic, {
					name = var0_7,
					task = arg0_6.ship.groupId,
					bound = arg0_7.sizeDelta,
					tf = arg0_7
				})
			end

			onButton(arg0_6, arg0_7, function()
				if arg0_6.spinePainting:isInAction() then
					return
				end

				local var0_11 = arg0_6:GetSpecialTouchEvent(arg0_7.name)

				if arg0_7.name == "special" then
					if arg0_6.isDragAndZoomState then
						return
					end

					if arg0_6.chatting then
						return
					end

					arg0_6.spinePainting:DoSpecialTouch()
				else
					arg0_6:TriggerEvent(var0_11)
					arg0_6:TriggerPersonalTask(arg0_6.ship.groupId)
				end
			end)
		end
	end)
end

function var0_0.OnClick(arg0_12)
	if arg0_12.spinePainting:isInAction() then
		return
	end

	local var0_12 = arg0_12:CollectTouchEvents()

	arg0_12:TriggerEvent(var0_12[math.ceil(math.random(#var0_12))])
end

function var0_0.OnEnableTimerEvent(arg0_13)
	return not arg0_13.spinePainting:isInAction()
end

function var0_0.PrepareTriggerAction(arg0_14, arg1_14)
	local var0_14
	local var1_14

	if pg.AssistantInfo.assistantEvents[arg1_14] then
		var0_14 = pg.AssistantInfo.assistantEvents[arg1_14].action

		local var2_14 = SpinePaintingConst.ship_action_extend[arg0_14.spinePainting:getPaintingName()]

		if var2_14 and table.contains(var2_14, var0_14) then
			var1_14 = true
		end
	end

	if var1_14 then
		arg0_14.spinePainting:SetOnceAction(var0_14, nil, function()
			arg0_14:TryToTriggerEvent(arg1_14)
		end, true)
	else
		arg0_14:TryToTriggerEvent(arg1_14)
	end
end

function var0_0.OnDisplayWorld(arg0_16, arg1_16)
	local var0_16 = arg0_16.ship:getCVIntimacy()
	local var1_16 = ShipExpressionHelper.GetExpression(arg0_16.paintingName, arg1_16, var0_16, arg0_16.ship.skinId)

	if var1_16 ~= "" then
		arg0_16.spinePainting:SetAction(var1_16, 1)
		arg0_16.spinePainting:displayWord(true)
	end
end

function var0_0.OnDisplayWordEnd(arg0_17)
	var0_0.super.OnDisplayWordEnd(arg0_17)
	arg0_17.spinePainting:SetEmptyAction(1)
	arg0_17.spinePainting:displayWord(false)
end

function var0_0.OnLongPress(arg0_18)
	if arg0_18.isFoldState then
		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
		shipId = arg0_18.ship.id
	})
end

function var0_0.PlayChangeSkinActionIn(arg0_19, arg1_19)
	if arg0_19.spinePainting and arg0_19.spinePainting:getInitFlag() then
		arg0_19:TriggerEvent("event_login")
	else
		arg0_19._initTriggerEvent = "event_login"
	end

	if arg1_19 and arg1_19.callback then
		arg1_19.callback({
			flag = true
		})
	end
end

function var0_0.PlayChangeSkinActionOut(arg0_20, arg1_20)
	if arg1_20 and arg1_20.callback then
		arg1_20.callback({
			flag = true
		})
	end
end

function var0_0.OnUnload(arg0_21)
	if arg0_21.spinePainting then
		arg0_21.spinePainting:Dispose()

		arg0_21.spinePainting = nil
	end

	if arg0_21.dragEvent then
		ClearEventTrigger(arg0_21.dragEvent)
	end
end

function var0_0.GetOffset(arg0_22)
	return arg0_22.spTF.localPosition.x
end

function var0_0.OnPuase(arg0_23)
	if arg0_23.spinePainting then
		arg0_23.spinePainting:SetVisible(false)
	end
end

function var0_0.OnResume(arg0_24)
	if arg0_24.spinePainting then
		arg0_24.spinePainting:SetVisible(true)
		arg0_24.spinePainting:SetEmptyAction(1)
	end
end

return var0_0
