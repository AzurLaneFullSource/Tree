local var0_0 = class("IslandBaseBuilder")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg1_1

	assert(arg2_1)

	arg0_1.unitListType = arg2_1
	arg0_1.loadingIdList = {}
	arg0_1.insIdList = {}
end

function var0_0.Build(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:GetModule(arg0_2.view, arg1_2)

	assert(arg0_2.unitListType)
	var0_2:SetUnitType(arg0_2.unitListType)

	local var1_2

	seriesAsync({
		function(arg0_3)
			arg0_2:Load(arg1_2, function(arg0_4)
				var1_2 = arg0_4

				arg0_3()
			end)
		end,
		function(arg0_5)
			arg0_2:LoadTimeline(var1_2, var0_2, arg1_2, arg0_5)
		end,
		function(arg0_6)
			arg0_2:LoadOtherPart(var1_2, var0_2, arg1_2, arg0_6)
		end
	}, function()
		arg0_2:AddTypeAndID(var1_2, var0_2)
		arg0_2:AddComponents(var1_2, arg1_2)
		arg0_2:SetTag(var1_2)
		var0_2:Init(var1_2, arg0_2)
		existCall(arg2_2, var0_2)
	end)

	return var0_2
end

function var0_0.AddTypeAndID(arg0_8, arg1_8, arg2_8)
	local var0_8 = GetOrAddComponent(arg1_8, typeof(WorldObjectItem))

	var0_8.type = arg2_8:GetUnitType()
	var0_8.id = arg2_8.id
end

function var0_0.GetView(arg0_9)
	return arg0_9.view
end

function var0_0.GetPoolMgr(arg0_10)
	return arg0_10.view:GetPoolMgr()
end

function var0_0.AddLoadingID(arg0_11, arg1_11)
	table.insert(arg0_11.loadingIdList, arg1_11)
end

function var0_0.Dispose(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.insIdList) do
		FrameAsyncInstantiateManager.Instance:Cancel(iter1_12)
	end

	arg0_12.insIdList = nil

	for iter2_12, iter3_12 in ipairs(arg0_12.loadingIdList) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter3_12)
	end

	arg0_12.loadingIdList = nil
end

function var0_0.Load(arg0_13, arg1_13, arg2_13)
	assert(false, "overwrite !!!")
end

function var0_0.Recycle(arg0_14, arg1_14, arg2_14)
	assert(false, "overwrite !!!")
end

function var0_0.GetModule(arg0_15, arg1_15, arg2_15)
	assert(false, "overwrite !!!")
end

function var0_0.SetTag(arg0_16, arg1_16)
	return
end

function var0_0.AddComponents(arg0_17, arg1_17)
	return
end

function var0_0.LoadTimeline(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	arg4_18()
end

function var0_0.LoadOtherPart(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg4_19()
end

function var0_0.OnDispose(arg0_20)
	return
end

return var0_0
