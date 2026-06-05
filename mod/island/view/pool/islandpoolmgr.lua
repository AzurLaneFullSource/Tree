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
local var12_0 = 12
local var13_0 = 13
local var14_0 = 14
local var15_0 = 15
local var16_0 = 16

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
		[var12_0] = IslandObjectPoolSet.New(arg1_1, 1, 1),
		[var13_0] = IslandObjectPoolSet.New(arg1_1, 3, 1),
		[var14_0] = IslandObjectPoolSet.New(arg1_1, 3, 1),
		[var15_0] = IslandObjectPoolSet.New(arg1_1, 4, 1),
		[var16_0] = IslandObjectPoolSet.New(arg1_1, 6, 2),
		[var2_0] = IslandPublicAssetPoolSet.New(arg1_1, 5, 2),
		[var4_0] = IslandPublicAssetPoolSet.New(arg1_1, 5, 2),
		[var5_0] = IslandBtAssetPoolSet.New(arg1_1, 5, 2)
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

local function var17_0(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
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

local function var18_0(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = GetOrAddComponent(arg4_11, typeof(Animator))
	local var1_11 = var0_11.runtimeAnimatorController

	arg1_11:ReturnObject(arg3_11, var1_11)

	var0_11.runtimeAnimatorController = nil

	arg0_11:ReturnObject(arg2_11, arg4_11)
end

local function var19_0(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	local var0_12 = {}

	table.insert(var0_12, function(arg0_13)
		var17_0(arg0_12, arg1_12, arg2_12, arg3_12, arg0_13)
	end)
	seriesAsync(var0_12, function(arg0_14)
		local var0_14 = GameObject.New(arg0_14.name)

		setParent(arg0_14, var0_14.transform, false)
		arg4_12(var0_14)
	end)
end

local function var20_0(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = arg4_15.transform:GetChild(0).gameObject

	var18_0(arg0_15, arg1_15, arg2_15, arg3_15, var0_15)
	Object.Destroy(arg4_15)
end

function var0_0.GetCharacter(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg0_16:GetPool(var1_0)
	local var1_16 = arg0_16:GetPool(var2_0)

	var19_0(var0_16, var1_16, arg1_16, arg2_16, arg3_16)
end

function var0_0.ReturnCharacter(arg0_17, arg1_17, arg2_17, arg3_17)
	if not arg0_17.pools then
		return
	end

	local var0_17 = arg0_17:GetPool(var1_0)
	local var1_17 = arg0_17:GetPool(var2_0)

	var20_0(var0_17, var1_17, arg1_17, arg2_17, arg3_17)
end

function var0_0.GetCharacterModel(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18:GetPool(var1_0)
	local var1_18 = arg0_18:GetPool(var2_0)

	var17_0(var0_18, var1_18, arg1_18, arg2_18, arg3_18)
end

function var0_0.ReturnCharacterModel(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:GetPool(var1_0)
	local var1_19 = arg0_19:GetPool(var2_0)

	var18_0(var0_19, var1_19, arg1_19, arg2_19, arg3_19)
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

function var0_0.GetSceneDelegateItem(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
	local var0_27 = arg0_27:GetPool(var16_0)
	local var1_27 = arg0_27:GetPool(var2_0)
	local var2_27 = {}
	local var3_27

	table.insert(var2_27, function(arg0_28)
		var0_27:GetObject(arg1_27, typeof(GameObject), function(arg0_29)
			var3_27 = arg0_29

			arg0_28()
		end)
	end)
	table.insert(var2_27, function(arg0_30)
		var1_27:GetObject(arg2_27, typeof(RuntimeAnimatorController), function(arg0_31)
			GetOrAddComponent(var3_27, typeof(Animator)).runtimeAnimatorController = arg0_31

			arg0_30()
		end)
	end)
	table.insert(var2_27, function(arg0_32)
		var3_27 = arg0_27:NestModel(var3_27)

		arg0_32()
	end)

	if arg3_27 and arg3_27 ~= "" then
		table.insert(var2_27, function(arg0_33)
			arg0_27:GetPool(var5_0):GetObject(arg3_27, typeof(NodeCanvas.BehaviourTrees.BehaviourTree), function(arg0_34)
				GetOrAddComponent(var3_27, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = arg0_34

				arg0_33()
			end)
		end)
	end

	seriesAsync(var2_27, function()
		arg4_27(var3_27)
	end)
end

function var0_0.ReturnSceneDelegateItem(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = arg0_36:GetPool(var16_0)
	local var1_36 = arg0_36:GetPool(var2_0)
	local var2_36 = arg4_36.transform:GetChild(0).gameObject
	local var3_36 = GetOrAddComponent(arg4_36, typeof(Animator))
	local var4_36 = var3_36.runtimeAnimatorController

	var1_36:ReturnObject(arg2_36, var4_36)

	var3_36.runtimeAnimatorController = nil

	var0_36:ReturnObject(path, var2_36)
	Object.Destroy(arg4_36)
end

function var0_0.ClearSceneDelegateItem(arg0_37, arg1_37, arg2_37)
	return
end

function var0_0.GetSceneProductItem(arg0_38, arg1_38, arg2_38)
	arg0_38:GetPool(var6_0):GetObject(arg1_38, typeof(GameObject), arg2_38)
end

function var0_0.ReturnSceneProductItem(arg0_39, arg1_39, arg2_39)
	arg0_39:GetPool(var6_0):ReturnObject(arg1_39, arg2_39)
end

function var0_0.ClearSceneProductItem(arg0_40, arg1_40, arg2_40)
	arg0_40:GetPool(var6_0):Clear()
end

function var0_0.GetSceneProductEffect(arg0_41, arg1_41, arg2_41)
	arg0_41:GetPool(var7_0):GetObject(arg1_41, typeof(GameObject), arg2_41)
end

function var0_0.ReturnSceneProductEffect(arg0_42, arg1_42, arg2_42)
	arg0_42:GetPool(var7_0):ReturnObject(arg1_42, arg2_42)
end

function var0_0.ClearSceneProductEffect(arg0_43, arg1_43, arg2_43)
	arg0_43:GetPool(var7_0):Clear()
end

function var0_0.GetAgoraObj(arg0_44, arg1_44, arg2_44)
	arg0_44:GetPool(var8_0):GetObject(arg1_44, typeof(GameObject), arg2_44)
end

function var0_0.ReturnAgoraObj(arg0_45, arg1_45, arg2_45)
	arg0_45:GetPool(var8_0):ReturnObject(arg1_45, arg2_45)
end

function var0_0.GetAgoraRoot(arg0_46)
	return arg0_46:GetPool(var9_0):GetObject()
end

function var0_0.ReturnAgoraRoot(arg0_47, arg1_47)
	arg0_47:GetPool(var9_0):ReturnObject(arg1_47)
end

function var0_0.ClearAograPools(arg0_48)
	arg0_48:GetPool(var8_0):Clear()
	arg0_48:GetPool(var9_0):Clear()
end

function var0_0.GetOpUI(arg0_49)
	return arg0_49:GetPool(var11_0):GetObject()
end

function var0_0.ReturnOpUI(arg0_50, arg1_50)
	arg0_50:GetPool(var11_0):ReturnObject(arg1_50)
end

function var0_0.BuildPreviewPart(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51)
	local var0_51 = {}

	table.insert(var0_51, function(arg0_52)
		local function var0_52(arg0_53)
			return arg2_51[arg0_53] or 0
		end

		local function var1_52(arg0_54)
			return arg3_51[arg0_54] or 0
		end

		IslandShipDressHelperNew.BuildCommanderCustomParts(arg1_51, var0_52, var1_52, arg0_52)
	end)
	seriesAsync(var0_51, arg4_51)
end

function var0_0.BuildCommanderPart(arg0_55, arg1_55, arg2_55)
	local var0_55 = {}

	table.insert(var0_55, function(arg0_56)
		local var0_56 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()
		local var1_56 = var0_56:IsNew()

		local function var2_56(arg0_57)
			return var1_56 and IslandShipDressHelperNew.GetInitDressByType(arg0_57) or var0_56:GetDressByType(arg0_57)
		end

		local function var3_56(arg0_58)
			return var0_56:GetCurrentColorByDressId(arg0_58)
		end

		IslandShipDressHelperNew.BuildCommanderCustomParts(arg1_55, var2_56, var3_56, arg0_56)
	end)
	seriesAsync(var0_55, arg2_55)
end

function var0_0.BuildVisterPart(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59)
	local var0_59 = {}

	table.insert(var0_59, function(arg0_60)
		local var0_60 = (arg3_59 and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetVisitorAgency():GetPlayer(arg2_59)

		if not var0_60 then
			arg0_60()

			return
		end

		local function var1_60(arg0_61)
			return var0_60:GetDressByType(arg0_61)
		end

		local function var2_60(arg0_62)
			return var0_60:GetCurrentColorByDressId(arg0_62)
		end

		IslandShipDressHelperNew.BuildCommanderCustomParts(arg1_59, var1_60, var2_60, arg0_60)
	end)
	seriesAsync(var0_59, arg4_59)
end

function var0_0.LoadAnimator(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63, arg5_63)
	local var0_63 = IslandAssetLoadDispatcher.Instance:Enqueue(arg3_63, "", typeof(RuntimeAnimatorController), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_64)
		local var0_64 = GetOrAddComponent(arg1_63.transform, typeof(Animator))

		var0_64.runtimeAnimatorController = arg0_64
		arg2_63 = arg2_63 or "idle"

		var0_64:Play(arg2_63, 4)

		local var1_64 = arg5_63 and arg5_63 ~= 0 and pg.island_dress_template[arg5_63] or nil
		local var2_64 = var1_64 and var1_64.special_animator or ""

		if var2_64 == "" then
			arg4_63()

			return
		end

		local var3_64 = IslandAssetLoadDispatcher.Instance:Enqueue(var2_64, "", typeof(UnityEngine.RuntimeAnimatorController), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_65)
			if not IsNil(arg1_63) then
				var0_64.runtimeAnimatorController = arg0_65
			end

			arg4_63()
		end), true, true)

		table.insert(arg0_63.loadingIdList, var3_64)
	end), true, true)

	table.insert(arg0_63.loadingIdList, var0_63)
end

function var0_0.NestModel(arg0_66, arg1_66)
	local var0_66 = arg1_66.name
	local var1_66 = GameObject.New(var0_66)

	setParent(arg1_66.transform, var1_66.transform, false)

	arg1_66 = var1_66

	return arg1_66
end

function var0_0.GetPreviewModel(arg0_67, arg1_67, arg2_67, arg3_67, arg4_67)
	local var0_67 = {}
	local var1_67

	table.insert(var0_67, function(arg0_68)
		local var0_68 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_67.model, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_69)
			var1_67 = Object.Instantiate(arg0_69)

			arg0_68()
		end), true, true)

		table.insert(arg0_67.loadingIdList, var0_68)
	end)
	table.insert(var0_67, function(arg0_70)
		arg0_67:BuildPreviewPart(var1_67, arg3_67 or {}, arg4_67 or {}, arg0_70)
	end)
	table.insert(var0_67, function(arg0_71, arg1_71, arg2_71)
		arg0_67:LoadAnimator(var1_67, arg1_71, arg1_67.animator, arg0_71, arg2_71)
	end)
	table.insert(var0_67, function(arg0_72)
		var1_67 = arg0_67:NestModel(var1_67)

		arg0_72()
	end)
	seriesAsync(var0_67, function()
		arg2_67(var1_67)
	end)
end

function var0_0.GetCommanderModel(arg0_74, arg1_74, arg2_74, arg3_74, arg4_74, arg5_74)
	local var0_74 = {}
	local var1_74

	table.insert(var0_74, function(arg0_75)
		local var0_75 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_74.model, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_76)
			var1_74 = Object.Instantiate(arg0_76)

			arg0_75()
		end), true, true)

		table.insert(arg0_74.loadingIdList, var0_75)
	end)

	if arg3_74 then
		table.insert(var0_74, function(arg0_77)
			arg0_74:BuildVisterPart(var1_74, arg3_74, arg4_74, arg0_77)
		end)
	else
		table.insert(var0_74, function(arg0_78)
			arg0_74:BuildCommanderPart(var1_74, arg0_78)
		end)
	end

	table.insert(var0_74, function(arg0_79, arg1_79, arg2_79)
		arg0_74:LoadAnimator(var1_74, arg1_79, arg1_74.animator, arg0_79, arg2_79)
	end)
	table.insert(var0_74, function(arg0_80)
		var1_74 = arg0_74:NestModel(var1_74)

		arg0_80()
	end)

	if arg5_74 and arg5_74 ~= "" then
		table.insert(var0_74, function(arg0_81)
			arg0_74:GetPool(var5_0):GetObject(arg5_74, typeof(NodeCanvas.BehaviourTrees.BehaviourTree), function(arg0_82)
				GetOrAddComponent(var1_74, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = arg0_82

				arg0_81()
			end)
		end)
	end

	seriesAsync(var0_74, function()
		arg2_74(var1_74)
	end)
end

function var0_0.ReturnCommanderModel(arg0_84, arg1_84, arg2_84)
	if arg2_84 and arg2_84 ~= "" then
		local var0_84 = arg0_84:GetPool(var5_0)
		local var1_84 = GetOrAddComponent(arg1_84, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))
		local var2_84 = var1_84.graph

		var0_84:ReturnObject(arg2_84, var2_84)

		var1_84.graph = nil
	end

	Object.Destroy(arg1_84)
end

function var0_0.GetDelegateEffect(arg0_85, arg1_85, arg2_85)
	arg0_85:GetPool(var10_0):GetObject(arg1_85, typeof(GameObject), arg2_85)
end

function var0_0.ReturnDelegateEffect(arg0_86, arg1_86, arg2_86)
	arg0_86:GetPool(var10_0):ReturnObject(arg1_86, arg2_86)
end

function var0_0.ClearDelegateEffect(arg0_87)
	arg0_87:GetPool(var10_0):Clear()
end

function var0_0.GetFishRod(arg0_88, arg1_88, arg2_88, arg3_88)
	local var0_88 = arg0_88:GetPool(var12_0)
	local var1_88 = arg0_88:GetPool(var4_0)
	local var2_88

	seriesAsync({
		function(arg0_89)
			var0_88:GetObject(arg1_88, typeof(GameObject), function(arg0_90)
				var2_88 = arg0_90

				arg0_89()
			end)
		end,
		function(arg0_91)
			var1_88:GetObject(arg2_88, typeof(RuntimeAnimatorController), function(arg0_92)
				GetOrAddComponent(var2_88, typeof(Animator)).runtimeAnimatorController = arg0_92

				arg0_91()
			end)
		end
	}, function()
		arg3_88(var2_88)
	end)
end

function var0_0.ReturnFishRod(arg0_94, arg1_94, arg2_94, arg3_94)
	local var0_94 = arg0_94:GetPool(var4_0)
	local var1_94 = GetOrAddComponent(arg3_94, typeof(Animator)).runtimeAnimatorController

	var0_94:ReturnObject(arg2_94, var1_94)
	arg0_94:GetPool(var12_0):ReturnObject(arg1_94, arg3_94)
end

function var0_0.GetFish(arg0_95, arg1_95, arg2_95, arg3_95)
	local var0_95 = arg0_95:GetPool(var13_0)
	local var1_95 = arg0_95:GetPool(var4_0)
	local var2_95

	seriesAsync({
		function(arg0_96)
			var0_95:GetObject(arg1_95, typeof(GameObject), function(arg0_97)
				var2_95 = arg0_97

				arg0_96()
			end)
		end,
		function(arg0_98)
			var1_95:GetObject(arg2_95, typeof(RuntimeAnimatorController), function(arg0_99)
				GetOrAddComponent(var2_95, typeof(Animator)).runtimeAnimatorController = arg0_99

				arg0_98()
			end)
		end
	}, function()
		arg3_95(var2_95)
	end)
end

function var0_0.ReturnFish(arg0_101, arg1_101, arg2_101, arg3_101)
	local var0_101 = arg0_101:GetPool(var4_0)
	local var1_101 = GetOrAddComponent(arg3_101, typeof(Animator)).runtimeAnimatorController

	var0_101:ReturnObject(arg2_101, var1_101)
	arg0_101:GetPool(var13_0):ReturnObject(arg1_101, arg3_101)
end

function var0_0.GetUI(arg0_102, arg1_102, arg2_102)
	arg0_102:GetPool(var14_0):GetObject("ui/" .. arg1_102, typeof(GameObject), arg2_102)
end

function var0_0.ReturnUI(arg0_103, arg1_103, arg2_103)
	arg0_103:GetPool(var14_0):ReturnObject("ui/" .. arg1_103, arg2_103)
end

function var0_0.GetFishingEffect(arg0_104, arg1_104, arg2_104)
	arg0_104:GetPool(var15_0):GetObject(arg1_104, typeof(GameObject), arg2_104)
end

function var0_0.ReturnFishingEffect(arg0_105, arg1_105, arg2_105)
	arg0_105:GetPool(var15_0):ReturnObject(arg1_105, arg2_105)
end

function var0_0.ClearFishingEffect(arg0_106)
	arg0_106:GetPool(var15_0):Clear()
end

function var0_0.Dispose(arg0_107)
	for iter0_107, iter1_107 in pairs(arg0_107.pools) do
		iter1_107:Dispose()
	end

	arg0_107.pools = nil

	for iter2_107, iter3_107 in ipairs(arg0_107.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter3_107)
	end

	arg0_107.loadingIdList = nil
end

return var0_0
