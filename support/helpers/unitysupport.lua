function tf(arg0)
	return arg0.transform
end

function go(arg0)
	return tf(arg0).gameObject
end

function rtf(arg0)
	return arg0.transform
end

function findGO(arg0, arg1)
	assert(arg0, "object or transform should exist")

	local var0 = tf(arg0):Find(arg1)

	return var0 and var0.gameObject
end

function findTF(arg0, arg1)
	assert(arg0, "object or transform should exist " .. arg1)

	return (tf(arg0):Find(arg1))
end

function Instantiate(arg0)
	return Object.Instantiate(go(arg0))
end

instantiate = Instantiate

function Destroy(arg0)
	Object.Destroy(go(arg0))
end

destroy = Destroy

function SetActive(arg0, arg1)
	LuaHelper.SetActiveForLua(arg0, tobool(arg1))
end

setActive = SetActive

function isActive(arg0)
	return go(arg0).activeSelf
end

function SetName(arg0, arg1)
	arg0.name = arg1
end

setName = SetName

function SetParent(arg0, arg1, arg2)
	LuaHelper.SetParentForLua(arg0, arg1, tobool(arg2))
end

setParent = SetParent

function setText(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:GetComponent(typeof(Text)).text = tostring(arg1)
end

function setTextEN(arg0, arg1)
	if not arg1 then
		return
	end

	arg1 = splitByWordEN(arg1, arg0)
	arg0:GetComponent(typeof(Text)).text = tostring(arg1)
end

function setBestFitTextEN(arg0, arg1, arg2)
	if not arg1 then
		return
	end

	local var0 = arg0:GetComponent(typeof(RectTransform))
	local var1 = arg0:GetComponent(typeof(Text))
	local var2 = arg2 or 20
	local var3 = var0.rect.width
	local var4 = var0.rect.height

	while var2 > 0 do
		var1.fontSize = var2

		local var5 = splitByWordEN(arg1, arg0)

		var1.text = tostring(var5)

		if var3 >= var1.preferredWidth and var4 >= var1.preferredHeight then
			break
		end

		var2 = var2 - 1
	end
end

function setTextFont(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:GetComponent(typeof(Text)).font = arg1
end

function getText(arg0)
	return arg0:GetComponent(typeof(Text)).text
end

function setInputText(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:GetComponent(typeof(InputField)).text = arg1
end

function getInputText(arg0)
	return arg0:GetComponent(typeof(InputField)).text
end

function onInputEndEdit(arg0, arg1, arg2)
	local var0 = arg1:GetComponent(typeof(InputField)).onEndEdit

	pg.DelegateInfo.Add(arg0, var0)
	var0:RemoveAllListeners()
	var0:AddListener(arg2)
end

function activateInputField(arg0)
	arg0:GetComponent(typeof(InputField)):ActivateInputField()
end

function setButtonText(arg0, arg1, arg2)
	setWidgetText(arg0, arg1, arg2)
end

function setWidgetText(arg0, arg1, arg2)
	arg2 = arg2 or "Text"
	arg2 = findTF(arg0, arg2)

	setText(arg2, arg1)
end

function setWidgetTextEN(arg0, arg1, arg2)
	arg2 = arg2 or "Text"
	arg2 = findTF(arg0, arg2)

	setTextEN(arg2, arg1)
end

local var0
local var1 = true
local var2 = -1

function onButton(arg0, arg1, arg2, arg3, arg4)
	local var0 = GetOrAddComponent(arg1, typeof(Button))

	assert(var0, "could not found Button component on " .. arg1.name)
	assert(arg2, "callback should exist")

	local var1 = var0.onClick

	pg.DelegateInfo.Add(arg0, var1)
	var1:RemoveAllListeners()
	var1:AddListener(function()
		if var2 == Time.frameCount and Input.touchCount > 1 then
			return
		end

		var2 = Time.frameCount

		if arg3 and var1 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3)
		end

		arg2()
	end)
end

function removeOnButton(arg0)
	local var0 = arg0:GetComponent(typeof(Button))

	if var0 ~= nil then
		var0.onClick:RemoveAllListeners()
	end
end

function removeAllOnButton(arg0)
	local var0 = arg0:GetComponentsInChildren(typeof(Button))

	for iter0 = 1, var0.Length do
		local var1 = var0[iter0 - 1]

		if var1 ~= nil then
			var1.onClick:RemoveAllListeners()
		end
	end
end

function ClearAllText(arg0)
	local var0 = arg0:GetComponentsInChildren(typeof(Text))

	for iter0 = 1, var0.Length do
		local var1 = var0[iter0 - 1]

		if var1 ~= nil then
			var1.text = ""
		end
	end
end

function onLongPressTrigger(arg0, arg1, arg2, arg3)
	local var0 = GetOrAddComponent(arg1, typeof(UILongPressTrigger))

	assert(var0, "could not found UILongPressTrigger component on " .. arg1.name)
	assert(arg2, "callback should exist")

	local var1 = var0.onLongPressed

	pg.DelegateInfo.Add(arg0, var1)
	var1:RemoveAllListeners()
	var1:AddListener(function()
		if arg3 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3)
		end

		arg2()
	end)
end

function removeOnLongPressTrigger(arg0)
	local var0 = arg0:GetComponent(typeof(UILongPressTrigger))

	if var0 ~= nil then
		var0.onLongPressed:RemoveAllListeners()
	end
end

function setButtonEnabled(arg0, arg1)
	GetComponent(arg0, typeof(Button)).interactable = arg1
end

function setToggleEnabled(arg0, arg1)
	GetComponent(arg0, typeof(Toggle)).interactable = arg1
end

function setSliderEnable(arg0, arg1)
	GetComponent(arg0, typeof(Slider)).interactable = arg1
end

function triggerButton(arg0)
	local var0 = GetComponent(arg0, typeof(Button))

	var1 = false
	var2 = -1

	var0.onClick:Invoke()

	var1 = true
end

local var3 = true

function onToggle(arg0, arg1, arg2, arg3, arg4)
	local var0 = GetComponent(arg1, typeof(Toggle))

	assert(arg2, "callback should exist")

	local var1 = var0.onValueChanged

	var1:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0, var1)
	var1:AddListener(function(arg0)
		if var3 then
			if arg0 and arg3 and var0.isOn == arg0 then
				arg3 = SFX_UI_TAG

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3)
			elseif not arg0 and arg4 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg4)
			end
		end

		arg2(arg0)
	end)

	local var2 = GetComponent(arg1, typeof(UIToggleEvent))

	if not IsNil(var2) then
		var2:Rebind()
	end
end

function removeOnToggle(arg0)
	local var0 = GetComponent(arg0, typeof(Toggle))

	if var0 ~= nil then
		var0.onValueChanged:RemoveAllListeners()
	end
end

function triggerToggle(arg0, arg1)
	local var0 = GetComponent(arg0, typeof(Toggle))

	var3 = false
	arg1 = tobool(arg1)

	if var0.isOn ~= arg1 then
		var0.isOn = arg1
	else
		var0.onValueChanged:Invoke(arg1)
	end

	var3 = true
end

function triggerToggleWithoutNotify(arg0, arg1)
	local var0 = GetComponent(arg0, typeof(Toggle))

	var3 = false
	arg1 = tobool(arg1)

	LuaHelper.ChangeToggleValueWithoutNotify(var0, arg1)

	var3 = true
end

function onSlider(arg0, arg1, arg2)
	local var0 = GetComponent(arg1, typeof(Slider)).onValueChanged

	assert(arg2, "callback should exist")
	var0:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0, var0)
	var0:AddListener(arg2)
end

function setSlider(arg0, arg1, arg2, arg3)
	local var0 = GetComponent(arg0, typeof(Slider))

	assert(var0, "slider should exist")

	var0.minValue = arg1
	var0.maxValue = arg2
	var0.value = arg3
end

function eachChild(arg0, arg1)
	local var0 = tf(arg0)

	for iter0 = var0.childCount - 1, 0, -1 do
		arg1(var0:GetChild(iter0))
	end
end

function removeAllChildren(arg0)
	eachChild(arg0, function(arg0)
		tf(arg0).transform:SetParent(nil, false)
		Destroy(arg0)
	end)
end

function scrollTo(arg0, arg1, arg2)
	Canvas.ForceUpdateCanvases()

	local var0 = GetComponent(arg0, typeof(ScrollRect))
	local var1 = Vector2(arg1 or var0.normalizedPosition.x, arg2 or var0.normalizedPosition.y)

	onNextTick(function()
		if not IsNil(arg0) then
			var0.normalizedPosition = var1

			var0.onValueChanged:Invoke(var1)
		end
	end)
end

function scrollToBottom(arg0)
	scrollTo(arg0, 0, 0)
end

function onScroll(arg0, arg1, arg2)
	local var0 = GetComponent(arg1, typeof(ScrollRect)).onValueChanged

	assert(arg2, "callback should exist")
	var0:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0, var0)
	var0:AddListener(arg2)
end

function ClearEventTrigger(arg0)
	arg0:RemovePointClickFunc()
	arg0:RemovePointDownFunc()
	arg0:RemovePointEnterFunc()
	arg0:RemovePointExitFunc()
	arg0:RemovePointUpFunc()
	arg0:RemoveCheckDragFunc()
	arg0:RemoveBeginDragFunc()
	arg0:RemoveDragFunc()
	arg0:RemoveDragEndFunc()
	arg0:RemoveDropFunc()
	arg0:RemoveScrollFunc()
	arg0:RemoveSelectFunc()
	arg0:RemoveUpdateSelectFunc()
	arg0:RemoveMoveFunc()
end

function ClearLScrollrect(arg0)
	arg0.onStart = nil
	arg0.onInitItem = nil
	arg0.onUpdateItem = nil
	arg0.onReturnItem = nil
end

function GetComponent(arg0, arg1)
	return (arg0:GetComponent(arg1))
end

function GetOrAddComponent(arg0, arg1)
	assert(arg0, "objectOrTransform not found: " .. debug.traceback())

	local var0 = arg1

	if type(arg1) == "string" then
		assert(_G[arg1], arg1 .. " not exist in Global")

		var0 = typeof(_G[arg1])
	end

	return LuaHelper.GetOrAddComponentForLua(arg0, var0)
end

function RemoveComponent(arg0, arg1)
	local var0 = arg0:GetComponent(arg1)

	if var0 then
		Object.Destroy(var0)
	end
end

function SetCompomentEnabled(arg0, arg1, arg2)
	local var0 = arg0:GetComponent(arg1)

	assert(var0, "compoment not found")

	var0.enabled = tobool(arg2)
end

function GetInChildren(arg0, arg1)
	local function var0(arg0, arg1)
		if not arg0 then
			return nil
		end

		if arg0.name == arg1 then
			return arg0
		end

		for iter0 = 0, arg0.childCount - 1 do
			local var0 = arg0:GetChild(iter0)

			if arg1 == var0.name then
				return var0
			end

			local var1 = var0(var0, arg1)

			if var1 then
				return var1
			end
		end

		return nil
	end

	return var0(arg0, arg1)
end

function onNextTick(arg0)
	FrameTimer.New(arg0, 1, 1):Start()
end

function onDelayTick(arg0, arg1)
	Timer.New(arg0, arg1, 1):Start()
end

function seriesAsync(arg0, arg1, ...)
	local var0 = 0
	local var1 = #arg0
	local var2

	local function var3(...)
		var0 = var0 + 1

		if var0 <= var1 then
			arg0[var0](var3, ...)
		elseif var0 == var1 + 1 and arg1 then
			arg1(...)
		end
	end

	var3(...)
end

function seriesAsyncExtend(arg0, arg1, ...)
	local var0

	local function var1(...)
		if #arg0 > 0 then
			table.remove(arg0, 1)(var1, ...)
		elseif arg1 then
			arg1(...)
		end
	end

	var1(...)
end

function parallelAsync(arg0, arg1)
	local var0 = #arg0

	local function var1()
		var0 = var0 - 1

		if var0 == 0 and arg1 then
			arg1()
		end
	end

	if var0 > 0 then
		for iter0, iter1 in ipairs(arg0) do
			iter1(var1)
		end
	elseif arg1 then
		arg1()
	end
end

function limitedParallelAsync(arg0, arg1, arg2)
	local var0 = #arg0
	local var1 = var0

	if var1 == 0 then
		arg2()

		return
	end

	local var2 = math.min(arg1, var0)
	local var3

	local function var4()
		var1 = var1 - 1

		if var1 == 0 then
			arg2()
		elseif var2 + 1 <= var0 then
			var2 = var2 + 1

			arg0[var2](var4)
		end
	end

	for iter0 = 1, var2 do
		arg0[iter0](var4)
	end
end

function waitUntil(arg0, arg1)
	local var0

	var0 = FrameTimer.New(function()
		if arg0() then
			arg1()
			var0:Stop()

			return
		end
	end, 1, -1)

	var0:Start()

	return var0
end

function setImageSprite(arg0, arg1, arg2)
	if IsNil(arg0) then
		assert(false)

		return
	end

	local var0 = GetComponent(arg0, typeof(Image))

	if IsNil(var0) then
		return
	end

	var0.sprite = arg1

	if arg2 then
		var0:SetNativeSize()
	end
end

function clearImageSprite(arg0)
	GetComponent(arg0, typeof(Image)).sprite = nil
end

function getImageSprite(arg0)
	local var0 = GetComponent(arg0, typeof(Image))

	return var0 and var0.sprite
end

function tex2sprite(arg0)
	return UnityEngine.Sprite.Create(arg0, UnityEngine.Rect.New(0, 0, arg0.width, arg0.height), Vector2(0.5, 0.5), 100)
end

function setFillAmount(arg0, arg1)
	GetComponent(arg0, typeof(Image)).fillAmount = arg1
end

function string2vector3(arg0)
	local var0 = string.split(arg0, ",")

	return Vector3(var0[1], var0[2], var0[3])
end

function getToggleState(arg0)
	return arg0:GetComponent(typeof(Toggle)).isOn
end

function setLocalPosition(arg0, arg1)
	local var0 = tf(arg0).localPosition

	arg1.x = arg1.x or var0.x
	arg1.y = arg1.y or var0.y
	arg1.z = arg1.z or var0.z
	tf(arg0).localPosition = arg1
end

function setAnchoredPosition(arg0, arg1)
	local var0 = rtf(arg0)
	local var1 = var0.anchoredPosition

	arg1.x = arg1.x or var1.x
	arg1.y = arg1.y or var1.y
	var0.anchoredPosition = arg1
end

function setAnchoredPosition3D(arg0, arg1)
	local var0 = rtf(arg0)
	local var1 = var0.anchoredPosition3D

	arg1.x = arg1.x or var1.x
	arg1.y = arg1.y or var1.y
	arg1.z = arg1.y or var1.z
	var0.anchoredPosition3D = arg1
end

function getAnchoredPosition(arg0)
	return rtf(arg0).anchoredPosition
end

function setLocalScale(arg0, arg1)
	local var0 = tf(arg0).localScale

	arg1.x = arg1.x or var0.x
	arg1.y = arg1.y or var0.y
	arg1.z = arg1.z or var0.z
	tf(arg0).localScale = arg1
end

function setLocalRotation(arg0, arg1)
	local var0 = tf(arg0).localRotation

	arg1.x = arg1.x or var0.x
	arg1.y = arg1.y or var0.y
	arg1.z = arg1.z or var0.z
	tf(arg0).localRotation = arg1
end

function setLocalEulerAngles(arg0, arg1)
	local var0 = tf(arg0).localEulerAngles

	arg1.x = arg1.x or var0.x
	arg1.y = arg1.y or var0.y
	arg1.z = arg1.z or var0.z
	tf(arg0).localEulerAngles = arg1
end

function ActivateInputField(arg0)
	GetComponent(arg0, typeof(InputField)):ActivateInputField()
end

function onInputChanged(arg0, arg1, arg2)
	local var0 = GetComponent(arg1, typeof(InputField)).onValueChanged

	var0:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0, var0)
	var0:AddListener(arg2)
end

function getImageColor(arg0)
	return GetComponent(arg0, typeof(Image)).color
end

function setImageColor(arg0, arg1)
	GetComponent(arg0, typeof(Image)).color = arg1
end

function getImageAlpha(arg0)
	return GetComponent(arg0, typeof(Image)).color.a
end

function setImageAlpha(arg0, arg1)
	local var0 = GetComponent(arg0, typeof(Image))
	local var1 = var0.color

	var1.a = arg1
	var0.color = var1
end

function getImageRaycastTarget(arg0)
	return GetComponent(arg0, typeof(Image)).raycastTarget
end

function setImageRaycastTarget(arg0, arg1)
	GetComponent(arg0, typeof(Image)).raycastTarget = tobool(arg1)
end

function getCanvasGroupAlpha(arg0)
	return GetComponent(arg0, typeof(CanvasGroup)).alpha
end

function setCanvasGroupAlpha(arg0, arg1)
	GetComponent(arg0, typeof(CanvasGroup)).alpha = arg1
end

function setActiveViaLayer(arg0, arg1)
	UIUtil.SetUIActiveViaLayer(go(arg0), arg1)
end

function setActiveViaCG(arg0, arg1)
	UIUtil.SetUIActiveViaCG(go(arg0), arg1)
end

function getTextColor(arg0)
	return GetComponent(arg0, typeof(Text)).color
end

function setTextColor(arg0, arg1)
	GetComponent(arg0, typeof(Text)).color = arg1
end

function getTextAlpha(arg0)
	return GetComponent(arg0, typeof(Text)).color.a
end

function setTextAlpha(arg0, arg1)
	local var0 = GetComponent(arg0, typeof(Text))
	local var1 = var0.color

	var1.a = arg1
	var0.color = var1
end

function setSizeDelta(arg0, arg1)
	local var0 = GetComponent(arg0, typeof(RectTransform))

	if not var0 then
		return
	end

	local var1 = var0.sizeDelta

	var1.x = arg1.x
	var1.y = arg1.y
	var0.sizeDelta = var1
end

function getOutlineColor(arg0)
	return GetComponent(arg0, typeof(Outline)).effectColor
end

function setOutlineColor(arg0, arg1)
	GetComponent(arg0, typeof(Outline)).effectColor = arg1
end

function pressPersistTrigger(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	arg6 = defaultValue(arg6, 0.25)

	assert(arg6 > 0, "maxSpeed less than zero")
	assert(arg0, "should exist objectOrTransform")

	local var0 = GetOrAddComponent(arg0, typeof(EventTriggerListener))

	assert(arg2, "should exist callback")

	local var1

	local function var2()
		if var1 then
			var1:Stop()

			var1 = nil

			existCall(arg3)
		end
	end

	var0:AddPointDownFunc(function()
		var1 = Timer.New(function()
			if arg5 then
				local var0 = math.max(var1.duration - arg1 / 10, arg6)

				var1.duration = var0
			end

			existCall(arg2, var2)
		end, arg1, -1)

		var1:Start()

		if arg4 then
			var1.func()
		end

		if arg7 and var1 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg7)
		end
	end)
	var0:AddPointUpFunc(var2)

	return var0
end

function getSpritePivot(arg0)
	local var0 = arg0.bounds
	local var1 = -var0.center.x / var0.extents.x / 2 + 0.5
	local var2 = -var0.center.y / var0.extents.y / 2 + 0.5

	return Vector2(var1, var2)
end

function resetAspectRatio(arg0)
	local var0 = GetComponent(arg0, "Image")

	GetComponent(arg0, "AspectRatioFitter").aspectRatio = var0.preferredWidth / var0.preferredHeight
end

function cloneTplTo(arg0, arg1, arg2)
	local var0 = tf(Instantiate(arg0))

	var0:SetParent(tf(arg1), false)
	SetActive(var0, true)

	if arg2 then
		var0.name = arg2
	end

	return var0
end

function setGray(arg0, arg1, arg2)
	if arg1 then
		local var0 = GetOrAddComponent(arg0, "UIGrayScale")

		var0.Recursive = defaultValue(arg2, true)
		var0.enabled = true
	else
		RemoveComponent(arg0, "UIGrayScale")
	end
end

function setBlackMask(arg0, arg1, arg2)
	if arg1 then
		arg2 = arg2 or {}

		local var0 = GetOrAddComponent(arg0, "UIMaterialAdjuster")

		var0.Recursive = tobool(defaultValue(arg2.recursive, true))

		local var1 = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit Colored_Alpha_UI"))

		var1:SetColor("_Color", arg2.color or Color(0, 0, 0, 0.2))

		var0.adjusterMaterial = var1
		var0.enabled = true
	else
		RemoveComponent(arg0, "UIMaterialAdjuster")
	end
end

function blockBlackMask(arg0, arg1, arg2)
	if arg1 then
		local var0 = GetOrAddComponent(arg0, "UIMaterialAdjuster")

		var0.Recursive = tobool(defaultValue(arg2, true))
		var0.enabled = false
	else
		RemoveComponent(arg0, "UIMaterialAdjuster")
	end
end

function long2int(arg0)
	local var0, var1 = int64.tonum2(arg0)

	return var0
end

function OnSliderWithButton(arg0, arg1, arg2)
	local var0 = arg1:GetComponent("Slider")

	var0.onValueChanged:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0, var0.onValueChanged)
	var0.onValueChanged:AddListener(arg2)

	local var1 = (var0.maxValue - var0.minValue) * 0.1

	onButton(arg0, arg1:Find("up"), function()
		var0.value = math.clamp(var0.value + var1, var0.minValue, var0.maxValue)
	end, SFX_PANEL)
	onButton(arg0, arg1:Find("down"), function()
		var0.value = math.clamp(var0.value - var1, var0.minValue, var0.maxValue)
	end, SFX_PANEL)
end

function addSlip(arg0, arg1, arg2, arg3, arg4)
	local var0 = GetOrAddComponent(arg1, "EventTriggerListener")
	local var1
	local var2 = 0
	local var3 = 50

	var0:AddPointDownFunc(function()
		var2 = 0
		var1 = nil
	end)
	var0:AddDragFunc(function(arg0, arg1)
		local var0 = arg1.position

		if not var1 then
			var1 = var0
		end

		if arg0 == SLIP_TYPE_HRZ then
			var2 = var0.x - var1.x
		elseif arg0 == SLIP_TYPE_VERT then
			var2 = var0.y - var1.y
		end
	end)
	var0:AddPointUpFunc(function(arg0, arg1)
		if var2 < -var3 then
			if arg3 then
				arg3()
			end
		elseif var2 > var3 then
			if arg2 then
				arg2()
			end
		elseif arg4 then
			arg4()
		end
	end)
end

function getSizeRate()
	local var0 = pg.UIMgr.GetInstance().LevelMain.transform.rect
	local var1 = UnityEngine.Screen

	return Vector2.New(var0.width / var1.width, var0.height / var1.height), var0.width, var0.height
end

function IsUsingWifi()
	return Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaLocalAreaNetwork
end
