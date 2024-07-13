local var0_0 = class("CourtYardFurnitureJob")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.poolMgr = arg1_1
	arg0_1.state = var1_0
	arg0_1.callback = arg2_1
	arg0_1.rollBacks = {}
end

function var0_0.IsWorking(arg0_2)
	return arg0_2.state == var2_0
end

function var0_0.InstantiateObj(arg0_3, arg1_3, arg2_3)
	local var0_3 = Object.Instantiate(arg1_3, arg2_3)

	table.insert(arg0_3.rollBacks, var0_3)

	return var0_3
end

function var0_0.CloneTplTo(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = Object.Instantiate(arg1_4, arg2_4).transform

	if arg3_4 then
		var0_4.name = arg3_4
	end

	return var0_4
end

function var0_0.Work(arg0_5, arg1_5, arg2_5)
	arg0_5.id = arg2_5.id

	if arg1_5:IsExit() then
		arg0_5:FinishWork(false)

		return
	end

	arg0_5.state = var2_0

	local var0_5 = arg1_5._tf

	arg0_5.module = arg1_5

	local function var1_5()
		if arg1_5:IsExit() then
			arg0_5:FinishWork(false)
		else
			arg1_5:Init(var0_5)
			arg0_5:FinishWork(true)
		end
	end

	local function var2_5()
		arg1_5:OnIconLoaed()
	end

	arg0_5.rollBacks = {}

	if arg2_5:IsSpine() then
		arg0_5:LoadSpine(var0_5, arg2_5, var1_5, var2_5)
	else
		arg0_5:Load(var0_5, arg2_5, var1_5, var2_5)
	end
end

local function var4_0(arg0_8, arg1_8, arg2_8, arg3_8)
	ResourceMgr.Inst:getAssetAsync("furnitrues/" .. arg2_8:GetPicture(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		if arg0_8:IsStop() or IsNil(arg1_8) or IsNil(arg0_9) then
			arg0_8:OnStop()

			return
		end

		local var0_9 = arg0_8:InstantiateObj(arg0_9, arg1_8).transform

		var0_9.name = "icon"

		var0_9:SetSiblingIndex(1)

		var0_9.anchorMin = var0_9.pivot
		var0_9.anchorMax = var0_9.pivot

		arg0_8:AdjustModel(arg1_8, var0_9.sizeDelta, var0_9.pivot)
		arg3_8()
	end), true, true)
end

local function var5_0(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg2_10:GetMaskNames()
	local var1_10 = {}

	for iter0_10, iter1_10 in pairs(var0_10) do
		table.insert(var1_10, function(arg0_11)
			ResourceMgr.Inst:getAssetAsync("furnitrues/" .. iter1_10, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_12)
				if arg0_10:IsStop() or IsNil(arg1_10) or IsNil(arg0_12) then
					arg0_10:OnStop()

					return
				end

				local var0_12 = arg0_10:InstantiateObj(arg0_12, arg1_10:Find("masks"))

				var0_12.name = "icon_front_" .. iter0_10
				var0_12.transform.anchorMin = var0_12.transform.pivot
				var0_12.transform.anchorMax = var0_12.transform.pivot

				var0_12.transform:SetSiblingIndex(2)
				setActive(var0_12, false)
				arg0_11()
			end), true, true)
		end)
	end

	seriesAsync(var1_10, arg3_10)
end

local function var6_0(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg2_13:GetBodyMasks()
	local var1_13 = arg0_13.poolMgr.root:Find("mask")

	for iter0_13, iter1_13 in pairs(var0_13) do
		local var2_13 = arg0_13:CloneTplTo(var1_13, arg1_13:Find("interaction"), "body_mask" .. iter0_13)

		var2_13.anchoredPosition = iter1_13.offset
		var2_13.sizeDelta = iter1_13.size

		if iter1_13.img then
			local var3_13 = ResourceMgr.Inst:getAssetSync("furnitrues/" .. iter1_13.img, "", true, true)

			var2_13:GetComponent(typeof(Image)).sprite = var3_13:GetComponent(typeof(Image)).sprite
		end
	end

	arg3_13()
end

local function var7_0(arg0_14, arg1_14, arg2_14, arg3_14)
	if arg2_14:GetType() == Furniture.TYPE_ARCH then
		local var0_14 = arg2_14:GetArchMask()

		if not checkABExist("furnitrues/" .. var0_14) then
			arg3_14()

			return
		end

		ResourceMgr.Inst:getAssetAsync("furnitrues/" .. var0_14, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_15)
			if arg0_14:IsStop() or IsNil(arg1_14) or IsNil(arg0_15) then
				arg0_14:OnStop()

				return
			end

			local var0_15 = arg0_14:InstantiateObj(arg0_15, arg1_14:Find("masks"))

			var0_15.name = "icon_front_arch"
			var0_15.transform.anchorMin = var0_15.transform.pivot
			var0_15.transform.anchorMax = var0_15.transform.pivot

			arg3_14()
		end), true, true)
	else
		arg3_14()
	end
end

local function var8_0(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg2_16:GetFirstSlot():GetName()

	ResourceMgr.Inst:getAssetAsync("sfurniture/" .. var0_16, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_17)
		if arg0_16:IsStop() or IsNil(arg1_16) or IsNil(arg0_17) then
			arg0_16:OnStop()

			return
		end

		local var0_17 = arg0_16:InstantiateObj(arg0_17, arg1_16)

		arg0_16:AdjustModel(arg1_16, var0_17.transform.sizeDelta, var0_17.transform.pivot)

		var0_17.name = "spine_icon"
		var0_17.transform.localPosition = Vector3(0, 0, 0)

		var0_17.transform:SetSiblingIndex(1)
		arg3_16()
	end), true, true)
end

local function var9_0(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg2_18:GetMaskNames()
	local var1_18 = {}

	for iter0_18, iter1_18 in ipairs(var0_18) do
		table.insert(var1_18, function(arg0_19)
			ResourceMgr.Inst:getAssetAsync("sfurniture/" .. iter1_18, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_20)
				if arg0_18:IsStop() or IsNil(arg1_18) or IsNil(arg0_20) then
					arg0_18:OnStop()

					return
				end

				local var0_20 = arg0_18:InstantiateObj(arg0_20, arg1_18:Find("masks"))

				var0_20.name = "icon_front_" .. iter0_18
				var0_20.transform.localPosition = Vector3(0, 0, 0)

				setActive(var0_20, false)
				arg0_19()
			end), true, true)
		end)
	end

	seriesAsync(var1_18, arg3_18)
end

local function var10_0(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg2_21:GetAnimatorMask()

	if var0_21 then
		local var1_21 = arg0_21.poolMgr.root:Find("mask")
		local var2_21 = arg0_21:CloneTplTo(var1_21, arg1_21:Find("interaction"), "animtor_mask")

		var2_21.sizeDelta = var0_21.size

		setAnchoredPosition(var2_21, var0_21.offset)
	end

	local var3_21 = {}

	for iter0_21, iter1_21 in ipairs(arg2_21:GetAnimators()) do
		local var4_21 = iter1_21.key
		local var5_21 = iter1_21.value

		table.insert(var3_21, function(arg0_22)
			ResourceMgr.Inst:getAssetAsync("sfurniture/" .. var5_21, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_23)
				if arg0_21:IsStop() or IsNil(arg1_21) or IsNil(arg0_23) then
					arg0_21:OnStop()

					return
				end

				local var0_23 = arg1_21:Find("interaction")
				local var1_23 = var0_21 and var0_23:Find("animtor_mask") or var0_23
				local var2_23 = arg0_21:InstantiateObj(arg0_23, var1_23)

				var2_23.name = "Animator" .. var4_21

				setActive(var2_23, false)
				arg0_22()
			end), true, true)
		end)
	end

	parallelAsync(var3_21, arg3_21)
end

function var0_0.Load(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	seriesAsync({
		function(arg0_25)
			var6_0(arg0_24, arg1_24.transform, arg2_24, arg0_25)
		end,
		function(arg0_26)
			var4_0(arg0_24, arg1_24.transform, arg2_24, function()
				arg4_24()
				arg0_26()
			end)
		end,
		function(arg0_28)
			var5_0(arg0_24, arg1_24.transform, arg2_24, arg0_28)
		end,
		function(arg0_29)
			var7_0(arg0_24, arg1_24.transform, arg2_24, arg0_29)
		end
	}, arg3_24)
end

function var0_0.LoadSpine(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	arg0_30.working = true

	seriesAsync({
		function(arg0_31)
			var6_0(arg0_30, arg1_30.transform, arg2_30, arg0_31)
		end,
		function(arg0_32)
			var8_0(arg0_30, arg1_30, arg2_30, function()
				arg4_30()
				arg0_32()
			end)
		end,
		function(arg0_34)
			var9_0(arg0_30, arg1_30, arg2_30, arg0_34)
		end,
		function(arg0_35)
			var10_0(arg0_30, arg1_30, arg2_30, arg0_35)
		end
	}, arg3_30)
end

function var0_0.AdjustModel(arg0_36, arg1_36, arg2_36, arg3_36)
	arg1_36.pivot = arg3_36
	arg1_36.sizeDelta = arg2_36
	arg1_36:Find("interaction").pivot = arg3_36
	arg1_36:Find("masks").pivot = arg3_36

	local var0_36 = arg1_36:Find("childs")

	var0_36.anchorMin = arg3_36
	var0_36.anchorMax = arg3_36
end

function var0_0.FinishWork(arg0_37, arg1_37)
	if arg1_37 then
		arg0_37.rollBacks = {}
	else
		arg0_37:RollBackLoaded()
	end

	arg0_37.state = var1_0

	if arg0_37.callback then
		arg0_37.callback()
	end

	arg0_37.module = nil
end

function var0_0.RollBackLoaded(arg0_38)
	for iter0_38 = #arg0_38.rollBacks, 1, -1 do
		local var0_38 = arg0_38.rollBacks[iter0_38]

		if not IsNil(var0_38) then
			Object.Destroy(var0_38)
		end
	end

	arg0_38.rollBacks = {}
end

function var0_0.Stop(arg0_39)
	arg0_39.state = var3_0
	arg0_39.callback = nil
end

function var0_0.OnStop(arg0_40)
	if arg0_40.state ~= var3_0 then
		arg0_40:FinishWork(false)
	end
end

function var0_0.IsStop(arg0_41)
	return arg0_41.state == var3_0 or arg0_41.module and arg0_41.module:IsExit()
end

return var0_0
