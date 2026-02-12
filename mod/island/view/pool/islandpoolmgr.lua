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

function var0_0.BuildCommanderPart(arg0_51, arg1_51, arg2_51)
	local var0_51 = {}
	local var1_51

	table.insert(var0_51, function(arg0_52)
		local var0_52 = 0
		local var1_52 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()
		local var2_52 = var1_52:IsNew()

		local function var3_52()
			var0_52 = var0_52 + 1

			if var0_52 == #IslandShipDressHelperNew.CommanderCustom then
				local var0_53 = IslandShipDressHelperNew.DressType.Hat
				local var1_53 = var2_52 and IslandShipDressHelperNew.GetInitDressByType(var0_53) or var1_52:GetDressByType(var0_53)

				if var1_53 ~= 0 then
					local var2_53 = pg.island_dress_template[var1_53].sub_type - 1

					GraphicsInterface.Instance:SetCharacterBlendShape(arg1_51, IslandShipDressHelperNew.ComponentType.Hair, var2_53, 100)
				end

				arg0_52()
			end
		end

		for iter0_52, iter1_52 in ipairs(IslandShipDressHelperNew.CommanderCustom) do
			local var4_52 = var2_52 and IslandShipDressHelperNew.GetInitDressByType(iter1_52) or var1_52:GetDressByType(iter1_52)
			local var5_52 = var1_52:GetCurrentColorByDressId(var4_52)

			if var4_52 == 0 then
				GraphicsInterface.Instance:SetCharacterComponentShow(arg1_51, IslandShipDressHelperNew.ComponentType.Headware, false, var3_52)
			else
				local var6_52 = pg.island_dress_template[var4_52]
				local var7_52 = var6_52.model

				if var5_52 == 0 then
					GraphicsInterface.Instance:LoadCharacterComponent(arg1_51, var7_52, var3_52)
				else
					local var8_52 = pg.island_dress_colordiff_template[var5_52].model

					GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg1_51, var7_52, var8_52, var3_52)
				end

				if var6_52.face_clip ~= "" then
					var1_51 = var6_52.face_clip
				end
			end
		end
	end)
	seriesAsync(var0_51, function()
		arg2_51(var1_51)
	end)
end

function var0_0.BuildVisterPart(arg0_55, arg1_55, arg2_55, arg3_55, arg4_55)
	local var0_55 = {}
	local var1_55

	table.insert(var0_55, function(arg0_56)
		local var0_56 = 0
		local var1_56 = (arg3_55 and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetVisitorAgency():GetPlayer(arg2_55)

		if not var1_56 then
			arg0_56()

			return
		end

		local function var2_56()
			var0_56 = var0_56 + 1

			if var0_56 == #IslandShipDressHelperNew.CommanderCustom then
				local var0_57 = IslandShipDressHelperNew.DressType.Hat
				local var1_57 = var1_56:GetDressByType(var0_57)

				if var1_57 ~= 0 then
					local var2_57 = pg.island_dress_template[var1_57].sub_type - 1

					GraphicsInterface.Instance:SetCharacterBlendShape(arg1_55, IslandShipDressHelperNew.ComponentType.Hair, var2_57, 100)
				end

				arg0_56()
			end
		end

		for iter0_56, iter1_56 in ipairs(IslandShipDressHelperNew.CommanderCustom) do
			local var3_56 = var1_56:GetDressByType(iter1_56)
			local var4_56 = var1_56:GetCurrentColorByDressId(var3_56)

			if var3_56 == 0 then
				GraphicsInterface.Instance:SetCharacterComponentShow(arg1_55, IslandShipDressHelperNew.ComponentType.Headware, false, var2_56)
			else
				local var5_56 = pg.island_dress_template[var3_56]
				local var6_56 = var5_56.model

				if var4_56 == 0 then
					GraphicsInterface.Instance:LoadCharacterComponent(arg1_55, var6_56, var2_56)
				else
					local var7_56 = pg.island_dress_colordiff_template[var4_56].model

					GraphicsInterface.Instance:LoadCharacterComponentAndMaterial(arg1_55, var6_56, var7_56, var2_56)
				end

				if var5_56.face_clip ~= "" then
					var1_55 = var5_56.face_clip
				end
			end
		end
	end)
	seriesAsync(var0_55, function()
		arg4_55(var1_55)
	end)
end

function var0_0.LoadAnimator(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59)
	local var0_59 = IslandAssetLoadDispatcher.Instance:Enqueue(arg3_59, "", typeof(RuntimeAnimatorController), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_60)
		local var0_60 = GetOrAddComponent(arg1_59.transform, typeof(Animator))

		var0_60.runtimeAnimatorController = arg0_60
		arg2_59 = arg2_59 or "idle"

		var0_60:Play(arg2_59, 4)
		arg4_59()
	end), true, true)

	table.insert(arg0_59.loadingIdList, var0_59)
end

function var0_0.NestModel(arg0_61, arg1_61)
	local var0_61 = arg1_61.name
	local var1_61 = GameObject.New(var0_61)

	setParent(arg1_61.transform, var1_61.transform, false)

	arg1_61 = var1_61

	return arg1_61
end

function var0_0.GetCommanderModel(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62, arg5_62)
	local var0_62 = {}
	local var1_62

	table.insert(var0_62, function(arg0_63)
		local var0_63 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_62.model, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_64)
			var1_62 = Object.Instantiate(arg0_64)

			arg0_63()
		end), true, true)

		table.insert(arg0_62.loadingIdList, var0_63)
	end)

	if arg3_62 then
		table.insert(var0_62, function(arg0_65)
			arg0_62:BuildVisterPart(var1_62, arg3_62, arg4_62, arg0_65)
		end)
	else
		table.insert(var0_62, function(arg0_66)
			arg0_62:BuildCommanderPart(var1_62, arg0_66)
		end)
	end

	table.insert(var0_62, function(arg0_67, arg1_67)
		arg0_62:LoadAnimator(var1_62, arg1_67, arg1_62.animator, arg0_67)
	end)
	table.insert(var0_62, function(arg0_68)
		var1_62 = arg0_62:NestModel(var1_62)

		arg0_68()
	end)

	if arg5_62 and arg5_62 ~= "" then
		table.insert(var0_62, function(arg0_69)
			arg0_62:GetPool(var5_0):GetObject(arg5_62, typeof(NodeCanvas.BehaviourTrees.BehaviourTree), function(arg0_70)
				GetOrAddComponent(var1_62, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = arg0_70

				arg0_69()
			end)
		end)
	end

	seriesAsync(var0_62, function()
		arg2_62(var1_62)
	end)
end

function var0_0.ReturnCommanderModel(arg0_72, arg1_72, arg2_72)
	if arg2_72 and arg2_72 ~= "" then
		local var0_72 = arg0_72:GetPool(var5_0)
		local var1_72 = GetOrAddComponent(arg1_72, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))
		local var2_72 = var1_72.graph

		var0_72:ReturnObject(arg2_72, var2_72)

		var1_72.graph = nil
	end

	Object.Destroy(arg1_72)
end

function var0_0.GetDelegateEffect(arg0_73, arg1_73, arg2_73)
	arg0_73:GetPool(var10_0):GetObject(arg1_73, typeof(GameObject), arg2_73)
end

function var0_0.ReturnDelegateEffect(arg0_74, arg1_74, arg2_74)
	arg0_74:GetPool(var10_0):ReturnObject(arg1_74, arg2_74)
end

function var0_0.ClearDelegateEffect(arg0_75)
	arg0_75:GetPool(var10_0):Clear()
end

function var0_0.GetFishRod(arg0_76, arg1_76, arg2_76, arg3_76)
	local var0_76 = arg0_76:GetPool(var12_0)
	local var1_76 = arg0_76:GetPool(var4_0)
	local var2_76

	seriesAsync({
		function(arg0_77)
			var0_76:GetObject(arg1_76, typeof(GameObject), function(arg0_78)
				var2_76 = arg0_78

				arg0_77()
			end)
		end,
		function(arg0_79)
			var1_76:GetObject(arg2_76, typeof(RuntimeAnimatorController), function(arg0_80)
				GetOrAddComponent(var2_76, typeof(Animator)).runtimeAnimatorController = arg0_80

				arg0_79()
			end)
		end
	}, function()
		arg3_76(var2_76)
	end)
end

function var0_0.ReturnFishRod(arg0_82, arg1_82, arg2_82, arg3_82)
	local var0_82 = arg0_82:GetPool(var4_0)
	local var1_82 = GetOrAddComponent(arg3_82, typeof(Animator)).runtimeAnimatorController

	var0_82:ReturnObject(arg2_82, var1_82)
	arg0_82:GetPool(var12_0):ReturnObject(arg1_82, arg3_82)
end

function var0_0.GetFish(arg0_83, arg1_83, arg2_83, arg3_83)
	local var0_83 = arg0_83:GetPool(var13_0)
	local var1_83 = arg0_83:GetPool(var4_0)
	local var2_83

	seriesAsync({
		function(arg0_84)
			var0_83:GetObject(arg1_83, typeof(GameObject), function(arg0_85)
				var2_83 = arg0_85

				arg0_84()
			end)
		end,
		function(arg0_86)
			var1_83:GetObject(arg2_83, typeof(RuntimeAnimatorController), function(arg0_87)
				GetOrAddComponent(var2_83, typeof(Animator)).runtimeAnimatorController = arg0_87

				arg0_86()
			end)
		end
	}, function()
		arg3_83(var2_83)
	end)
end

function var0_0.ReturnFish(arg0_89, arg1_89, arg2_89, arg3_89)
	local var0_89 = arg0_89:GetPool(var4_0)
	local var1_89 = GetOrAddComponent(arg3_89, typeof(Animator)).runtimeAnimatorController

	var0_89:ReturnObject(arg2_89, var1_89)
	arg0_89:GetPool(var13_0):ReturnObject(arg1_89, arg3_89)
end

function var0_0.GetUI(arg0_90, arg1_90, arg2_90)
	arg0_90:GetPool(var14_0):GetObject("ui/" .. arg1_90, typeof(GameObject), arg2_90)
end

function var0_0.ReturnUI(arg0_91, arg1_91, arg2_91)
	arg0_91:GetPool(var14_0):ReturnObject("ui/" .. arg1_91, arg2_91)
end

function var0_0.GetFishingEffect(arg0_92, arg1_92, arg2_92)
	arg0_92:GetPool(var15_0):GetObject(arg1_92, typeof(GameObject), arg2_92)
end

function var0_0.ReturnFishingEffect(arg0_93, arg1_93, arg2_93)
	arg0_93:GetPool(var15_0):ReturnObject(arg1_93, arg2_93)
end

function var0_0.ClearFishingEffect(arg0_94)
	arg0_94:GetPool(var15_0):Clear()
end

function var0_0.Dispose(arg0_95)
	for iter0_95, iter1_95 in pairs(arg0_95.pools) do
		iter1_95:Dispose()
	end

	arg0_95.pools = nil

	for iter2_95, iter3_95 in ipairs(arg0_95.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter3_95)
	end

	arg0_95.loadingIdList = nil
end

return var0_0
