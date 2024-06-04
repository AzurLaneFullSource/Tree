local var0 = class("CourtYardFurnitureJob")
local var1 = 0
local var2 = 1
local var3 = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0.poolMgr = arg1
	arg0.state = var1
	arg0.callback = arg2
	arg0.rollBacks = {}
end

function var0.IsWorking(arg0)
	return arg0.state == var2
end

function var0.InstantiateObj(arg0, arg1, arg2)
	local var0 = Object.Instantiate(arg1, arg2)

	table.insert(arg0.rollBacks, var0)

	return var0
end

function var0.CloneTplTo(arg0, arg1, arg2, arg3)
	local var0 = Object.Instantiate(arg1, arg2).transform

	if arg3 then
		var0.name = arg3
	end

	return var0
end

function var0.Work(arg0, arg1, arg2)
	arg0.id = arg2.id

	if arg1:IsExit() then
		arg0:FinishWork(false)

		return
	end

	arg0.state = var2

	local var0 = arg1._tf

	arg0.module = arg1

	local function var1()
		if arg1:IsExit() then
			arg0:FinishWork(false)
		else
			arg1:Init(var0)
			arg0:FinishWork(true)
		end
	end

	local function var2()
		arg1:OnIconLoaed()
	end

	arg0.rollBacks = {}

	if arg2:IsSpine() then
		arg0:LoadSpine(var0, arg2, var1, var2)
	else
		arg0:Load(var0, arg2, var1, var2)
	end
end

local function var4(arg0, arg1, arg2, arg3)
	ResourceMgr.Inst:getAssetAsync("furnitrues/" .. arg2:GetPicture(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0:IsStop() or IsNil(arg1) or IsNil(arg0) then
			arg0:OnStop()

			return
		end

		local var0 = arg0:InstantiateObj(arg0, arg1).transform

		var0.name = "icon"

		var0:SetSiblingIndex(1)

		var0.anchorMin = var0.pivot
		var0.anchorMax = var0.pivot

		arg0:AdjustModel(arg1, var0.sizeDelta, var0.pivot)
		arg3()
	end), true, true)
end

local function var5(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetMaskNames()
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var1, function(arg0)
			ResourceMgr.Inst:getAssetAsync("furnitrues/" .. iter1, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0:IsStop() or IsNil(arg1) or IsNil(arg0) then
					arg0:OnStop()

					return
				end

				local var0 = arg0:InstantiateObj(arg0, arg1:Find("masks"))

				var0.name = "icon_front_" .. iter0
				var0.transform.anchorMin = var0.transform.pivot
				var0.transform.anchorMax = var0.transform.pivot

				var0.transform:SetSiblingIndex(2)
				setActive(var0, false)
				arg0()
			end), true, true)
		end)
	end

	seriesAsync(var1, arg3)
end

local function var6(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetBodyMasks()
	local var1 = arg0.poolMgr.root:Find("mask")

	for iter0, iter1 in pairs(var0) do
		local var2 = arg0:CloneTplTo(var1, arg1:Find("interaction"), "body_mask" .. iter0)

		var2.anchoredPosition = iter1.offset
		var2.sizeDelta = iter1.size

		if iter1.img then
			local var3 = ResourceMgr.Inst:getAssetSync("furnitrues/" .. iter1.img, "", true, true)

			var2:GetComponent(typeof(Image)).sprite = var3:GetComponent(typeof(Image)).sprite
		end
	end

	arg3()
end

local function var7(arg0, arg1, arg2, arg3)
	if arg2:GetType() == Furniture.TYPE_ARCH then
		local var0 = arg2:GetArchMask()

		if not checkABExist("furnitrues/" .. var0) then
			arg3()

			return
		end

		ResourceMgr.Inst:getAssetAsync("furnitrues/" .. var0, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0:IsStop() or IsNil(arg1) or IsNil(arg0) then
				arg0:OnStop()

				return
			end

			local var0 = arg0:InstantiateObj(arg0, arg1:Find("masks"))

			var0.name = "icon_front_arch"
			var0.transform.anchorMin = var0.transform.pivot
			var0.transform.anchorMax = var0.transform.pivot

			arg3()
		end), true, true)
	else
		arg3()
	end
end

local function var8(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetFirstSlot():GetName()

	ResourceMgr.Inst:getAssetAsync("sfurniture/" .. var0, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0:IsStop() or IsNil(arg1) or IsNil(arg0) then
			arg0:OnStop()

			return
		end

		local var0 = arg0:InstantiateObj(arg0, arg1)

		arg0:AdjustModel(arg1, var0.transform.sizeDelta, var0.transform.pivot)

		var0.name = "spine_icon"
		var0.transform.localPosition = Vector3(0, 0, 0)

		var0.transform:SetSiblingIndex(1)
		arg3()
	end), true, true)
end

local function var9(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetMaskNames()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			ResourceMgr.Inst:getAssetAsync("sfurniture/" .. iter1, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0:IsStop() or IsNil(arg1) or IsNil(arg0) then
					arg0:OnStop()

					return
				end

				local var0 = arg0:InstantiateObj(arg0, arg1:Find("masks"))

				var0.name = "icon_front_" .. iter0
				var0.transform.localPosition = Vector3(0, 0, 0)

				setActive(var0, false)
				arg0()
			end), true, true)
		end)
	end

	seriesAsync(var1, arg3)
end

local function var10(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetAnimatorMask()

	if var0 then
		local var1 = arg0.poolMgr.root:Find("mask")
		local var2 = arg0:CloneTplTo(var1, arg1:Find("interaction"), "animtor_mask")

		var2.sizeDelta = var0.size

		setAnchoredPosition(var2, var0.offset)
	end

	local var3 = {}

	for iter0, iter1 in ipairs(arg2:GetAnimators()) do
		local var4 = iter1.key
		local var5 = iter1.value

		table.insert(var3, function(arg0)
			ResourceMgr.Inst:getAssetAsync("sfurniture/" .. var5, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0:IsStop() or IsNil(arg1) or IsNil(arg0) then
					arg0:OnStop()

					return
				end

				local var0 = arg1:Find("interaction")
				local var1 = var0 and var0:Find("animtor_mask") or var0
				local var2 = arg0:InstantiateObj(arg0, var1)

				var2.name = "Animator" .. var4

				setActive(var2, false)
				arg0()
			end), true, true)
		end)
	end

	parallelAsync(var3, arg3)
end

function var0.Load(arg0, arg1, arg2, arg3, arg4)
	seriesAsync({
		function(arg0)
			var6(arg0, arg1.transform, arg2, arg0)
		end,
		function(arg0)
			var4(arg0, arg1.transform, arg2, function()
				arg4()
				arg0()
			end)
		end,
		function(arg0)
			var5(arg0, arg1.transform, arg2, arg0)
		end,
		function(arg0)
			var7(arg0, arg1.transform, arg2, arg0)
		end
	}, arg3)
end

function var0.LoadSpine(arg0, arg1, arg2, arg3, arg4)
	arg0.working = true

	seriesAsync({
		function(arg0)
			var6(arg0, arg1.transform, arg2, arg0)
		end,
		function(arg0)
			var8(arg0, arg1, arg2, function()
				arg4()
				arg0()
			end)
		end,
		function(arg0)
			var9(arg0, arg1, arg2, arg0)
		end,
		function(arg0)
			var10(arg0, arg1, arg2, arg0)
		end
	}, arg3)
end

function var0.AdjustModel(arg0, arg1, arg2, arg3)
	arg1.pivot = arg3
	arg1.sizeDelta = arg2
	arg1:Find("interaction").pivot = arg3
	arg1:Find("masks").pivot = arg3

	local var0 = arg1:Find("childs")

	var0.anchorMin = arg3
	var0.anchorMax = arg3
end

function var0.FinishWork(arg0, arg1)
	if arg1 then
		arg0.rollBacks = {}
	else
		arg0:RollBackLoaded()
	end

	arg0.state = var1

	if arg0.callback then
		arg0.callback()
	end

	arg0.module = nil
end

function var0.RollBackLoaded(arg0)
	for iter0 = #arg0.rollBacks, 1, -1 do
		local var0 = arg0.rollBacks[iter0]

		if not IsNil(var0) then
			Object.Destroy(var0)
		end
	end

	arg0.rollBacks = {}
end

function var0.Stop(arg0)
	arg0.state = var3
	arg0.callback = nil
end

function var0.OnStop(arg0)
	if arg0.state ~= var3 then
		arg0:FinishWork(false)
	end
end

function var0.IsStop(arg0)
	return arg0.state == var3 or arg0.module and arg0.module:IsExit()
end

return var0
