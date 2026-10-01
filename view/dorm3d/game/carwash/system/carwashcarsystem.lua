local var0_0 = class("CarWashCarSystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.UPDATE_PHASE2_TIP = "CarWashCarSystem.UPDATE_PHASE2_TIP"
var0_0.PLAY_PHASE2_REACTION = "CarWashCarSystem.PLAY_PHASE2_REACTION"
var0_0.MATERIAL_INDEX = 0
var0_0.OPAQUE_INDEX = 1
var0_0.TRANSPARENT_INDEX = 0
var0_0.GENERATOR_NAME = "[DECALROOT]/[DECAL GENERATOR]"
var0_0.CAR_PREFAB_PATH = "/[MainBlock]/[Model]/scene_root/no_bake/pre_db_cw_car"
var0_0.GLASS_CONFIG = {
	{
		regionId = "zuoglass_01",
		vfx = "pre_db_cw_car01/all/con_1/L_men/L_Bl/vfx_nxmfdoorglass01_l",
		path = "pre_db_cw_car01/all/mod/fbx_db_cw_car01_doorglass01_l"
	},
	{
		regionId = "zuoglass_02",
		vfx = "pre_db_cw_car01/all/con_1/R_men/R_Bl/vfx_nxmfdoorglass01_r",
		path = "pre_db_cw_car01/all/mod/fbx_db_cw_car01_doorglass01_r"
	},
	{
		regionId = "glass_01",
		vfx = "pre_db_cw_car01/all/con_1/vfx_nxmfglass01",
		path = "pre_db_cw_car01/all/mod/fbx_db_cw_car01_glass01"
	}
}
var0_0.PHASE_2_VFX = "pre_db_cw_car01/all/con_1/vfx_nxmfglass02"
var0_0.PHASE_2_RENDER = "pre_db_cw_car01/all/mod/fbx_db_cw_car01_glass01"

function var0_0.OnInit(arg0_1)
	arg0_1.mainCamera = arg0_1:GetMainCamera()
	arg0_1.gameState = CarWashConst.GAME_STATE.NONE
	arg0_1.carTouchClicked = false
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(CarWashGameFlowSystem.SET_STAINS_COUNT_MAX, function(arg0_3, arg1_3)
		arg0_2:InitSceneRefs()
		arg0_2:RefreshAllGlassMaterialByRegion()
		arg0_2:PlayIdleAnim()
	end)
	arg0_2:Bind(CarWashGameFlowSystem.DECREASE_STAINS_COUNT, function(arg0_4, arg1_4)
		onNextTick(function()
			arg0_2:RefreshAllGlassMaterialByRegion(true)
		end)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN, function(arg0_6)
		arg0_2:SetAllGlassTransparent()
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function(arg0_7)
		arg0_2:RefreshAllGlassMaterialByRegion()
		arg0_2:PlayIdleAnim()
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_LADY_POS, function(arg0_8, arg1_8)
		arg0_2.posConfig = arg1_8.newValue
		arg0_2.carTouchTF = nil

		arg0_2:PlayIdleAnim()
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_9, arg1_9)
		arg0_2.gameState = arg1_9.newValue

		if arg1_9.newValue == CarWashConst.GAME_STATE.PHASE_2 then
			arg0_2.carTouchClicked = false

			arg0_2:SetAllGlassTransparent()
		elseif arg1_9.newValue == CarWashConst.GAME_STATE.PHASE_1 then
			arg0_2:RefreshAllGlassMaterialByRegion()
		end

		arg0_2:EnablePhase2(arg1_9.newValue == CarWashConst.GAME_STATE.PHASE_2 and arg0_2.posConfig and arg0_2.posConfig.phase2_glass_effect == 1)
	end)
	arg0_2:Bind(var0_0.PLAY_PHASE2_REACTION, function(arg0_10)
		arg0_2:PlayPhase2Reaction()
	end)
end

function var0_0.OnUpdate(arg0_11, arg1_11)
	if arg0_11.gameState ~= CarWashConst.GAME_STATE.PHASE_2 then
		return
	end

	arg0_11:Emit(var0_0.UPDATE_PHASE2_TIP, arg0_11:GetPhase2TipInfo())
end

function var0_0.OnDispose(arg0_12)
	arg0_12.mainCamera = nil
	arg0_12.carTF = nil
	arg0_12.carAnimator = nil
	arg0_12.posConfig = nil
	arg0_12.carTouchTF = nil
	arg0_12.glassInfos = nil
	arg0_12.randomDecalGenerator = nil
	arg0_12.phase2VFX = nil
	arg0_12.phase2Render = nil
end

function var0_0.InitSceneRefs(arg0_13)
	local var0_13 = GameObject.Find(var0_0.CAR_PREFAB_PATH)

	assert(var0_13, "CarWash car prefab not found: " .. var0_0.CAR_PREFAB_PATH)

	arg0_13.carTF = var0_13.transform
	arg0_13.carAnimator = arg0_13.carTF:GetChild(0):GetComponent(typeof(Animator))
	arg0_13.glassInfos = {}

	local var1_13 = GameObject.Find(var0_0.GENERATOR_NAME)

	assert(var1_13, "CarWash RandomDecalGenerator object not found: " .. var0_0.GENERATOR_NAME)

	arg0_13.randomDecalGenerator = var1_13:GetComponent(typeof(RandomDecalGenerator))

	assert(arg0_13.randomDecalGenerator, "RandomDecalGenerator component not found on " .. var0_0.GENERATOR_NAME)

	for iter0_13, iter1_13 in ipairs(var0_0.GLASS_CONFIG) do
		local var2_13 = arg0_13.carTF:Find(iter1_13.path)

		assert(var2_13, "CarWash glass object not found: " .. tostring(iter1_13.path))

		local var3_13 = var2_13:GetComponent(typeof(MaterialSwitcher))

		assert(var3_13, "MaterialSwitcher component not found on " .. tostring(iter1_13.path))

		local var4_13 = arg0_13.randomDecalGenerator:GetRegionRootById(iter1_13.regionId)

		assert(var4_13, "CarWash glass decal region not found: " .. tostring(iter1_13.regionId))

		local var5_13 = arg0_13.carTF:Find(iter1_13.vfx)

		assert(var5_13, "CarWash glass vfx not found: " .. tostring(iter1_13.vfx))
		setActive(var5_13, false)
		table.insert(arg0_13.glassInfos, {
			switcher = var3_13,
			regionId = iter1_13.regionId,
			regionTF = var4_13,
			vfxTF = var5_13
		})
	end

	arg0_13.phase2VFX = arg0_13.carTF:Find(var0_0.PHASE_2_VFX)

	local var6_13 = arg0_13.carTF:Find(var0_0.PHASE_2_RENDER)

	assert(arg0_13.phase2VFX, "CarWash phase2 vfx not found: " .. var0_0.PHASE_2_VFX)
	assert(var6_13, "CarWash phase2 renderer not found: " .. var0_0.PHASE_2_RENDER)

	arg0_13.phase2Render = var6_13:GetComponent(typeof(SkinnedMeshRenderer))

	assert(arg0_13.phase2Render, "CarWash phase2 MeshRenderer not found: " .. var0_0.PHASE_2_RENDER)
end

function var0_0.PlayIdleAnim(arg0_14)
	if not arg0_14.carAnimator or not arg0_14.posConfig then
		return
	end

	local var0_14 = arg0_14.posConfig.car_idle_anim

	if not var0_14 or var0_14 == "" then
		return
	end

	arg0_14.carAnimator:CrossFadeInFixedTime(var0_14, 0, 0)
end

function var0_0.GetPhase2TipInfo(arg0_15)
	if arg0_15.carTouchClicked or not arg0_15.carTF or not arg0_15.posConfig then
		return nil
	end

	local var0_15 = arg0_15.posConfig.car_touch_anim

	if not var0_15 or not var0_15[1] or var0_15[1] == "" or not var0_15[2] or var0_15[2] == "" then
		return nil
	end

	if not arg0_15.carTouchTF then
		arg0_15.carTouchTF = arg0_15.carTF:Find(var0_15[1])

		assert(arg0_15.carTouchTF, "CarWash car touch node not found: " .. tostring(var0_15[1]))
	end

	local var1_15 = arg0_15.mainCamera:WorldToScreenPoint(arg0_15.carTouchTF.position)

	return {
		isCar = true,
		screenPosition = var1_15,
		visible = var1_15.z > 0
	}
end

function var0_0.PlayPhase2Reaction(arg0_16)
	if arg0_16.gameState ~= CarWashConst.GAME_STATE.PHASE_2 then
		return
	end

	if arg0_16.carTouchClicked or not arg0_16.posConfig then
		return
	end

	local var0_16 = arg0_16.posConfig.car_touch_anim

	if not var0_16 or not var0_16[2] or var0_16[2] == "" then
		return
	end

	arg0_16.carTouchClicked = true

	arg0_16:Emit(var0_0.UPDATE_PHASE2_TIP, nil)

	if arg0_16.carAnimator then
		arg0_16.carAnimator:CrossFadeInFixedTime(var0_16[2], 0, 0)
	end
end

function var0_0.RefreshAllGlassMaterialByRegion(arg0_17, arg1_17)
	if not arg0_17.glassInfos then
		return
	end

	for iter0_17, iter1_17 in pairs(arg0_17.glassInfos) do
		iter1_17.regionTF = arg0_17.randomDecalGenerator and arg0_17.randomDecalGenerator:GetRegionRootById(iter1_17.regionId) or nil

		if iter1_17.regionTF then
			arg0_17:SetGlassTransparent(iter1_17, iter1_17.regionTF.childCount == 0, arg1_17)
		else
			warning("CarWash glass decal region not found: " .. tostring(iter1_17.regionId))
		end
	end
end

function var0_0.SetAllGlassTransparent(arg0_18)
	if not arg0_18.glassInfos then
		return
	end

	for iter0_18, iter1_18 in pairs(arg0_18.glassInfos) do
		arg0_18:SetGlassTransparent(iter1_18, true)
	end
end

function var0_0.SetGlassTransparent(arg0_19, arg1_19, arg2_19, arg3_19)
	if arg3_19 and arg2_19 and not arg1_19.isTransparent then
		setActive(arg1_19.vfxTF, true)
	end

	local var0_19 = arg2_19 and var0_0.TRANSPARENT_INDEX or var0_0.OPAQUE_INDEX

	arg1_19.switcher:ReplaceMaterial(var0_0.MATERIAL_INDEX, var0_19)

	arg1_19.isTransparent = arg2_19
end

function var0_0.EnablePhase2(arg0_20, arg1_20)
	if arg0_20.phase2VFX then
		setActive(arg0_20.phase2VFX, arg1_20)
	end

	if arg0_20.phase2Render then
		arg0_20.phase2Render.enabled = not arg1_20
	end
end

return var0_0
