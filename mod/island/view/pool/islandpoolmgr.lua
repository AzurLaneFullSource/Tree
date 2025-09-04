local var0_0 = class("IslandPoolMgr")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 7
local var8_0 = 8
local var9_0 = 9
local var10_0 = 10

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.pools = {
		[var1_0] = IslandObjectPoolSet.New(arg1_1, 3, 2),
		[var3_0] = IslandObjectPoolSet.New(arg1_1, 8, 2),
		[var6_0] = IslandObjectPoolSet.New(arg1_1, 3, 5),
		[var7_0] = IslandObjectPoolSet.New(arg1_1, 3, 5),
		[var8_0] = IslandObjectPoolSet.New(arg1_1, 10, 3),
		[var9_0] = IslandAgoraFurnitureTplPool.New(arg1_1, 1, 20),
		[var10_0] = IslandObjectPoolSet.New(arg1_1, 2, 5),
		[var2_0] = IslandAssetPoolSet.New(arg1_1, 5, 2),
		[var4_0] = IslandAssetPoolSet.New(arg1_1, 5, 2),
		[var5_0] = IslandAssetPoolSet.New(arg1_1, 5, 2)
	}
end

function var0_0.Init(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in pairs(arg0_2.pools) do
		table.insert(var0_2, function(arg0_3)
			iter1_2:Init(arg0_3)
		end)
	end

	parallelAsync(var0_2, arg1_2)
end

function var0_0.GetPool(arg0_4, arg1_4)
	assert(arg0_4.pools[arg1_4], "pool is nil >>>" .. arg1_4)

	return arg0_4.pools[arg1_4]
end

local function var11_0(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = {}
	local var1_5
	local var2_5

	table.insert(var0_5, function(arg0_6)
		arg0_5:GetObject(arg2_5, typeof(GameObject), function(arg0_7)
			var1_5 = arg0_7

			arg0_6()
		end)
	end)
	table.insert(var0_5, function(arg0_8)
		arg1_5:GetObject(arg3_5, typeof(RuntimeAnimatorController), function(arg0_9)
			var2_5 = arg0_9

			arg0_8()
		end)
	end)
	seriesAsync(var0_5, function()
		GetOrAddComponent(var1_5.transform, typeof(Animator)).runtimeAnimatorController = var2_5

		arg4_5(var1_5)
	end)
end

local function var12_0(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = {}

	table.insert(var0_11, function(arg0_12)
		var11_0(arg0_11, arg1_11, arg2_11, arg3_11, arg0_12)
	end)
	seriesAsync(var0_11, function(arg0_13)
		local var0_13 = GameObject.New(arg0_13.name)

		setParent(arg0_13, var0_13.transform, false)
		arg4_11(var0_13)
	end)
end

local function var13_0(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14, arg5_14)
	local var0_14 = GetOrAddComponent(arg4_14, typeof(Animator))
	local var1_14 = var0_14.runtimeAnimatorController

	arg1_14:ReturnObject(arg3_14, var1_14)

	var0_14.runtimeAnimatorController = nil

	arg0_14:ReturnObject(arg2_14, arg4_14)
end

local function var14_0(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = arg4_15.transform:GetChild(0).gameObject

	var13_0(arg0_15, arg1_15, arg2_15, arg3_15, var0_15)
	Object.Destroy(arg4_15)
end

function var0_0.GetCharacter(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg0_16:GetPool(var1_0)
	local var1_16 = arg0_16:GetPool(var2_0)

	var12_0(var0_16, var1_16, arg1_16, arg2_16, arg3_16, notWarp)
end

function var0_0.ReturnCharacter(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17:GetPool(var1_0)
	local var1_17 = arg0_17:GetPool(var2_0)

	var14_0(var0_17, var1_17, arg1_17, arg2_17, arg3_17)
end

function var0_0.GetCharacterModel(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18:GetPool(var1_0)
	local var1_18 = arg0_18:GetPool(var2_0)

	var11_0(var0_18, var1_18, arg1_18, arg2_18, arg3_18)
end

function var0_0.ReturnCharacterModel(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:GetPool(var1_0)
	local var1_19 = arg0_19:GetPool(var2_0)

	var13_0(var0_19, var1_19, arg1_19, arg2_19, arg3_19)
end

function var0_0.GetSceneCharacter(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20 = arg0_20:GetPool(var3_0)
	local var1_20 = arg0_20:GetPool(var4_0)
	local var2_20 = arg0_20:GetPool(var5_0)
	local var3_20 = {}
	local var4_20

	table.insert(var3_20, function(arg0_21)
		var12_0(var0_20, var1_20, arg1_20, arg2_20, function(arg0_22)
			var4_20 = arg0_22

			arg0_21()
		end)
	end)

	if arg3_20 and arg3_20 ~= "" then
		table.insert(var3_20, function(arg0_23)
			var2_20:GetObject(arg3_20, typeof(NodeCanvas.BehaviourTrees.BehaviourTree), function(arg0_24)
				GetOrAddComponent(var4_20, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = arg0_24

				arg0_23()
			end)
		end)
	end

	seriesAsync(var3_20, function()
		arg4_20(var4_20)
	end)
end

function var0_0.ReturnSceneCharacter(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = arg0_26:GetPool(var3_0)
	local var1_26 = arg0_26:GetPool(var4_0)
	local var2_26 = arg0_26:GetPool(var5_0)

	if arg3_26 and arg3_26 ~= "" then
		local var3_26 = GetOrAddComponent(arg4_26, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))
		local var4_26 = var3_26.graph

		var2_26:ReturnObject(arg3_26, var4_26)

		var3_26.graph = nil
	end

	var14_0(var0_26, var1_26, arg1_26, arg2_26, arg4_26)
end

function var0_0.GetSceneProductItem(arg0_27, arg1_27, arg2_27)
	arg0_27:GetPool(var6_0):GetObject(arg1_27, typeof(GameObject), arg2_27)
end

function var0_0.ReturnSceneProductItem(arg0_28, arg1_28, arg2_28)
	arg0_28:GetPool(var6_0):ReturnObject(arg1_28, arg2_28)
end

function var0_0.ClearSceneProductItem(arg0_29, arg1_29, arg2_29)
	arg0_29:GetPool(var6_0):Clear()
end

function var0_0.GetSceneProductEffect(arg0_30, arg1_30, arg2_30)
	arg0_30:GetPool(var7_0):GetObject(arg1_30, typeof(GameObject), arg2_30)
end

function var0_0.ReturnSceneProductEffect(arg0_31, arg1_31, arg2_31)
	arg0_31:GetPool(var7_0):ReturnObject(arg1_31, arg2_31)
end

function var0_0.ClearSceneProductEffect(arg0_32, arg1_32, arg2_32)
	arg0_32:GetPool(var7_0):Clear()
end

function var0_0.GetAgoraObj(arg0_33, arg1_33, arg2_33)
	arg0_33:GetPool(var8_0):GetObject(arg1_33, typeof(GameObject), arg2_33)
end

function var0_0.ReturnAgoraObj(arg0_34, arg1_34, arg2_34)
	arg0_34:GetPool(var8_0):ReturnObject(arg1_34, arg2_34)
end

function var0_0.GetAgoraRoot(arg0_35)
	return arg0_35:GetPool(var9_0):GetObject()
end

function var0_0.ReturnAgoraRoot(arg0_36, arg1_36)
	arg0_36:GetPool(var9_0):ReturnObject(arg1_36)
end

function var0_0.ClearAograPools(arg0_37)
	arg0_37:GetPool(var8_0):Clear()
	arg0_37:GetPool(var9_0):Clear()
end

function var0_0.BuildCommanderPart(arg0_38, arg1_38, arg2_38)
	local var0_38 = {}

	table.insert(var0_38, function(arg0_39)
		local var0_39 = 0
		local var1_39 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()
		local var2_39 = var1_39:IsNew()

		local function var3_39()
			var0_39 = var0_39 + 1

			if var0_39 == #IslandShipDressHelperNew.CommanderCustom then
				arg0_39()
			end
		end

		for iter0_39, iter1_39 in ipairs(IslandShipDressHelperNew.CommanderCustom) do
			local var4_39 = var2_39 and IslandShipDressHelperNew.GetInitDressByType(iter1_39) or var1_39:GetDressByType(iter1_39)
			local var5_39 = var1_39:GetCurrentColorByDressId(var4_39)

			if var4_39 == 0 then
				GraphicsInterface.Instance:SetCharacterComponentShow(arg1_38, IslandShipDressHelperNew.ComponentType.Headware, false, var3_39)
			else
				local var6_39 = pg.island_dress_template[var4_39].model

				if var5_39 == 0 then
					GraphicsInterface.Instance:LoadCharacterComponent(arg1_38, var6_39, var3_39)
				else
					local var7_39 = pg.island_dress_colordiff_template[var5_39].model

					GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg1_38, var6_39, var7_39, var3_39)
				end
			end
		end
	end)
	seriesAsync(var0_38, function()
		arg2_38(arg1_38)
	end)
end

function var0_0.LoadAnimator(arg0_42, arg1_42, arg2_42, arg3_42)
	ResourceMgr.Inst:getAssetAsync(arg2_42, "", typeof(RuntimeAnimatorController), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_43)
		local var0_43 = Object.Instantiate(arg0_43)

		GetOrAddComponent(arg1_42.transform, typeof(Animator)).runtimeAnimatorController = var0_43

		arg3_42()
	end), true, true)
end

function var0_0.NestModel(arg0_44, arg1_44)
	local var0_44 = arg1_44.name
	local var1_44 = GameObject.New(var0_44)

	setParent(arg1_44.transform, var1_44.transform, false)

	arg1_44 = var1_44

	return arg1_44
end

function var0_0.GetCommanderModel(arg0_45, arg1_45, arg2_45)
	local var0_45 = {}
	local var1_45

	table.insert(var0_45, function(arg0_46)
		ResourceMgr.Inst:getAssetAsync(arg1_45.model, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_47)
			var1_45 = Object.Instantiate(arg0_47)

			arg0_46(var1_45)
		end), true, true)
	end)
	table.insert(var0_45, function(arg0_48)
		arg0_45:BuildCommanderPart(var1_45, arg0_48)
	end)
	table.insert(var0_45, function(arg0_49)
		arg0_45:LoadAnimator(var1_45, arg1_45.animator, arg0_49)
	end)
	table.insert(var0_45, function(arg0_50)
		var1_45 = arg0_45:NestModel(var1_45)

		arg0_50()
	end)
	seriesAsync(var0_45, function()
		arg2_45(var1_45)
	end)
end

function var0_0.ReturnCommanderModel(arg0_52, arg1_52)
	Object.Destroy(arg1_52)
end

function var0_0.GetDelegateEffect(arg0_53, arg1_53, arg2_53)
	arg0_53:GetPool(var10_0):GetObject(arg1_53, typeof(GameObject), arg2_53)
end

function var0_0.ReturnDelegateEffect(arg0_54, arg1_54, arg2_54)
	arg0_54:GetPool(var10_0):ReturnObject(arg1_54, arg2_54)
end

function var0_0.ClearDelegateEffect(arg0_55)
	arg0_55:GetPool(var10_0):Clear()
end

function var0_0.Dispose(arg0_56)
	for iter0_56, iter1_56 in pairs(arg0_56.pools) do
		iter1_56:Dispose()
	end

	arg0_56.pools = nil
end

return var0_0
