local var0_0 = class("IslandUnitVO")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.modelId = arg1_1.modelId
	arg0_1.type = arg1_1.type
	arg0_1.name = arg1_1.name
	arg0_1.index = arg1_1.index
	arg0_1.genType = defaultValue(arg1_1.genType, IslandConst.UNIT_GEN_TYPE_STATIC)
	arg0_1.isDynamic = arg0_1.genType == IslandConst.UNIT_GEN_TYPE_DYNAMIC
	arg0_1.showCondition = defaultValue(arg1_1.showCondition, {})
	arg0_1.hideCondition = defaultValue(arg1_1.hideCondition, {})
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

function var0_0.IsGift(arg0_4)
	return arg0_4.genType == IslandConst.UNIT_GEN_TYPE_GIFT
end

function var0_0.Interactable(arg0_5)
	return arg0_5.type == IslandConst.UNIT_TYPE_ITEM_INTERACT
end

function var0_0.GetAssetPath(arg0_6)
	local var0_6

	if arg0_6.type == IslandConst.UNIT_TYPE_CHAR or arg0_6.type == IslandConst.UNIT_TYPE_PLAYER or arg0_6.type == IslandConst.UNIT_TYPE_VISITOR or arg0_6.type == IslandConst.UNIT_TYPE_SYSTEM or arg0_6.type == IslandConst.UNIT_TYPE_STROLL or arg0_6.type == IslandConst.UNIT_TYPE_MANAGE_CHARA or arg0_6.type == IslandConst.UNIT_TYPE_MANAGE_CUSTOMER or arg0_6.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION or arg0_6.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION then
		assert(pg.island_unit_character[arg0_6.modelId], arg0_6.modelId)

		var0_6 = pg.island_unit_character[arg0_6.modelId].model
	elseif arg0_6.type == IslandConst.UNIT_TYPE_ITEM or arg0_6.type == IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT or arg0_6.type == IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING or arg0_6.type == IslandConst.UNIT_TYPE_ITEM_PRODUCT_ITEM or arg0_6.type == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM or arg0_6.type == IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM or arg0_6.type == IslandConst.UNIT_TYPE_MANAGE_ITEM then
		var0_6 = pg.island_unit_item[arg0_6.modelId].model
	elseif arg0_6.type == IslandConst.UNIT_TYPE_ITEM_INTERACT then
		var0_6 = pg.island_unit_interactive_item[arg0_6.modelId].model
	end

	assert(var0_6)

	return string.lower(var0_6)
end

function var0_0.GetBehaviourTree(arg0_7)
	return arg0_7.behaviourTree
end

function var0_0.GetAnimator(arg0_8)
	if arg0_8.type == IslandConst.UNIT_TYPE_PLAYER or arg0_8.type == IslandConst.UNIT_TYPE_VISITOR or arg0_8.type == IslandConst.UNIT_TYPE_CHAR or arg0_8.type == IslandConst.UNIT_TYPE_STROLL or arg0_8.type == IslandConst.UNIT_TYPE_MANAGE_CHARA or arg0_8.type == IslandConst.UNIT_TYPE_MANAGE_CUSTOMER or arg0_8.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION or arg0_8.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION then
		return pg.island_unit_character[arg0_8.modelId].animator
	elseif arg0_8.type == IslandConst.UNIT_TYPE_SYSTEM then
		return pg.island_unit_character[arg0_8.modelId].animator
	end

	warning("目前只有角色需要动态获取动画状态机")
end

function var0_0.GetShowCondition(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.showCondition) do
		table.insert(var0_9, iter1_9)
	end

	return var0_9
end

function var0_0.GetHideCondition(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.hideCondition) do
		table.insert(var0_10, iter1_10)
	end

	return var0_10
end

return var0_0
