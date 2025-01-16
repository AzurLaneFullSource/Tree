local var0_0 = class("MainMeshImagePainting", import(".MainBasePainting"))

var0_0.DEFAULT_HEIGHT = 0
var0_0.TOUCH_HEIGHT = 20
var0_0.TOUCH_LOOP = 1
var0_0.TOUCH_DURATION = 0.1
var0_0.CHAT_HEIGHT = 15
var0_0.CHAT_DURATION = 0.3
var0_0.BREATH_HEIGHT = -10
var0_0.BREATH_DURATION = 2.3
var0_0.PAINTING_VARIANT_NORMAL = 0
var0_0.PAINTING_VARIANT_EX = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
end

function var0_0.StaticGetPaintingName(arg0_2)
	local var0_2 = arg0_2

	if checkABExist("painting/" .. var0_2 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_2, 0) ~= 0 then
		var0_2 = var0_2 .. "_n"
	end

	if HXSet.isHx() then
		return var0_2
	end

	local var1_2 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0_2) == var0_0.PAINTING_VARIANT_EX

	if var1_2 and not checkABExist("painting/" .. var0_2 .. "_ex") then
		return var0_2
	end

	return var1_2 and var0_2 .. "_ex" or var0_2
end

function var0_0.GetPaintingName(arg0_3)
	return var0_0.StaticGetPaintingName(arg0_3.paintingName)
end

function var0_0.OnLoad(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetPaintingName()

	LoadPaintingPrefabAsync(arg0_4.container, arg0_4.paintingName, var0_4, "mainNormal", function()
		if arg0_4:IsExited() then
			arg0_4:UnLoad()

			return
		end

		arg0_4.loadPaintingName = var0_4

		local var0_5 = arg0_4:InitSpecialTouch()

		arg0_4:InitSpecialDrag(var0_5)

		if arg0_4.expression then
			ShipExpressionHelper.UpdateExpression(findTF(arg0_4.container, "fitter"):GetChild(0), arg0_4.paintingName, arg0_4.expression)
		end

		arg0_4:Breath()
		arg1_4()
	end)
end

function var0_0.GetCenterPos(arg0_6)
	if arg0_6:IsLoaded() then
		local var0_6 = arg0_6.container:Find("fitter"):GetChild(0)
		local var1_6 = (0.5 - var0_6.pivot.x) * var0_6.sizeDelta.x
		local var2_6 = var0_6.localPosition + Vector3(var1_6, 0, 0)

		return (var0_6:TransformPoint(var2_6))
	else
		return var0_0.super.GetCenterPos(arg0_6)
	end
end

function var0_0.PlayChangeSkinActionIn(arg0_7, arg1_7)
	if arg1_7 and arg1_7.callback then
		arg1_7.callback({
			flag = true
		})
	end
end

function var0_0.PlayChangeSkinActionOut(arg0_8, arg1_8)
	if arg1_8 and arg1_8.callback then
		arg1_8.callback({
			flag = true
		})
	end
end

function var0_0.InitSpecialTouch(arg0_9)
	local var0_9 = findTF(findTF(arg0_9.container, "fitter"):GetChild(0), "Touch")

	if not var0_9 then
		return
	end

	setActive(var0_9, true)

	local var1_9 = {}

	eachChild(var0_9, function(arg0_10)
		onButton(arg0_9, arg0_10, function()
			local var0_11 = arg0_9:GetSpecialTouchEvent(arg0_10.name)

			arg0_9:TriggerEvent(var0_11)
			arg0_9:TriggerPersonalTask(arg0_9.ship.groupId)
		end)

		var1_9[arg0_10] = arg0_10.rect
	end)

	return var1_9
end

function var0_0.InitSpecialDrag(arg0_12, arg1_12)
	local var0_12 = findTF(findTF(arg0_12.container, "fitter"):GetChild(0), "Drag")

	if not var0_12 then
		return
	end

	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		setActive(var0_12, false)

		return
	end

	setActive(var0_12, true)

	local var1_12 = GetOrAddComponent(var0_12, typeof(EventTriggerListener))
	local var2_12 = Vector2(0, 0)

	arg0_12.isDrag = false

	var1_12:AddBeginDragFunc(function(arg0_13, arg1_13)
		arg0_12.isDrag = true
		var2_12 = arg1_13.position
	end)
	var1_12:AddDragEndFunc(function(arg0_14, arg1_14)
		arg0_12.isDrag = false

		local var0_14 = arg1_14.position - var2_12

		if math.abs(var0_14.x) > 50 or math.abs(var0_14.y) > 50 then
			arg0_12:SwitchToVariant(var0_12)
		end
	end)

	if arg1_12 and table.getCount(arg1_12) > 0 then
		var1_12:AddPointUpFunc(function(arg0_15, arg1_15)
			if arg0_12.isDrag then
				return
			end

			local var0_15

			for iter0_15, iter1_15 in pairs(arg1_12) do
				local var1_15 = LuaHelper.ScreenToLocal(iter0_15, arg1_15.position, arg0_12.uiCamera)

				if iter1_15:Contains(var1_15) then
					var0_15 = iter0_15

					break
				end
			end

			if var0_15 then
				triggerButton(var0_15)
			else
				triggerButton(arg0_12.container)
			end
		end)
	end

	local var3_12 = GetOrAddComponent(var0_12, "UILongPressTrigger").onLongPressed

	var3_12:RemoveAllListeners()
	var3_12:AddListener(function()
		arg0_12:OnLongPress()
	end)
end

function var0_0.SwitchToVariant(arg0_17, arg1_17)
	pg.UIMgr.GetInstance():LoadingOn(false)
	getProxy(SettingsProxy):SwitchMainPaintingVariantFlag(arg0_17.paintingName)
	seriesAsync({
		function(arg0_18)
			local var0_18 = arg0_17:GetPaintingName()

			PoolMgr.GetInstance():PreloadPainting(var0_18, arg0_18)
		end,
		function(arg0_19)
			arg0_17:PlayVariantEffect(arg1_17, arg0_19)
		end,
		function(arg0_20)
			onDelayTick(arg0_20, 0.5)
		end,
		function(arg0_21)
			arg0_17:UnloadOnlyPainting()
			arg0_17:Load(arg0_17.ship, true)
			onDelayTick(arg0_21, 1)
		end
	}, function()
		arg0_17:ClearEffect()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.PlayVariantEffect(arg0_23, arg1_23, arg2_23)
	local var0_23 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0_23.paintingName) == var0_0.PAINTING_VARIANT_EX
	local var1_23 = var0_23 and "lihui_qiehuan01" or "lihui_qiehuan02"

	pg.PoolMgr.GetInstance():GetPrefab("ui/" .. var1_23, "", true, function(arg0_24)
		pg.ViewUtils.SetLayer(arg0_24.transform, Layer.UI)

		arg0_23.effectGo = arg0_24
		arg0_23.effectGo.name = var1_23

		if arg0_23:IsExited() then
			arg0_23:ClearEffect()

			return
		end

		setParent(arg0_24, arg0_23.container)

		arg0_23.effectGo.transform.position = arg1_23.position

		if var0_23 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_EXPLOSIVE_SKIN)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_ANTI_EXPLOSIVE_SKIN)
		end

		arg2_23()
	end)
end

function var0_0.ClearEffect(arg0_25)
	if arg0_25.effectTimer then
		arg0_25.effectTimer:Stop()

		arg0_25.effectTimer = nil
	end

	if arg0_25.effectGo then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg0_25.effectGo.name, "", arg0_25.effectGo)

		arg0_25.effectGo = nil
	end
end

function var0_0.ClearSpecialDrag(arg0_26)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return
	end

	local var0_26 = findTF(findTF(arg0_26.container, "fitter"):GetChild(0), "Drag")

	if not var0_26 then
		return
	end

	local var1_26 = GetOrAddComponent(var0_26, typeof(EventTriggerListener))

	var1_26:AddBeginDragFunc(nil)
	var1_26:AddDragEndFunc(nil)
	var1_26:AddPointUpFunc(nil)
	GetOrAddComponent(var0_26, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
end

function var0_0.OnClick(arg0_27)
	local var0_27 = arg0_27:CollectTouchEvents()
	local var1_27 = var0_27[math.ceil(math.random(#var0_27))]

	arg0_27:TriggerEvent(var1_27)
end

function var0_0.OnLongPress(arg0_28)
	if arg0_28.isFoldState then
		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
		shipId = arg0_28.ship.id
	})
end

function var0_0.OnDisplayWorld(arg0_29, arg1_29)
	local var0_29 = arg0_29.ship:getCVIntimacy()
	local var1_29, var2_29 = ShipExpressionHelper.SetExpression(findTF(arg0_29.container, "fitter"):GetChild(0), arg0_29.paintingName, arg1_29, var0_29, arg0_29.ship.skinId)

	arg0_29.expression = var2_29
end

function var0_0.OnTriggerEvent(arg0_30)
	arg0_30:Shake(var0_0.TOUCH_HEIGHT, var0_0.TOUCH_DURATION, var0_0.TOUCH_LOOP)
end

function var0_0.OnTriggerEventAuto(arg0_31)
	arg0_31:Shake(var0_0.CHAT_HEIGHT, var0_0.CHAT_DURATION)
end

function var0_0.GetMeshPainting(arg0_32)
	local var0_32 = findTF(arg0_32.container, "fitter")

	if var0_32.childCount <= 0 then
		return nil
	end

	return (var0_32:GetChild(0))
end

function var0_0.Shake(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33
	local var1_33 = arg1_33

	if var0_33 then
		var1_33 = arg1_33 - var0_0.DEFAULT_HEIGHT + var0_33
	end

	arg3_33 = arg3_33 or math.random(3) - 1

	if arg3_33 == 0 then
		return
	end

	local var2_33 = arg0_33:GetMeshPainting()

	if not var2_33 then
		return
	end

	LeanTween.cancel(go(var2_33))
	LeanTween.moveY(rtf(var2_33), var1_33, 0.1):setLoopPingPong(arg3_33):setOnComplete(System.Action(function()
		arg0_33:Breath()
	end))
end

function var0_0.Breath(arg0_35)
	local var0_35 = arg0_35:GetMeshPainting()

	if not var0_35 then
		return
	end

	local var1_35
	local var2_35 = var1_35 or var0_0.BREATH_HEIGHT
	local var3_35 = var1_35 and var1_35 - 10 or var0_0.DEFAULT_HEIGHT

	LeanTween.cancel(go(var0_35))
	LeanTween.moveY(rtf(var0_35), var3_35, var0_0.BREATH_DURATION):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(var2_35)
end

function var0_0.StopBreath(arg0_36)
	local var0_36 = arg0_36:GetMeshPainting()

	if not var0_36 then
		return
	end

	LeanTween.cancel(go(var0_36))
end

function var0_0.OnEnableOrDisableDragAndZoom(arg0_37, arg1_37)
	if arg1_37 then
		arg0_37:StopBreath()
	else
		arg0_37:Breath()
	end
end

function var0_0.OnFold(arg0_38, arg1_38)
	if not arg1_38 then
		arg0_38:Breath()
	end
end

function var0_0.GetOffset(arg0_39)
	return MainPaintingView.MESH_POSITION_X_OFFSET
end

function var0_0.OnPuase(arg0_40)
	arg0_40:StopBreath()
end

function var0_0.OnResume(arg0_41)
	checkCullResume(arg0_41.container:Find("fitter"):GetChild(0))
	arg0_41:Breath()
end

function var0_0.Unload(arg0_42)
	var0_0.super.Unload(arg0_42)

	arg0_42.expression = nil
end

function var0_0.OnUnload(arg0_43)
	arg0_43:StopBreath()
	arg0_43:ClearSpecialDrag()

	if arg0_43.loadPaintingName then
		retPaintingPrefab(arg0_43.container, arg0_43.loadPaintingName)

		arg0_43.loadPaintingName = nil
	end
end

function var0_0.OnPuase(arg0_44)
	arg0_44:ClearEffect()
end

function var0_0.Dispose(arg0_45)
	var0_0.super.Dispose(arg0_45)
	arg0_45:ClearEffect()
end

return var0_0
