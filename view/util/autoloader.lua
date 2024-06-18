local var0_0 = class("AutoLoader")
local var1_0 = false
local var2_0 = false
local var3_0 = import("view.util.RequestPackages.LoadPrefabRequestPackage")
local var4_0 = import("view.util.RequestPackages.LoadReferenceRequestPackage")
local var5_0 = import("view.util.RequestPackages.LoadLive2dRequestPackage")
local var6_0 = import("view.util.RequestPackages.LoadBundleRequesetPackage")
local var7_0 = import("view.util.RequestPackages.GetSpineRequestPackage")
local var8_0 = import("view.util.RequestPackages.GetPrefabRequestPackage")
local var9_0 = import("view.util.RequestPackages.GetSpriteRequestPackage")
local var10_0 = import("view.util.RequestPackages.ReturnPrefabRequestPackage")
local var11_0 = import("view.util.RequestPackages.ReturnSpineRequestPackage")
local var12_0 = import("view.util.RequestPackages.UnloadBundleRequesetPackage")
local var13_0 = import("view.util.RequestPackages.DestroyAtlasPoolRequestPackage")

var0_0.PartLoading = bit.lshift(1, 0)
var0_0.PartLoaded = bit.lshift(1, 1)

function var0_0.Ctor(arg0_1)
	arg0_1._loadingRequest = {}
	arg0_1._returnRequest = {}
	arg0_1._instKeyDict = {}
	arg0_1._keyInstDict = {}
	arg0_1._groupDict = {}
end

function var0_0.GenerateUID4LoadingRequest(arg0_2)
	arg0_2._uidCounter = (arg0_2._uidCounter or 0) + 1

	assert(arg0_2._uidCounter ~= 0, "Error on Generating UID Too much times")

	return arg0_2._uidCounter
end

function var0_0.GetPrefab(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg2_3 = arg2_3 or ""

	arg0_3:ClearRequest(arg4_3)

	arg4_3 = arg4_3 or arg0_3:GenerateUID4LoadingRequest()

	local var0_3
	local var1_3 = var8_0.New(arg1_3, arg2_3, function(arg0_4)
		arg0_3._loadingRequest[arg4_3] = nil
		arg0_3._instKeyDict[arg0_4] = arg4_3
		arg0_3._keyInstDict[arg4_3] = arg0_4
		arg0_3._returnRequest[arg4_3] = var10_0.New(arg1_3, arg2_3, arg0_4)

		if arg3_3 then
			arg3_3(arg0_4)
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Path: " .. arg1_3 .. " Name: " .. arg2_3 .. " ;")
	end

	arg0_3._loadingRequest[arg4_3] = var1_3

	var1_3:Start()

	return arg4_3
end

function var0_0.GetPrefabBYStopLoading(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg2_5 = arg2_5 or ""

	arg0_5:ClearRequest(arg4_5, var0_0.PartLoading)

	arg4_5 = arg4_5 or arg0_5:GenerateUID4LoadingRequest()

	local var0_5
	local var1_5 = var8_0.New(arg1_5, arg2_5, function(arg0_6)
		arg0_5._loadingRequest[arg4_5] = nil

		arg0_5:ClearRequest(arg4_5, var0_0.PartLoaded)

		arg0_5._instKeyDict[arg0_6] = arg4_5
		arg0_5._keyInstDict[arg4_5] = arg0_6
		arg0_5._returnRequest[arg4_5] = var10_0.New(arg1_5, arg2_5, arg0_6)

		if arg3_5 then
			arg3_5(arg0_6)
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Path: " .. arg1_5 .. " Name: " .. arg2_5 .. " ;")
	end

	arg0_5._loadingRequest[arg4_5] = var1_5

	var1_5:Start()

	return arg4_5
end

function var0_0.GetPrefabBYGroup(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = arg0_7:GetPrefab(arg1_7, arg2_7, arg3_7)

	arg0_7._groupDict[var0_7] = arg4_7

	return var0_7
end

function var0_0.ReturnPrefab(arg0_8, arg1_8)
	arg0_8:ClearRequest(arg0_8._instKeyDict[go(arg1_8)])
end

function var0_0.ReturnGroup(arg0_9, arg1_9)
	if not arg1_9 then
		return
	end

	for iter0_9, iter1_9 in pairs(arg0_9._groupDict) do
		if iter1_9 == arg1_9 then
			arg0_9:ClearRequest(iter0_9)
		end
	end
end

function var0_0.GetSpine(arg0_10, arg1_10, arg2_10, arg3_10)
	if not arg1_10 or #arg1_10 < 0 then
		return
	end

	arg1_10 = arg1_10 or ""

	arg0_10:ClearRequest(arg3_10)

	arg3_10 = arg3_10 or arg0_10:GenerateUID4LoadingRequest()

	local var0_10
	local var1_10 = var7_0.New(arg1_10, function(arg0_11)
		arg0_10._loadingRequest[arg3_10] = nil
		arg0_10._instKeyDict[arg0_11] = arg3_10
		arg0_10._keyInstDict[arg3_10] = arg0_11
		arg0_10._returnRequest[arg3_10] = var11_0.New(arg1_10, arg0_11)

		if arg2_10 then
			arg2_10(arg0_11)
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Spine: " .. arg1_10 .. " ;")
	end

	arg0_10._loadingRequest[arg3_10] = var1_10

	var1_10:Start()

	return arg3_10
end

function var0_0.ReturnSpine(arg0_12, arg1_12)
	arg0_12:ClearRequest(arg0_12._instKeyDict[go(arg1_12)])
end

function var0_0.GetSprite(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg3_13:GetComponent(typeof(Image)).enabled = false

	return arg0_13:GetSpriteQuiet(arg1_13, arg2_13, arg3_13, arg4_13)
end

function var0_0.GetSpriteQuiet(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	arg2_14 = arg2_14 or ""

	local var0_14 = tf(arg3_14)

	arg0_14:GetSpriteDirect(arg1_14, arg2_14, function(arg0_15)
		local var0_15 = arg3_14:GetComponent(typeof(Image))

		var0_15.enabled = true
		var0_15.sprite = arg0_15

		if arg4_14 then
			var0_15:SetNativeSize()
		end
	end, var0_14)

	return var0_14
end

function var0_0.GetSpriteDirect(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	arg0_16:ClearRequest(arg4_16)

	arg4_16 = arg4_16 or arg0_16:GenerateUID4LoadingRequest()

	local var0_16
	local var1_16 = var9_0.New(arg1_16, arg2_16, function(arg0_17)
		arg0_16._loadingRequest[arg4_16] = nil

		if arg3_16 then
			arg3_16(arg0_17)
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Atlas: " .. arg1_16 .. " Name: " .. arg2_16 .. " ;")
	end

	arg0_16._loadingRequest[arg4_16] = var1_16

	var1_16:Start()

	arg0_16._returnRequest[arg1_16] = var13_0.New(arg1_16)

	return arg4_16
end

function var0_0.GetOffSpriteRequest(arg0_18, arg1_18)
	arg0_18:ClearRequest(arg1_18)
end

function var0_0.LoadPrefab(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg2_19 = arg2_19 or ""

	arg0_19:ClearRequest(arg4_19)

	arg4_19 = arg4_19 or arg0_19:GenerateUID4LoadingRequest()

	local var0_19
	local var1_19 = var3_0.New(arg1_19, arg2_19, function(arg0_20)
		arg0_19._loadingRequest[arg4_19] = nil

		if arg3_19 then
			arg3_19(arg0_20)
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Once Path: " .. arg1_19 .. " Name: " .. arg2_19 .. " ;")
	end

	arg0_19._loadingRequest[arg4_19] = var1_19

	var1_19:Start()

	return arg4_19
end

function var0_0.LoadLive2D(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21
	local var1_21, var2_21 = HXSet.autoHxShift("live2d/", arg1_21)

	arg1_21 = var2_21

	local var3_21 = var1_21 .. arg1_21

	arg0_21:ClearRequest(arg3_21)

	arg3_21 = arg3_21 or arg0_21:GenerateUID4LoadingRequest()

	local var4_21
	local var5_21 = var5_0.New(var3_21, arg1_21, function(arg0_22)
		arg0_21._loadingRequest[arg3_21] = nil

		if arg2_21 then
			arg2_21(arg0_22)
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Live2D Once Path: " .. var3_21 .. " Name: " .. arg1_21 .. " ;")
	end

	arg0_21._loadingRequest[arg3_21] = var5_21

	var5_21:Start()

	return arg3_21
end

function var0_0.LoadSprite(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	local var0_23 = arg3_23:GetComponent(typeof(Image))

	var0_23.enabled = false
	arg2_23 = arg2_23 or ""

	local var1_23 = tf(arg3_23)

	arg0_23:ClearRequest(var1_23)

	local var2_23
	local var3_23 = var4_0.New(arg1_23, arg2_23, typeof(Sprite), function(arg0_24)
		arg0_23._loadingRequest[var1_23] = nil
		var0_23.enabled = true
		var0_23.sprite = arg0_24

		if arg4_23 then
			var0_23:SetNativeSize()
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Once Path: " .. arg1_23 .. " Name: " .. arg2_23 .. " ;")
	end

	arg0_23._loadingRequest[var1_23] = var3_23

	var3_23:Start()

	return var1_23
end

function var0_0.LoadReference(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25, arg5_25)
	arg2_25 = arg2_25 or ""

	arg0_25:ClearRequest(arg5_25)

	arg5_25 = arg5_25 or arg0_25:GenerateUID4LoadingRequest()

	local var0_25
	local var1_25 = var4_0.New(arg1_25, arg2_25, arg3_25, function(arg0_26)
		arg0_25._loadingRequest[arg5_25] = nil

		if arg4_25 then
			arg4_25(arg0_26)
		end
	end)

	if var1_0 then
		print("AutoLoader Loading Once Path: " .. arg1_25 .. " Name: " .. arg2_25 .. " ;")
	end

	arg0_25._loadingRequest[arg5_25] = var1_25

	var1_25:Start()

	return arg5_25
end

function var0_0.DestroyAtlas(arg0_27, arg1_27)
	arg0_27:ClearRequest(arg1_27)
end

function var0_0.LoadBundle(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28:GenerateUID4LoadingRequest()
	local var1_28
	local var2_28 = var6_0.New(arg1_28, function(arg0_29)
		arg0_28._loadingRequest[var0_28] = nil
		arg0_28._returnRequest[var0_28] = var12_0.New(arg1_28)

		existCall(arg2_28, arg0_29)
	end)

	if var1_0 then
		print("AutoLoader Loading Bundle: " .. arg1_28 .. " ;")
	end

	arg0_28._loadingRequest[var0_28] = var2_28

	var2_28:Start()

	return var0_28
end

function var0_0.GetRequestPackage(arg0_30, arg1_30, arg2_30)
	arg2_30 = arg2_30 or var0_0.PartLoading + var0_0.PartLoaded

	return bit.band(arg2_30, var0_0.PartLoading) > 0 and arg0_30._loadingRequest[arg1_30] or bit.band(arg2_30, var0_0.PartLoaded) > 0 and arg0_30._returnRequest[arg1_30] or nil
end

function var0_0.GetLoadingRP(arg0_31, arg1_31)
	return arg0_31._loadingRequest[arg1_31]
end

function var0_0.ClearRequest(arg0_32, arg1_32, arg2_32)
	if (not arg2_32 or bit.band(arg2_32, var0_0.PartLoading) > 0) and arg0_32._loadingRequest[arg1_32] then
		if var2_0 then
			local var0_32 = arg0_32._loadingRequest[arg1_32]

			print("AutoLoader Unload loading Path: " .. var0_32.path .. " Name: " .. var0_32.name .. " ;")
		end

		arg0_32._loadingRequest[arg1_32]:Stop()

		arg0_32._loadingRequest[arg1_32] = nil
	end

	if not arg2_32 or bit.band(arg2_32, var0_0.PartLoaded) > 0 then
		if arg0_32._returnRequest[arg1_32] then
			if var2_0 then
				local var1_32 = arg0_32._returnRequest[arg1_32]

				if isa(var1_32, var11_0) then
					print("AutoLoader Unload Spine: " .. var1_32.name .. " ;")
				elseif isa(var1_32, var13_0) then
					print("AutoLoader Unload Atlas: " .. var1_32.path .. " ;")
				elseif isa(var1_32, var12_0) then
					print("AutoLoader Unload Bundle: " .. var1_32.path .. " ;")
				elseif isa(var1_32, var10_0) then
					print("AutoLoader Unload Path: " .. var1_32.path .. " Name: " .. var1_32.name .. " ;")
				end
			end

			arg0_32._returnRequest[arg1_32]:Start()

			arg0_32._returnRequest[arg1_32] = nil
		end

		if arg0_32._keyInstDict[arg1_32] then
			arg0_32._instKeyDict[arg0_32._keyInstDict[arg1_32]] = nil
			arg0_32._keyInstDict[arg1_32] = nil
		end
	end

	if arg1_32 then
		arg0_32._groupDict[arg1_32] = nil
	end
end

function var0_0.ClearLoadingRequests(arg0_33)
	for iter0_33 in pairs(arg0_33._loadingRequest) do
		arg0_33:ClearRequest(iter0_33)
	end

	table.clear(arg0_33._loadingRequest)
end

function var0_0.ClearLoadedRequests(arg0_34)
	for iter0_34 in pairs(arg0_34._returnRequest) do
		arg0_34:ClearRequest(iter0_34)
	end

	table.clear(arg0_34._returnRequest)
end

function var0_0.ClearRequests(arg0_35)
	arg0_35:ClearLoadingRequests()
	arg0_35:ClearLoadedRequests()
	table.clear(arg0_35._instKeyDict)
	table.clear(arg0_35._keyInstDict)
end

function var0_0.RegisterLoaded(arg0_36, arg1_36, arg2_36)
	arg0_36._instKeyDict[arg2_36] = arg1_36
	arg0_36._keyInstDict[arg1_36] = arg2_36

	local var0_36 = {
		Start = function()
			Destroy(arg2_36)
		end
	}

	arg0_36._returnRequest[arg1_36] = var0_36
end

function var0_0.Clear(arg0_38)
	arg0_38:ClearRequests()
end

return var0_0
