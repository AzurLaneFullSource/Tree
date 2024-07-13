local var0_0 = class("WorldMapCell", import("...BaseEntity"))

var0_0.Fields = {
	terrainDir = "number",
	discovered = "boolean",
	attachments = "table",
	fogSairen = "boolean",
	dir = "number",
	column = "number",
	walkable = "boolean",
	fog = "boolean",
	row = "number",
	infov = "number",
	terrain = "number",
	inLight = "number",
	terrainStrong = "number",
	fogLight = "boolean"
}
var0_0.EventAddAttachment = "WorldMapCell.EventAddAttachment"
var0_0.EventRemoveAttachment = "WorldMapCell.EventRemoveAttachment"
var0_0.EventUpdateInFov = "WorldMapCell.EventUpdateInFov"
var0_0.EventUpdateDiscovered = "WorldMapCell.EventUpdateDiscovered"
var0_0.EventUpdateFog = "WorldMapCell.EventUpdateFog"
var0_0.EventUpdateFogImage = "WorldMapCell.EventUpdateFogImage"
var0_0.EventUpdateTerrain = "WorldMapCell.EventUpdateTerrain"

function var0_0.GetName(arg0_1, arg1_1)
	return "cell_" .. arg0_1 .. "_" .. arg1_1
end

var0_0.TerrainNone = 0
var0_0.TerrainStream = 1
var0_0.TerrainIce = 2
var0_0.TerrainWind = 3
var0_0.TerrainFog = 4
var0_0.TerrainFire = 5
var0_0.TerrainPoison = 6

function var0_0.Build(arg0_2)
	arg0_2.attachments = {}
	arg0_2.dir = 0
	arg0_2.infov = 0
	arg0_2.inLight = 0
	arg0_2.fog = false
	arg0_2.fogLight = false
	arg0_2.fogSairen = false
end

function var0_0.Setup(arg0_3, arg1_3)
	arg0_3.row = arg1_3[1]
	arg0_3.column = arg1_3[2]
	arg0_3.walkable = arg1_3[3]
end

function var0_0.Dispose(arg0_4)
	WPool:ReturnArray(arg0_4.attachments)
	arg0_4:Clear()
end

function var0_0.AddAttachment(arg0_5, arg1_5)
	assert(not _.any(arg0_5.attachments, function(arg0_6)
		return arg0_6.row == arg1_5.row and arg0_6.column == arg1_5.column and arg0_6.type == arg1_5.type and arg0_6.id == arg1_5.id
	end))
	assert(arg1_5.row == arg0_5.row and arg1_5.column == arg0_5.column)
	assert(WorldMapAttachment.SortOrder[arg1_5.type], arg1_5.type .. " : sort order not set.")

	local var0_5 = WorldMapAttachment.SortOrder[arg1_5.type]
	local var1_5 = #arg0_5.attachments + 1

	for iter0_5, iter1_5 in ipairs(arg0_5.attachments) do
		if var0_5 > WorldMapAttachment.SortOrder[iter1_5.type] then
			var1_5 = iter0_5

			break
		end
	end

	table.insert(arg0_5.attachments, var1_5, arg1_5)
	arg0_5:DispatchEvent(var0_0.EventAddAttachment, arg1_5)

	if not arg0_5.discovered and arg1_5:ShouldMarkAsLurk() then
		arg1_5:UpdateLurk(true)
	end
end

function var0_0.RemoveAttachment(arg0_7, arg1_7)
	if arg1_7 == nil or type(arg1_7) == "number" then
		arg1_7 = arg1_7 or #arg0_7.attachments

		assert(arg1_7 >= 1 and arg1_7 <= #arg0_7.attachments)

		local var0_7 = arg0_7.attachments[arg1_7]

		table.remove(arg0_7.attachments, arg1_7)
		arg0_7:DispatchEvent(var0_0.EventRemoveAttachment, var0_7)
		WPool:Return(var0_7)
	elseif arg1_7.class == WorldMapAttachment then
		for iter0_7 = #arg0_7.attachments, 1, -1 do
			if arg0_7.attachments[iter0_7] == arg1_7 then
				arg0_7:RemoveAttachment(iter0_7)

				break
			end
		end
	end
end

function var0_0.ContainsAttachment(arg0_8, arg1_8)
	return _.any(arg0_8.attachments, function(arg0_9)
		return arg0_9 == arg1_8
	end)
end

function var0_0.GetInFOV(arg0_10)
	if arg0_10.fog then
		return arg0_10.fogLight
	else
		return arg0_10.infov > 0 or arg0_10.inLight > 0
	end
end

function var0_0.UpdateInFov(arg0_11, arg1_11)
	AfterCheck({
		{
			function()
				return arg0_11:GetInFOV()
			end,
			function()
				arg0_11:DispatchEvent(var0_0.EventUpdateInFov)
			end
		}
	}, function()
		arg0_11.infov = arg1_11
	end)
end

function var0_0.ChangeInLight(arg0_15, arg1_15)
	AfterCheck({
		{
			function()
				return arg0_15:GetInFOV()
			end,
			function()
				arg0_15:DispatchEvent(var0_0.EventUpdateInFov)
			end
		}
	}, function()
		arg0_15.inLight = arg0_15.inLight + (arg1_15 and 1 or -1)
	end)
end

function var0_0.InFog(arg0_19)
	if arg0_19.fog then
		return not arg0_19.fogLight
	else
		return arg0_19:GetTerrain() == var0_0.TerrainFog
	end
end

function var0_0.LookSairenFog(arg0_20)
	return arg0_20.fogSairen or arg0_20:IsTerrainSairenFog()
end

function var0_0.UpdateFog(arg0_21, arg1_21, arg2_21, arg3_21)
	AfterCheck({
		{
			function()
				return arg0_21:GetInFOV()
			end,
			function()
				arg0_21:DispatchEvent(var0_0.EventUpdateInFov)
			end
		},
		{
			function()
				return arg0_21:InFog()
			end,
			function()
				arg0_21:DispatchEvent(var0_0.EventUpdateFog)
			end
		},
		{
			function()
				return arg0_21:LookSairenFog()
			end,
			function()
				arg0_21:DispatchEvent(var0_0.EventUpdateFogImage)
			end
		}
	}, function()
		arg0_21.fog = defaultValue(arg1_21, arg0_21.fog)
		arg0_21.fogLight = defaultValue(arg2_21, arg0_21.fogLight)
		arg0_21.fogSairen = defaultValue(arg3_21, arg0_21.fogSairen)
	end)
end

function var0_0.UpdateDiscovered(arg0_29, arg1_29)
	if arg0_29.discovered ~= arg1_29 then
		arg0_29.discovered = arg1_29

		arg0_29:DispatchEvent(var0_0.EventUpdateDiscovered)
	end
end

function var0_0.GetTerrain(arg0_30)
	return arg0_30.terrain or var0_0.TerrainNone
end

function var0_0.UpdateTerrain(arg0_31, arg1_31, arg2_31, arg3_31)
	AfterCheck({
		{
			function()
				return arg0_31:InFog()
			end,
			function()
				arg0_31:DispatchEvent(var0_0.EventUpdateFog)
			end
		},
		{
			function()
				return arg0_31:LookSairenFog()
			end,
			function()
				arg0_31:DispatchEvent(var0_0.EventUpdateFogImage)
			end
		}
	}, function()
		arg0_31.terrain = arg1_31

		if arg0_31.terrain == var0_0.TerrainStream then
			assert(arg2_31)

			arg0_31.terrainDir = arg2_31
		elseif arg0_31.terrain == var0_0.TerrainWind then
			assert(arg2_31 and arg3_31)

			arg0_31.terrainDir = arg2_31
			arg0_31.terrainStrong = arg3_31
		elseif arg0_31.terrain == var0_0.TerrainFog then
			arg0_31.terrainStrong = arg3_31
		elseif arg0_31.terrain == var0_0.TerrainPoison then
			arg0_31.terrainStrong = arg3_31
		end

		arg0_31:DispatchEvent(var0_0.EventUpdateTerrain)
	end)
end

function var0_0.GetAliveAttachments(arg0_37)
	return _.filter(arg0_37.attachments, function(arg0_38)
		return arg0_38:IsAlive()
	end)
end

function var0_0.GetAliveAttachment(arg0_39)
	return _.detect(arg0_39.attachments, function(arg0_40)
		return arg0_40:IsAlive()
	end)
end

function var0_0.GetDisplayAttachment(arg0_41)
	return _.detect(arg0_41.attachments, function(arg0_42)
		return arg0_42:IsAlive() and arg0_42:IsVisible()
	end)
end

function var0_0.GetInterativeAttachment(arg0_43)
	return _.detect(arg0_43.attachments, function(arg0_44)
		return WorldMapAttachment.IsInteractiveType(arg0_44.type) and arg0_44:IsAlive() and arg0_44:IsVisible()
	end)
end

function var0_0.GetEventAttachment(arg0_45)
	return _.detect(arg0_45.attachments, function(arg0_46)
		return arg0_46:IsAlive() and arg0_46.type == WorldMapAttachment.TypeEvent
	end)
end

function var0_0.GetCompassAttachment(arg0_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in ipairs(arg0_47.attachments) do
		table.insert(var0_47, iter0_47)
	end

	local var1_47 = _.detect(_.sort(var0_47, function(arg0_48, arg1_48)
		return (arg0_47.attachments[arg0_48].config.compass_index or 0) > (arg0_47.attachments[arg1_48].config.compass_index or 0)
	end), function(arg0_49)
		local var0_49 = arg0_47.attachments[arg0_49]

		if var0_49:ShouldMarkAsLurk() then
			return var0_49:IsAlive() and var0_49:IsVisible() and arg0_47.discovered
		elseif var0_49.type == WorldMapAttachment.TypeEvent then
			return var0_49:IsAlive() and var0_49.config.visuality == 0
		elseif var0_49.type ~= WorldMapAttachment.TypeFleet and var0_49.type ~= WorldMapAttachment.TypePort then
			return var0_49:IsAlive()
		end
	end)

	return var1_47 and arg0_47.attachments[var1_47]
end

function var0_0.FindAliveAttachment(arg0_50, arg1_50)
	assert(arg1_50 ~= nil)

	return _.detect(arg0_50.attachments, function(arg0_51)
		return arg0_51:IsAlive() and arg0_51.type == arg1_50
	end)
end

function var0_0.IsTerrainSairenFog(arg0_52)
	return arg0_52.terrain == var0_0.TerrainFog and arg0_52.terrainStrong == 0
end

function var0_0.CanLeave(arg0_53)
	return arg0_53.walkable and arg0_53:GetTerrainObstacleConfig("leave") and underscore.all(arg0_53.attachments, function(arg0_54)
		return not arg0_54:IsAlive() or arg0_54:CanLeave()
	end)
end

function var0_0.CanArrive(arg0_55)
	return arg0_55.walkable and arg0_55:GetTerrainObstacleConfig("arrive") and underscore.all(arg0_55.attachments, function(arg0_56)
		return not arg0_56:IsAlive() or arg0_56:CanArrive()
	end)
end

function var0_0.CanPass(arg0_57)
	return arg0_57.walkable and arg0_57:GetTerrainObstacleConfig("pass") and underscore.all(arg0_57.attachments, function(arg0_58)
		return not arg0_58:IsAlive() or arg0_58:CanPass()
	end)
end

function var0_0.IsSign(arg0_59)
	return _.any(arg0_59.attachments, function(arg0_60)
		return arg0_60:IsAlive() and arg0_60:IsSign()
	end)
end

function var0_0.ExistEnemy(arg0_61)
	return tobool(arg0_61:GetStageEnemy())
end

function var0_0.GetStageEnemy(arg0_62)
	return _.detect(arg0_62.attachments, function(arg0_63)
		return arg0_63:IsAlive() and WorldMapAttachment.IsEnemyType(arg0_63.type)
	end)
end

function var0_0.GetDisplayQuad(arg0_64)
	local var0_64
	local var1_64 = arg0_64:GetDisplayAttachment()

	if not arg0_64:InFog() and var1_64 then
		if var1_64.type == WorldMapAttachment.TypeEvent then
			local var2_64 = var1_64.config.object_icon

			if var2_64 and #var2_64 > 0 then
				var0_64 = var2_64
			end
		elseif WorldMapAttachment.IsEnemyType(var1_64.type) then
			var0_64 = {
				"cell_red"
			}
		elseif var1_64.type == WorldMapAttachment.TypePort or var1_64.type == WorldMapAttachment.TypeBox then
			var0_64 = {
				"cell_yellow"
			}
		end
	end

	return var0_64
end

function var0_0.GetEmotion(arg0_65)
	return arg0_65.terrain == var0_0.TerrainPoison and WorldConst.PoisonEffect or nil
end

function var0_0.GetScannerAttachment(arg0_66)
	local var0_66 = arg0_66:GetAliveAttachments()
	local var1_66
	local var2_66

	for iter0_66, iter1_66 in ipairs(var0_66) do
		local var3_66 = iter1_66:IsScannerAttachment()

		if var3_66 and (not var1_66 or var2_66 < var3_66) then
			var1_66 = iter1_66
			var2_66 = var3_66
		end
	end

	return var1_66
end

var0_0.TerrainObstacleConfig = {
	SairenFog = 4,
	[var0_0.TerrainNone] = 7,
	[var0_0.TerrainStream] = 6,
	[var0_0.TerrainIce] = 6,
	[var0_0.TerrainWind] = 2,
	[var0_0.TerrainFog] = 6,
	[var0_0.TerrainFire] = 7,
	[var0_0.TerrainPoison] = 7
}

function var0_0.GetTerrainObstacleConfig(arg0_67, arg1_67)
	local var0_67 = arg0_67:IsTerrainSairenFog() and "SairenFog" or arg0_67:GetTerrain()
	local var1_67 = WorldConst.GetObstacleKey(arg1_67)

	return bit.band(var0_0.TerrainObstacleConfig[var0_67], var1_67) > 0
end

function var0_0.IsMovingTerrain(arg0_68)
	return arg0_68 == var0_0.TerrainStream or arg0_68 == var0_0.TerrainIce or arg0_68 == var0_0.TerrainWind
end

return var0_0
