local var0 = class("MainSpinePainting", import(".MainBasePainting"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.bgTr = arg3
	arg0.spTF = findTF(arg1, "spinePainting")
	arg0.spBg = findTF(arg3, "spinePainting")
	arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
end

function var0.GetCenterPos(arg0)
	return arg0.spTF.position
end

function var0.OnLoad(arg0, arg1)
	local var0 = SpinePainting.GenerateData({
		ship = arg0.ship,
		position = Vector3(0, 0, 0),
		parent = arg0.spTF,
		effectParent = arg0.spBg
	})

	arg0.spinePainting = SpinePainting.New(var0, function(arg0)
		arg0:AdJustOrderInLayer(arg0)
		arg0:InitSpecialTouch()
		arg1()
	end)
end

function var0.AdJustOrderInLayer(arg0, arg1)
	local var0 = 0
	local var1 = arg0.container:GetComponent(typeof(Canvas))

	if var1 and var1.overrideSorting and var1.sortingOrder ~= 0 then
		local var2 = arg0.spTF:GetComponentsInChildren(typeof(Canvas))

		for iter0 = 1, var2.Length do
			local var3 = var2[iter0 - 1]

			var3.overrideSorting = true
			var0 = var3.sortingOrder - var1.sortingOrder
			var3.sortingOrder = var1.sortingOrder
		end
	end

	local var4 = arg0.bgTr:GetComponent(typeof(Canvas))

	if var4 and var4.overrideSorting and var4.sortingOrder ~= 0 then
		local var5 = arg0.spBg:GetComponentsInChildren(typeof(Canvas))

		for iter1 = 1, var5.Length do
			local var6 = var5[iter1 - 1]

			var6.overrideSorting = true
			var6.sortingOrder = var6.sortingOrder - var0
		end

		local var7 = arg0.spBg:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter2 = 1, var7.Length do
			local var8 = var7[iter2 - 1]
			local var9 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var8) - var0

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var8, var9)
		end
	end
end

function var0.InitSpecialTouch(arg0)
	arg0.specialClickDic = {}

	local var0 = findTF(arg0.spTF:GetChild(0), "hitArea")

	if not var0 then
		return
	end

	eachChild(var0, function(arg0)
		if arg0.name == "drag" then
			arg0.dragEvent = GetOrAddComponent(arg0, typeof(EventTriggerListener))

			arg0.dragEvent:AddPointDownFunc(function(arg0, arg1)
				arg0.dragActive = true
				arg0.dragStart = arg1.position
			end)
			arg0.dragEvent:AddPointUpFunc(function(arg0, arg1)
				if arg0.dragActive then
					arg0.dragActive = false
					arg0.dragOffset = Vector2(arg0.dragStart.x - arg1.position.x, arg0.dragStart.y - arg1.position.y)

					if math.abs(arg0.dragOffset.x) < 200 or math.abs(arg0.dragOffset.y) < 200 then
						arg0.dragUp = arg1.position

						local var0 = arg0.uiCam:ScreenToWorldPoint(arg1.position)

						for iter0 = 1, #arg0.specialClickDic do
							local var1 = arg0.specialClickDic[iter0]
							local var2 = var1.tf:InverseTransformPoint(var0)

							if math.abs(var2.x) < var1.bound.x / 2 and math.abs(var2.y) < var1.bound.y / 2 then
								arg0:TriggerEvent(var1.name)
								arg0:TriggerPersonalTask(var1.task)

								return
							end
						end
					end
				end
			end)
			arg0.dragEvent:AddDragFunc(function(arg0, arg1)
				if arg0.dragActive then
					if arg0.isDragAndZoomState then
						arg0.dragActive = false

						return
					end

					if arg0.chatting then
						arg0.dragActive = false

						return
					end

					arg0.dragOffset = Vector2(arg0.dragStart.x - arg1.position.x, arg0.dragStart.y - arg1.position.y)

					if math.abs(arg0.dragOffset.x) > 200 or math.abs(arg0.dragOffset.y) > 200 then
						arg0.dragActive = false

						arg0.spinePainting:DoDragTouch()
					end
				end
			end)
		else
			local var0 = arg0:GetSpecialTouchEvent(arg0.name)

			if var0 then
				table.insert(arg0.specialClickDic, {
					name = var0,
					task = arg0.ship.groupId,
					bound = arg0.sizeDelta,
					tf = arg0
				})
			end

			onButton(arg0, arg0, function()
				local var0 = arg0:GetSpecialTouchEvent(arg0.name)

				if arg0.name == "special" then
					if arg0.isDragAndZoomState then
						return
					end

					if arg0.chatting then
						return
					end

					arg0.spinePainting:DoSpecialTouch()
				else
					arg0:TriggerEvent(var0)
					arg0:TriggerPersonalTask(arg0.ship.groupId)
				end
			end)
		end
	end)
end

function var0.OnClick(arg0)
	local var0 = arg0:CollectTouchEvents()

	arg0:TriggerEvent(var0[math.ceil(math.random(#var0))])
end

function var0.OnDisplayWorld(arg0, arg1)
	local var0 = arg0.ship:getCVIntimacy()
	local var1 = ShipExpressionHelper.GetExpression(arg0.paintingName, arg1, var0, arg0.ship.skinId)

	if var1 ~= "" then
		arg0.spinePainting:SetAction(var1, 1)
	end
end

function var0.OnDisplayWordEnd(arg0)
	var0.super.OnDisplayWordEnd(arg0)
	arg0.spinePainting:SetEmptyAction(1)
end

function var0.OnLongPress(arg0)
	if arg0.isFoldState then
		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
		shipId = arg0.ship.id
	})
end

function var0.OnUnload(arg0)
	if arg0.spinePainting then
		arg0.spinePainting:Dispose()

		arg0.spinePainting = nil
	end

	if arg0.dragEvent then
		ClearEventTrigger(arg0.dragEvent)
	end
end

function var0.GetOffset(arg0)
	return arg0.spTF.localPosition.x
end

function var0.OnPuase(arg0)
	if arg0.spinePainting then
		arg0.spinePainting:SetVisible(false)
	end
end

function var0.OnResume(arg0)
	if arg0.spinePainting then
		arg0.spinePainting:SetVisible(true)
		arg0.spinePainting:SetEmptyAction(1)
	end
end

return var0
