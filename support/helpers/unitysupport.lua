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

function setTextEN(arg0_13, arg1_13)
	if not arg1_13 then
		return
	end

	arg1_13 = splitByWordEN(arg1_13, arg0_13)
	arg0_13:GetComponent(typeof(Text)).text = tostring(arg1_13)
end

function setBestFitTextEN(arg0_14, arg1_14, arg2_14)
	if not arg1_14 then
		return
	end

	local var0_14 = arg0_14:GetComponent(typeof(RectTransform))
	local var1_14 = arg0_14:GetComponent(typeof(Text))
	local var2_14 = arg2_14 or 20
	local var3_14 = var0_14.rect.width
	local var4_14 = var0_14.rect.height

	while var2_14 > 0 do
		var1_14.fontSize = var2_14

		local var5_14 = splitByWordEN(arg1_14, arg0_14)

		var1_14.text = tostring(var5_14)

		if var3_14 >= var1_14.preferredWidth and var4_14 >= var1_14.preferredHeight then
			break
		end

		var2_14 = var2_14 - 1
	end
end

function setTextFont(arg0_15, arg1_15)
	if not arg1_15 then
		return
	end

	arg0_15:GetComponent(typeof(Text)).font = arg1_15
end

function getText(arg0_16)
	return arg0_16:GetComponent(typeof(Text)).text
end

function setInputText(arg0_17, arg1_17)
	if not arg1_17 then
		return
	end

	arg0_17:GetComponent(typeof(InputField)).text = arg1_17
end

function getInputText(arg0_18)
	return arg0_18:GetComponent(typeof(InputField)).text
end

function onInputEndEdit(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19:GetComponent(typeof(InputField)).onEndEdit

	pg.DelegateInfo.Add(arg0_19, var0_19)
	var0_19:RemoveAllListeners()
	var0_19:AddListener(arg2_19)
end

function activateInputField(arg0_20)
	arg0_20:GetComponent(typeof(InputField)):ActivateInputField()
end

function setButtonText(arg0_21, arg1_21, arg2_21)
	setWidgetText(arg0_21, arg1_21, arg2_21)
end

function setWidgetText(arg0_22, arg1_22, arg2_22)
	arg2_22 = arg2_22 or "Text"
	arg2_22 = findTF(arg0_22, arg2_22)

	setText(arg2_22, arg1_22)
end

function setWidgetTextEN(arg0_23, arg1_23, arg2_23)
	arg2_23 = arg2_23 or "Text"
	arg2_23 = findTF(arg0_23, arg2_23)

	setTextEN(arg2_23, arg1_23)
end

local var0_0
local var1_0 = true
local var2_0 = -1

function onButton(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	local var0_24 = GetOrAddComponent(arg1_24, typeof(Button))

	assert(var0_24, "could not found Button component on " .. arg1_24.name)
	assert(arg2_24, "callback should exist")

	local var1_24 = var0_24.onClick

	pg.DelegateInfo.Add(arg0_24, var1_24)
	var1_24:RemoveAllListeners()
	var1_24:AddListener(function()
		if var2_0 == Time.frameCount and Input.touchCount > 1 then
			return
		end

		var2_0 = Time.frameCount

		if arg3_24 and var1_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_24)
		end

		arg2_24()
	end)
end

function removeOnButton(arg0_26)
	local var0_26 = arg0_26:GetComponent(typeof(Button))

	if var0_26 ~= nil then
		var0_26.onClick:RemoveAllListeners()
	end
end

function removeAllOnButton(arg0_27)
	local var0_27 = arg0_27:GetComponentsInChildren(typeof(Button))

	for iter0_27 = 1, var0_27.Length do
		local var1_27 = var0_27[iter0_27 - 1]

		if var1_27 ~= nil then
			var1_27.onClick:RemoveAllListeners()
		end
	end
end

function ClearAllText(arg0_28)
	local var0_28 = arg0_28:GetComponentsInChildren(typeof(Text))

	for iter0_28 = 1, var0_28.Length do
		local var1_28 = var0_28[iter0_28 - 1]

		if var1_28 ~= nil then
			var1_28.text = ""
		end
	end
end

function onLongPressTrigger(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = GetOrAddComponent(arg1_29, typeof(UILongPressTrigger))

	assert(var0_29, "could not found UILongPressTrigger component on " .. arg1_29.name)
	assert(arg2_29, "callback should exist")

	local var1_29 = var0_29.onLongPressed

	pg.DelegateInfo.Add(arg0_29, var1_29)
	var1_29:RemoveAllListeners()
	var1_29:AddListener(function()
		if arg3_29 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_29)
		end

		arg2_29()
	end)
end

function removeOnLongPressTrigger(arg0_31)
	local var0_31 = arg0_31:GetComponent(typeof(UILongPressTrigger))

	if var0_31 ~= nil then
		var0_31.onLongPressed:RemoveAllListeners()
	end
end

function setButtonEnabled(arg0_32, arg1_32)
	GetComponent(arg0_32, typeof(Button)).interactable = arg1_32
end

function setToggleEnabled(arg0_33, arg1_33)
	GetComponent(arg0_33, typeof(Toggle)).interactable = arg1_33
end

function setSliderEnable(arg0_34, arg1_34)
	GetComponent(arg0_34, typeof(Slider)).interactable = arg1_34
end

function triggerButton(arg0_35)
	local var0_35 = GetComponent(arg0_35, typeof(Button))

	var1_0 = false
	var2_0 = -1

	var0_35.onClick:Invoke()

	var1_0 = true
end

local var3_0 = true

function onToggle(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = GetComponent(arg1_36, typeof(Toggle))

	assert(arg2_36, "callback should exist")

	local var1_36 = var0_36.onValueChanged

	var1_36:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_36, var1_36)
	var1_36:AddListener(function(arg0_37)
		if var3_0 then
			if arg0_37 and arg3_36 and var0_36.isOn == arg0_37 then
				arg3_36 = SFX_UI_TAG

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_36)
			elseif not arg0_37 and arg4_36 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg4_36)
			end
		end

		arg2_36(arg0_37)
	end)

	local var2_36 = GetComponent(arg1_36, typeof(UIToggleEvent))

	if not IsNil(var2_36) then
		var2_36:Rebind()
	end
end

function removeOnToggle(arg0_38)
	local var0_38 = GetComponent(arg0_38, typeof(Toggle))

	if var0_38 ~= nil then
		var0_38.onValueChanged:RemoveAllListeners()
	end
end

function triggerToggle(arg0_39, arg1_39)
	local var0_39 = GetComponent(arg0_39, typeof(Toggle))

	var3_0 = false
	arg1_39 = tobool(arg1_39)

	if var0_39.isOn ~= arg1_39 then
		var0_39.isOn = arg1_39
	else
		var0_39.onValueChanged:Invoke(arg1_39)
	end

	var3_0 = true
end

function triggerToggleWithoutNotify(arg0_40, arg1_40)
	local var0_40 = GetComponent(arg0_40, typeof(Toggle))

	var3_0 = false
	arg1_40 = tobool(arg1_40)

	LuaHelper.ChangeToggleValueWithoutNotify(var0_40, arg1_40)

	var3_0 = true
end

function onSlider(arg0_41, arg1_41, arg2_41)
	local var0_41 = GetComponent(arg1_41, typeof(Slider)).onValueChanged

	assert(arg2_41, "callback should exist")
	var0_41:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_41, var0_41)
	var0_41:AddListener(arg2_41)
end

function setSlider(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = GetComponent(arg0_42, typeof(Slider))

	assert(var0_42, "slider should exist")

	var0_42.minValue = arg1_42
	var0_42.maxValue = arg2_42
	var0_42.value = arg3_42
end

function eachChild(arg0_43, arg1_43)
	local var0_43 = tf(arg0_43)

	for iter0_43 = var0_43.childCount - 1, 0, -1 do
		arg1_43(var0_43:GetChild(iter0_43))
	end
end

function removeAllChildren(arg0_44)
	eachChild(arg0_44, function(arg0_45)
		tf(arg0_45).transform:SetParent(nil, false)
		Destroy(arg0_45)
	end)
end

function scrollTo(arg0_46, arg1_46, arg2_46)
	Canvas.ForceUpdateCanvases()

	local var0_46 = GetComponent(arg0_46, typeof(ScrollRect))
	local var1_46 = Vector2(arg1_46 or var0_46.normalizedPosition.x, arg2_46 or var0_46.normalizedPosition.y)

	onNextTick(function()
		if not IsNil(arg0_46) then
			var0_46.normalizedPosition = var1_46

			var0_46.onValueChanged:Invoke(var1_46)
		end
	end)
end

function scrollToBottom(arg0_48)
	scrollTo(arg0_48, 0, 0)
end

function onScroll(arg0_49, arg1_49, arg2_49)
	local var0_49 = GetComponent(arg1_49, typeof(ScrollRect)).onValueChanged

	assert(arg2_49, "callback should exist")
	var0_49:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_49, var0_49)
	var0_49:AddListener(arg2_49)
end

function ClearEventTrigger(arg0_50)
	arg0_50:RemovePointClickFunc()
	arg0_50:RemovePointDownFunc()
	arg0_50:RemovePointEnterFunc()
	arg0_50:RemovePointExitFunc()
	arg0_50:RemovePointUpFunc()
	arg0_50:RemoveCheckDragFunc()
	arg0_50:RemoveBeginDragFunc()
	arg0_50:RemoveDragFunc()
	arg0_50:RemoveDragEndFunc()
	arg0_50:RemoveDropFunc()
	arg0_50:RemoveScrollFunc()
	arg0_50:RemoveSelectFunc()
	arg0_50:RemoveUpdateSelectFunc()
	arg0_50:RemoveMoveFunc()
end

function ClearLScrollrect(arg0_51)
	arg0_51.onStart = nil
	arg0_51.onInitItem = nil
	arg0_51.onUpdateItem = nil
	arg0_51.onReturnItem = nil
end

function GetComponent(arg0_52, arg1_52)
	return (arg0_52:GetComponent(arg1_52))
end

function GetOrAddComponent(arg0_53, arg1_53)
	assert(arg0_53, "objectOrTransform not found: " .. debug.traceback())

	local var0_53 = arg1_53

	if type(arg1_53) == "string" then
		assert(_G[arg1_53], arg1_53 .. " not exist in Global")

		var0_53 = typeof(_G[arg1_53])
	end

	return LuaHelper.GetOrAddComponentForLua(arg0_53, var0_53)
end

function RemoveComponent(arg0_54, arg1_54)
	local var0_54 = arg0_54:GetComponent(arg1_54)

	if var0_54 then
		Object.Destroy(var0_54)
	end
end

function SetCompomentEnabled(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg0_55:GetComponent(arg1_55)

	assert(var0_55, "compoment not found")

	var0_55.enabled = tobool(arg2_55)
end

function GetInChildren(arg0_56, arg1_56)
	local function var0_56(arg0_57, arg1_57)
		if not arg0_57 then
			return nil
		end

		if arg0_57.name == arg1_57 then
			return arg0_57
		end

		for iter0_57 = 0, arg0_57.childCount - 1 do
			local var0_57 = arg0_57:GetChild(iter0_57)

			if arg1_57 == var0_57.name then
				return var0_57
			end

			local var1_57 = var0_56(var0_57, arg1_57)

			if var1_57 then
				return var1_57
			end
		end

		return nil
	end

	return var0_56(arg0_56, arg1_56)
end

function onNextTick(arg0_58)
	FrameTimer.New(arg0_58, 1, 1):Start()
end

function onDelayTick(arg0_59, arg1_59)
	Timer.New(arg0_59, arg1_59, 1):Start()
end

function seriesAsync(arg0_60, arg1_60, ...)
	local var0_60 = 0
	local var1_60 = #arg0_60
	local var2_60

	local function var3_60(...)
		var0_60 = var0_60 + 1

		if var0_60 <= var1_60 then
			arg0_60[var0_60](var3_60, ...)
		elseif var0_60 == var1_60 + 1 and arg1_60 then
			arg1_60(...)
		end
	end

	var3_60(...)
end

function seriesAsyncExtend(arg0_62, arg1_62, ...)
	local var0_62

	local function var1_62(...)
		if #arg0_62 > 0 then
			table.remove(arg0_62, 1)(var1_62, ...)
		elseif arg1_62 then
			arg1_62(...)
		end
	end

	var1_62(...)
end

function parallelAsync(arg0_64, arg1_64)
	local var0_64 = #arg0_64

	local function var1_64()
		var0_64 = var0_64 - 1

		if var0_64 == 0 and arg1_64 then
			arg1_64()
		end
	end

	if var0_64 > 0 then
		for iter0_64, iter1_64 in ipairs(arg0_64) do
			iter1_64(var1_64)
		end
	elseif arg1_64 then
		arg1_64()
	end
end

function limitedParallelAsync(arg0_66, arg1_66, arg2_66)
	local var0_66 = #arg0_66
	local var1_66 = var0_66

	if var1_66 == 0 then
		arg2_66()

		return
	end

	local var2_66 = math.min(arg1_66, var0_66)
	local var3_66

	local function var4_66()
		var1_66 = var1_66 - 1

		if var1_66 == 0 then
			arg2_66()
		elseif var2_66 + 1 <= var0_66 then
			var2_66 = var2_66 + 1

			arg0_66[var2_66](var4_66)
		end
	end

	for iter0_66 = 1, var2_66 do
		arg0_66[iter0_66](var4_66)
	end
end

function waitUntil(arg0_68, arg1_68)
	local var0_68

	var0_68 = FrameTimer.New(function()
		if arg0_68() then
			arg1_68()
			var0_68:Stop()

			return
		end
	end, 1, -1)

	var0_68:Start()

	return var0_68
end

function setImageSprite(arg0_70, arg1_70, arg2_70)
	if IsNil(arg0_70) then
		assert(false)

		return
	end

	local var0_70 = GetComponent(arg0_70, typeof(Image))

	if IsNil(var0_70) then
		return
	end

	var0_70.sprite = arg1_70

	if arg2_70 then
		var0_70:SetNativeSize()
	end
end

function clearImageSprite(arg0_71)
	GetComponent(arg0_71, typeof(Image)).sprite = nil
end

function getImageSprite(arg0_72)
	local var0_72 = GetComponent(arg0_72, typeof(Image))

	return var0_72 and var0_72.sprite
end

function tex2sprite(arg0_73)
	return UnityEngine.Sprite.Create(arg0_73, UnityEngine.Rect.New(0, 0, arg0_73.width, arg0_73.height), Vector2(0.5, 0.5), 100)
end

function setFillAmount(arg0_74, arg1_74)
	GetComponent(arg0_74, typeof(Image)).fillAmount = arg1_74
end

function string2vector3(arg0_75)
	local var0_75 = string.split(arg0_75, ",")

	return Vector3(var0_75[1], var0_75[2], var0_75[3])
end

function getToggleState(arg0_76)
	return arg0_76:GetComponent(typeof(Toggle)).isOn
end

function setLocalPosition(arg0_77, arg1_77)
	local var0_77 = tf(arg0_77).localPosition

	arg1_77.x = arg1_77.x or var0_77.x
	arg1_77.y = arg1_77.y or var0_77.y
	arg1_77.z = arg1_77.z or var0_77.z
	tf(arg0_77).localPosition = arg1_77
end

function setAnchoredPosition(arg0_78, arg1_78)
	local var0_78 = rtf(arg0_78)
	local var1_78 = var0_78.anchoredPosition

	arg1_78.x = arg1_78.x or var1_78.x
	arg1_78.y = arg1_78.y or var1_78.y
	var0_78.anchoredPosition = arg1_78
end

function setAnchoredPosition3D(arg0_79, arg1_79)
	local var0_79 = rtf(arg0_79)
	local var1_79 = var0_79.anchoredPosition3D

	arg1_79.x = arg1_79.x or var1_79.x
	arg1_79.y = arg1_79.y or var1_79.y
	arg1_79.z = arg1_79.y or var1_79.z
	var0_79.anchoredPosition3D = arg1_79
end

function getAnchoredPosition(arg0_80)
	return rtf(arg0_80).anchoredPosition
end

function setLocalScale(arg0_81, arg1_81)
	local var0_81 = tf(arg0_81).localScale

	arg1_81.x = arg1_81.x or var0_81.x
	arg1_81.y = arg1_81.y or var0_81.y
	arg1_81.z = arg1_81.z or var0_81.z
	tf(arg0_81).localScale = arg1_81
end

function setLocalRotation(arg0_82, arg1_82)
	local var0_82 = tf(arg0_82).localRotation

	arg1_82.x = arg1_82.x or var0_82.x
	arg1_82.y = arg1_82.y or var0_82.y
	arg1_82.z = arg1_82.z or var0_82.z
	tf(arg0_82).localRotation = arg1_82
end

function setLocalEulerAngles(arg0_83, arg1_83)
	local var0_83 = tf(arg0_83).localEulerAngles

	arg1_83.x = arg1_83.x or var0_83.x
	arg1_83.y = arg1_83.y or var0_83.y
	arg1_83.z = arg1_83.z or var0_83.z
	tf(arg0_83).localEulerAngles = arg1_83
end

function ActivateInputField(arg0_84)
	GetComponent(arg0_84, typeof(InputField)):ActivateInputField()
end

function onInputChanged(arg0_85, arg1_85, arg2_85)
	local var0_85 = GetComponent(arg1_85, typeof(InputField)).onValueChanged

	var0_85:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_85, var0_85)
	var0_85:AddListener(arg2_85)
end

function getImageColor(arg0_86)
	return GetComponent(arg0_86, typeof(Image)).color
end

function setImageColor(arg0_87, arg1_87)
	GetComponent(arg0_87, typeof(Image)).color = arg1_87
end

function getImageAlpha(arg0_88)
	return GetComponent(arg0_88, typeof(Image)).color.a
end

function setImageAlpha(arg0_89, arg1_89)
	local var0_89 = GetComponent(arg0_89, typeof(Image))
	local var1_89 = var0_89.color

	var1_89.a = arg1_89
	var0_89.color = var1_89
end

function getImageRaycastTarget(arg0_90)
	return GetComponent(arg0_90, typeof(Image)).raycastTarget
end

function setImageRaycastTarget(arg0_91, arg1_91)
	GetComponent(arg0_91, typeof(Image)).raycastTarget = tobool(arg1_91)
end

function getCanvasGroupAlpha(arg0_92)
	return GetComponent(arg0_92, typeof(CanvasGroup)).alpha
end

function setCanvasGroupAlpha(arg0_93, arg1_93)
	GetComponent(arg0_93, typeof(CanvasGroup)).alpha = arg1_93
end

function setActiveViaLayer(arg0_94, arg1_94)
	UIUtil.SetUIActiveViaLayer(go(arg0_94), arg1_94)
end

function setActiveViaCG(arg0_95, arg1_95)
	UIUtil.SetUIActiveViaCG(go(arg0_95), arg1_95)
end

function getTextColor(arg0_96)
	return GetComponent(arg0_96, typeof(Text)).color
end

function setTextColor(arg0_97, arg1_97)
	GetComponent(arg0_97, typeof(Text)).color = arg1_97
end

function getTextAlpha(arg0_98)
	return GetComponent(arg0_98, typeof(Text)).color.a
end

function setTextAlpha(arg0_99, arg1_99)
	local var0_99 = GetComponent(arg0_99, typeof(Text))
	local var1_99 = var0_99.color

	var1_99.a = arg1_99
	var0_99.color = var1_99
end

function setSizeDelta(arg0_100, arg1_100)
	local var0_100 = GetComponent(arg0_100, typeof(RectTransform))

	if not var0_100 then
		return
	end

	local var1_100 = var0_100.sizeDelta

	var1_100.x = arg1_100.x
	var1_100.y = arg1_100.y
	var0_100.sizeDelta = var1_100
end

function getOutlineColor(arg0_101)
	return GetComponent(arg0_101, typeof(Outline)).effectColor
end

function setOutlineColor(arg0_102, arg1_102)
	GetComponent(arg0_102, typeof(Outline)).effectColor = arg1_102
end

function pressPersistTrigger(arg0_103, arg1_103, arg2_103, arg3_103, arg4_103, arg5_103, arg6_103, arg7_103)
	arg6_103 = defaultValue(arg6_103, 0.25)

	assert(arg6_103 > 0, "maxSpeed less than zero")
	assert(arg0_103, "should exist objectOrTransform")

	local var0_103 = GetOrAddComponent(arg0_103, typeof(EventTriggerListener))

	assert(arg2_103, "should exist callback")

	local var1_103

	local function var2_103()
		if var1_103 then
			var1_103:Stop()

			var1_103 = nil

			existCall(arg3_103)
		end
	end

	var0_103:AddPointDownFunc(function()
		var1_103 = Timer.New(function()
			if arg5_103 then
				local var0_106 = math.max(var1_103.duration - arg1_103 / 10, arg6_103)

				var1_103.duration = var0_106
			end

			existCall(arg2_103, var2_103)
		end, arg1_103, -1)

		var1_103:Start()

		if arg4_103 then
			var1_103.func()
		end

		if arg7_103 and var1_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg7_103)
		end
	end)
	var0_103:AddPointUpFunc(var2_103)

	return var0_103
end

function getSpritePivot(arg0_107)
	local var0_107 = arg0_107.bounds
	local var1_107 = -var0_107.center.x / var0_107.extents.x / 2 + 0.5
	local var2_107 = -var0_107.center.y / var0_107.extents.y / 2 + 0.5

	return Vector2(var1_107, var2_107)
end

function resetAspectRatio(arg0_108)
	local var0_108 = GetComponent(arg0_108, "Image")

	GetComponent(arg0_108, "AspectRatioFitter").aspectRatio = var0_108.preferredWidth / var0_108.preferredHeight
end

function cloneTplTo(arg0_109, arg1_109, arg2_109)
	local var0_109 = tf(Instantiate(arg0_109))

	var0_109:SetParent(tf(arg1_109), false)
	SetActive(var0_109, true)

	if arg2_109 then
		var0_109.name = arg2_109
	end

	return var0_109
end

function setGray(arg0_110, arg1_110, arg2_110)
	if arg1_110 then
		local var0_110 = GetOrAddComponent(arg0_110, "UIGrayScale")

		var0_110.Recursive = defaultValue(arg2_110, true)
		var0_110.enabled = true
	else
		RemoveComponent(arg0_110, "UIGrayScale")
	end
end

function setBlackMask(arg0_111, arg1_111, arg2_111)
	if arg1_111 then
		arg2_111 = arg2_111 or {}

		local var0_111 = GetOrAddComponent(arg0_111, "UIMaterialAdjuster")

		var0_111.Recursive = tobool(defaultValue(arg2_111.recursive, true))

		local var1_111 = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit Colored_Alpha_UI"))

		var1_111:SetColor("_Color", arg2_111.color or Color(0, 0, 0, 0.2))

		var0_111.adjusterMaterial = var1_111
		var0_111.enabled = true
	else
		RemoveComponent(arg0_111, "UIMaterialAdjuster")
	end
end

function blockBlackMask(arg0_112, arg1_112, arg2_112)
	if arg1_112 then
		local var0_112 = GetOrAddComponent(arg0_112, "UIMaterialAdjuster")

		var0_112.Recursive = tobool(defaultValue(arg2_112, true))
		var0_112.enabled = false
	else
		RemoveComponent(arg0_112, "UIMaterialAdjuster")
	end
end

function long2int(arg0_113)
	local var0_113, var1_113 = int64.tonum2(arg0_113)

	return var0_113
end

function OnSliderWithButton(arg0_114, arg1_114, arg2_114)
	local var0_114 = arg1_114:GetComponent("Slider")

	var0_114.onValueChanged:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_114, var0_114.onValueChanged)
	var0_114.onValueChanged:AddListener(arg2_114)

	local var1_114 = (var0_114.maxValue - var0_114.minValue) * 0.1

	onButton(arg0_114, arg1_114:Find("up"), function()
		var0_114.value = math.clamp(var0_114.value + var1_114, var0_114.minValue, var0_114.maxValue)
	end, SFX_PANEL)
	onButton(arg0_114, arg1_114:Find("down"), function()
		var0_114.value = math.clamp(var0_114.value - var1_114, var0_114.minValue, var0_114.maxValue)
	end, SFX_PANEL)
end

function addSlip(arg0_117, arg1_117, arg2_117, arg3_117, arg4_117)
	local var0_117 = GetOrAddComponent(arg1_117, "EventTriggerListener")
	local var1_117
	local var2_117 = 0
	local var3_117 = 50

	var0_117:AddPointDownFunc(function()
		var2_117 = 0
		var1_117 = nil
	end)
	var0_117:AddDragFunc(function(arg0_119, arg1_119)
		local var0_119 = arg1_119.position

		if not var1_117 then
			var1_117 = var0_119
		end

		if arg0_117 == SLIP_TYPE_HRZ then
			var2_117 = var0_119.x - var1_117.x
		elseif arg0_117 == SLIP_TYPE_VERT then
			var2_117 = var0_119.y - var1_117.y
		end
	end)
	var0_117:AddPointUpFunc(function(arg0_120, arg1_120)
		if var2_117 < -var3_117 then
			if arg3_117 then
				arg3_117()
			end
		elseif var2_117 > var3_117 then
			if arg2_117 then
				arg2_117()
			end
		elseif arg4_117 then
			arg4_117()
		end
	end)
end

function getSizeRate()
	local var0_121 = pg.UIMgr.GetInstance().LevelMain.transform.rect
	local var1_121 = UnityEngine.Screen

	return Vector2.New(var0_121.width / var1_121.width, var0_121.height / var1_121.height), var0_121.width, var0_121.height
end

function IsUsingWifi()
	return Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaLocalAreaNetwork
end
