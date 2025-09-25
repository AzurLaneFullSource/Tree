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
local var11_0 = 11

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.pools = {
		[var1_0] = IslandObjectPoolSet.New(arg1_1, 3, 2),
		[var3_0] = IslandObjectPoolSet.New(arg1_1, 8, 2),
		[var6_0] = IslandObjectPoolSet.New(arg1_1, 3, 5),
		[var7_0] = IslandObjectPoolSet.New(arg1_1, 3, 5),
		[var8_0] = IslandObjectPoolSet.New(arg1_1, 10, 3),
		[var9_0] = IslandRootTplPool.New(arg1_1, "ui/agorafurnituretpl", 1, 20),
		[var10_0] = IslandObjectPoolSet.New(arg1_1, 2, 6),
		[var11_0] = IslandUITplPoolSet.New(arg1_1, "ui/IslandOpUI", 1, 1, false),
		[var2_0] = IslandAssetPoolSet.New(arg1_1, 5, 2),
		[var4_0] = IslandAssetPoolSet.New(arg1_1, 5, 2),
		[var5_0] = IslandAssetPoolSet.New(arg1_1, 5, 2)
	}
	arg0_1.loadingIdList = {}
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

local function var12_0(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
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

local function var13_0(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = GetOrAddComponent(arg4_11, typeof(Animator))
	local var1_11 = var0_11.runtimeAnimatorController

	arg1_11:ReturnObject(arg3_11, var1_11)

	var0_11.runtimeAnimatorController = nil

	arg0_11:ReturnObject(arg2_11, arg4_11)
end

local function var14_0(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	local var0_12 = {}

	table.insert(var0_12, function(arg0_13)
		var12_0(arg0_12, arg1_12, arg2_12, arg3_12, arg0_13)
	end)
	seriesAsync(var0_12, function(arg0_14)
		local var0_14 = GameObject.New(arg0_14.name)

		setParent(arg0_14, var0_14.transform, false)
		arg4_12(var0_14)
	end)
end

local function var15_0(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = arg4_15.transform:GetChild(0).gameObject

	var13_0(arg0_15, arg1_15, arg2_15, arg3_15, var0_15)
	Object.Destroy(arg4_15)
end

function var0_0.GetCharacter(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg0_16:GetPool(var1_0)
	local var1_16 = arg0_16:GetPool(var2_0)

	var14_0(var0_16, var1_16, arg1_16, arg2_16, arg3_16)
end

function var0_0.ReturnCharacter(arg0_17, arg1_17, arg2_17, arg3_17)
	if not arg0_17.pools then
		return
	end

	local var0_17 = arg0_17:GetPool(var1_0)
	local var1_17 = arg0_17:GetPool(var2_0)

	var15_0(var0_17, var1_17, arg1_17, arg2_17, arg3_17)
end

function var0_0.GetCharacterModel(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18:GetPool(var1_0)
	local var1_18 = arg0_18:GetPool(var2_0)

	var12_0(var0_18, var1_18, arg1_18, arg2_18, arg3_18)
end

function var0_0.ReturnCharacterModel(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:GetPool(var1_0)
	local var1_19 = arg0_19:GetPool(var2_0)

	var13_0(var0_19, var1_19, arg1_19, arg2_19, arg3_19)
end

function var0_0.GetSceneCharacter(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20 = arg0_20:GetPool(var5_0)
	local var1_20 = {}
	local var2_20

	table.insert(var1_20, function(arg0_21)
		arg0_20:GetCharacter(arg1_20, arg2_20, function(arg0_22)
			var2_20 = arg0_22

			arg0_21()
		end)
	end)

	if arg3_20 and arg3_20 ~= "" then
		table.insert(var1_20, function(arg0_23)
			var0_20:GetObject(arg3_20, typeof(NodeCanvas.BehaviourTrees.BehaviourTree), function(arg0_24)
				GetOrAddComponent(var2_20, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = arg0_24

				arg0_23()
			end)
		end)
	end

	seriesAsync(var1_20, function()
		arg4_20(var2_20)
	end)
end

function var0_0.ReturnSceneCharacter(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = arg0_26:GetPool(var5_0)

	if arg3_26 and arg3_26 ~= "" then
		local var1_26 = GetOrAddComponent(arg4_26, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))
		local var2_26 = var1_26.graph

		var0_26:ReturnObject(arg3_26, var2_26)

		var1_26.graph = nil
	end

	arg0_26:ReturnCharacter(arg1_26, arg2_26, arg4_26)
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

function var0_0.GetOpUI(arg0_38)
	return arg0_38:GetPool(var11_0):GetObject()
end

function var0_0.ReturnOpUI(arg0_39, arg1_39)
	arg0_39:GetPool(var11_0):ReturnObject(arg1_39)
end

function var0_0.BuildCommanderPart(arg0_40, arg1_40, arg2_40)
	local var0_40 = {}
	local var1_40

	table.insert(var0_40, function(arg0_41)
		local var0_41 = 0
		local var1_41 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()
		local var2_41 = var1_41:IsNew()

		local function var3_41()
			var0_41 = var0_41 + 1

			if var0_41 == #IslandShipDressHelperNew.CommanderCustom then
				local var0_42 = IslandShipDressHelperNew.DressType.Hat
				local var1_42 = var2_41 and IslandShipDressHelperNew.GetInitDressByType(var0_42) or var1_41:GetDressByType(var0_42)

				if var1_42 ~= 0 then
					local var2_42 = pg.island_dress_template[var1_42].sub_type - 1

					GraphicsInterface.Instance:SetCharacterBlendShape(arg1_40, IslandShipDressHelperNew.ComponentType.Hair, var2_42, 100)
				end

				arg0_41()
			end
		end

		for iter0_41, iter1_41 in ipairs(IslandShipDressHelperNew.CommanderCustom) do
			local var4_41 = var2_41 and IslandShipDressHelperNew.GetInitDressByType(iter1_41) or var1_41:GetDressByType(iter1_41)
			local var5_41 = var1_41:GetCurrentColorByDressId(var4_41)

			if var4_41 == 0 then
				GraphicsInterface.Instance:SetCharacterComponentShow(arg1_40, IslandShipDressHelperNew.ComponentType.Headware, false, var3_41)
			else
				local var6_41 = pg.island_dress_template[var4_41]
				local var7_41 = var6_41.model

				if var5_41 == 0 then
					GraphicsInterface.Instance:LoadCharacterComponent(arg1_40, var7_41, var3_41)
				else
					local var8_41 = pg.island_dress_colordiff_template[var5_41].model

					GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg1_40, var7_41, var8_41, var3_41)
				end

				if var6_41.face_clip ~= "" then
					var1_40 = var6_41.face_clip
				end
			end
		end
	end)
	seriesAsync(var0_40, function()
		arg2_40(var1_40)
	end)
end

function var0_0.BuildVisterPart(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44)
	local var0_44 = {}
	local var1_44

	table.insert(var0_44, function(arg0_45)
		local var0_45 = 0
		local var1_45 = (arg3_44 and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetVisitorAgency():GetPlayer(arg2_44)

		if not var1_45 then
			arg0_45()

			return
		end

		local function var2_45()
			var0_45 = var0_45 + 1

			if var0_45 == #IslandShipDressHelperNew.CommanderCustom then
				local var0_46 = IslandShipDressHelperNew.DressType.Hat
				local var1_46 = var1_45:GetDressByType(var0_46)

				if var1_46 ~= 0 then
					local var2_46 = pg.island_dress_template[var1_46].sub_type - 1

					GraphicsInterface.Instance:SetCharacterBlendShape(arg1_44, IslandShipDressHelperNew.ComponentType.Hair, var2_46, 100)
				end

				arg0_45()
			end
		end

		for iter0_45, iter1_45 in ipairs(IslandShipDressHelperNew.CommanderCustom) do
			local var3_45 = var1_45:GetDressByType(iter1_45)
			local var4_45 = var1_45:GetCurrentColorByDressId(var3_45)

			if var3_45 == 0 then
				GraphicsInterface.Instance:SetCharacterComponentShow(arg1_44, IslandShipDressHelperNew.ComponentType.Headware, false, var2_45)
			else
				local var5_45 = pg.island_dress_template[var3_45]
				local var6_45 = var5_45.model

				if var4_45 == 0 then
					GraphicsInterface.Instance:LoadCharacterComponent(arg1_44, var6_45, var2_45)
				else
					local var7_45 = pg.island_dress_colordiff_template[var4_45].model

					GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg1_44, var6_45, var7_45, var2_45)
				end

				if var5_45.face_clip ~= "" then
					var1_44 = var5_45.face_clip
				end
			end
		end
	end)
	seriesAsync(var0_44, function()
		arg4_44(var1_44)
	end)
end

function var0_0.LoadAnimator(arg0_48, arg1_48, arg2_48, arg3_48, arg4_48)
	local var0_48 = IslandAssetLoadDispatcher.Instance:Enqueue(arg3_48, "", typeof(RuntimeAnimatorController), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_49)
		local var0_49

		var0_49.runtimeAnimatorController, var0_49 = Object.Instantiate(arg0_49), GetOrAddComponent(arg1_48.transform, typeof(Animator))
		arg2_48 = arg2_48 or "idle"

		var0_49:Play(arg2_48, 4)
		arg4_48()
	end), true, true)

	table.insert(arg0_48.loadingIdList, var0_48)
end

function var0_0.NestModel(arg0_50, arg1_50)
	local var0_50 = arg1_50.name
	local var1_50 = GameObject.New(var0_50)

	setParent(arg1_50.transform, var1_50.transform, false)

	arg1_50 = var1_50

	return arg1_50
end

function var0_0.GetCommanderModel(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51, arg5_51)
	local var0_51 = {}
	local var1_51

	table.insert(var0_51, function(arg0_52)
		local var0_52 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_51.model, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_53)
			var1_51 = Object.Instantiate(arg0_53)

			arg0_52()
		end), true, true)

		table.insert(arg0_51.loadingIdList, var0_52)
	end)

	if arg3_51 then
		table.insert(var0_51, function(arg0_54)
			arg0_51:BuildVisterPart(var1_51, arg3_51, arg4_51, arg0_54)
		end)
	else
		table.insert(var0_51, function(arg0_55)
			arg0_51:BuildCommanderPart(var1_51, arg0_55)
		end)
	end

	table.insert(var0_51, function(arg0_56, arg1_56)
		arg0_51:LoadAnimator(var1_51, arg1_56, arg1_51.animator, arg0_56)
	end)
	table.insert(var0_51, function(arg0_57)
		var1_51 = arg0_51:NestModel(var1_51)

		arg0_57()
	end)

	if arg5_51 and arg5_51 ~= "" then
		table.insert(var0_51, function(arg0_58)
			arg0_51:GetPool(var5_0):GetObject(arg5_51, typeof(NodeCanvas.BehaviourTrees.BehaviourTree), function(arg0_59)
				GetOrAddComponent(var1_51, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = arg0_59

				arg0_58()
			end)
		end)
	end

	seriesAsync(var0_51, function()
		arg2_51(var1_51)
	end)
end

function var0_0.ReturnCommanderModel(arg0_61, arg1_61, arg2_61)
	if arg2_61 and arg2_61 ~= "" then
		local var0_61 = arg0_61:GetPool(var5_0)
		local var1_61 = GetOrAddComponent(arg1_61, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))
		local var2_61 = var1_61.graph

		var0_61:ReturnObject(arg2_61, var2_61)

		var1_61.graph = nil
	end

	Object.Destroy(arg1_61)
end

function var0_0.GetDelegateEffect(arg0_62, arg1_62, arg2_62)
	arg0_62:GetPool(var10_0):GetObject(arg1_62, typeof(GameObject), arg2_62)
end

function var0_0.ReturnDelegateEffect(arg0_63, arg1_63, arg2_63)
	arg0_63:GetPool(var10_0):ReturnObject(arg1_63, arg2_63)
end

function var0_0.ClearDelegateEffect(arg0_64)
	arg0_64:GetPool(var10_0):Clear()
end

function var0_0.Dispose(arg0_65)
	for iter0_65, iter1_65 in pairs(arg0_65.pools) do
		iter1_65:Dispose()
	end

	arg0_65.pools = nil

	for iter2_65, iter3_65 in ipairs(arg0_65.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter3_65)
	end

	arg0_65.loadingIdList = nil
end

return var0_0
