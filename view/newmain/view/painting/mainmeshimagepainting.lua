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

function var0_0.InitSpecialTouch(arg0_7)
	local var0_7 = findTF(findTF(arg0_7.container, "fitter"):GetChild(0), "Touch")

	if not var0_7 then
		return
	end

	setActive(var0_7, true)

	local var1_7 = {}

	eachChild(var0_7, function(arg0_8)
		onButton(arg0_7, arg0_8, function()
			local var0_9 = arg0_7:GetSpecialTouchEvent(arg0_8.name)

			arg0_7:TriggerEvent(var0_9)
			arg0_7:TriggerPersonalTask(arg0_7.ship.groupId)
		end)

		var1_7[arg0_8] = arg0_8.rect
	end)

	return var1_7
end

function var0_0.InitSpecialDrag(arg0_10, arg1_10)
	local var0_10 = findTF(findTF(arg0_10.container, "fitter"):GetChild(0), "Drag")

	if not var0_10 then
		return
	end

	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		setActive(var0_10, false)

		return
	end

	setActive(var0_10, true)

	local var1_10 = GetOrAddComponent(var0_10, typeof(EventTriggerListener))
	local var2_10 = Vector2(0, 0)

	arg0_10.isDrag = false

	var1_10:AddBeginDragFunc(function(arg0_11, arg1_11)
		arg0_10.isDrag = true
		var2_10 = arg1_11.position
	end)
	var1_10:AddDragEndFunc(function(arg0_12, arg1_12)
		arg0_10.isDrag = false

		local var0_12 = arg1_12.position - var2_10

		if math.abs(var0_12.x) > 50 or math.abs(var0_12.y) > 50 then
			arg0_10:SwitchToVariant(var0_10)
		end
	end)

	if arg1_10 and table.getCount(arg1_10) > 0 then
		var1_10:AddPointUpFunc(function(arg0_13, arg1_13)
			if arg0_10.isDrag then
				return
			end

			local var0_13

			for iter0_13, iter1_13 in pairs(arg1_10) do
				local var1_13 = LuaHelper.ScreenToLocal(iter0_13, arg1_13.position, arg0_10.uiCamera)

				if iter1_13:Contains(var1_13) then
					var0_13 = iter0_13

					break
				end
			end

			if var0_13 then
				triggerButton(var0_13)
			else
				triggerButton(arg0_10.container)
			end
		end)
	end

	local var3_10 = GetOrAddComponent(var0_10, "UILongPressTrigger").onLongPressed

	var3_10:RemoveAllListeners()
	var3_10:AddListener(function()
		arg0_10:OnLongPress()
	end)
end

function var0_0.SwitchToVariant(arg0_15, arg1_15)
	pg.UIMgr.GetInstance():LoadingOn(false)
	getProxy(SettingsProxy):SwitchMainPaintingVariantFlag(arg0_15.paintingName)
	seriesAsync({
		function(arg0_16)
			local var0_16 = arg0_15:GetPaintingName()

			PoolMgr.GetInstance():PreloadPainting(var0_16, arg0_16)
		end,
		function(arg0_17)
			arg0_15:PlayVariantEffect(arg1_15, arg0_17)
		end,
		function(arg0_18)
			onDelayTick(arg0_18, 0.5)
		end,
		function(arg0_19)
			arg0_15:UnloadOnlyPainting()
			arg0_15:Load(arg0_15.ship, true)
			onDelayTick(arg0_19, 1)
		end
	}, function()
		arg0_15:ClearEffect()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.PlayVariantEffect(arg0_21, arg1_21, arg2_21)
	local var0_21 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0_21.paintingName) == var0_0.PAINTING_VARIANT_EX
	local var1_21 = var0_21 and "lihui_qiehuan01" or "lihui_qiehuan02"

	pg.PoolMgr.GetInstance():GetPrefab("ui/" .. var1_21, "", true, function(arg0_22)
		pg.ViewUtils.SetLayer(arg0_22.transform, Layer.UI)

		arg0_21.effectGo = arg0_22
		arg0_21.effectGo.name = var1_21

		if arg0_21:IsExited() then
			arg0_21:ClearEffect()

			return
		end

		setParent(arg0_22, arg0_21.container)

		arg0_21.effectGo.transform.position = arg1_21.position

		if var0_21 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_EXPLOSIVE_SKIN)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_ANTI_EXPLOSIVE_SKIN)
		end

		arg2_21()
	end)
end

function var0_0.ClearEffect(arg0_23)
	if arg0_23.effectTimer then
		arg0_23.effectTimer:Stop()

		arg0_23.effectTimer = nil
	end

	if arg0_23.effectGo then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg0_23.effectGo.name, "", arg0_23.effectGo)

		arg0_23.effectGo = nil
	end
end

function var0_0.ClearSpecialDrag(arg0_24)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return
	end

	local var0_24 = findTF(findTF(arg0_24.container, "fitter"):GetChild(0), "Drag")

	if not var0_24 then
		return
	end

	local var1_24 = GetOrAddComponent(var0_24, typeof(EventTriggerListener))

	var1_24:AddBeginDragFunc(nil)
	var1_24:AddDragEndFunc(nil)
	var1_24:AddPointUpFunc(nil)
	GetOrAddComponent(var0_24, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
end

function var0_0.OnClick(arg0_25)
	local var0_25 = arg0_25:CollectTouchEvents()
	local var1_25 = var0_25[math.ceil(math.random(#var0_25))]

	arg0_25:TriggerEvent(var1_25)
end

function var0_0.OnLongPress(arg0_26)
	if arg0_26.isFoldState then
		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
		shipId = arg0_26.ship.id
	})
end

function var0_0.OnDisplayWorld(arg0_27, arg1_27)
	local var0_27 = arg0_27.ship:getCVIntimacy()
	local var1_27, var2_27 = ShipExpressionHelper.SetExpression(findTF(arg0_27.container, "fitter"):GetChild(0), arg0_27.paintingName, arg1_27, var0_27, arg0_27.ship.skinId)

	arg0_27.expression = var2_27
end

function var0_0.OnTriggerEvent(arg0_28)
	arg0_28:Shake(var0_0.TOUCH_HEIGHT, var0_0.TOUCH_DURATION, var0_0.TOUCH_LOOP)
end

function var0_0.OnTriggerEventAuto(arg0_29)
	arg0_29:Shake(var0_0.CHAT_HEIGHT, var0_0.CHAT_DURATION)
end

function var0_0.GetMeshPainting(arg0_30)
	local var0_30 = findTF(arg0_30.container, "fitter")

	if var0_30.childCount <= 0 then
		return nil
	end

	return (var0_30:GetChild(0))
end

function var0_0.Shake(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31
	local var1_31 = arg1_31

	if var0_31 then
		var1_31 = arg1_31 - var0_0.DEFAULT_HEIGHT + var0_31
	end

	arg3_31 = arg3_31 or math.random(3) - 1

	if arg3_31 == 0 then
		return
	end

	local var2_31 = arg0_31:GetMeshPainting()

	if not var2_31 then
		return
	end

	LeanTween.cancel(go(var2_31))
	LeanTween.moveY(rtf(var2_31), var1_31, 0.1):setLoopPingPong(arg3_31):setOnComplete(System.Action(function()
		arg0_31:Breath()
	end))
end

function var0_0.Breath(arg0_33)
	local var0_33 = arg0_33:GetMeshPainting()

	if not var0_33 then
		return
	end

	local var1_33
	local var2_33 = var1_33 or var0_0.BREATH_HEIGHT
	local var3_33 = var1_33 and var1_33 - 10 or var0_0.DEFAULT_HEIGHT

	LeanTween.cancel(go(var0_33))
	LeanTween.moveY(rtf(var0_33), var3_33, var0_0.BREATH_DURATION):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(var2_33)
end

function var0_0.StopBreath(arg0_34)
	local var0_34 = arg0_34:GetMeshPainting()

	if not var0_34 then
		return
	end

	LeanTween.cancel(go(var0_34))
end

function var0_0.OnEnableOrDisableDragAndZoom(arg0_35, arg1_35)
	if arg1_35 then
		arg0_35:StopBreath()
	else
		arg0_35:Breath()
	end
end

function var0_0.OnFold(arg0_36, arg1_36)
	if not arg1_36 then
		arg0_36:Breath()
	end
end

function var0_0.GetOffset(arg0_37)
	return MainPaintingView.MESH_POSITION_X_OFFSET
end

function var0_0.OnPuase(arg0_38)
	arg0_38:StopBreath()
end

function var0_0.OnResume(arg0_39)
	checkCullResume(arg0_39.container:Find("fitter"):GetChild(0))
	arg0_39:Breath()
end

function var0_0.Unload(arg0_40)
	var0_0.super.Unload(arg0_40)

	arg0_40.expression = nil
end

function var0_0.OnUnload(arg0_41)
	arg0_41:StopBreath()
	arg0_41:ClearSpecialDrag()

	if arg0_41.loadPaintingName then
		retPaintingPrefab(arg0_41.container, arg0_41.loadPaintingName)

		arg0_41.loadPaintingName = nil
	end
end

function var0_0.OnPuase(arg0_42)
	arg0_42:ClearEffect()
end

function var0_0.Dispose(arg0_43)
	var0_0.super.Dispose(arg0_43)
	arg0_43:ClearEffect()
end

return var0_0
