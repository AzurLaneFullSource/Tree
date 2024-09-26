function tf(arg0_1)
	return arg0_1.transform
end

function go(arg0_2)
	return tf(arg0_2).gameObject
end

function rtf(arg0_3)
	return arg0_3.transform
end

function findGO(arg0_4, arg1_4)
	assert(arg0_4, "object or transform should exist")

	local var0_4 = tf(arg0_4):Find(arg1_4)

	return var0_4 and var0_4.gameObject
end

function findTF(arg0_5, arg1_5)
	assert(arg0_5, "object or transform should exist " .. arg1_5)

	return (tf(arg0_5):Find(arg1_5))
end

function Instantiate(arg0_6)
	return Object.Instantiate(go(arg0_6))
end

instantiate = Instantiate

function Destroy(arg0_7)
	Object.Destroy(go(arg0_7))
end

destroy = Destroy

function SetActive(arg0_8, arg1_8)
	LuaHelper.SetActiveForLua(arg0_8, tobool(arg1_8))
end

setActive = SetActive

function isActive(arg0_9)
	return go(arg0_9).activeSelf
end

function SetName(arg0_10, arg1_10)
	arg0_10.name = arg1_10
end

setName = SetName

function SetParent(arg0_11, arg1_11, arg2_11)
	LuaHelper.SetParentForLua(arg0_11, arg1_11, tobool(arg2_11))
end

setParent = SetParent

function setText(arg0_12, arg1_12)
	if not arg1_12 then
		return
	end

	arg0_12:GetComponent(typeof(Text)).text = tostring(arg1_12)
end

function setScrollText(arg0_13, arg1_13)
	if not arg1_13 then
		return
	end

	arg0_13:GetComponent("ScrollText"):SetText(tostring(arg1_13))
end

function setTextEN(arg0_14, arg1_14)
	if not arg1_14 then
		return
	end

	arg1_14 = splitByWordEN(arg1_14, arg0_14)
	arg0_14:GetComponent(typeof(Text)).text = tostring(arg1_14)
end

function setBestFitTextEN(arg0_15, arg1_15, arg2_15)
	if not arg1_15 then
		return
	end

	local var0_15 = arg0_15:GetComponent(typeof(RectTransform))
	local var1_15 = arg0_15:GetComponent(typeof(Text))
	local var2_15 = arg2_15 or 20
	local var3_15 = var0_15.rect.width
	local var4_15 = var0_15.rect.height

	while var2_15 > 0 do
		var1_15.fontSize = var2_15

		local var5_15 = splitByWordEN(arg1_15, arg0_15)

		var1_15.text = tostring(var5_15)

		if var3_15 >= var1_15.preferredWidth and var4_15 >= var1_15.preferredHeight then
			break
		end

		var2_15 = var2_15 - 1
	end
end

function setTextFont(arg0_16, arg1_16)
	if not arg1_16 then
		return
	end

	arg0_16:GetComponent(typeof(Text)).font = arg1_16
end

function getText(arg0_17)
	return arg0_17:GetComponent(typeof(Text)).text
end

function setInputText(arg0_18, arg1_18)
	if not arg1_18 then
		return
	end

	arg0_18:GetComponent(typeof(InputField)).text = arg1_18
end

function getInputText(arg0_19)
	return arg0_19:GetComponent(typeof(InputField)).text
end

function onInputEndEdit(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20:GetComponent(typeof(InputField)).onEndEdit

	pg.DelegateInfo.Add(arg0_20, var0_20)
	var0_20:RemoveAllListeners()
	var0_20:AddListener(arg2_20)
end

function activateInputField(arg0_21)
	arg0_21:GetComponent(typeof(InputField)):ActivateInputField()
end

function setButtonText(arg0_22, arg1_22, arg2_22)
	setWidgetText(arg0_22, arg1_22, arg2_22)
end

function setWidgetText(arg0_23, arg1_23, arg2_23)
	arg2_23 = arg2_23 or "Text"
	arg2_23 = findTF(arg0_23, arg2_23)

	setText(arg2_23, arg1_23)
end

function setWidgetTextEN(arg0_24, arg1_24, arg2_24)
	arg2_24 = arg2_24 or "Text"
	arg2_24 = findTF(arg0_24, arg2_24)

	setTextEN(arg2_24, arg1_24)
end

local var0_0
local var1_0 = true
local var2_0 = -1

function onButton(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	local var0_25 = GetOrAddComponent(arg1_25, typeof(Button))

	assert(var0_25, "could not found Button component on " .. arg1_25.name)
	assert(arg2_25, "callback should exist")

	local var1_25 = var0_25.onClick

	pg.DelegateInfo.Add(arg0_25, var1_25)
	var1_25:RemoveAllListeners()
	var1_25:AddListener(function()
		if var2_0 == Time.frameCount and Input.touchCount > 1 then
			return
		end

		var2_0 = Time.frameCount

		if arg3_25 and var1_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_25)
		end

		arg2_25()
	end)
end

function removeOnButton(arg0_27)
	local var0_27 = arg0_27:GetComponent(typeof(Button))

	if var0_27 ~= nil then
		var0_27.onClick:RemoveAllListeners()
	end
end

function removeAllOnButton(arg0_28)
	local var0_28 = arg0_28:GetComponentsInChildren(typeof(Button))

	for iter0_28 = 1, var0_28.Length do
		local var1_28 = var0_28[iter0_28 - 1]

		if var1_28 ~= nil then
			var1_28.onClick:RemoveAllListeners()
		end
	end
end

function ClearAllText(arg0_29)
	local var0_29 = arg0_29:GetComponentsInChildren(typeof(Text))

	for iter0_29 = 1, var0_29.Length do
		local var1_29 = var0_29[iter0_29 - 1]

		if var1_29 ~= nil then
			var1_29.text = ""
		end
	end
end

function onLongPressTrigger(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = GetOrAddComponent(arg1_30, typeof(UILongPressTrigger))

	assert(var0_30, "could not found UILongPressTrigger component on " .. arg1_30.name)
	assert(arg2_30, "callback should exist")

	local var1_30 = var0_30.onLongPressed

	pg.DelegateInfo.Add(arg0_30, var1_30)
	var1_30:RemoveAllListeners()
	var1_30:AddListener(function()
		if arg3_30 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_30)
		end

		arg2_30()
	end)
end

function removeOnLongPressTrigger(arg0_32)
	local var0_32 = arg0_32:GetComponent(typeof(UILongPressTrigger))

	if var0_32 ~= nil then
		var0_32.onLongPressed:RemoveAllListeners()
	end
end

function setButtonEnabled(arg0_33, arg1_33)
	GetComponent(arg0_33, typeof(Button)).interactable = arg1_33
end

function setToggleEnabled(arg0_34, arg1_34)
	GetComponent(arg0_34, typeof(Toggle)).interactable = arg1_34
end

function setSliderEnable(arg0_35, arg1_35)
	GetComponent(arg0_35, typeof(Slider)).interactable = arg1_35
end

function triggerButton(arg0_36)
	local var0_36 = GetComponent(arg0_36, typeof(Button))

	var1_0 = false
	var2_0 = -1

	var0_36.onClick:Invoke()

	var1_0 = true
end

local var3_0 = true

function onToggle(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	local var0_37 = GetComponent(arg1_37, typeof(Toggle))

	assert(arg2_37, "callback should exist")

	local var1_37 = var0_37.onValueChanged

	var1_37:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_37, var1_37)
	var1_37:AddListener(function(arg0_38)
		if var3_0 then
			if arg0_38 and arg3_37 and var0_37.isOn == arg0_38 then
				arg3_37 = SFX_UI_TAG

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_37)
			elseif not arg0_38 and arg4_37 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg4_37)
			end
		end

		arg2_37(arg0_38)
	end)

	local var2_37 = GetComponent(arg1_37, typeof(UIToggleEvent))

	if not IsNil(var2_37) then
		var2_37:Rebind()
	end
end

function removeOnToggle(arg0_39)
	local var0_39 = GetComponent(arg0_39, typeof(Toggle))

	if var0_39 ~= nil then
		var0_39.onValueChanged:RemoveAllListeners()
	end
end

function triggerToggle(arg0_40, arg1_40)
	local var0_40 = GetComponent(arg0_40, typeof(Toggle))

	var3_0 = false
	arg1_40 = tobool(arg1_40)

	if var0_40.isOn ~= arg1_40 then
		var0_40.isOn = arg1_40
	else
		var0_40.onValueChanged:Invoke(arg1_40)
	end

	var3_0 = true
end

function triggerToggleWithoutNotify(arg0_41, arg1_41)
	local var0_41 = GetComponent(arg0_41, typeof(Toggle))

	var3_0 = false
	arg1_41 = tobool(arg1_41)

	LuaHelper.ChangeToggleValueWithoutNotify(var0_41, arg1_41)

	var3_0 = true
end

function onSlider(arg0_42, arg1_42, arg2_42)
	local var0_42 = GetComponent(arg1_42, typeof(Slider)).onValueChanged

	assert(arg2_42, "callback should exist")
	var0_42:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_42, var0_42)
	var0_42:AddListener(arg2_42)
end

function setSlider(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = GetComponent(arg0_43, typeof(Slider))

	assert(var0_43, "slider should exist")

	var0_43.minValue = arg1_43
	var0_43.maxValue = arg2_43
	var0_43.value = arg3_43
end

function eachChild(arg0_44, arg1_44)
	local var0_44 = tf(arg0_44)

	for iter0_44 = var0_44.childCount - 1, 0, -1 do
		arg1_44(var0_44:GetChild(iter0_44))
	end
end

function removeAllChildren(arg0_45)
	eachChild(arg0_45, function(arg0_46)
		tf(arg0_46).transform:SetParent(nil, false)
		Destroy(arg0_46)
	end)
end

function scrollTo(arg0_47, arg1_47, arg2_47)
	Canvas.ForceUpdateCanvases()

	local var0_47 = GetComponent(arg0_47, typeof(ScrollRect))
	local var1_47 = Vector2(arg1_47 or var0_47.normalizedPosition.x, arg2_47 or var0_47.normalizedPosition.y)

	onNextTick(function()
		if not IsNil(arg0_47) then
			var0_47.normalizedPosition = var1_47

			var0_47.onValueChanged:Invoke(var1_47)
		end
	end)
end

function scrollToBottom(arg0_49)
	scrollTo(arg0_49, 0, 0)
end

function onScroll(arg0_50, arg1_50, arg2_50)
	local var0_50 = GetComponent(arg1_50, typeof(ScrollRect)).onValueChanged

	assert(arg2_50, "callback should exist")
	var0_50:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_50, var0_50)
	var0_50:AddListener(arg2_50)
end

function ClearEventTrigger(arg0_51)
	arg0_51:RemovePointClickFunc()
	arg0_51:RemovePointDownFunc()
	arg0_51:RemovePointEnterFunc()
	arg0_51:RemovePointExitFunc()
	arg0_51:RemovePointUpFunc()
	arg0_51:RemoveCheckDragFunc()
	arg0_51:RemoveBeginDragFunc()
	arg0_51:RemoveDragFunc()
	arg0_51:RemoveDragEndFunc()
	arg0_51:RemoveDropFunc()
	arg0_51:RemoveScrollFunc()
	arg0_51:RemoveSelectFunc()
	arg0_51:RemoveUpdateSelectFunc()
	arg0_51:RemoveMoveFunc()
end

function ClearLScrollrect(arg0_52)
	arg0_52.onStart = nil
	arg0_52.onInitItem = nil
	arg0_52.onUpdateItem = nil
	arg0_52.onReturnItem = nil
end

function GetComponent(arg0_53, arg1_53)
	return (arg0_53:GetComponent(arg1_53))
end

function GetOrAddComponent(arg0_54, arg1_54)
	assert(arg0_54, "objectOrTransform not found: " .. debug.traceback())

	local var0_54 = arg1_54

	if type(arg1_54) == "string" then
		assert(_G[arg1_54], arg1_54 .. " not exist in Global")

		var0_54 = typeof(_G[arg1_54])
	end

	return LuaHelper.GetOrAddComponentForLua(arg0_54, var0_54)
end

function RemoveComponent(arg0_55, arg1_55)
	local var0_55 = arg0_55:GetComponent(arg1_55)

	if var0_55 then
		Object.Destroy(var0_55)
	end
end

function SetCompomentEnabled(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg0_56:GetComponent(arg1_56)

	assert(var0_56, "compoment not found")

	var0_56.enabled = tobool(arg2_56)
end

function GetInChildren(arg0_57, arg1_57)
	local function var0_57(arg0_58, arg1_58)
		if not arg0_58 then
			return nil
		end

		if arg0_58.name == arg1_58 then
			return arg0_58
		end

		for iter0_58 = 0, arg0_58.childCount - 1 do
			local var0_58 = arg0_58:GetChild(iter0_58)

			if arg1_58 == var0_58.name then
				return var0_58
			end

			local var1_58 = var0_57(var0_58, arg1_58)

			if var1_58 then
				return var1_58
			end
		end

		return nil
	end

	return var0_57(arg0_57, arg1_57)
end

function onNextTick(arg0_59)
	FrameTimer.New(arg0_59, 1, 1):Start()
end

function onDelayTick(arg0_60, arg1_60)
	Timer.New(arg0_60, arg1_60, 1):Start()
end

function seriesAsync(arg0_61, arg1_61, ...)
	local var0_61 = 0
	local var1_61 = #arg0_61
	local var2_61

	local function var3_61(...)
		var0_61 = var0_61 + 1

		if var0_61 <= var1_61 then
			arg0_61[var0_61](var3_61, ...)
		elseif var0_61 == var1_61 + 1 and arg1_61 then
			arg1_61(...)
		end
	end

	var3_61(...)
end

function seriesAsyncExtend(arg0_63, arg1_63, ...)
	local var0_63

	local function var1_63(...)
		if #arg0_63 > 0 then
			table.remove(arg0_63, 1)(var1_63, ...)
		elseif arg1_63 then
			arg1_63(...)
		end
	end

	var1_63(...)
end

function parallelAsync(arg0_65, arg1_65)
	local var0_65 = #arg0_65

	local function var1_65()
		var0_65 = var0_65 - 1

		if var0_65 == 0 and arg1_65 then
			arg1_65()
		end
	end

	if var0_65 > 0 then
		for iter0_65, iter1_65 in ipairs(arg0_65) do
			iter1_65(var1_65)
		end
	elseif arg1_65 then
		arg1_65()
	end
end

function limitedParallelAsync(arg0_67, arg1_67, arg2_67)
	local var0_67 = #arg0_67
	local var1_67 = var0_67

	if var1_67 == 0 then
		arg2_67()

		return
	end

	local var2_67 = math.min(arg1_67, var0_67)
	local var3_67

	local function var4_67()
		var1_67 = var1_67 - 1

		if var1_67 == 0 then
			arg2_67()
		elseif var2_67 + 1 <= var0_67 then
			var2_67 = var2_67 + 1

			arg0_67[var2_67](var4_67)
		end
	end

	for iter0_67 = 1, var2_67 do
		arg0_67[iter0_67](var4_67)
	end
end

function waitUntil(arg0_69, arg1_69)
	local var0_69

	var0_69 = FrameTimer.New(function()
		if arg0_69() then
			arg1_69()
			var0_69:Stop()

			return
		end
	end, 1, -1)

	var0_69:Start()

	return var0_69
end

function setImageSprite(arg0_71, arg1_71, arg2_71)
	if IsNil(arg0_71) then
		assert(false)

		return
	end

	local var0_71 = GetComponent(arg0_71, typeof(Image))

	if IsNil(var0_71) then
		return
	end

	var0_71.sprite = arg1_71

	if arg2_71 then
		var0_71:SetNativeSize()
	end
end

function clearImageSprite(arg0_72)
	GetComponent(arg0_72, typeof(Image)).sprite = nil
end

function getImageSprite(arg0_73)
	local var0_73 = GetComponent(arg0_73, typeof(Image))

	return var0_73 and var0_73.sprite
end

function tex2sprite(arg0_74)
	return UnityEngine.Sprite.Create(arg0_74, UnityEngine.Rect.New(0, 0, arg0_74.width, arg0_74.height), Vector2(0.5, 0.5), 100)
end

function setFillAmount(arg0_75, arg1_75)
	GetComponent(arg0_75, typeof(Image)).fillAmount = arg1_75
end

function string2vector3(arg0_76)
	local var0_76 = string.split(arg0_76, ",")

	return Vector3(var0_76[1], var0_76[2], var0_76[3])
end

function getToggleState(arg0_77)
	return arg0_77:GetComponent(typeof(Toggle)).isOn
end

function setLocalPosition(arg0_78, arg1_78)
	local var0_78 = tf(arg0_78).localPosition

	arg1_78.x = arg1_78.x or var0_78.x
	arg1_78.y = arg1_78.y or var0_78.y
	arg1_78.z = arg1_78.z or var0_78.z
	tf(arg0_78).localPosition = arg1_78
end

function setAnchoredPosition(arg0_79, arg1_79)
	local var0_79 = rtf(arg0_79)
	local var1_79 = var0_79.anchoredPosition

	arg1_79.x = arg1_79.x or var1_79.x
	arg1_79.y = arg1_79.y or var1_79.y
	var0_79.anchoredPosition = arg1_79
end

function setAnchoredPosition3D(arg0_80, arg1_80)
	local var0_80 = rtf(arg0_80)
	local var1_80 = var0_80.anchoredPosition3D

	arg1_80.x = arg1_80.x or var1_80.x
	arg1_80.y = arg1_80.y or var1_80.y
	arg1_80.z = arg1_80.y or var1_80.z
	var0_80.anchoredPosition3D = arg1_80
end

function getAnchoredPosition(arg0_81)
	return rtf(arg0_81).anchoredPosition
end

function setLocalScale(arg0_82, arg1_82)
	local var0_82 = tf(arg0_82).localScale

	arg1_82.x = arg1_82.x or var0_82.x
	arg1_82.y = arg1_82.y or var0_82.y
	arg1_82.z = arg1_82.z or var0_82.z
	tf(arg0_82).localScale = arg1_82
end

function setLocalRotation(arg0_83, arg1_83)
	local var0_83 = tf(arg0_83).localRotation

	arg1_83.x = arg1_83.x or var0_83.x
	arg1_83.y = arg1_83.y or var0_83.y
	arg1_83.z = arg1_83.z or var0_83.z
	tf(arg0_83).localRotation = arg1_83
end

function setLocalEulerAngles(arg0_84, arg1_84)
	local var0_84 = tf(arg0_84).localEulerAngles

	arg1_84.x = arg1_84.x or var0_84.x
	arg1_84.y = arg1_84.y or var0_84.y
	arg1_84.z = arg1_84.z or var0_84.z
	tf(arg0_84).localEulerAngles = arg1_84
end

function ActivateInputField(arg0_85)
	GetComponent(arg0_85, typeof(InputField)):ActivateInputField()
end

function onInputChanged(arg0_86, arg1_86, arg2_86)
	local var0_86 = GetComponent(arg1_86, typeof(InputField)).onValueChanged

	var0_86:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_86, var0_86)
	var0_86:AddListener(arg2_86)
end

function getImageColor(arg0_87)
	return GetComponent(arg0_87, typeof(Image)).color
end

function setImageColor(arg0_88, arg1_88)
	GetComponent(arg0_88, typeof(Image)).color = arg1_88
end

function getImageAlpha(arg0_89)
	return GetComponent(arg0_89, typeof(Image)).color.a
end

function setImageAlpha(arg0_90, arg1_90)
	local var0_90 = GetComponent(arg0_90, typeof(Image))
	local var1_90 = var0_90.color

	var1_90.a = arg1_90
	var0_90.color = var1_90
end

function getImageRaycastTarget(arg0_91)
	return GetComponent(arg0_91, typeof(Image)).raycastTarget
end

function setImageRaycastTarget(arg0_92, arg1_92)
	GetComponent(arg0_92, typeof(Image)).raycastTarget = tobool(arg1_92)
end

function getCanvasGroupAlpha(arg0_93)
	return GetComponent(arg0_93, typeof(CanvasGroup)).alpha
end

function setCanvasGroupAlpha(arg0_94, arg1_94)
	GetComponent(arg0_94, typeof(CanvasGroup)).alpha = arg1_94
end

function setActiveViaLayer(arg0_95, arg1_95)
	UIUtil.SetUIActiveViaLayer(go(arg0_95), arg1_95)
end

function setActiveViaCG(arg0_96, arg1_96)
	UIUtil.SetUIActiveViaCG(go(arg0_96), arg1_96)
end

function getTextColor(arg0_97)
	return GetComponent(arg0_97, typeof(Text)).color
end

function setTextColor(arg0_98, arg1_98)
	GetComponent(arg0_98, typeof(Text)).color = arg1_98
end

function getTextAlpha(arg0_99)
	return GetComponent(arg0_99, typeof(Text)).color.a
end

function setTextAlpha(arg0_100, arg1_100)
	local var0_100 = GetComponent(arg0_100, typeof(Text))
	local var1_100 = var0_100.color

	var1_100.a = arg1_100
	var0_100.color = var1_100
end

function setSizeDelta(arg0_101, arg1_101)
	local var0_101 = GetComponent(arg0_101, typeof(RectTransform))

	if not var0_101 then
		return
	end

	local var1_101 = var0_101.sizeDelta

	var1_101.x = arg1_101.x
	var1_101.y = arg1_101.y
	var0_101.sizeDelta = var1_101
end

function getOutlineColor(arg0_102)
	return GetComponent(arg0_102, typeof(Outline)).effectColor
end

function setOutlineColor(arg0_103, arg1_103)
	GetComponent(arg0_103, typeof(Outline)).effectColor = arg1_103
end

function pressPersistTrigger(arg0_104, arg1_104, arg2_104, arg3_104, arg4_104, arg5_104, arg6_104, arg7_104)
	arg6_104 = defaultValue(arg6_104, 0.25)

	assert(arg6_104 > 0, "maxSpeed less than zero")
	assert(arg0_104, "should exist objectOrTransform")

	local var0_104 = GetOrAddComponent(arg0_104, typeof(EventTriggerListener))

	assert(arg2_104, "should exist callback")

	local var1_104

	local function var2_104()
		if var1_104 then
			var1_104:Stop()

			var1_104 = nil

			existCall(arg3_104)
		end
	end

	var0_104:AddPointDownFunc(function()
		var1_104 = Timer.New(function()
			if arg5_104 then
				local var0_107 = math.max(var1_104.duration - arg1_104 / 10, arg6_104)

				var1_104.duration = var0_107
			end

			existCall(arg2_104, var2_104)
		end, arg1_104, -1)

		var1_104:Start()

		if arg4_104 then
			var1_104.func()
		end

		if arg7_104 and var1_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg7_104)
		end
	end)
	var0_104:AddPointUpFunc(var2_104)

	return var0_104
end

function getSpritePivot(arg0_108)
	local var0_108 = arg0_108.bounds
	local var1_108 = -var0_108.center.x / var0_108.extents.x / 2 + 0.5
	local var2_108 = -var0_108.center.y / var0_108.extents.y / 2 + 0.5

	return Vector2(var1_108, var2_108)
end

function resetAspectRatio(arg0_109)
	local var0_109 = GetComponent(arg0_109, "Image")

	GetComponent(arg0_109, "AspectRatioFitter").aspectRatio = var0_109.preferredWidth / var0_109.preferredHeight
end

function cloneTplTo(arg0_110, arg1_110, arg2_110)
	local var0_110 = tf(Instantiate(arg0_110))

	var0_110:SetParent(tf(arg1_110), false)
	SetActive(var0_110, true)

	if arg2_110 then
		var0_110.name = arg2_110
	end

	return var0_110
end

function setGray(arg0_111, arg1_111, arg2_111)
	if arg1_111 then
		local var0_111 = GetOrAddComponent(arg0_111, "UIGrayScale")

		var0_111.Recursive = defaultValue(arg2_111, true)
		var0_111.enabled = true
	else
		RemoveComponent(arg0_111, "UIGrayScale")
	end
end

function setBlackMask(arg0_112, arg1_112, arg2_112)
	if arg1_112 then
		arg2_112 = arg2_112 or {}

		local var0_112 = GetOrAddComponent(arg0_112, "UIMaterialAdjuster")

		var0_112.Recursive = tobool(defaultValue(arg2_112.recursive, true))

		local var1_112 = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit Colored_Alpha_UI"))

		var1_112:SetColor("_Color", arg2_112.color or Color(0, 0, 0, 0.2))

		var0_112.adjusterMaterial = var1_112
		var0_112.enabled = true
	else
		RemoveComponent(arg0_112, "UIMaterialAdjuster")
	end
end

function blockBlackMask(arg0_113, arg1_113, arg2_113)
	if arg1_113 then
		local var0_113 = GetOrAddComponent(arg0_113, "UIMaterialAdjuster")

		var0_113.Recursive = tobool(defaultValue(arg2_113, true))
		var0_113.enabled = false
	else
		RemoveComponent(arg0_113, "UIMaterialAdjuster")
	end
end

function long2int(arg0_114)
	local var0_114, var1_114 = int64.tonum2(arg0_114)

	return var0_114
end

function OnSliderWithButton(arg0_115, arg1_115, arg2_115)
	local var0_115 = arg1_115:GetComponent("Slider")

	var0_115.onValueChanged:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_115, var0_115.onValueChanged)
	var0_115.onValueChanged:AddListener(arg2_115)

	local var1_115 = (var0_115.maxValue - var0_115.minValue) * 0.1

	onButton(arg0_115, arg1_115:Find("up"), function()
		var0_115.value = math.clamp(var0_115.value + var1_115, var0_115.minValue, var0_115.maxValue)
	end, SFX_PANEL)
	onButton(arg0_115, arg1_115:Find("down"), function()
		var0_115.value = math.clamp(var0_115.value - var1_115, var0_115.minValue, var0_115.maxValue)
	end, SFX_PANEL)
end

function addSlip(arg0_118, arg1_118, arg2_118, arg3_118, arg4_118)
	local var0_118 = GetOrAddComponent(arg1_118, "EventTriggerListener")
	local var1_118
	local var2_118 = 0
	local var3_118 = 50

	var0_118:AddPointDownFunc(function()
		var2_118 = 0
		var1_118 = nil
	end)
	var0_118:AddDragFunc(function(arg0_120, arg1_120)
		local var0_120 = arg1_120.position

		if not var1_118 then
			var1_118 = var0_120
		end

		if arg0_118 == SLIP_TYPE_HRZ then
			var2_118 = var0_120.x - var1_118.x
		elseif arg0_118 == SLIP_TYPE_VERT then
			var2_118 = var0_120.y - var1_118.y
		end
	end)
	var0_118:AddPointUpFunc(function(arg0_121, arg1_121)
		if var2_118 < -var3_118 then
			if arg3_118 then
				arg3_118()
			end
		elseif var2_118 > var3_118 then
			if arg2_118 then
				arg2_118()
			end
		elseif arg4_118 then
			arg4_118()
		end
	end)
end

function getSizeRate()
	local var0_122 = pg.UIMgr.GetInstance().LevelMain.transform.rect
	local var1_122 = UnityEngine.Screen

	return Vector2.New(var0_122.width / var1_122.width, var0_122.height / var1_122.height), var0_122.width, var0_122.height
end

function IsUsingWifi()
	return Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaLocalAreaNetwork
end

function getSceneRootTFDic(arg0_124)
	local var0_124 = {}

	table.IpairsCArray(arg0_124:GetRootGameObjects(), function(arg0_125, arg1_125)
		var0_124[arg1_125.name] = arg1_125.transform
	end)

	return var0_124
end
