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

function var0_0.InitDuplication(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg1_7:GetComponent(typeof(CanvasGroup))

	if var0_7 then
		var0_7.alpha = 1
	end

	local var1_7 = arg1_7:GetComponentInChildren(typeof(UnityEngine.UI.Graphic))

	if arg1_7:GetComponentInChildren(typeof(Canvas)) or var1_7 == nil then
		GetOrAddComponent(arg1_7, typeof(Image)).color = Color.New(1, 1, 1, 0)
	end

	if var1_7 and var1_7.raycastTarget == false then
		var1_7.raycastTarget = true
	end

	local var2_7 = arg1_7:GetComponent(typeof(Animator))

	if var2_7 then
		var2_7.enabled = false
	end

	if var1_0(arg1_7) or arg3_7.clearChildEvent then
		var2_0(arg1_7)
	end

	var3_0(arg1_7)

	if not arg3_7.keepScrollTxt then
		local var3_7 = arg1_7:GetComponentsInChildren(typeof(ScrollText))

		for iter0_7 = 1, var3_7.Length do
			local var4_7 = var3_7[iter0_7 - 1]

			setActive(var4_7.gameObject, false)
		end
	end

	if arg1_7:GetComponent(typeof(Canvas)) and arg1_7:GetComponent(typeof(GraphicRaycaster)) == nil then
		GetOrAddComponent(arg1_7, typeof(GraphicRaycaster))
	end

	arg1_7.sizeDelta = arg2_7.sizeDelta
end

function var0_0.UpdateSettings(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg3_8.customPosition then
		arg0_8:SetCustomPosition(arg1_8, arg2_8, arg3_8)
	else
		arg0_8:Syn(arg1_8, arg2_8, arg3_8)
	end

	if arg3_8.clearAllEvent then
		GetOrAddComponent(arg1_8, typeof(CanvasGroup)).blocksRaycasts = false
	end
end

function var0_0.SetCustomPosition(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg3_9.pos then
		arg1_9.localPosition = Vector3(arg3_9.pos.x, arg3_9.pos.y, arg3_9.pos.z or 0)
	elseif arg3_9.isLevelPoint then
		local var0_9 = pg.UIMgr.GetInstance().levelCameraComp
		local var1_9 = arg2_9.transform.parent:TransformPoint(arg2_9.transform.localPosition)
		local var2_9 = var0_9:WorldToScreenPoint(var1_9)
		local var3_9 = pg.UIMgr.GetInstance().overlayCameraComp

		arg1_9.localPosition = LuaHelper.ScreenToLocal(arg0_9.root, var2_9, var3_9)
	else
		arg1_9.position = arg2_9.transform.position
		arg1_9.localPosition = Vector3(arg1_9.localPosition.x, arg1_9.localPosition.y, 0)
	end

	local var4_9 = arg3_9.scale or 1

	arg1_9.localScale = Vector3(var4_9, var4_9, var4_9)
	arg1_9.eulerAngles = arg3_9.eulerAngles and Vector3(arg3_9.eulerAngles[1], arg3_9.eulerAngles[2], arg3_9.eulerAngles[3]) or Vector3(0, 0, 0)
end

local function var4_0(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg0_10.root:InverseTransformPoint(arg2_10.transform.position)

	arg1_10.localPosition = Vector3(var0_10.x, var0_10.y, 0)

	local var1_10 = arg2_10.transform.localScale

	arg1_10.localScale = Vector3(var1_10.x, var1_10.y, var1_10.z)
end

local function var5_0(arg0_11, arg1_11, arg2_11)
	local var0_11
	local var1_11
	local var2_11 = arg2_11.image.isChild and arg1_11:Find(arg2_11.image.source) or GameObject.Find(arg2_11.image.source)

	if arg2_11.image.isRelative then
		var1_11 = arg2_11.image.target == "" and arg0_11 or arg0_11:Find(arg2_11.image.target)
	else
		var1_11 = GameObject.Find(arg2_11.image.target)
	end

	if IsNil(var2_11) or IsNil(var1_11) then
		return
	end

	local var3_11 = var2_11:GetComponent(typeof(Image))
	local var4_11 = var1_11:GetComponent(typeof(Image))

	if not var3_11 or not var4_11 then
		return
	end

	local var5_11 = var3_11.sprite
	local var6_11 = var4_11.sprite

	if var5_11 and var6_11 and var5_11 ~= var6_11 then
		var4_11.enabled = var3_11.enabled

		setImageSprite(var1_11, var5_11)
	end
end

function var0_0.Syn(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12:RemoveTimer()

	arg0_12.timer = Timer.New(function()
		var4_0(arg0_12, arg1_12, arg2_12, arg3_12)

		if arg3_12.image then
			var5_0(arg1_12, arg2_12, arg3_12)
		end
	end, 0.01, -1)

	arg0_12.timer:Start()
	arg0_12.timer.func()
end

function var0_0.RemoveTimer(arg0_14)
	if arg0_14.timer then
		arg0_14.timer:Stop()

		arg0_14.timer = nil
	end
end

function var0_0.Clear(arg0_15)
	if arg0_15.caches and #arg0_15.caches > 0 then
		for iter0_15, iter1_15 in ipairs(arg0_15.caches) do
			Object.Destroy(iter1_15.gameObject)
		end

		arg0_15.caches = {}
	end

	arg0_15:RemoveTimer()
end

return var0_0
