local var0_0 = class("CarWashGlassMaterialFix", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.MATERIAL_INDEX = 0
var0_0.OPAQUE_INDEX = 1
var0_0.TRANSPARENT_INDEX = 0
var0_0.GLASS_CONFIG = {
	{
		region = "/[DECALROOT]/[DECAL GENERATOR]/[RandomDecals]/Region_18",
		vfx = "vfx_nxmfdoorglass01_l",
		path = "/[MainBlock]/[Model]/scene_root/no_bake/pre_db_cw_car/pre_db_cw_car01/all/fbx_db_cw_car01_doorglass01_l"
	},
	{
		region = "/[DECALROOT]/[DECAL GENERATOR]/[RandomDecals]/Region_19",
		vfx = "vfx_nxmfdoorglass01_r",
		path = "/[MainBlock]/[Model]/scene_root/no_bake/pre_db_cw_car/pre_db_cw_car01/all/fbx_db_cw_car01_doorglass01_r"
	},
	{
		region = "/[DECALROOT]/[DECAL GENERATOR]/[RandomDecals]/Region_17",
		vfx = "vfx_nxmfglass01",
		path = "/[MainBlock]/[Model]/scene_root/no_bake/pre_db_cw_car/pre_db_cw_car01/all/fbx_db_cw_car01_glass01"
	}
}
var0_0.PHASE_2_VFX = "/[MainBlock]/[Model]/scene_root/no_bake/pre_db_cw_car/pre_db_cw_car01/all/fbx_db_cw_car01_glass01/vfx_nxmfglass02"
var0_0.PHASE_2_RENDER = "/[MainBlock]/[Model]/scene_root/no_bake/pre_db_cw_car/pre_db_cw_car01/all/fbx_db_cw_car01_glass01"

function var0_0.OnInit(arg0_1)
	return
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(CarWashGameFlowSystem.SET_STAINS_COUNT_MAX, function(arg0_3, arg1_3)
		arg0_2:InitSceneRefs()
		arg0_2:RefreshAllGlassMaterialByRegion()
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
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_8, arg1_8)
		if arg1_8.newValue == CarWashConst.GAME_STATE.PHASE_2 then
			arg0_2:SetAllGlassTransparent()
		elseif arg1_8.newValue == CarWashConst.GAME_STATE.PHASE_1 then
			arg0_2:RefreshAllGlassMaterialByRegion()
		end

		arg0_2:EnablePhase2(arg1_8.newValue == CarWashConst.GAME_STATE.PHASE_2)
	end)
end

function var0_0.OnDispose(arg0_9)
	arg0_9.glassInfos = nil
end

function var0_0.InitSceneRefs(arg0_10)
	arg0_10.glassInfos = {}

	for iter0_10, iter1_10 in ipairs(var0_0.GLASS_CONFIG) do
		local var0_10 = GameObject.Find(iter1_10.path)

		assert(var0_10, "CarWash glass object not found: " .. tostring(iter1_10.path))

		local var1_10 = var0_10.transform
		local var2_10 = var0_10:GetComponent(typeof(MaterialSwitcher))

		assert(var2_10, "MaterialSwitcher component not found on " .. tostring(iter1_10.path))

		local var3_10 = GameObject.Find(iter1_10.region)

		assert(var3_10, "CarWash glass decal region not found: " .. tostring(iter1_10.region))

		local var4_10 = var1_10:Find(iter1_10.vfx)

		assert(var4_10, "CarWash glass vfx not found: " .. tostring(iter1_10.vfx))
		setActive(var4_10, false)
		table.insert(arg0_10.glassInfos, {
			switcher = var2_10,
			regionTF = var3_10.transform,
			vfxTF = var4_10
		})
	end

	arg0_10.phase2VFX = GameObject.Find(var0_0.PHASE_2_VFX)
	arg0_10.phase2Render = GameObject.Find(var0_0.PHASE_2_RENDER):GetComponent(typeof(MeshRenderer))
end

function var0_0.RefreshAllGlassMaterialByRegion(arg0_11, arg1_11)
	if not arg0_11.glassInfos then
		return
	end

	for iter0_11, iter1_11 in pairs(arg0_11.glassInfos) do
		arg0_11:SetGlassTransparent(iter1_11, iter1_11.regionTF.childCount == 0, arg1_11)
	end
end

function var0_0.SetAllGlassTransparent(arg0_12)
	if not arg0_12.glassInfos then
		return
	end

	for iter0_12, iter1_12 in pairs(arg0_12.glassInfos) do
		arg0_12:SetGlassTransparent(iter1_12, true)
	end
end

function var0_0.SetGlassTransparent(arg0_13, arg1_13, arg2_13, arg3_13)
	if arg3_13 and arg2_13 and not arg1_13.isTransparent then
		setActive(arg1_13.vfxTF, true)
	end

	local var0_13 = arg2_13 and var0_0.TRANSPARENT_INDEX or var0_0.OPAQUE_INDEX

	arg1_13.switcher:ReplaceMaterial(var0_0.MATERIAL_INDEX, var0_13)

	arg1_13.isTransparent = arg2_13
end

function var0_0.EnablePhase2(arg0_14, arg1_14)
	if arg0_14.phase2VFX then
		setActive(arg0_14.phase2VFX, arg1_14)
	end

	if arg0_14.phase2Render then
		arg0_14.phase2Render.enabled = not arg1_14
	end
end

return var0_0
