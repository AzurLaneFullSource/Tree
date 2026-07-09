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

function Instantiate(arg0_6, ...)
	return Object.Instantiate(go(arg0_6), ...)
end

instantiate = Instantiate

function Destroy(arg0_7)
	Object.Destroy(go(arg0_7))
end

destroy = Destroy

function SetActive(arg0_8, arg1_8)
	if arg0_8 == nil then
		print("<color=red>SetActive Object is NIL!!!!</color>")

		return
	end

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
	local var0_29 = arg0_29:GetComponentsInChildren(typeof(Button)):ToTable()

	for iter0_29, iter1_29 in ipairs(var0_29) do
		if iter1_29 ~= nil then
			iter1_29.onClick:RemoveAllListeners()
		end
	end
end

function ClearAllText(arg0_30)
	local var0_30 = arg0_30:GetComponentsInChildren(typeof(Text)):ToTable()

	for iter0_30, iter1_30 in ipairs(var0_30) do
		if iter1_30 ~= nil then
			iter1_30.text = ""
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
		arg1_45(var0_45:GetChild(iter0_45), iter0_45)
	end
end

function removeAllChildren(arg0_46)
	eachChild(arg0_46, function(arg0_47)
		tf(arg0_47).transform:SetParent(nil, false)
		Destroy(arg0_47)
	end)
end

function scrollToIndex(arg0_48, arg1_48)
	Canvas.ForceUpdateCanvases()

	local var0_48 = GetComponent(arg0_48, typeof(ScrollRect))
	local var1_48 = var0_48.viewport.rect
	local var2_48 = var0_48.content.rect
	local var3_48 = Vector2(math.max(var2_48.width - var1_48.width, 0), math.max(var2_48.height - var1_48.height, 0))

	if var3_48 == Vector2.zero then
		scrollTo(arg0_48, 0, 0)
	else
		local var4_48 = var0_48.content:GetChild(arg1_48 - 1)
		local var5_48 = var4_48.rect
		local var6_48 = (var5_48.x + var4_48.localPosition.x) / var3_48.x
		local var7_48 = 1 + (var5_48.y + var5_48.height + var4_48.localPosition.y - (var2_48.y + var2_48.height)) / var3_48.y

		scrollTo(arg0_48, math.clamp(var6_48, 0, 1), math.clamp(var7_48, 0, 1))
	end
end

function scrollTo(arg0_49, arg1_49, arg2_49)
	Canvas.ForceUpdateCanvases()

	local var0_49 = GetComponent(arg0_49, typeof(ScrollRect))
	local var1_49 = Vector2(var0_49.horizontal and arg1_49 or var0_49.normalizedPosition.x, var0_49.vertical and arg2_49 or var0_49.normalizedPosition.y)

	onNextTick(function()
		if not IsNil(arg0_49) then
			var0_49.normalizedPosition = var1_49

			var0_49.onValueChanged:Invoke(var1_49)
		end
	end)
end

function scrollToBottom(arg0_51)
	scrollTo(arg0_51, 0, 0)
end

function onScroll(arg0_52, arg1_52, arg2_52)
	local var0_52 = GetComponent(arg1_52, typeof(ScrollRect)).onValueChanged

	assert(arg2_52, "callback should exist")
	var0_52:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_52, var0_52)
	var0_52:AddListener(arg2_52)
end

function ClearEventTrigger(arg0_53)
	arg0_53:RemovePointClickFunc()
	arg0_53:RemovePointDownFunc()
	arg0_53:RemovePointEnterFunc()
	arg0_53:RemovePointExitFunc()
	arg0_53:RemovePointUpFunc()
	arg0_53:RemoveCheckDragFunc()
	arg0_53:RemoveBeginDragFunc()
	arg0_53:RemoveDragFunc()
	arg0_53:RemoveDragEndFunc()
	arg0_53:RemoveDropFunc()
	arg0_53:RemoveScrollFunc()
	arg0_53:RemoveSelectFunc()
	arg0_53:RemoveUpdateSelectFunc()
	arg0_53:RemoveMoveFunc()
end

function ClearLScrollrect(arg0_54)
	if not arg0_54 then
		return
	end

	arg0_54.onStart = nil
	arg0_54.onInitItem = nil
	arg0_54.onUpdateItem = nil
	arg0_54.onReturnItem = nil
end

function GetComponent(arg0_55, arg1_55)
	return (arg0_55:GetComponent(arg1_55))
end

function GetOrAddComponent(arg0_56, arg1_56)
	assert(arg0_56, "objectOrTransform not found: " .. debug.traceback())

	local var0_56 = arg1_56

	if type(arg1_56) == "string" then
		assert(_G[arg1_56], arg1_56 .. " not exist in Global")

		var0_56 = typeof(_G[arg1_56])
	end

	return LuaHelper.GetOrAddComponentForLua(arg0_56, var0_56)
end

function RemoveComponent(arg0_57, arg1_57)
	local var0_57 = arg0_57:GetComponent(arg1_57)

	if var0_57 then
		Object.Destroy(var0_57)
	end
end

function SetComponentEnabled(arg0_58, arg1_58, arg2_58)
	local var0_58 = arg0_58:GetComponent(arg1_58)

	assert(var0_58, "compoment not found")

	var0_58.enabled = tobool(arg2_58)
end

SetCompomentEnabled = SetComponentEnabled

function GetInChildren(arg0_59, arg1_59)
	local function var0_59(arg0_60, arg1_60)
		if not arg0_60 then
			return nil
		end

		if arg0_60.name == arg1_60 then
			return arg0_60
		end

		for iter0_60 = 0, arg0_60.childCount - 1 do
			local var0_60 = arg0_60:GetChild(iter0_60)

			if arg1_60 == var0_60.name then
				return var0_60
			end

			local var1_60 = var0_59(var0_60, arg1_60)

			if var1_60 then
				return var1_60
			end
		end

		return nil
	end

	return var0_59(arg0_59, arg1_59)
end

function onNextTick(arg0_61)
	FrameTimer.New(arg0_61, 1, 1):Start()
end

function onDelayTick(arg0_62, arg1_62)
	local var0_62 = Timer.New(arg0_62, arg1_62, 1)

	var0_62:Start()

	return var0_62
end

function seriesAsync(arg0_63, arg1_63, ...)
	local var0_63 = 0
	local var1_63 = #arg0_63
	local var2_63

	local function var3_63(...)
		var0_63 = var0_63 + 1

		if var0_63 <= var1_63 then
			arg0_63[var0_63](var3_63, ...)
		elseif var0_63 == var1_63 + 1 and arg1_63 then
			arg1_63(...)
		end
	end

	var3_63(...)
end

function seriesAsyncExtend(arg0_65, arg1_65, ...)
	local var0_65

	local function var1_65(...)
		if #arg0_65 > 0 then
			table.remove(arg0_65, 1)(var1_65, ...)
		elseif arg1_65 then
			arg1_65(...)
		end
	end

	var1_65(...)
end

function parallelAsync(arg0_67, arg1_67)
	local var0_67 = #arg0_67

	local function var1_67()
		var0_67 = var0_67 - 1

		if var0_67 == 0 and arg1_67 then
			arg1_67()
		end
	end

	if var0_67 > 0 then
		for iter0_67, iter1_67 in ipairs(arg0_67) do
			iter1_67(var1_67)
		end
	elseif arg1_67 then
		arg1_67()
	end
end

function limitedParallelAsync(arg0_69, arg1_69, arg2_69)
	local var0_69 = #arg0_69
	local var1_69 = var0_69

	if var1_69 == 0 then
		arg2_69()

		return
	end

	local var2_69 = math.min(arg1_69, var0_69)
	local var3_69

	local function var4_69()
		var1_69 = var1_69 - 1

		if var1_69 == 0 then
			arg2_69()
		elseif var2_69 + 1 <= var0_69 then
			var2_69 = var2_69 + 1

			arg0_69[var2_69](var4_69)
		end
	end

	for iter0_69 = 1, var2_69 do
		arg0_69[iter0_69](var4_69)
	end
end

function waitUntil(arg0_71, arg1_71)
	local var0_71

	var0_71 = FrameTimer.New(function()
		if arg0_71() then
			arg1_71()
			var0_71:Stop()

			return
		end
	end, 1, -1)

	var0_71:Start()

	return var0_71
end

function setImageSprite(arg0_73, arg1_73, arg2_73)
	if IsNil(arg0_73) then
		assert(false)

		return
	end

	local var0_73 = GetComponent(arg0_73, typeof(Image))

	if IsNil(var0_73) then
		return
	end

	var0_73.sprite = arg1_73

	if arg2_73 then
		var0_73:SetNativeSize()
	end
end

function clearImageSprite(arg0_74)
	GetComponent(arg0_74, typeof(Image)).sprite = nil
end

function getImageSprite(arg0_75)
	local var0_75 = GetComponent(arg0_75, typeof(Image))

	return var0_75 and var0_75.sprite
end

function tex2sprite(arg0_76)
	return UnityEngine.Sprite.Create(arg0_76, UnityEngine.Rect.New(0, 0, arg0_76.width, arg0_76.height), Vector2(0.5, 0.5), 100)
end

function setFillAmount(arg0_77, arg1_77)
	GetComponent(arg0_77, typeof(Image)).fillAmount = arg1_77
end

function string2vector3(arg0_78)
	local var0_78 = string.split(arg0_78, ",")

	return Vector3(var0_78[1], var0_78[2], var0_78[3])
end

function getToggleState(arg0_79)
	return arg0_79:GetComponent(typeof(Toggle)).isOn
end

function setLocalPosition(arg0_80, arg1_80)
	local var0_80 = tf(arg0_80).localPosition

	arg1_80.x = arg1_80.x or var0_80.x
	arg1_80.y = arg1_80.y or var0_80.y
	arg1_80.z = arg1_80.z or var0_80.z
	tf(arg0_80).localPosition = arg1_80
end

function setAnchoredPosition(arg0_81, arg1_81)
	local var0_81 = rtf(arg0_81)
	local var1_81 = var0_81.anchoredPosition

	arg1_81.x = arg1_81.x or var1_81.x
	arg1_81.y = arg1_81.y or var1_81.y
	var0_81.anchoredPosition = arg1_81
end

function setAnchoredPosition3D(arg0_82, arg1_82)
	local var0_82 = rtf(arg0_82)
	local var1_82 = var0_82.anchoredPosition3D

	arg1_82.x = arg1_82.x or var1_82.x
	arg1_82.y = arg1_82.y or var1_82.y
	arg1_82.z = arg1_82.y or var1_82.z
	var0_82.anchoredPosition3D = arg1_82
end

function getAnchoredPosition(arg0_83)
	return rtf(arg0_83).anchoredPosition
end

function setLocalScale(arg0_84, arg1_84)
	local var0_84 = tf(arg0_84).localScale

	arg1_84.x = arg1_84.x or var0_84.x
	arg1_84.y = arg1_84.y or var0_84.y
	arg1_84.z = arg1_84.z or var0_84.z
	tf(arg0_84).localScale = arg1_84
end

function setLocalRotation(arg0_85, arg1_85)
	local var0_85 = tf(arg0_85).localRotation

	arg1_85.x = arg1_85.x or var0_85.x
	arg1_85.y = arg1_85.y or var0_85.y
	arg1_85.z = arg1_85.z or var0_85.z
	tf(arg0_85).localRotation = arg1_85
end

function setLocalEulerAngles(arg0_86, arg1_86)
	local var0_86 = tf(arg0_86).localEulerAngles

	arg1_86.x = arg1_86.x or var0_86.x
	arg1_86.y = arg1_86.y or var0_86.y
	arg1_86.z = arg1_86.z or var0_86.z
	tf(arg0_86).localEulerAngles = arg1_86
end

function ActivateInputField(arg0_87)
	GetComponent(arg0_87, typeof(InputField)):ActivateInputField()
end

function onInputChanged(arg0_88, arg1_88, arg2_88)
	local var0_88 = GetComponent(arg1_88, typeof(InputField)).onValueChanged

	var0_88:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_88, var0_88)
	var0_88:AddListener(arg2_88)
end

function getImageColor(arg0_89)
	return GetComponent(arg0_89, typeof(Image)).color
end

function setImageColor(arg0_90, arg1_90)
	GetComponent(arg0_90, typeof(Image)).color = arg1_90
end

function getImageAlpha(arg0_91)
	return GetComponent(arg0_91, typeof(Image)).color.a
end

function setImageAlpha(arg0_92, arg1_92)
	local var0_92 = GetComponent(arg0_92, typeof(Image))
	local var1_92 = var0_92.color

	var1_92.a = arg1_92
	var0_92.color = var1_92
end

function getImageRaycastTarget(arg0_93)
	return GetComponent(arg0_93, typeof(Image)).raycastTarget
end

function setImageRaycastTarget(arg0_94, arg1_94)
	GetComponent(arg0_94, typeof(Image)).raycastTarget = tobool(arg1_94)
end

function getCanvasGroupAlpha(arg0_95)
	return GetOrAddComponent(arg0_95, typeof(CanvasGroup)).alpha
end

function setCanvasGroupAlpha(arg0_96, arg1_96)
	GetOrAddComponent(arg0_96, typeof(CanvasGroup)).alpha = arg1_96
end

function setActiveByCanvasGroup(arg0_97, arg1_97)
	local var0_97 = GetOrAddComponent(arg0_97, typeof(CanvasGroup))

	var0_97.alpha = arg1_97 and 1 or 0
	var0_97.blocksRaycasts = arg1_97
end

function setActiveViaLayer(arg0_98, arg1_98)
	HotfixHelper.SetUIActiveViaLayer(go(arg0_98), arg1_98)
end

function getTextColor(arg0_99)
	return GetComponent(arg0_99, typeof(Text)).color
end

function setTextColor(arg0_100, arg1_100)
	GetComponent(arg0_100, typeof(Text)).color = arg1_100
end

function getTextAlpha(arg0_101)
	return GetComponent(arg0_101, typeof(Text)).color.a
end

function setTextAlpha(arg0_102, arg1_102)
	local var0_102 = GetComponent(arg0_102, typeof(Text))
	local var1_102 = var0_102.color

	var1_102.a = arg1_102
	var0_102.color = var1_102
end

function setSizeDelta(arg0_103, arg1_103)
	local var0_103 = GetComponent(arg0_103, typeof(RectTransform))

	if not var0_103 then
		return
	end

	local var1_103 = var0_103.sizeDelta

	var1_103.x = arg1_103.x or var1_103.x
	var1_103.y = arg1_103.y or var1_103.y
	var0_103.sizeDelta = var1_103
end

function getOutlineColor(arg0_104)
	return GetComponent(arg0_104, typeof(Outline)).effectColor
end

function setOutlineColor(arg0_105, arg1_105)
	GetComponent(arg0_105, typeof(Outline)).effectColor = arg1_105
end

function pressPersistTrigger(arg0_106, arg1_106, arg2_106, arg3_106, arg4_106, arg5_106, arg6_106, arg7_106)
	arg6_106 = defaultValue(arg6_106, 0.25)

	assert(arg6_106 > 0, "maxSpeed less than zero")
	assert(arg0_106, "should exist objectOrTransform")

	local var0_106 = GetOrAddComponent(arg0_106, typeof(EventTriggerListener))

	assert(arg2_106, "should exist callback")

	local var1_106

	local function var2_106()
		if var1_106 then
			var1_106:Stop()

			var1_106 = nil

			existCall(arg3_106)
		end
	end

	var0_106:AddPointDownFunc(function()
		var1_106 = Timer.New(function()
			if arg5_106 then
				local var0_109 = math.max(var1_106.duration - arg1_106 / 10, arg6_106)

				var1_106.duration = var0_109
			end

			existCall(arg2_106, var2_106)
		end, arg1_106, -1)

		var1_106:Start()

		if arg4_106 then
			var1_106.func()
		end

		if arg7_106 and var1_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg7_106)
		end
	end)
	var0_106:AddPointUpFunc(var2_106)

	return var0_106
end

function getSpritePivot(arg0_110)
	local var0_110 = arg0_110.bounds
	local var1_110 = -var0_110.center.x / var0_110.extents.x / 2 + 0.5
	local var2_110 = -var0_110.center.y / var0_110.extents.y / 2 + 0.5

	return Vector2(var1_110, var2_110)
end

function resetAspectRatio(arg0_111)
	local var0_111 = GetComponent(arg0_111, "Image")

	GetComponent(arg0_111, "AspectRatioFitter").aspectRatio = var0_111.preferredWidth / var0_111.preferredHeight
end

function cloneTplTo(arg0_112, arg1_112, arg2_112)
	local var0_112 = tf(Instantiate(arg0_112))

	var0_112:SetParent(tf(arg1_112), false)
	SetActive(var0_112, true)

	if arg2_112 then
		var0_112.name = arg2_112
	end

	return var0_112
end

function setGray(arg0_113, arg1_113, arg2_113)
	if arg1_113 then
		local var0_113 = GetOrAddComponent(arg0_113, "UIGrayScale")

		var0_113.Recursive = defaultValue(arg2_113, true)
		var0_113.enabled = true
	else
		RemoveComponent(arg0_113, "UIGrayScale")
	end
end

function setBlackMask(arg0_114, arg1_114, arg2_114)
	if arg1_114 then
		arg2_114 = setmetatable(arg2_114 or {}, {
			__index = {
				recursive = true,
				color = Color(0, 0, 0, 0.2)
			}
		})

		local var0_114 = GetOrAddComponent(arg0_114, "UIMaterialAdjuster")

		var0_114.Recursive = arg2_114.recursive

		local var1_114 = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit Colored_Alpha_UI"))

		var1_114:SetColor("_Color", arg2_114.color)

		var0_114.adjusterMaterial = var1_114
		var0_114.enabled = true
	else
		RemoveComponent(arg0_114, "UIMaterialAdjuster")
	end
end

function blockBlackMask(arg0_115, arg1_115, arg2_115)
	if arg1_115 then
		local var0_115 = GetOrAddComponent(arg0_115, "UIMaterialAdjuster")

		var0_115.Recursive = tobool(defaultValue(arg2_115, true))
		var0_115.enabled = false
	else
		RemoveComponent(arg0_115, "UIMaterialAdjuster")
	end
end

function long2int(arg0_116)
	local var0_116, var1_116 = int64.tonum2(arg0_116)

	return var0_116
end

function OnSliderWithButton(arg0_117, arg1_117, arg2_117)
	local var0_117 = arg1_117:GetComponent("Slider")

	var0_117.onValueChanged:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_117, var0_117.onValueChanged)
	var0_117.onValueChanged:AddListener(arg2_117)

	local var1_117 = (var0_117.maxValue - var0_117.minValue) * 0.1

	onButton(arg0_117, arg1_117:Find("up"), function()
		var0_117.value = math.clamp(var0_117.value + var1_117, var0_117.minValue, var0_117.maxValue)
	end, SFX_PANEL)
	onButton(arg0_117, arg1_117:Find("down"), function()
		var0_117.value = math.clamp(var0_117.value - var1_117, var0_117.minValue, var0_117.maxValue)
	end, SFX_PANEL)
end

function addSlip(arg0_120, arg1_120, arg2_120, arg3_120, arg4_120)
	local var0_120 = GetOrAddComponent(arg1_120, "EventTriggerListener")
	local var1_120
	local var2_120 = 0
	local var3_120 = 50

	var0_120:AddPointDownFunc(function()
		var2_120 = 0
		var1_120 = nil
	end)
	var0_120:AddDragFunc(function(arg0_122, arg1_122)
		local var0_122 = arg1_122.position

		if not var1_120 then
			var1_120 = var0_122
		end

		if arg0_120 == SLIP_TYPE_HRZ then
			var2_120 = var0_122.x - var1_120.x
		elseif arg0_120 == SLIP_TYPE_VERT then
			var2_120 = var0_122.y - var1_120.y
		end
	end)
	var0_120:AddPointUpFunc(function(arg0_123, arg1_123)
		if var2_120 < -var3_120 then
			if arg3_120 then
				arg3_120()
			end
		elseif var2_120 > var3_120 then
			if arg2_120 then
				arg2_120()
			end
		elseif arg4_120 then
			arg4_120()
		end
	end)
end

function getSizeRate()
	local var0_124 = pg.UIMgr.GetInstance().LevelMain.transform.rect
	local var1_124 = UnityEngine.Screen

	return Vector2.New(var0_124.width / var1_124.width, var0_124.height / var1_124.height), var0_124.width, var0_124.height
end

function IsUsingWifi()
	return Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaLocalAreaNetwork
end

function getSceneRootTFDic(arg0_126)
	local var0_126 = {}

	for iter0_126, iter1_126 in ipairs(arg0_126:GetRootGameObjects():ToTable()) do
		var0_126[iter1_126.name] = iter1_126.transform
	end

	return var0_126
end

function bindComponent(arg0_127, arg1_127)
	local var0_127 = tf(arg1_127):GetComponent(typeof(ComponentBinding))

	if var0_127 == nil then
		return
	end

	local var1_127 = var0_127:GetLuaNames():ToTable()
	local var2_127 = var0_127:GetComponentValues():ToTable()

	for iter0_127, iter1_127 in ipairs(var1_127) do
		arg0_127[iter1_127] = var2_127[iter0_127]
	end
end
