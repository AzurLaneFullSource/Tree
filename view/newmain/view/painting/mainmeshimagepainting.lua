local var0 = class("MainMeshImagePainting", import(".MainBasePainting"))

var0.DEFAULT_HEIGHT = 0
var0.TOUCH_HEIGHT = 20
var0.TOUCH_LOOP = 1
var0.TOUCH_DURATION = 0.1
var0.CHAT_HEIGHT = 15
var0.CHAT_DURATION = 0.3
var0.BREATH_HEIGHT = -10
var0.BREATH_DURATION = 2.3
var0.PAINTING_VARIANT_NORMAL = 0
var0.PAINTING_VARIANT_EX = 1

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
end

function var0.StaticGetPaintingName(arg0)
	local var0 = arg0

	if checkABExist("painting/" .. var0 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0, 0) ~= 0 then
		var0 = var0 .. "_n"
	end

	if HXSet.isHx() then
		return var0
	end

	local var1 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0) == var0.PAINTING_VARIANT_EX

	if var1 and not checkABExist("painting/" .. var0 .. "_ex") then
		return var0
	end

	return var1 and var0 .. "_ex" or var0
end

function var0.GetPaintingName(arg0)
	return var0.StaticGetPaintingName(arg0.paintingName)
end

function var0.OnLoad(arg0, arg1)
	local var0 = arg0:GetPaintingName()

	LoadPaintingPrefabAsync(arg0.container, arg0.paintingName, var0, "mainNormal", function()
		if arg0:IsExited() then
			arg0:UnLoad()

			return
		end

		arg0.loadPaintingName = var0

		local var0 = arg0:InitSpecialTouch()

		arg0:InitSpecialDrag(var0)

		if arg0.expression then
			ShipExpressionHelper.UpdateExpression(findTF(arg0.container, "fitter"):GetChild(0), arg0.paintingName, arg0.expression)
		end

		arg0:Breath()
		arg1()
	end)
end

function var0.GetCenterPos(arg0)
	if arg0:IsLoaded() then
		local var0 = arg0.container:Find("fitter"):GetChild(0)
		local var1 = (0.5 - var0.pivot.x) * var0.sizeDelta.x
		local var2 = var0.localPosition + Vector3(var1, 0, 0)

		return (var0:TransformPoint(var2))
	else
		return var0.super.GetCenterPos(arg0)
	end
end

function var0.InitSpecialTouch(arg0)
	local var0 = findTF(findTF(arg0.container, "fitter"):GetChild(0), "Touch")

	if not var0 then
		return
	end

	setActive(var0, true)

	local var1 = {}

	eachChild(var0, function(arg0)
		onButton(arg0, arg0, function()
			local var0 = arg0:GetSpecialTouchEvent(arg0.name)

			arg0:TriggerEvent(var0)
			arg0:TriggerPersonalTask(arg0.ship.groupId)
		end)

		var1[arg0] = arg0.rect
	end)

	return var1
end

function var0.InitSpecialDrag(arg0, arg1)
	local var0 = findTF(findTF(arg0.container, "fitter"):GetChild(0), "Drag")

	if not var0 then
		return
	end

	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		setActive(var0, false)

		return
	end

	setActive(var0, true)

	local var1 = GetOrAddComponent(var0, typeof(EventTriggerListener))
	local var2 = Vector2(0, 0)

	arg0.isDrag = false

	var1:AddBeginDragFunc(function(arg0, arg1)
		arg0.isDrag = true
		var2 = arg1.position
	end)
	var1:AddDragEndFunc(function(arg0, arg1)
		arg0.isDrag = false

		local var0 = arg1.position - var2

		if math.abs(var0.x) > 50 or math.abs(var0.y) > 50 then
			arg0:SwitchToVariant(var0)
		end
	end)

	if arg1 and table.getCount(arg1) > 0 then
		var1:AddPointUpFunc(function(arg0, arg1)
			if arg0.isDrag then
				return
			end

			local var0

			for iter0, iter1 in pairs(arg1) do
				local var1 = LuaHelper.ScreenToLocal(iter0, arg1.position, arg0.uiCamera)

				if iter1:Contains(var1) then
					var0 = iter0

					break
				end
			end

			if var0 then
				triggerButton(var0)
			else
				triggerButton(arg0.container)
			end
		end)
	end

	local var3 = GetOrAddComponent(var0, "UILongPressTrigger").onLongPressed

	var3:RemoveAllListeners()
	var3:AddListener(function()
		arg0:OnLongPress()
	end)
end

function var0.SwitchToVariant(arg0, arg1)
	pg.UIMgr.GetInstance():LoadingOn(false)
	getProxy(SettingsProxy):SwitchMainPaintingVariantFlag(arg0.paintingName)
	seriesAsync({
		function(arg0)
			local var0 = arg0:GetPaintingName()

			PoolMgr.GetInstance():PreloadPainting(var0, arg0)
		end,
		function(arg0)
			arg0:PlayVariantEffect(arg1, arg0)
		end,
		function(arg0)
			onDelayTick(arg0, 0.5)
		end,
		function(arg0)
			arg0:UnloadOnlyPainting()
			arg0:Load(arg0.ship, true)
			onDelayTick(arg0, 1)
		end
	}, function()
		arg0:ClearEffect()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0.PlayVariantEffect(arg0, arg1, arg2)
	local var0 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0.paintingName) == var0.PAINTING_VARIANT_EX
	local var1 = var0 and "lihui_qiehuan01" or "lihui_qiehuan02"

	pg.PoolMgr.GetInstance():GetPrefab("ui/" .. var1, "", true, function(arg0)
		pg.ViewUtils.SetLayer(arg0.transform, Layer.UI)

		arg0.effectGo = arg0
		arg0.effectGo.name = var1

		if arg0:IsExited() then
			arg0:ClearEffect()

			return
		end

		setParent(arg0, arg0.container)

		arg0.effectGo.transform.position = arg1.position

		if var0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_EXPLOSIVE_SKIN)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_ANTI_EXPLOSIVE_SKIN)
		end

		arg2()
	end)
end

function var0.ClearEffect(arg0)
	if arg0.effectTimer then
		arg0.effectTimer:Stop()

		arg0.effectTimer = nil
	end

	if arg0.effectGo then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg0.effectGo.name, "", arg0.effectGo)

		arg0.effectGo = nil
	end
end

function var0.ClearSpecialDrag(arg0)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return
	end

	local var0 = findTF(findTF(arg0.container, "fitter"):GetChild(0), "Drag")

	if not var0 then
		return
	end

	local var1 = GetOrAddComponent(var0, typeof(EventTriggerListener))

	var1:AddBeginDragFunc(nil)
	var1:AddDragEndFunc(nil)
	var1:AddPointUpFunc(nil)
	GetOrAddComponent(var0, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
end

function var0.OnClick(arg0)
	local var0 = arg0:CollectTouchEvents()
	local var1 = var0[math.ceil(math.random(#var0))]

	arg0:TriggerEvent(var1)
end

function var0.OnLongPress(arg0)
	if arg0.isFoldState then
		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
		shipId = arg0.ship.id
	})
end

function var0.OnDisplayWorld(arg0, arg1)
	local var0 = arg0.ship:getCVIntimacy()
	local var1, var2 = ShipExpressionHelper.SetExpression(findTF(arg0.container, "fitter"):GetChild(0), arg0.paintingName, arg1, var0, arg0.ship.skinId)

	arg0.expression = var2
end

function var0.OnTriggerEvent(arg0)
	arg0:Shake(var0.TOUCH_HEIGHT, var0.TOUCH_DURATION, var0.TOUCH_LOOP)
end

function var0.OnTriggerEventAuto(arg0)
	arg0:Shake(var0.CHAT_HEIGHT, var0.CHAT_DURATION)
end

function var0.GetMeshPainting(arg0)
	local var0 = findTF(arg0.container, "fitter")

	if var0.childCount <= 0 then
		return nil
	end

	return (var0:GetChild(0))
end

function var0.Shake(arg0, arg1, arg2, arg3)
	local var0
	local var1 = arg1

	if var0 then
		var1 = arg1 - var0.DEFAULT_HEIGHT + var0
	end

	arg3 = arg3 or math.random(3) - 1

	if arg3 == 0 then
		return
	end

	local var2 = arg0:GetMeshPainting()

	if not var2 then
		return
	end

	LeanTween.cancel(go(var2))
	LeanTween.moveY(rtf(var2), var1, 0.1):setLoopPingPong(arg3):setOnComplete(System.Action(function()
		arg0:Breath()
	end))
end

function var0.Breath(arg0)
	local var0 = arg0:GetMeshPainting()

	if not var0 then
		return
	end

	local var1
	local var2 = var1 or var0.BREATH_HEIGHT
	local var3 = var1 and var1 - 10 or var0.DEFAULT_HEIGHT

	LeanTween.cancel(go(var0))
	LeanTween.moveY(rtf(var0), var3, var0.BREATH_DURATION):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(var2)
end

function var0.StopBreath(arg0)
	local var0 = arg0:GetMeshPainting()

	if not var0 then
		return
	end

	LeanTween.cancel(go(var0))
end

function var0.OnEnableOrDisableDragAndZoom(arg0, arg1)
	if arg1 then
		arg0:StopBreath()
	else
		arg0:Breath()
	end
end

function var0.OnFold(arg0, arg1)
	if not arg1 then
		arg0:Breath()
	end
end

function var0.GetOffset(arg0)
	return MainPaintingView.MESH_POSITION_X_OFFSET
end

function var0.OnPuase(arg0)
	arg0:StopBreath()
end

function var0.OnResume(arg0)
	checkCullResume(arg0.container:Find("fitter"):GetChild(0))
	arg0:Breath()
end

function var0.Unload(arg0)
	var0.super.Unload(arg0)

	arg0.expression = nil
end

function var0.OnUnload(arg0)
	arg0:StopBreath()
	arg0:ClearSpecialDrag()

	if arg0.loadPaintingName then
		retPaintingPrefab(arg0.container, arg0.loadPaintingName)

		arg0.loadPaintingName = nil
	end
end

function var0.OnPuase(arg0)
	arg0:ClearEffect()
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:ClearEffect()
end

return var0
