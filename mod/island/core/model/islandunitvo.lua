local var0_0 = class("IslandUnitVO")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.modelId = arg1_1.modelId
	arg0_1.type = arg1_1.type
	arg0_1.name = arg1_1.name
	arg0_1.position = BuildVector3(arg1_1.position)
	arg0_1.rotation = BuildVector3(arg1_1.rotation)
	arg0_1.scale = BuildVector3(arg1_1.scale)
	arg0_1.behaviourTree = arg1_1.behaviourTree
end

function var0_0.GetType(arg0_2)
	return arg0_2.type
end

function var0_0.IsPlayer(arg0_3)
	return arg0_3.type == IslandConst.UNIT_TYPE_PLAYER
end

function var0_0.GetAssetPath(arg0_4)
	local var0_4

	if arg0_4.type == IslandConst.UNIT_TYPE_CHAR then
		var0_4 = pg.island_unit_character[arg0_4.modelId].model
	elseif arg0_4.type == IslandConst.UNIT_TYPE_ITEM or arg0_4.type == IslandConst.UNIT_TYPE_ITEM_INTERACT then
		var0_4 = pg.island_unit_item[arg0_4.modelId].model
	elseif arg0_4.type == IslandConst.UNIT_TYPE_PLAYER or arg0_4.type == IslandConst.UNIT_TYPE_VISITOR or arg0_4.type == IslandConst.UNIT_TYPE_SYSTEM then
		var0_4 = pg.island_ship[arg0_4.modelId].model
	end

	assert(var0_4)

	return string.lower(var0_4)
end

function var0_0.GetBehaviourTree(arg0_5)
	return arg0_5.behaviourTree
end

return var0_0
