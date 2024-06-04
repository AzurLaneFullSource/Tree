local var0 = class("WorldMapCell", import("...BaseEntity"))

var0.Fields = {
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
var0.EventAddAttachment = "WorldMapCell.EventAddAttachment"
var0.EventRemoveAttachment = "WorldMapCell.EventRemoveAttachment"
var0.EventUpdateInFov = "WorldMapCell.EventUpdateInFov"
var0.EventUpdateDiscovered = "WorldMapCell.EventUpdateDiscovered"
var0.EventUpdateFog = "WorldMapCell.EventUpdateFog"
var0.EventUpdateFogImage = "WorldMapCell.EventUpdateFogImage"
var0.EventUpdateTerrain = "WorldMapCell.EventUpdateTerrain"

function var0.GetName(arg0, arg1)
	return "cell_" .. arg0 .. "_" .. arg1
end

var0.TerrainNone = 0
var0.TerrainStream = 1
var0.TerrainIce = 2
var0.TerrainWind = 3
var0.TerrainFog = 4
var0.TerrainFire = 5
var0.TerrainPoison = 6

function var0.Build(arg0)
	arg0.attachments = {}
	arg0.dir = 0
	arg0.infov = 0
	arg0.inLight = 0
	arg0.fog = false
	arg0.fogLight = false
	arg0.fogSairen = false
end

function var0.Setup(arg0, arg1)
	arg0.row = arg1[1]
	arg0.column = arg1[2]
	arg0.walkable = arg1[3]
end

function var0.Dispose(arg0)
	WPool:ReturnArray(arg0.attachments)
	arg0:Clear()
end

function var0.AddAttachment(arg0, arg1)
	assert(not _.any(arg0.attachments, function(arg0)
		return arg0.row == arg1.row and arg0.column == arg1.column and arg0.type == arg1.type and arg0.id == arg1.id
	end))
	assert(arg1.row == arg0.row and arg1.column == arg0.column)
	assert(WorldMapAttachment.SortOrder[arg1.type], arg1.type .. " : sort order not set.")

	local var0 = WorldMapAttachment.SortOrder[arg1.type]
	local var1 = #arg0.attachments + 1

	for iter0, iter1 in ipairs(arg0.attachments) do
		if var0 > WorldMapAttachment.SortOrder[iter1.type] then
			var1 = iter0

			break
		end
	end

	table.insert(arg0.attachments, var1, arg1)
	arg0:DispatchEvent(var0.EventAddAttachment, arg1)

	if not arg0.discovered and arg1:ShouldMarkAsLurk() then
		arg1:UpdateLurk(true)
	end
end

function var0.RemoveAttachment(arg0, arg1)
	if arg1 == nil or type(arg1) == "number" then
		arg1 = arg1 or #arg0.attachments

		assert(arg1 >= 1 and arg1 <= #arg0.attachments)

		local var0 = arg0.attachments[arg1]

		table.remove(arg0.attachments, arg1)
		arg0:DispatchEvent(var0.EventRemoveAttachment, var0)
		WPool:Return(var0)
	elseif arg1.class == WorldMapAttachment then
		for iter0 = #arg0.attachments, 1, -1 do
			if arg0.attachments[iter0] == arg1 then
				arg0:RemoveAttachment(iter0)

				break
			end
		end
	end
end

function var0.ContainsAttachment(arg0, arg1)
	return _.any(arg0.attachments, function(arg0)
		return arg0 == arg1
	end)
end

function var0.GetInFOV(arg0)
	if arg0.fog then
		return arg0.fogLight
	else
		return arg0.infov > 0 or arg0.inLight > 0
	end
end

function var0.UpdateInFov(arg0, arg1)
	AfterCheck({
		{
			function()
				return arg0:GetInFOV()
			end,
			function()
				arg0:DispatchEvent(var0.EventUpdateInFov)
			end
		}
	}, function()
		arg0.infov = arg1
	end)
end

function var0.ChangeInLight(arg0, arg1)
	AfterCheck({
		{
			function()
				return arg0:GetInFOV()
			end,
			function()
				arg0:DispatchEvent(var0.EventUpdateInFov)
			end
		}
	}, function()
		arg0.inLight = arg0.inLight + (arg1 and 1 or -1)
	end)
end

function var0.InFog(arg0)
	if arg0.fog then
		return not arg0.fogLight
	else
		return arg0:GetTerrain() == var0.TerrainFog
	end
end

function var0.LookSairenFog(arg0)
	return arg0.fogSairen or arg0:IsTerrainSairenFog()
end

function var0.UpdateFog(arg0, arg1, arg2, arg3)
	AfterCheck({
		{
			function()
				return arg0:GetInFOV()
			end,
			function()
				arg0:DispatchEvent(var0.EventUpdateInFov)
			end
		},
		{
			function()
				return arg0:InFog()
			end,
			function()
				arg0:DispatchEvent(var0.EventUpdateFog)
			end
		},
		{
			function()
				return arg0:LookSairenFog()
			end,
			function()
				arg0:DispatchEvent(var0.EventUpdateFogImage)
			end
		}
	}, function()
		arg0.fog = defaultValue(arg1, arg0.fog)
		arg0.fogLight = defaultValue(arg2, arg0.fogLight)
		arg0.fogSairen = defaultValue(arg3, arg0.fogSairen)
	end)
end

function var0.UpdateDiscovered(arg0, arg1)
	if arg0.discovered ~= arg1 then
		arg0.discovered = arg1

		arg0:DispatchEvent(var0.EventUpdateDiscovered)
	end
end

function var0.GetTerrain(arg0)
	return arg0.terrain or var0.TerrainNone
end

function var0.UpdateTerrain(arg0, arg1, arg2, arg3)
	AfterCheck({
		{
			function()
				return arg0:InFog()
			end,
			function()
				arg0:DispatchEvent(var0.EventUpdateFog)
			end
		},
		{
			function()
				return arg0:LookSairenFog()
			end,
			function()
				arg0:DispatchEvent(var0.EventUpdateFogImage)
			end
		}
	}, function()
		arg0.terrain = arg1

		if arg0.terrain == var0.TerrainStream then
			assert(arg2)

			arg0.terrainDir = arg2
		elseif arg0.terrain == var0.TerrainWind then
			assert(arg2 and arg3)

			arg0.terrainDir = arg2
			arg0.terrainStrong = arg3
		elseif arg0.terrain == var0.TerrainFog then
			arg0.terrainStrong = arg3
		elseif arg0.terrain == var0.TerrainPoison then
			arg0.terrainStrong = arg3
		end

		arg0:DispatchEvent(var0.EventUpdateTerrain)
	end)
end

function var0.GetAliveAttachments(arg0)
	return _.filter(arg0.attachments, function(arg0)
		return arg0:IsAlive()
	end)
end

function var0.GetAliveAttachment(arg0)
	return _.detect(arg0.attachments, function(arg0)
		return arg0:IsAlive()
	end)
end

function var0.GetDisplayAttachment(arg0)
	return _.detect(arg0.attachments, function(arg0)
		return arg0:IsAlive() and arg0:IsVisible()
	end)
end

function var0.GetInterativeAttachment(arg0)
	return _.detect(arg0.attachments, function(arg0)
		return WorldMapAttachment.IsInteractiveType(arg0.type) and arg0:IsAlive() and arg0:IsVisible()
	end)
end

function var0.GetEventAttachment(arg0)
	return _.detect(arg0.attachments, function(arg0)
		return arg0:IsAlive() and arg0.type == WorldMapAttachment.TypeEvent
	end)
end

function var0.GetCompassAttachment(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.attachments) do
		table.insert(var0, iter0)
	end

	local var1 = _.detect(_.sort(var0, function(arg0, arg1)
		return (arg0.attachments[arg0].config.compass_index or 0) > (arg0.attachments[arg1].config.compass_index or 0)
	end), function(arg0)
		local var0 = arg0.attachments[arg0]

		if var0:ShouldMarkAsLurk() then
			return var0:IsAlive() and var0:IsVisible() and arg0.discovered
		elseif var0.type == WorldMapAttachment.TypeEvent then
			return var0:IsAlive() and var0.config.visuality == 0
		elseif var0.type ~= WorldMapAttachment.TypeFleet and var0.type ~= WorldMapAttachment.TypePort then
			return var0:IsAlive()
		end
	end)

	return var1 and arg0.attachments[var1]
end

function var0.FindAliveAttachment(arg0, arg1)
	assert(arg1 ~= nil)

	return _.detect(arg0.attachments, function(arg0)
		return arg0:IsAlive() and arg0.type == arg1
	end)
end

function var0.IsTerrainSairenFog(arg0)
	return arg0.terrain == var0.TerrainFog and arg0.terrainStrong == 0
end

function var0.CanLeave(arg0)
	return arg0.walkable and arg0:GetTerrainObstacleConfig("leave") and underscore.all(arg0.attachments, function(arg0)
		return not arg0:IsAlive() or arg0:CanLeave()
	end)
end

function var0.CanArrive(arg0)
	return arg0.walkable and arg0:GetTerrainObstacleConfig("arrive") and underscore.all(arg0.attachments, function(arg0)
		return not arg0:IsAlive() or arg0:CanArrive()
	end)
end

function var0.CanPass(arg0)
	return arg0.walkable and arg0:GetTerrainObstacleConfig("pass") and underscore.all(arg0.attachments, function(arg0)
		return not arg0:IsAlive() or arg0:CanPass()
	end)
end

function var0.IsSign(arg0)
	return _.any(arg0.attachments, function(arg0)
		return arg0:IsAlive() and arg0:IsSign()
	end)
end

function var0.ExistEnemy(arg0)
	return tobool(arg0:GetStageEnemy())
end

function var0.GetStageEnemy(arg0)
	return _.detect(arg0.attachments, function(arg0)
		return arg0:IsAlive() and WorldMapAttachment.IsEnemyType(arg0.type)
	end)
end

function var0.GetDisplayQuad(arg0)
	local var0
	local var1 = arg0:GetDisplayAttachment()

	if not arg0:InFog() and var1 then
		if var1.type == WorldMapAttachment.TypeEvent then
			local var2 = var1.config.object_icon

			if var2 and #var2 > 0 then
				var0 = var2
			end
		elseif WorldMapAttachment.IsEnemyType(var1.type) then
			var0 = {
				"cell_red"
			}
		elseif var1.type == WorldMapAttachment.TypePort or var1.type == WorldMapAttachment.TypeBox then
			var0 = {
				"cell_yellow"
			}
		end
	end

	return var0
end

function var0.GetEmotion(arg0)
	return arg0.terrain == var0.TerrainPoison and WorldConst.PoisonEffect or nil
end

function var0.GetScannerAttachment(arg0)
	local var0 = arg0:GetAliveAttachments()
	local var1
	local var2

	for iter0, iter1 in ipairs(var0) do
		local var3 = iter1:IsScannerAttachment()

		if var3 and (not var1 or var2 < var3) then
			var1 = iter1
			var2 = var3
		end
	end

	return var1
end

var0.TerrainObstacleConfig = {
	SairenFog = 4,
	[var0.TerrainNone] = 7,
	[var0.TerrainStream] = 6,
	[var0.TerrainIce] = 6,
	[var0.TerrainWind] = 2,
	[var0.TerrainFog] = 6,
	[var0.TerrainFire] = 7,
	[var0.TerrainPoison] = 7
}

function var0.GetTerrainObstacleConfig(arg0, arg1)
	local var0 = arg0:IsTerrainSairenFog() and "SairenFog" or arg0:GetTerrain()
	local var1 = WorldConst.GetObstacleKey(arg1)

	return bit.band(var0.TerrainObstacleConfig[var0], var1) > 0
end

function var0.IsMovingTerrain(arg0)
	return arg0 == var0.TerrainStream or arg0 == var0.TerrainIce or arg0 == var0.TerrainWind
end

return var0
