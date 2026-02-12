local var0_0 = class("MainSpinePainting", import(".MainBasePainting"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.bgTr = arg3_1
	arg0_1.spTF = findTF(arg1_1, "spinePainting")
	arg0_1.spBg = findTF(arg3_1, "spinePainting")
	arg0_1.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	arg0_1._initCallback = {}
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

	arg0_3:ClearScalePart()

	arg0_3.spinePainting = SpinePainting.New(var0_3, function(arg0_4)
		arg0_3:AdJustOrderInLayer(arg0_4)
		arg0_3:InitSpecialTouch()
		arg1_3()

		for iter0_4, iter1_4 in ipairs(arg0_3._initCallback) do
			iter1_4()
		end

		arg0_3._initCallback = {}

		if getProxy(PlayerProxy):getFlag("login") then
			getProxy(PlayerProxy):setFlag("login", nil)
			arg0_3:TriggerEvent("event_login")
		end

		arg0_3:InitScalePart()
	end)

	arg0_3.spinePainting:setEventTriggerCallback(function(arg0_5)
		arg0_3:onSpinePaintingEvent(arg0_5)
	end)
end

function var0_0.AdJustOrderInLayer(arg0_6, arg1_6)
	local var0_6 = 0
	local var1_6 = arg0_6.container:GetComponent(typeof(Canvas))

	if var1_6 and var1_6.overrideSorting and var1_6.sortingOrder ~= 0 then
		local var2_6 = arg0_6.spTF:GetComponentsInChildren(typeof(Canvas)):ToTable()

		for iter0_6, iter1_6 in ipairs(var2_6) do
			iter1_6.overrideSorting = true
			var0_6 = iter1_6.sortingOrder - var1_6.sortingOrder
			iter1_6.sortingOrder = var1_6.sortingOrder
		end
	end

	local var3_6 = arg0_6.bgTr:GetComponent(typeof(Canvas))

	if var3_6 and var3_6.overrideSorting and var3_6.sortingOrder ~= 0 then
		local var4_6 = arg0_6.spBg:GetComponentsInChildren(typeof(Canvas)):ToTable()

		for iter2_6, iter3_6 in ipairs(var4_6) do
			iter3_6.overrideSorting = true
			iter3_6.sortingOrder = iter3_6.sortingOrder - var0_6
		end

		local var5_6 = arg0_6.spBg:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer")):ToTable()

		for iter4_6, iter5_6 in ipairs(var5_6) do
			local var6_6 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", iter5_6) - var0_6

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", iter5_6, var6_6)
		end
	end
end

function var0_0.InitSpecialTouch(arg0_7)
	local var0_7 = arg0_7.ship:getPainting()

	arg0_7.specialClickDic = {}

	local var1_7 = findTF(arg0_7.spTF:GetChild(0), "hitArea")

	if not var1_7 then
		return
	end

	eachChild(var1_7, function(arg0_8)
		if arg0_7:getDragTouchAble(arg0_8.name, var0_7, false) then
			arg0_7.dragEvent = GetOrAddComponent(arg0_8, typeof(EventTriggerListener))

			arg0_7.dragEvent:AddPointDownFunc(function(arg0_9, arg1_9)
				arg0_7.dragActive = true
				arg0_7.dragStart = arg1_9.position
			end)
			arg0_7.dragEvent:AddPointUpFunc(function(arg0_10, arg1_10)
				if arg0_7.dragActive then
					arg0_7.dragActive = false
					arg0_7.dragOffset = Vector2(arg0_7.dragStart.x - arg1_10.position.x, arg0_7.dragStart.y - arg1_10.position.y)

					if math.abs(arg0_7.dragOffset.x) < 200 or math.abs(arg0_7.dragOffset.y) < 200 then
						arg0_7.dragUp = arg1_10.position

						if arg0_7.spinePainting:isInAction() then
							return
						end

						local var0_10

						if arg0_7:getDragTouchAble(arg0_8.name, var0_7, true) then
							var0_10 = arg0_7.spinePainting:readyDragAction(arg0_8.name, false)
						end

						if not var0_10 then
							local var1_10 = arg0_7.uiCam:ScreenToWorldPoint(arg1_10.position)

							for iter0_10 = 1, #arg0_7.specialClickDic do
								local var2_10 = arg0_7.specialClickDic[iter0_10]
								local var3_10 = var2_10.tf:InverseTransformPoint(var1_10)

								if math.abs(var3_10.x) < var2_10.bound.x / 2 and math.abs(var3_10.y) < var2_10.bound.y / 2 then
									arg0_7:PrepareTriggerAction(var2_10.name)
									arg0_7:TriggerPersonalTask(var2_10.task)
								end
							end
						end
					end
				end
			end)
			arg0_7.dragEvent:AddDragFunc(function(arg0_11, arg1_11)
				if arg0_7.dragActive then
					if arg0_7.isDragAndZoomState then
						arg0_7.dragActive = false

						return
					end

					if arg0_7.chatting then
						arg0_7.dragActive = false

						return
					end

					arg0_7.dragOffset = Vector2(arg0_7.dragStart.x - arg1_11.position.x, arg0_7.dragStart.y - arg1_11.position.y)

					if math.abs(arg0_7.dragOffset.x) > 200 or math.abs(arg0_7.dragOffset.y) > 200 then
						arg0_7.dragActive = false

						arg0_7.spinePainting:readyDragAction(arg0_8.name, true)
					end
				end
			end)
		else
			local var0_8 = arg0_7:GetSpecialTouchEvent(arg0_8.name)

			if var0_8 then
				table.insert(arg0_7.specialClickDic, {
					name = var0_8,
					task = arg0_7.ship.groupId,
					bound = arg0_8.sizeDelta,
					tf = arg0_8
				})
			end

			onButton(arg0_7, arg0_8, function()
				if arg0_7.spinePainting:isInAction() then
					return
				end

				local var0_12 = arg0_7:GetSpecialTouchEvent(arg0_8.name)

				if arg0_7:getDragTouchAble(arg0_8.name, var0_7, true) then
					if arg0_7.isDragAndZoomState then
						return
					end

					if arg0_7.chatting then
						return
					end

					arg0_7.spinePainting:readyDragAction(arg0_8.name, false)
				elseif var0_12 and not arg0_7._asmrFlag then
					arg0_7:TriggerEvent(var0_12)
					arg0_7:TriggerPersonalTask(arg0_7.ship.groupId)
				end
			end)
		end
	end)
end

function var0_0.OnClick(arg0_13)
	if arg0_13.spinePainting:isInAction() or arg0_13._asmrFlag then
		return
	end

	local var0_13 = arg0_13:CollectTouchEvents()

	arg0_13:TriggerEvent(var0_13[math.ceil(math.random(#var0_13))])
end

function var0_0.OnEnableTimerEvent(arg0_14)
	return not arg0_14.spinePainting:isInAction() and not arg0_14._asmrFlag
end

function var0_0.PrepareTriggerAction(arg0_15, arg1_15)
	if arg0_15._asmrFlag then
		return
	end

	local var0_15
	local var1_15 = false
	local var2_15 = ""

	if pg.AssistantInfo.assistantEvents[arg1_15] then
		var0_15 = pg.AssistantInfo.assistantEvents[arg1_15].action
		var1_15 = arg0_15.spinePainting:getAnimationExist(var0_15)
		var2_15 = arg0_15.spinePainting:getIdleName()
	end

	if var1_15 and var2_15 == "normal" then
		arg0_15.spinePainting:SetOnceAction(var0_15, nil, function()
			arg0_15:TryToTriggerEvent(arg1_15)
		end, true)
	else
		arg0_15:TryToTriggerEvent(arg1_15)
	end
end

function var0_0.GetEventExit(arg0_17, arg1_17)
	local var0_17 = false

	if pg.AssistantInfo.assistantEvents[arg1_17] then
		local var1_17 = pg.AssistantInfo.assistantEvents[arg1_17].action

		var0_17 = arg0_17.spinePainting:getAnimationExist(var1_17)
	end

	return var0_17
end

function var0_0.TryToTriggerEvent(arg0_18, arg1_18)
	arg0_18:_TriggerEvent(arg1_18)
end

function var0_0.onSpinePaintingEvent(arg0_19, arg1_19)
	arg0_19:TryToTriggerEvent(arg1_19)
	arg0_19:TriggerPersonalTask(arg0_19.ship.groupId)
end

function var0_0.GetPaintingTransform(arg0_20)
	if arg0_20.spinePainting then
		return arg0_20.spinePainting:GetSpineTrasform()
	end

	return nil
end

function var0_0.GetPartScaleData(arg0_21)
	return pg.ship_skin_template[arg0_21.ship:getSkinId()].part_scale.spine
end

function var0_0.GetPartStateType(arg0_22)
	return MainPaintingView.STATE_SPINE_PAINTING
end

function var0_0.getDragTouchAble(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = SpinePaintingConst.ship_drag_datas[arg2_23]

	if not var0_23 then
		return false
	end

	if var0_23.drag_data and var0_23.click_trigger ~= arg3_23 then
		return false
	end

	if var0_23.hit_area then
		return table.contains(var0_23.hit_area, arg1_23)
	end

	return false
end

function var0_0.OnDisplayWorld(arg0_24, arg1_24)
	local var0_24 = arg0_24.ship:getCVIntimacy()
	local var1_24 = ShipExpressionHelper.GetExpression(arg0_24.paintingName, arg1_24, var0_24, arg0_24.ship:getSkinId())

	if var1_24 and var1_24 ~= "" then
		arg0_24.spinePainting:SetAction(var1_24, 1)
		arg0_24.spinePainting:displayWord(true)
	end
end

function var0_0.OnDisplayWordEnd(arg0_25)
	var0_0.super.OnDisplayWordEnd(arg0_25)
	arg0_25.spinePainting:SetEmptyAction(1)
	arg0_25.spinePainting:displayWord(false)
end

function var0_0.OnLongPress(arg0_26)
	if arg0_26.isFoldState then
		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
		shipId = arg0_26.ship.id
	})
end

function var0_0.PlayChangeSkinActionIn(arg0_27, arg1_27)
	if arg0_27.spinePainting then
		local function var0_27()
			if arg1_27 and arg1_27.callback then
				arg1_27.callback({
					flag = true
				})
			end
		end

		local function var1_27()
			local var0_29 = arg0_27.spinePainting:GetDragDataConfig("change_in_hit")

			if var0_29 and #var0_29 > 0 then
				arg0_27.spinePainting:readyDragAction(var0_29)
				var0_27()
			elseif arg0_27.spinePainting:getAnimationExist("change_in") and arg0_27.spinePainting:ablePlayAction("change_in", false, 0) then
				arg0_27.spinePainting:SetOnceAction("change_in", nil, function()
					var0_27()
				end, true)
			else
				arg0_27:TriggerEvent("event_login")
				var0_27()
			end
		end

		if arg0_27.spinePainting:getInitFlag() then
			var1_27()
		else
			arg0_27:pullInitCallback(var1_27)
		end
	end
end

function var0_0.pullInitCallback(arg0_31, arg1_31)
	table.insert(arg0_31._initCallback, arg1_31)
end

function var0_0.PlayChangeSkinActionOut(arg0_32, arg1_32)
	if arg0_32.spinePainting and arg0_32.spinePainting:getAnimationExist("change_out") then
		if arg0_32.spinePainting:ablePlayAction("change_out", false, 0) then
			arg0_32.spinePainting:SetOnceAction("change_out", function()
				return
			end, function()
				if arg1_32 and arg1_32.callback then
					arg1_32.callback({
						flag = true
					})
				end
			end, true)
		elseif arg1_32 and arg1_32.callback then
			arg1_32.callback({
				flag = true
			})
		end
	elseif arg1_32 and arg1_32.callback then
		arg1_32.callback({
			flag = true
		})
	end
end

function var0_0.OnUnload(arg0_35)
	if arg0_35.spinePainting then
		arg0_35.spinePainting:Dispose()

		arg0_35.spinePainting = nil
	end

	if arg0_35.dragEvent then
		ClearEventTrigger(arg0_35.dragEvent)
	end
end

function var0_0.GetOffset(arg0_36)
	return arg0_36.spTF.localPosition.x
end

function var0_0.OnPause(arg0_37)
	if arg0_37.spinePainting then
		arg0_37.spinePainting:SetVisible(false)
	end
end

function var0_0.OnResume(arg0_38)
	if arg0_38.spinePainting then
		arg0_38.spinePainting:SetVisible(true)
		arg0_38.spinePainting:SetEmptyAction(1)
	end
end

return var0_0
