local var0_0 = class("AgoraPreviewController", import("..AgoraController"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.furnitureId = arg3_1
	arg0_1.lastExitPoint = arg4_1

	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.GoBackLastExitPoint(arg0_2)
	arg0_2:ExitEditMode()
	arg0_2:NotifiyIsland(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_2.lastExitPoint)
end

function var0_0.EnterEditMode(arg0_3)
	arg0_3.isEidting = true

	arg0_3:NotifiyAgora(ISLAND_AGORA_EVT.ENTER_EDIT)
end

function var0_0.ExitEditMode(arg0_4)
	arg0_4.isEidting = false

	arg0_4:NotifiyAgora(ISLAND_AGORA_EVT.EXIT_EDIT)
end

function var0_0.SetUp(arg0_5)
	var0_0.super.super.SetUp(arg0_5)
	arg0_5:NotifiyAgora(ISLAND_AGORA_EVT.MAP_SIZE_UPDATE, arg0_5.agora:GetSize())

	for iter0_5, iter1_5 in pairs(arg0_5.agora:GetPlaceableList()) do
		arg0_5:PlaceItem(iter1_5.id, Vector2(0, 0), Vector3(0, 0, 0))
	end

	arg0_5:NotifiyAgora(ISLAND_AGORA_EVT.END_LOAD_ITEMS)
end

function var0_0.UnPlaceItem(arg0_6)
	pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_function_unuse"))
end

function var0_0.CreateAgora(arg0_7, arg1_7)
	local var0_7 = arg1_7:GetAgoraAgency()
	local var1_7 = arg0_7.furnitureId
	local var2_7 = {}

	for iter0_7, iter1_7 in ipairs({
		{
			count = 1,
			id = var1_7
		}
	}) do
		for iter2_7 = 1, iter1_7.count do
			local var3_7 = AgoraCalc.GetUniqueId(iter1_7.id, iter2_7)
			local var4_7 = AgoraFurniture.New({
				id = var3_7,
				configId = iter1_7.id
			})

			var2_7[var4_7.id] = var4_7
		end
	end

	local var5_7 = var0_7:GetLevel()
	local var6_7 = math.clamp(var5_7, 1, #IslandConst.AGORA_LEVEL_2_SIZE)
	local var7_7 = IslandConst.AGORA_LEVEL_2_SIZE[var6_7]
	local var8_7 = var0_7:GetCapacity()

	return Agora.New({
		size = Vector2(var7_7, var7_7),
		placeableList = var2_7,
		capacity = var8_7,
		themes = {},
		systemThemes = {}
	}), {
		placedlist = {},
		placedFloor = {},
		placedTile = {}
	}
end

return var0_0
