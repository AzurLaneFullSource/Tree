local var0 = class("AutoLoader")
local var1 = false
local var2 = false
local var3 = import("view.util.RequestPackages.LoadPrefabRequestPackage")
local var4 = import("view.util.RequestPackages.LoadReferenceRequestPackage")
local var5 = import("view.util.RequestPackages.LoadLive2dRequestPackage")
local var6 = import("view.util.RequestPackages.LoadBundleRequesetPackage")
local var7 = import("view.util.RequestPackages.GetSpineRequestPackage")
local var8 = import("view.util.RequestPackages.GetPrefabRequestPackage")
local var9 = import("view.util.RequestPackages.GetSpriteRequestPackage")
local var10 = import("view.util.RequestPackages.ReturnPrefabRequestPackage")
local var11 = import("view.util.RequestPackages.ReturnSpineRequestPackage")
local var12 = import("view.util.RequestPackages.UnloadBundleRequesetPackage")
local var13 = import("view.util.RequestPackages.DestroyAtlasPoolRequestPackage")

var0.PartLoading = bit.lshift(1, 0)
var0.PartLoaded = bit.lshift(1, 1)

function var0.Ctor(arg0)
	arg0._loadingRequest = {}
	arg0._returnRequest = {}
	arg0._instKeyDict = {}
	arg0._keyInstDict = {}
	arg0._groupDict = {}
end

function var0.GenerateUID4LoadingRequest(arg0)
	arg0._uidCounter = (arg0._uidCounter or 0) + 1

	assert(arg0._uidCounter ~= 0, "Error on Generating UID Too much times")

	return arg0._uidCounter
end

function var0.GetPrefab(arg0, arg1, arg2, arg3, arg4)
	arg2 = arg2 or ""

	arg0:ClearRequest(arg4)

	arg4 = arg4 or arg0:GenerateUID4LoadingRequest()

	local var0
	local var1 = var8.New(arg1, arg2, function(arg0)
		arg0._loadingRequest[arg4] = nil
		arg0._instKeyDict[arg0] = arg4
		arg0._keyInstDict[arg4] = arg0
		arg0._returnRequest[arg4] = var10.New(arg1, arg2, arg0)

		if arg3 then
			arg3(arg0)
		end
	end)

	if var1 then
		print("AutoLoader Loading Path: " .. arg1 .. " Name: " .. arg2 .. " ;")
	end

	arg0._loadingRequest[arg4] = var1

	var1:Start()

	return arg4
end

function var0.GetPrefabBYStopLoading(arg0, arg1, arg2, arg3, arg4)
	arg2 = arg2 or ""

	arg0:ClearRequest(arg4, var0.PartLoading)

	arg4 = arg4 or arg0:GenerateUID4LoadingRequest()

	local var0
	local var1 = var8.New(arg1, arg2, function(arg0)
		arg0._loadingRequest[arg4] = nil

		arg0:ClearRequest(arg4, var0.PartLoaded)

		arg0._instKeyDict[arg0] = arg4
		arg0._keyInstDict[arg4] = arg0
		arg0._returnRequest[arg4] = var10.New(arg1, arg2, arg0)

		if arg3 then
			arg3(arg0)
		end
	end)

	if var1 then
		print("AutoLoader Loading Path: " .. arg1 .. " Name: " .. arg2 .. " ;")
	end

	arg0._loadingRequest[arg4] = var1

	var1:Start()

	return arg4
end

function var0.GetPrefabBYGroup(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GetPrefab(arg1, arg2, arg3)

	arg0._groupDict[var0] = arg4

	return var0
end

function var0.ReturnPrefab(arg0, arg1)
	arg0:ClearRequest(arg0._instKeyDict[go(arg1)])
end

function var0.ReturnGroup(arg0, arg1)
	if not arg1 then
		return
	end

	for iter0, iter1 in pairs(arg0._groupDict) do
		if iter1 == arg1 then
			arg0:ClearRequest(iter0)
		end
	end
end

function var0.GetSpine(arg0, arg1, arg2, arg3)
	if not arg1 or #arg1 < 0 then
		return
	end

	arg1 = arg1 or ""

	arg0:ClearRequest(arg3)

	arg3 = arg3 or arg0:GenerateUID4LoadingRequest()

	local var0
	local var1 = var7.New(arg1, function(arg0)
		arg0._loadingRequest[arg3] = nil
		arg0._instKeyDict[arg0] = arg3
		arg0._keyInstDict[arg3] = arg0
		arg0._returnRequest[arg3] = var11.New(arg1, arg0)

		if arg2 then
			arg2(arg0)
		end
	end)

	if var1 then
		print("AutoLoader Loading Spine: " .. arg1 .. " ;")
	end

	arg0._loadingRequest[arg3] = var1

	var1:Start()

	return arg3
end

function var0.ReturnSpine(arg0, arg1)
	arg0:ClearRequest(arg0._instKeyDict[go(arg1)])
end

function var0.GetSprite(arg0, arg1, arg2, arg3, arg4)
	arg3:GetComponent(typeof(Image)).enabled = false

	return arg0:GetSpriteQuiet(arg1, arg2, arg3, arg4)
end

function var0.GetSpriteQuiet(arg0, arg1, arg2, arg3, arg4)
	arg2 = arg2 or ""

	local var0 = tf(arg3)

	arg0:GetSpriteDirect(arg1, arg2, function(arg0)
		local var0 = arg3:GetComponent(typeof(Image))

		var0.enabled = true
		var0.sprite = arg0

		if arg4 then
			var0:SetNativeSize()
		end
	end, var0)

	return var0
end

function var0.GetSpriteDirect(arg0, arg1, arg2, arg3, arg4)
	arg0:ClearRequest(arg4)

	arg4 = arg4 or arg0:GenerateUID4LoadingRequest()

	local var0
	local var1 = var9.New(arg1, arg2, function(arg0)
		arg0._loadingRequest[arg4] = nil

		if arg3 then
			arg3(arg0)
		end
	end)

	if var1 then
		print("AutoLoader Loading Atlas: " .. arg1 .. " Name: " .. arg2 .. " ;")
	end

	arg0._loadingRequest[arg4] = var1

	var1:Start()

	arg0._returnRequest[arg1] = var13.New(arg1)

	return arg4
end

function var0.GetOffSpriteRequest(arg0, arg1)
	arg0:ClearRequest(arg1)
end

function var0.LoadPrefab(arg0, arg1, arg2, arg3, arg4)
	arg2 = arg2 or ""

	arg0:ClearRequest(arg4)

	arg4 = arg4 or arg0:GenerateUID4LoadingRequest()

	local var0
	local var1 = var3.New(arg1, arg2, function(arg0)
		arg0._loadingRequest[arg4] = nil

		if arg3 then
			arg3(arg0)
		end
	end)

	if var1 then
		print("AutoLoader Loading Once Path: " .. arg1 .. " Name: " .. arg2 .. " ;")
	end

	arg0._loadingRequest[arg4] = var1

	var1:Start()

	return arg4
end

function var0.LoadLive2D(arg0, arg1, arg2, arg3)
	local var0
	local var1, var2 = HXSet.autoHxShift("live2d/", arg1)

	arg1 = var2

	local var3 = var1 .. arg1

	arg0:ClearRequest(arg3)

	arg3 = arg3 or arg0:GenerateUID4LoadingRequest()

	local var4
	local var5 = var5.New(var3, arg1, function(arg0)
		arg0._loadingRequest[arg3] = nil

		if arg2 then
			arg2(arg0)
		end
	end)

	if var1 then
		print("AutoLoader Loading Live2D Once Path: " .. var3 .. " Name: " .. arg1 .. " ;")
	end

	arg0._loadingRequest[arg3] = var5

	var5:Start()

	return arg3
end

function var0.LoadSprite(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg3:GetComponent(typeof(Image))

	var0.enabled = false
	arg2 = arg2 or ""

	local var1 = tf(arg3)

	arg0:ClearRequest(var1)

	local var2
	local var3 = var4.New(arg1, arg2, typeof(Sprite), function(arg0)
		arg0._loadingRequest[var1] = nil
		var0.enabled = true
		var0.sprite = arg0

		if arg4 then
			var0:SetNativeSize()
		end
	end)

	if var1 then
		print("AutoLoader Loading Once Path: " .. arg1 .. " Name: " .. arg2 .. " ;")
	end

	arg0._loadingRequest[var1] = var3

	var3:Start()

	return var1
end

function var0.LoadReference(arg0, arg1, arg2, arg3, arg4, arg5)
	arg2 = arg2 or ""

	arg0:ClearRequest(arg5)

	arg5 = arg5 or arg0:GenerateUID4LoadingRequest()

	local var0
	local var1 = var4.New(arg1, arg2, arg3, function(arg0)
		arg0._loadingRequest[arg5] = nil

		if arg4 then
			arg4(arg0)
		end
	end)

	if var1 then
		print("AutoLoader Loading Once Path: " .. arg1 .. " Name: " .. arg2 .. " ;")
	end

	arg0._loadingRequest[arg5] = var1

	var1:Start()

	return arg5
end

function var0.DestroyAtlas(arg0, arg1)
	arg0:ClearRequest(arg1)
end

function var0.LoadBundle(arg0, arg1, arg2)
	local var0 = arg0:GenerateUID4LoadingRequest()
	local var1
	local var2 = var6.New(arg1, function(arg0)
		arg0._loadingRequest[var0] = nil
		arg0._returnRequest[var0] = var12.New(arg1)

		existCall(arg2, arg0)
	end)

	if var1 then
		print("AutoLoader Loading Bundle: " .. arg1 .. " ;")
	end

	arg0._loadingRequest[var0] = var2

	var2:Start()

	return var0
end

function var0.GetRequestPackage(arg0, arg1, arg2)
	arg2 = arg2 or var0.PartLoading + var0.PartLoaded

	return bit.band(arg2, var0.PartLoading) > 0 and arg0._loadingRequest[arg1] or bit.band(arg2, var0.PartLoaded) > 0 and arg0._returnRequest[arg1] or nil
end

function var0.GetLoadingRP(arg0, arg1)
	return arg0._loadingRequest[arg1]
end

function var0.ClearRequest(arg0, arg1, arg2)
	if (not arg2 or bit.band(arg2, var0.PartLoading) > 0) and arg0._loadingRequest[arg1] then
		if var2 then
			local var0 = arg0._loadingRequest[arg1]

			print("AutoLoader Unload loading Path: " .. var0.path .. " Name: " .. var0.name .. " ;")
		end

		arg0._loadingRequest[arg1]:Stop()

		arg0._loadingRequest[arg1] = nil
	end

	if not arg2 or bit.band(arg2, var0.PartLoaded) > 0 then
		if arg0._returnRequest[arg1] then
			if var2 then
				local var1 = arg0._returnRequest[arg1]

				if isa(var1, var11) then
					print("AutoLoader Unload Spine: " .. var1.name .. " ;")
				elseif isa(var1, var13) then
					print("AutoLoader Unload Atlas: " .. var1.path .. " ;")
				elseif isa(var1, var12) then
					print("AutoLoader Unload Bundle: " .. var1.path .. " ;")
				elseif isa(var1, var10) then
					print("AutoLoader Unload Path: " .. var1.path .. " Name: " .. var1.name .. " ;")
				end
			end

			arg0._returnRequest[arg1]:Start()

			arg0._returnRequest[arg1] = nil
		end

		if arg0._keyInstDict[arg1] then
			arg0._instKeyDict[arg0._keyInstDict[arg1]] = nil
			arg0._keyInstDict[arg1] = nil
		end
	end

	if arg1 then
		arg0._groupDict[arg1] = nil
	end
end

function var0.ClearLoadingRequests(arg0)
	for iter0 in pairs(arg0._loadingRequest) do
		arg0:ClearRequest(iter0)
	end

	table.clear(arg0._loadingRequest)
end

function var0.ClearLoadedRequests(arg0)
	for iter0 in pairs(arg0._returnRequest) do
		arg0:ClearRequest(iter0)
	end

	table.clear(arg0._returnRequest)
end

function var0.ClearRequests(arg0)
	arg0:ClearLoadingRequests()
	arg0:ClearLoadedRequests()
	table.clear(arg0._instKeyDict)
	table.clear(arg0._keyInstDict)
end

function var0.RegisterLoaded(arg0, arg1, arg2)
	arg0._instKeyDict[arg2] = arg1
	arg0._keyInstDict[arg1] = arg2

	local var0 = {
		Start = function()
			Destroy(arg2)
		end
	}

	arg0._returnRequest[arg1] = var0
end

function var0.Clear(arg0)
	arg0:ClearRequests()
end

return var0
