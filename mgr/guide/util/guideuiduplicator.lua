local var0 = class("GuideUIDuplicator")

function var0.Ctor(arg0, arg1)
	arg0.caches = {}
	arg0.root = arg1
end

function var0.Duplicate(arg0, arg1, arg2)
	local var0 = Object.Instantiate(arg1, arg0.root).transform

	setActive(var0, true)
	arg0:InitDuplication(var0, arg1, arg2)

	if arg2 then
		arg0:UpdateSettings(var0, arg1, arg2)
	end

	table.insert(arg0.caches, var0)

	return var0
end

local function var1(arg0)
	return arg0:GetComponent(typeof(Button)) ~= nil or arg0:GetComponent(typeof(Toggle)) ~= nil or arg0:GetComponent(typeof(EventTriggerListener)) ~= nil
end

local function var2(arg0)
	local var0 = arg0:GetComponent(typeof(Button))
	local var1 = arg0:GetComponentsInChildren(typeof(Button))

	for iter0 = 1, var1.Length do
		local var2 = var1[iter0 - 1]

		if var0 ~= var2 then
			var2.enabled = false
		end
	end

	local var3 = arg0:GetComponent(typeof(Toggle))
	local var4 = arg0:GetComponentsInChildren(typeof(Toggle))

	for iter1 = 1, var4.Length do
		local var5 = var4[iter1 - 1]

		if var3 ~= var5 then
			var5.enabled = false
		end
	end

	if var3 then
		setToggleEnabled(arg0, true)
	end
end

local function var3(arg0)
	if LeanTween.isTweening(arg0.gameObject) then
		LeanTween.cancel(arg0.gameObject)
	end

	eachChild(arg0, function(arg0)
		if LeanTween.isTweening(arg0.gameObject) then
			LeanTween.cancel(arg0.gameObject)
		end
	end)
end

function var0.InitDuplication(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetComponent(typeof(CanvasGroup))

	if var0 then
		var0.alpha = 1
	end

	local var1 = arg1:GetComponentInChildren(typeof(UnityEngine.UI.Graphic))

	if arg1:GetComponentInChildren(typeof(Canvas)) or var1 == nil then
		GetOrAddComponent(arg1, typeof(Image)).color = Color.New(1, 1, 1, 0)
	end

	if var1 and var1.raycastTarget == false then
		var1.raycastTarget = true
	end

	local var2 = arg1:GetComponent(typeof(Animator))

	if var2 then
		var2.enabled = false
	end

	if var1(arg1) or arg3.clearChildEvent then
		var2(arg1)
	end

	var3(arg1)

	if not arg3.keepScrollTxt then
		local var3 = arg1:GetComponentsInChildren(typeof(ScrollText))

		for iter0 = 1, var3.Length do
			local var4 = var3[iter0 - 1]

			setActive(var4.gameObject, false)
		end
	end

	if arg1:GetComponent(typeof(Canvas)) and arg1:GetComponent(typeof(GraphicRaycaster)) == nil then
		GetOrAddComponent(arg1, typeof(GraphicRaycaster))
	end

	arg1.sizeDelta = arg2.sizeDelta
end

function var0.UpdateSettings(arg0, arg1, arg2, arg3)
	if arg3.customPosition then
		arg0:SetCustomPosition(arg1, arg2, arg3)
	else
		arg0:Syn(arg1, arg2, arg3)
	end

	if arg3.clearAllEvent then
		GetOrAddComponent(arg1, typeof(CanvasGroup)).blocksRaycasts = false
	end
end

function var0.SetCustomPosition(arg0, arg1, arg2, arg3)
	if arg3.pos then
		arg1.localPosition = Vector3(arg3.pos.x, arg3.pos.y, arg3.pos.z or 0)
	elseif arg3.isLevelPoint then
		local var0 = pg.UIMgr.GetInstance().levelCameraComp
		local var1 = arg2.transform.parent:TransformPoint(arg2.transform.localPosition)
		local var2 = var0:WorldToScreenPoint(var1)
		local var3 = pg.UIMgr.GetInstance().overlayCameraComp

		arg1.localPosition = LuaHelper.ScreenToLocal(arg0.root, var2, var3)
	else
		arg1.position = arg2.transform.position
		arg1.localPosition = Vector3(arg1.localPosition.x, arg1.localPosition.y, 0)
	end

	local var4 = arg3.scale or 1

	arg1.localScale = Vector3(var4, var4, var4)
	arg1.eulerAngles = arg3.eulerAngles and Vector3(arg3.eulerAngles[1], arg3.eulerAngles[2], arg3.eulerAngles[3]) or Vector3(0, 0, 0)
end

local function var4(arg0, arg1, arg2, arg3)
	local var0 = arg0.root:InverseTransformPoint(arg2.transform.position)

	arg1.localPosition = Vector3(var0.x, var0.y, 0)

	local var1 = arg2.transform.localScale

	arg1.localScale = Vector3(var1.x, var1.y, var1.z)
end

local function var5(arg0, arg1, arg2)
	local var0
	local var1
	local var2 = arg2.image.isChild and arg1:Find(arg2.image.source) or GameObject.Find(arg2.image.source)

	if arg2.image.isRelative then
		var1 = arg2.image.target == "" and arg0 or arg0:Find(arg2.image.target)
	else
		var1 = GameObject.Find(arg2.image.target)
	end

	if IsNil(var2) or IsNil(var1) then
		return
	end

	local var3 = var2:GetComponent(typeof(Image))
	local var4 = var1:GetComponent(typeof(Image))

	if not var3 or not var4 then
		return
	end

	local var5 = var3.sprite
	local var6 = var4.sprite

	if var5 and var6 and var5 ~= var6 then
		var4.enabled = var3.enabled

		setImageSprite(var1, var5)
	end
end

function var0.Syn(arg0, arg1, arg2, arg3)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		var4(arg0, arg1, arg2, arg3)

		if arg3.image then
			var5(arg1, arg2, arg3)
		end
	end, 0.01, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Clear(arg0)
	if arg0.caches and #arg0.caches > 0 then
		for iter0, iter1 in ipairs(arg0.caches) do
			Object.Destroy(iter1.gameObject)
		end

		arg0.caches = {}
	end

	arg0:RemoveTimer()
end

return var0
