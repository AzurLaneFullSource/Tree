local var0_0 = class("GuideUIDuplicator")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.caches = {}
	arg0_1.root = arg1_1
end

function var0_0.Duplicate(arg0_2, arg1_2, arg2_2)
	local var0_2 = Object.Instantiate(arg1_2, arg0_2.root).transform

	setActive(var0_2, true)
	arg0_2:InitDuplication(var0_2, arg1_2, arg2_2)

	if arg2_2 then
		arg0_2:UpdateSettings(var0_2, arg1_2, arg2_2)
	end

	table.insert(arg0_2.caches, var0_2)

	return var0_2
end

local function var1_0(arg0_3)
	return arg0_3:GetComponent(typeof(Button)) ~= nil or arg0_3:GetComponent(typeof(Toggle)) ~= nil or arg0_3:GetComponent(typeof(EventTriggerListener)) ~= nil
end

local function var2_0(arg0_4)
	local var0_4 = arg0_4:GetComponent(typeof(Button))
	local var1_4 = arg0_4:GetComponentsInChildren(typeof(Button))

	for iter0_4 = 1, var1_4.Length do
		local var2_4 = var1_4[iter0_4 - 1]

		if var0_4 ~= var2_4 then
			var2_4.enabled = false
		end
	end

	local var3_4 = arg0_4:GetComponent(typeof(Toggle))
	local var4_4 = arg0_4:GetComponentsInChildren(typeof(Toggle))

	for iter1_4 = 1, var4_4.Length do
		local var5_4 = var4_4[iter1_4 - 1]

		if var3_4 ~= var5_4 then
			var5_4.enabled = false
		end
	end

	if var3_4 then
		setToggleEnabled(arg0_4, true)
	end
end

local function var3_0(arg0_5)
	if LeanTween.isTweening(arg0_5.gameObject) then
		LeanTween.cancel(arg0_5.gameObject)
	end

	eachChild(arg0_5, function(arg0_6)
		if LeanTween.isTweening(arg0_6.gameObject) then
			LeanTween.cancel(arg0_6.gameObject)
		end
	end)
end

local function var4_0(arg0_7)
	for iter0_7, iter1_7 in ipairs({
		Animator,
		Animation
	}) do
		local var0_7 = arg0_7:GetComponentsInChildren(typeof(iter1_7))

		for iter2_7 = 1, var0_7.Length do
			var0_7[iter2_7 - 1].enabled = false
		end
	end
end

function var0_0.InitDuplication(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg1_8:GetComponent(typeof(CanvasGroup))

	if var0_8 then
		var0_8.alpha = 1
	end

	local var1_8 = arg1_8:GetComponentInChildren(typeof(UnityEngine.UI.Graphic))

	if arg1_8:GetComponentInChildren(typeof(Canvas)) or var1_8 == nil then
		GetOrAddComponent(arg1_8, typeof(Image)).color = Color.New(1, 1, 1, 0)
	end

	if var1_8 and var1_8.raycastTarget == false then
		var1_8.raycastTarget = true
	end

	var4_0(arg1_8)

	if var1_0(arg1_8) or arg3_8.clearChildEvent then
		var2_0(arg1_8)
	end

	var3_0(arg1_8)

	if not arg3_8.keepScrollTxt then
		local var2_8 = arg1_8:GetComponentsInChildren(typeof(ScrollText))

		for iter0_8 = 1, var2_8.Length do
			local var3_8 = var2_8[iter0_8 - 1]

			setActive(var3_8.gameObject, false)
		end
	end

	if arg1_8:GetComponent(typeof(Canvas)) and arg1_8:GetComponent(typeof(GraphicRaycaster)) == nil then
		GetOrAddComponent(arg1_8, typeof(GraphicRaycaster))
	end

	arg1_8.anchorMax = arg1_8.pivot
	arg1_8.anchorMin = arg1_8.pivot
	arg1_8.sizeDelta = arg2_8.rect.size
end

function var0_0.UpdateSettings(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg3_9.customPosition then
		arg0_9:SetCustomPosition(arg1_9, arg2_9, arg3_9)
	else
		arg0_9:Syn(arg1_9, arg2_9, arg3_9)
	end

	if arg3_9.clearAllEvent then
		GetOrAddComponent(arg1_9, typeof(CanvasGroup)).blocksRaycasts = false
	end
end

function var0_0.SetCustomPosition(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg3_10.pos then
		arg1_10.localPosition = Vector3(arg3_10.pos.x, arg3_10.pos.y, arg3_10.pos.z or 0)
	elseif arg3_10.isLevelPoint then
		local var0_10 = pg.UIMgr.GetInstance().levelCameraComp
		local var1_10 = arg2_10.transform.parent:TransformPoint(arg2_10.transform.localPosition)
		local var2_10 = var0_10:WorldToScreenPoint(var1_10)
		local var3_10 = pg.UIMgr.GetInstance().overlayCameraComp

		arg1_10.localPosition = LuaHelper.ScreenToLocal(arg0_10.root, var2_10, var3_10)
	else
		arg1_10.position = arg2_10.transform.position
		arg1_10.localPosition = Vector3(arg1_10.localPosition.x, arg1_10.localPosition.y, 0)
	end

	local var4_10 = arg3_10.scale or 1

	arg1_10.localScale = Vector3(var4_10, var4_10, var4_10)
	arg1_10.eulerAngles = arg3_10.eulerAngles and Vector3(arg3_10.eulerAngles[1], arg3_10.eulerAngles[2], arg3_10.eulerAngles[3]) or Vector3(0, 0, 0)
end

local function var5_0(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11.root:InverseTransformPoint(arg2_11.transform.position)

	arg1_11.localPosition = Vector3(var0_11.x, var0_11.y, 0)

	local var1_11 = arg2_11.transform.localScale

	arg1_11.localScale = Vector3(var1_11.x, var1_11.y, var1_11.z)
end

local function var6_0(arg0_12, arg1_12, arg2_12)
	local var0_12
	local var1_12
	local var2_12 = arg2_12.image.isChild and arg1_12:Find(arg2_12.image.source) or GameObject.Find(arg2_12.image.source)

	if arg2_12.image.isRelative then
		var1_12 = arg2_12.image.target == "" and arg0_12 or arg0_12:Find(arg2_12.image.target)
	else
		var1_12 = GameObject.Find(arg2_12.image.target)
	end

	if IsNil(var2_12) or IsNil(var1_12) then
		return
	end

	local var3_12 = var2_12:GetComponent(typeof(Image))
	local var4_12 = var1_12:GetComponent(typeof(Image))

	if not var3_12 or not var4_12 then
		return
	end

	local var5_12 = var3_12.sprite
	local var6_12 = var4_12.sprite

	if var5_12 and var6_12 and var5_12 ~= var6_12 then
		var4_12.enabled = var3_12.enabled

		setImageSprite(var1_12, var5_12)
	end
end

function var0_0.Syn(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13:RemoveTimer()

	arg0_13.timer = Timer.New(function()
		var5_0(arg0_13, arg1_13, arg2_13, arg3_13)

		if arg3_13.image then
			var6_0(arg1_13, arg2_13, arg3_13)
		end
	end, 0.01, -1)

	arg0_13.timer:Start()
	arg0_13.timer.func()
end

function var0_0.RemoveTimer(arg0_15)
	if arg0_15.timer then
		arg0_15.timer:Stop()

		arg0_15.timer = nil
	end
end

function var0_0.Clear(arg0_16)
	if arg0_16.caches and #arg0_16.caches > 0 then
		for iter0_16, iter1_16 in ipairs(arg0_16.caches) do
			Object.Destroy(iter1_16.gameObject)
		end

		arg0_16.caches = {}
	end

	arg0_16:RemoveTimer()
end

return var0_0
