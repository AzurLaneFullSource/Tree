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
	arg0_1.delayTime = arg1_1.delayTime
end

function var0_0.GetType(arg0_2)
	return arg0_2.type
end

function var0_0.IsPlayer(arg0_3)
	return arg0_3.type == IslandConst.UNIT_TYPE_PLAYER
end

function var0_0.IsFirstTakePhoto(arg0_4)
	return arg0_4.type == IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM and arg0_4.id == 2
end

function var0_0.IsThirdTakePhoto(arg0_5)
	return arg0_5.type == IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM and arg0_5.id == 3
end

function var0_0.IsGift(arg0_6)
	return arg0_6.genType == IslandConst.UNIT_GEN_TYPE_GIFT
end

function var0_0.Interactable(arg0_7)
	return arg0_7.type == IslandConst.UNIT_TYPE_ITEM_INTERACT
end

function var0_0.IsNpcType(arg0_8)
	return arg0_8.type == IslandConst.UNIT_TYPE_CHAR or arg0_8.type == IslandConst.UNIT_TYPE_PLAYER or arg0_8.type == IslandConst.UNIT_TYPE_VISITOR or arg0_8.type == IslandConst.UNIT_TYPE_SYSTEM or arg0_8.type == IslandConst.UNIT_TYPE_STROLL or arg0_8.type == IslandConst.UNIT_TYPE_MANAGE_CHARA or arg0_8.type == IslandConst.UNIT_TYPE_MANAGE_CUSTOMER or arg0_8.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION or arg0_8.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION or arg0_8.type == IslandConst.UNIT_TYPE_FOLLOWER or arg0_8.type == IslandConst.UNIT_TYPE_DELEGATE_FISH or arg0_8.type == IslandConst.UNIT_TYPE_CHEATERTAVERN_PLAYER
end

function var0_0.IsItemType(arg0_9)
	return arg0_9.type == IslandConst.UNIT_TYPE_ITEM or arg0_9.type == IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT or arg0_9.type == IslandConst.UNIT_TYPE_ITEM_HANDLE_PLANTING or arg0_9.type == IslandConst.UNIT_TYPE_ITEM_PRODUCT_ITEM or arg0_9.type == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM or arg0_9.type == IslandConst.UNIT_TYPE_ITEM_WILD_COLLECT_ITEM or arg0_9.type == IslandConst.UNIT_TYPE_MANAGE_ITEM or arg0_9.type == IslandConst.UNIT_TYPE_ITEM_DELAY_RECYCLE or arg0_9.type == IslandConst.UNIT_TYPE_FIRST_TAKE_PHOTO_ITEM or arg0_9.type == IslandConst.UNIT_TYPE_CHEATERTAVERN_TABLE or arg0_9.type == IslandConst.UNIT_TYPE_CHEATERTAVERN_CHAIR or arg0_9.type == IslandConst.UNIT_TYPE_FISH_POINT
end

function var0_0.GetPersonality(arg0_10)
	local var0_10 = 0
	local var1_10 = 0

	if arg0_10:IsNpcType() then
		local var2_10 = pg.island_unit_character[arg0_10.modelId]

		var0_10, var1_10 = var2_10.personality or 0, var2_10.is_active or 0
	end

	return var0_10, var1_10
end

function var0_0.GetAssetPath(arg0_11)
	local var0_11

	if arg0_11:IsNpcType() then
		warning(arg0_11.type)
		assert(pg.island_unit_character[arg0_11.modelId], arg0_11.modelId)

		var0_11 = pg.island_unit_character[arg0_11.modelId].model
	elseif arg0_11:IsItemType() then
		var0_11 = pg.island_unit_item[arg0_11.modelId].model
	elseif arg0_11:Interactable() then
		var0_11 = pg.island_unit_interactive_item[arg0_11.modelId].model
	end

	assert(var0_11)

	return string.lower(var0_11)
end

function var0_0.GetBehaviourTree(arg0_12)
	return arg0_12.behaviourTree
end

function var0_0.GetAnimator(arg0_13)
	if arg0_13.type == IslandConst.UNIT_TYPE_PLAYER or arg0_13.type == IslandConst.UNIT_TYPE_VISITOR or arg0_13.type == IslandConst.UNIT_TYPE_CHAR or arg0_13.type == IslandConst.UNIT_TYPE_STROLL or arg0_13.type == IslandConst.UNIT_TYPE_MANAGE_CHARA or arg0_13.type == IslandConst.UNIT_TYPE_MANAGE_CUSTOMER or arg0_13.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION or arg0_13.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION or arg0_13.type == IslandConst.UNIT_TYPE_FOLLOWER or arg0_13.type == IslandConst.UNIT_TYPE_DELEGATE_FISH then
		return pg.island_unit_character[arg0_13.modelId].animator
	elseif arg0_13.type == IslandConst.UNIT_TYPE_SYSTEM then
		return pg.island_unit_character[arg0_13.modelId].animator
	elseif arg0_13.type == IslandConst.UNIT_TYPE_CHEATERTAVERN_PLAYER then
		return "island/animator/ani_role_all_cheatertavern_01"
	end

	warning("目前只有角色需要动态获取动画状态机")
end

function var0_0.GetShowCondition(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.showCondition) do
		table.insert(var0_14, iter1_14)
	end

	return var0_14
end

function var0_0.GetHideCondition(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.hideCondition) do
		table.insert(var0_15, iter1_15)
	end

	return var0_15
end

return var0_0
