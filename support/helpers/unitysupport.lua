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

function setTextInNewStyleBox(arg0_13, arg1_13)
	if not arg1_13 then
		return
	end

	for iter0_13, iter1_13 in pairs(pg.NewStyleMsgboxMgr.COLOR_MAP) do
		arg1_13 = string.gsub(arg1_13, iter0_13, iter1_13)
	end

	arg0_13:GetComponent(typeof(Text)).text = tostring(arg1_13)
end

function setScrollText(arg0_14, arg1_14)
	if not arg1_14 then
		return
	end

	arg0_14:GetComponent("ScrollText"):SetText(tostring(arg1_14))
end

function setTextEN(arg0_15, arg1_15)
	if not arg1_15 then
		return
	end

	arg1_15 = splitByWordEN(arg1_15, arg0_15)
	arg0_15:GetComponent(typeof(Text)).text = tostring(arg1_15)
end

function setBestFitTextEN(arg0_16, arg1_16, arg2_16)
	if not arg1_16 then
		return
	end

	local var0_16 = arg0_16:GetComponent(typeof(RectTransform))
	local var1_16 = arg0_16:GetComponent(typeof(Text))
	local var2_16 = arg2_16 or 20
	local var3_16 = var0_16.rect.width
	local var4_16 = var0_16.rect.height

	while var2_16 > 0 do
		var1_16.fontSize = var2_16

		local var5_16 = splitByWordEN(arg1_16, arg0_16)

		var1_16.text = tostring(var5_16)

		if var3_16 >= var1_16.preferredWidth and var4_16 >= var1_16.preferredHeight then
			break
		end

		var2_16 = var2_16 - 1
	end
end

function setTextFont(arg0_17, arg1_17)
	if not arg1_17 then
		return
	end

	arg0_17:GetComponent(typeof(Text)).font = arg1_17
end

function getText(arg0_18)
	return arg0_18:GetComponent(typeof(Text)).text
end

function setInputText(arg0_19, arg1_19)
	if not arg1_19 then
		return
	end

	arg0_19:GetComponent(typeof(InputField)).text = arg1_19
end

function getInputText(arg0_20)
	return arg0_20:GetComponent(typeof(InputField)).text
end

function onInputEndEdit(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg1_21:GetComponent(typeof(InputField)).onEndEdit

	pg.DelegateInfo.Add(arg0_21, var0_21)
	var0_21:RemoveAllListeners()
	var0_21:AddListener(arg2_21)
end

function activateInputField(arg0_22)
	arg0_22:GetComponent(typeof(InputField)):ActivateInputField()
end

function setButtonText(arg0_23, arg1_23, arg2_23)
	setWidgetText(arg0_23, arg1_23, arg2_23)
end

function setWidgetText(arg0_24, arg1_24, arg2_24)
	arg2_24 = arg2_24 or "Text"
	arg2_24 = findTF(arg0_24, arg2_24)

	setText(arg2_24, arg1_24)
end

function setWidgetTextEN(arg0_25, arg1_25, arg2_25)
	arg2_25 = arg2_25 or "Text"
	arg2_25 = findTF(arg0_25, arg2_25)

	setTextEN(arg2_25, arg1_25)
end

local var0_0
local var1_0 = true
local var2_0 = -1

function onButton(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = GetOrAddComponent(arg1_26, typeof(Button))

	assert(var0_26, "could not found Button component on " .. arg1_26.name)
	assert(arg2_26, "callback should exist")

	local var1_26 = var0_26.onClick

	pg.DelegateInfo.Add(arg0_26, var1_26)
	var1_26:RemoveAllListeners()
	var1_26:AddListener(function()
		if var2_0 == Time.frameCount and Input.touchCount > 1 then
			return
		end

		var2_0 = Time.frameCount

		if arg3_26 and var1_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_26)
		end

		arg2_26()
	end)
end

function removeOnButton(arg0_28)
	local var0_28 = arg0_28:GetComponent(typeof(Button))

	if var0_28 ~= nil then
		var0_28.onClick:RemoveAllListeners()
	end
end

function removeAllOnButton(arg0_29)
	local var0_29 = arg0_29:GetComponentsInChildren(typeof(Button))

	for iter0_29 = 1, var0_29.Length do
		local var1_29 = var0_29[iter0_29 - 1]

		if var1_29 ~= nil then
			var1_29.onClick:RemoveAllListeners()
		end
	end
end

function ClearAllText(arg0_30)
	local var0_30 = arg0_30:GetComponentsInChildren(typeof(Text))

	for iter0_30 = 1, var0_30.Length do
		local var1_30 = var0_30[iter0_30 - 1]

		if var1_30 ~= nil then
			var1_30.text = ""
		end
	end
end

function onLongPressTrigger(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = GetOrAddComponent(arg1_31, typeof(UILongPressTrigger))

	assert(var0_31, "could not found UILongPressTrigger component on " .. arg1_31.name)
	assert(arg2_31, "callback should exist")

	local var1_31 = var0_31.onLongPressed

	pg.DelegateInfo.Add(arg0_31, var1_31)
	var1_31:RemoveAllListeners()
	var1_31:AddListener(function()
		if arg3_31 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_31)
		end

		arg2_31()
	end)
end

function removeOnLongPressTrigger(arg0_33)
	local var0_33 = arg0_33:GetComponent(typeof(UILongPressTrigger))

	if var0_33 ~= nil then
		var0_33.onLongPressed:RemoveAllListeners()
	end
end

function setButtonEnabled(arg0_34, arg1_34)
	GetComponent(arg0_34, typeof(Button)).interactable = arg1_34
end

function setToggleEnabled(arg0_35, arg1_35)
	GetComponent(arg0_35, typeof(Toggle)).interactable = arg1_35
end

function setSliderEnable(arg0_36, arg1_36)
	GetComponent(arg0_36, typeof(Slider)).interactable = arg1_36
end

function triggerButton(arg0_37)
	local var0_37 = GetComponent(arg0_37, typeof(Button))

	var1_0 = false
	var2_0 = -1

	var0_37.onClick:Invoke()

	var1_0 = true
end

local var3_0 = true

function onToggle(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = GetComponent(arg1_38, typeof(Toggle))

	assert(arg2_38, "callback should exist")

	local var1_38 = var0_38.onValueChanged

	var1_38:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_38, var1_38)
	var1_38:AddListener(function(arg0_39)
		if var3_0 then
			if arg0_39 and arg3_38 and var0_38.isOn == arg0_39 then
				arg3_38 = SFX_UI_TAG

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_38)
			elseif not arg0_39 and arg4_38 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg4_38)
			end
		end

		arg2_38(arg0_39)
	end)

	local var2_38 = GetComponent(arg1_38, typeof(UIToggleEvent))

	if not IsNil(var2_38) then
		var2_38:Rebind()
	end
end

function removeOnToggle(arg0_40)
	local var0_40 = GetComponent(arg0_40, typeof(Toggle))

	if var0_40 ~= nil then
		var0_40.onValueChanged:RemoveAllListeners()
	end
end

function triggerToggle(arg0_41, arg1_41)
	local var0_41 = GetComponent(arg0_41, typeof(Toggle))

	var3_0 = false
	arg1_41 = tobool(arg1_41)

	if var0_41.isOn ~= arg1_41 then
		var0_41.isOn = arg1_41
	else
		var0_41.onValueChanged:Invoke(arg1_41)
	end

	var3_0 = true
end

function triggerToggleWithoutNotify(arg0_42, arg1_42)
	local var0_42 = GetComponent(arg0_42, typeof(Toggle))

	var3_0 = false
	arg1_42 = tobool(arg1_42)

	LuaHelper.ChangeToggleValueWithoutNotify(var0_42, arg1_42)

	var3_0 = true
end

function onSlider(arg0_43, arg1_43, arg2_43)
	local var0_43 = GetComponent(arg1_43, typeof(Slider)).onValueChanged

	assert(arg2_43, "callback should exist")
	var0_43:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_43, var0_43)
	var0_43:AddListener(arg2_43)
end

function setSlider(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44 = GetComponent(arg0_44, typeof(Slider))

	assert(var0_44, "slider should exist")

	var0_44.minValue = arg1_44
	var0_44.maxValue = arg2_44
	var0_44.value = arg3_44
end

function eachChild(arg0_45, arg1_45)
	local var0_45 = tf(arg0_45)

	for iter0_45 = var0_45.childCount - 1, 0, -1 do
		arg1_45(var0_45:GetChild(iter0_45))
	end
end

function removeAllChildren(arg0_46)
	eachChild(arg0_46, function(arg0_47)
		tf(arg0_47).transform:SetParent(nil, false)
		Destroy(arg0_47)
	end)
end

function scrollTo(arg0_48, arg1_48, arg2_48)
	Canvas.ForceUpdateCanvases()

	local var0_48 = GetComponent(arg0_48, typeof(ScrollRect))
	local var1_48 = Vector2(arg1_48 or var0_48.normalizedPosition.x, arg2_48 or var0_48.normalizedPosition.y)

	onNextTick(function()
		if not IsNil(arg0_48) then
			var0_48.normalizedPosition = var1_48

			var0_48.onValueChanged:Invoke(var1_48)
		end
	end)
end

function scrollToBottom(arg0_50)
	scrollTo(arg0_50, 0, 0)
end

function onScroll(arg0_51, arg1_51, arg2_51)
	local var0_51 = GetComponent(arg1_51, typeof(ScrollRect)).onValueChanged

	assert(arg2_51, "callback should exist")
	var0_51:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_51, var0_51)
	var0_51:AddListener(arg2_51)
end

function ClearEventTrigger(arg0_52)
	arg0_52:RemovePointClickFunc()
	arg0_52:RemovePointDownFunc()
	arg0_52:RemovePointEnterFunc()
	arg0_52:RemovePointExitFunc()
	arg0_52:RemovePointUpFunc()
	arg0_52:RemoveCheckDragFunc()
	arg0_52:RemoveBeginDragFunc()
	arg0_52:RemoveDragFunc()
	arg0_52:RemoveDragEndFunc()
	arg0_52:RemoveDropFunc()
	arg0_52:RemoveScrollFunc()
	arg0_52:RemoveSelectFunc()
	arg0_52:RemoveUpdateSelectFunc()
	arg0_52:RemoveMoveFunc()
end

function ClearLScrollrect(arg0_53)
	arg0_53.onStart = nil
	arg0_53.onInitItem = nil
	arg0_53.onUpdateItem = nil
	arg0_53.onReturnItem = nil
end

function GetComponent(arg0_54, arg1_54)
	return (arg0_54:GetComponent(arg1_54))
end

function GetOrAddComponent(arg0_55, arg1_55)
	assert(arg0_55, "objectOrTransform not found: " .. debug.traceback())

	local var0_55 = arg1_55

	if type(arg1_55) == "string" then
		assert(_G[arg1_55], arg1_55 .. " not exist in Global")

		var0_55 = typeof(_G[arg1_55])
	end

	return LuaHelper.GetOrAddComponentForLua(arg0_55, var0_55)
end

function RemoveComponent(arg0_56, arg1_56)
	local var0_56 = arg0_56:GetComponent(arg1_56)

	if var0_56 then
		Object.Destroy(var0_56)
	end
end

function SetCompomentEnabled(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg0_57:GetComponent(arg1_57)

	assert(var0_57, "compoment not found")

	var0_57.enabled = tobool(arg2_57)
end

function GetInChildren(arg0_58, arg1_58)
	local function var0_58(arg0_59, arg1_59)
		if not arg0_59 then
			return nil
		end

		if arg0_59.name == arg1_59 then
			return arg0_59
		end

		for iter0_59 = 0, arg0_59.childCount - 1 do
			local var0_59 = arg0_59:GetChild(iter0_59)

			if arg1_59 == var0_59.name then
				return var0_59
			end

			local var1_59 = var0_58(var0_59, arg1_59)

			if var1_59 then
				return var1_59
			end
		end

		return nil
	end

	return var0_58(arg0_58, arg1_58)
end

function onNextTick(arg0_60)
	FrameTimer.New(arg0_60, 1, 1):Start()
end

function onDelayTick(arg0_61, arg1_61)
	Timer.New(arg0_61, arg1_61, 1):Start()
end

function seriesAsync(arg0_62, arg1_62, ...)
	local var0_62 = 0
	local var1_62 = #arg0_62
	local var2_62

	local function var3_62(...)
		var0_62 = var0_62 + 1

		if var0_62 <= var1_62 then
			arg0_62[var0_62](var3_62, ...)
		elseif var0_62 == var1_62 + 1 and arg1_62 then
			arg1_62(...)
		end
	end

	var3_62(...)
end

function seriesAsyncExtend(arg0_64, arg1_64, ...)
	local var0_64

	local function var1_64(...)
		if #arg0_64 > 0 then
			table.remove(arg0_64, 1)(var1_64, ...)
		elseif arg1_64 then
			arg1_64(...)
		end
	end

	var1_64(...)
end

function parallelAsync(arg0_66, arg1_66)
	local var0_66 = #arg0_66

	local function var1_66()
		var0_66 = var0_66 - 1

		if var0_66 == 0 and arg1_66 then
			arg1_66()
		end
	end

	if var0_66 > 0 then
		for iter0_66, iter1_66 in ipairs(arg0_66) do
			iter1_66(var1_66)
		end
	elseif arg1_66 then
		arg1_66()
	end
end

function limitedParallelAsync(arg0_68, arg1_68, arg2_68)
	local var0_68 = #arg0_68
	local var1_68 = var0_68

	if var1_68 == 0 then
		arg2_68()

		return
	end

	local var2_68 = math.min(arg1_68, var0_68)
	local var3_68

	local function var4_68()
		var1_68 = var1_68 - 1

		if var1_68 == 0 then
			arg2_68()
		elseif var2_68 + 1 <= var0_68 then
			var2_68 = var2_68 + 1

			arg0_68[var2_68](var4_68)
		end
	end

	for iter0_68 = 1, var2_68 do
		arg0_68[iter0_68](var4_68)
	end
end

function waitUntil(arg0_70, arg1_70)
	local var0_70

	var0_70 = FrameTimer.New(function()
		if arg0_70() then
			arg1_70()
			var0_70:Stop()

			return
		end
	end, 1, -1)

	var0_70:Start()

	return var0_70
end

function setImageSprite(arg0_72, arg1_72, arg2_72)
	if IsNil(arg0_72) then
		assert(false)

		return
	end

	local var0_72 = GetComponent(arg0_72, typeof(Image))

	if IsNil(var0_72) then
		return
	end

	var0_72.sprite = arg1_72

	if arg2_72 then
		var0_72:SetNativeSize()
	end
end

function clearImageSprite(arg0_73)
	GetComponent(arg0_73, typeof(Image)).sprite = nil
end

function getImageSprite(arg0_74)
	local var0_74 = GetComponent(arg0_74, typeof(Image))

	return var0_74 and var0_74.sprite
end

function tex2sprite(arg0_75)
	return UnityEngine.Sprite.Create(arg0_75, UnityEngine.Rect.New(0, 0, arg0_75.width, arg0_75.height), Vector2(0.5, 0.5), 100)
end

function setFillAmount(arg0_76, arg1_76)
	GetComponent(arg0_76, typeof(Image)).fillAmount = arg1_76
end

function string2vector3(arg0_77)
	local var0_77 = string.split(arg0_77, ",")

	return Vector3(var0_77[1], var0_77[2], var0_77[3])
end

function getToggleState(arg0_78)
	return arg0_78:GetComponent(typeof(Toggle)).isOn
end

function setLocalPosition(arg0_79, arg1_79)
	local var0_79 = tf(arg0_79).localPosition

	arg1_79.x = arg1_79.x or var0_79.x
	arg1_79.y = arg1_79.y or var0_79.y
	arg1_79.z = arg1_79.z or var0_79.z
	tf(arg0_79).localPosition = arg1_79
end

function setAnchoredPosition(arg0_80, arg1_80)
	local var0_80 = rtf(arg0_80)
	local var1_80 = var0_80.anchoredPosition

	arg1_80.x = arg1_80.x or var1_80.x
	arg1_80.y = arg1_80.y or var1_80.y
	var0_80.anchoredPosition = arg1_80
end

function setAnchoredPosition3D(arg0_81, arg1_81)
	local var0_81 = rtf(arg0_81)
	local var1_81 = var0_81.anchoredPosition3D

	arg1_81.x = arg1_81.x or var1_81.x
	arg1_81.y = arg1_81.y or var1_81.y
	arg1_81.z = arg1_81.y or var1_81.z
	var0_81.anchoredPosition3D = arg1_81
end

function getAnchoredPosition(arg0_82)
	return rtf(arg0_82).anchoredPosition
end

function setLocalScale(arg0_83, arg1_83)
	local var0_83 = tf(arg0_83).localScale

	arg1_83.x = arg1_83.x or var0_83.x
	arg1_83.y = arg1_83.y or var0_83.y
	arg1_83.z = arg1_83.z or var0_83.z
	tf(arg0_83).localScale = arg1_83
end

function setLocalRotation(arg0_84, arg1_84)
	local var0_84 = tf(arg0_84).localRotation

	arg1_84.x = arg1_84.x or var0_84.x
	arg1_84.y = arg1_84.y or var0_84.y
	arg1_84.z = arg1_84.z or var0_84.z
	tf(arg0_84).localRotation = arg1_84
end

function setLocalEulerAngles(arg0_85, arg1_85)
	local var0_85 = tf(arg0_85).localEulerAngles

	arg1_85.x = arg1_85.x or var0_85.x
	arg1_85.y = arg1_85.y or var0_85.y
	arg1_85.z = arg1_85.z or var0_85.z
	tf(arg0_85).localEulerAngles = arg1_85
end

function ActivateInputField(arg0_86)
	GetComponent(arg0_86, typeof(InputField)):ActivateInputField()
end

function onInputChanged(arg0_87, arg1_87, arg2_87)
	local var0_87 = GetComponent(arg1_87, typeof(InputField)).onValueChanged

	var0_87:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_87, var0_87)
	var0_87:AddListener(arg2_87)
end

function getImageColor(arg0_88)
	return GetComponent(arg0_88, typeof(Image)).color
end

function setImageColor(arg0_89, arg1_89)
	GetComponent(arg0_89, typeof(Image)).color = arg1_89
end

function getImageAlpha(arg0_90)
	return GetComponent(arg0_90, typeof(Image)).color.a
end

function setImageAlpha(arg0_91, arg1_91)
	local var0_91 = GetComponent(arg0_91, typeof(Image))
	local var1_91 = var0_91.color

	var1_91.a = arg1_91
	var0_91.color = var1_91
end

function getImageRaycastTarget(arg0_92)
	return GetComponent(arg0_92, typeof(Image)).raycastTarget
end

function setImageRaycastTarget(arg0_93, arg1_93)
	GetComponent(arg0_93, typeof(Image)).raycastTarget = tobool(arg1_93)
end

function getCanvasGroupAlpha(arg0_94)
	return GetComponent(arg0_94, typeof(CanvasGroup)).alpha
end

function setCanvasGroupAlpha(arg0_95, arg1_95)
	GetComponent(arg0_95, typeof(CanvasGroup)).alpha = arg1_95
end

function setActiveViaLayer(arg0_96, arg1_96)
	UIUtil.SetUIActiveViaLayer(go(arg0_96), arg1_96)
end

function setActiveViaCG(arg0_97, arg1_97)
	UIUtil.SetUIActiveViaCG(go(arg0_97), arg1_97)
end

function getTextColor(arg0_98)
	return GetComponent(arg0_98, typeof(Text)).color
end

function setTextColor(arg0_99, arg1_99)
	GetComponent(arg0_99, typeof(Text)).color = arg1_99
end

function getTextAlpha(arg0_100)
	return GetComponent(arg0_100, typeof(Text)).color.a
end

function setTextAlpha(arg0_101, arg1_101)
	local var0_101 = GetComponent(arg0_101, typeof(Text))
	local var1_101 = var0_101.color

	var1_101.a = arg1_101
	var0_101.color = var1_101
end

function setSizeDelta(arg0_102, arg1_102)
	local var0_102 = GetComponent(arg0_102, typeof(RectTransform))

	if not var0_102 then
		return
	end

	local var1_102 = var0_102.sizeDelta

	var1_102.x = arg1_102.x
	var1_102.y = arg1_102.y
	var0_102.sizeDelta = var1_102
end

function getOutlineColor(arg0_103)
	return GetComponent(arg0_103, typeof(Outline)).effectColor
end

function setOutlineColor(arg0_104, arg1_104)
	GetComponent(arg0_104, typeof(Outline)).effectColor = arg1_104
end

function pressPersistTrigger(arg0_105, arg1_105, arg2_105, arg3_105, arg4_105, arg5_105, arg6_105, arg7_105)
	arg6_105 = defaultValue(arg6_105, 0.25)

	assert(arg6_105 > 0, "maxSpeed less than zero")
	assert(arg0_105, "should exist objectOrTransform")

	local var0_105 = GetOrAddComponent(arg0_105, typeof(EventTriggerListener))

	assert(arg2_105, "should exist callback")

	local var1_105

	local function var2_105()
		if var1_105 then
			var1_105:Stop()

			var1_105 = nil

			existCall(arg3_105)
		end
	end

	var0_105:AddPointDownFunc(function()
		var1_105 = Timer.New(function()
			if arg5_105 then
				local var0_108 = math.max(var1_105.duration - arg1_105 / 10, arg6_105)

				var1_105.duration = var0_108
			end

			existCall(arg2_105, var2_105)
		end, arg1_105, -1)

		var1_105:Start()

		if arg4_105 then
			var1_105.func()
		end

		if arg7_105 and var1_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg7_105)
		end
	end)
	var0_105:AddPointUpFunc(var2_105)

	return var0_105
end

function getSpritePivot(arg0_109)
	local var0_109 = arg0_109.bounds
	local var1_109 = -var0_109.center.x / var0_109.extents.x / 2 + 0.5
	local var2_109 = -var0_109.center.y / var0_109.extents.y / 2 + 0.5

	return Vector2(var1_109, var2_109)
end

function resetAspectRatio(arg0_110)
	local var0_110 = GetComponent(arg0_110, "Image")

	GetComponent(arg0_110, "AspectRatioFitter").aspectRatio = var0_110.preferredWidth / var0_110.preferredHeight
end

function cloneTplTo(arg0_111, arg1_111, arg2_111)
	local var0_111 = tf(Instantiate(arg0_111))

	var0_111:SetParent(tf(arg1_111), false)
	SetActive(var0_111, true)

	if arg2_111 then
		var0_111.name = arg2_111
	end

	return var0_111
end

function setGray(arg0_112, arg1_112, arg2_112)
	if arg1_112 then
		local var0_112 = GetOrAddComponent(arg0_112, "UIGrayScale")

		var0_112.Recursive = defaultValue(arg2_112, true)
		var0_112.enabled = true
	else
		RemoveComponent(arg0_112, "UIGrayScale")
	end
end

function setBlackMask(arg0_113, arg1_113, arg2_113)
	if arg1_113 then
		arg2_113 = arg2_113 or {}

		local var0_113 = GetOrAddComponent(arg0_113, "UIMaterialAdjuster")

		var0_113.Recursive = tobool(defaultValue(arg2_113.recursive, true))

		local var1_113 = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit Colored_Alpha_UI"))

		var1_113:SetColor("_Color", arg2_113.color or Color(0, 0, 0, 0.2))

		var0_113.adjusterMaterial = var1_113
		var0_113.enabled = true
	else
		RemoveComponent(arg0_113, "UIMaterialAdjuster")
	end
end

function blockBlackMask(arg0_114, arg1_114, arg2_114)
	if arg1_114 then
		local var0_114 = GetOrAddComponent(arg0_114, "UIMaterialAdjuster")

		var0_114.Recursive = tobool(defaultValue(arg2_114, true))
		var0_114.enabled = false
	else
		RemoveComponent(arg0_114, "UIMaterialAdjuster")
	end
end

function long2int(arg0_115)
	local var0_115, var1_115 = int64.tonum2(arg0_115)

	return var0_115
end

function OnSliderWithButton(arg0_116, arg1_116, arg2_116)
	local var0_116 = arg1_116:GetComponent("Slider")

	var0_116.onValueChanged:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_116, var0_116.onValueChanged)
	var0_116.onValueChanged:AddListener(arg2_116)

	local var1_116 = (var0_116.maxValue - var0_116.minValue) * 0.1

	onButton(arg0_116, arg1_116:Find("up"), function()
		var0_116.value = math.clamp(var0_116.value + var1_116, var0_116.minValue, var0_116.maxValue)
	end, SFX_PANEL)
	onButton(arg0_116, arg1_116:Find("down"), function()
		var0_116.value = math.clamp(var0_116.value - var1_116, var0_116.minValue, var0_116.maxValue)
	end, SFX_PANEL)
end

function addSlip(arg0_119, arg1_119, arg2_119, arg3_119, arg4_119)
	local var0_119 = GetOrAddComponent(arg1_119, "EventTriggerListener")
	local var1_119
	local var2_119 = 0
	local var3_119 = 50

	var0_119:AddPointDownFunc(function()
		var2_119 = 0
		var1_119 = nil
	end)
	var0_119:AddDragFunc(function(arg0_121, arg1_121)
		local var0_121 = arg1_121.position

		if not var1_119 then
			var1_119 = var0_121
		end

		if arg0_119 == SLIP_TYPE_HRZ then
			var2_119 = var0_121.x - var1_119.x
		elseif arg0_119 == SLIP_TYPE_VERT then
			var2_119 = var0_121.y - var1_119.y
		end
	end)
	var0_119:AddPointUpFunc(function(arg0_122, arg1_122)
		if var2_119 < -var3_119 then
			if arg3_119 then
				arg3_119()
			end
		elseif var2_119 > var3_119 then
			if arg2_119 then
				arg2_119()
			end
		elseif arg4_119 then
			arg4_119()
		end
	end)
end

function getSizeRate()
	local var0_123 = pg.UIMgr.GetInstance().LevelMain.transform.rect
	local var1_123 = UnityEngine.Screen

	return Vector2.New(var0_123.width / var1_123.width, var0_123.height / var1_123.height), var0_123.width, var0_123.height
end

function IsUsingWifi()
	return Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaLocalAreaNetwork
end

function getSceneRootTFDic(arg0_125)
	local var0_125 = {}

	table.IpairsCArray(arg0_125:GetRootGameObjects(), function(arg0_126, arg1_126)
		var0_125[arg1_126.name] = arg1_126.transform
	end)

	return var0_125
end
