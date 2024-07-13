ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleConst
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleAttr
local var8_0 = var0_0.Battle.BattleDataFunction
local var9_0 = var0_0.Battle.BattleAttr
local var10_0 = class("BattleFleetCardPuzzleCardManageComponent")

var0_0.Battle.BattleFleetCardPuzzleCardManageComponent = var10_0
var10_0.__name = "BattleFleetCardPuzzleCardManageComponent"
var10_0.FUNC_NAME_SHUFFLE = "Shuffle"
var10_0.FUNC_NAME_POP = "Pop"
var10_0.FUNC_NAME_ADD = "Add"
var10_0.FUNC_NAME_BOTTOM = "Bottom"
var10_0.FUNC_NAME_REMOVE = "Remove"
var10_0.FUNC_NAME_SEARCH = "Search"
var10_0.FUNC_NAME_SORT = "Sort"
var10_0.FUNC_NAME_GET_LENGTH = "GetLength"
var10_0.SEARCH_BY_ID = "ID"
var10_0.SEARCH_BY_LABEL = "LABEL"
var10_0.SEARCH_BY_TYPE = "TYPE"

function var10_0.AttachCardManager(arg0_1)
	assert(arg0_1.GetCardList ~= nil, "该类>>" .. arg0_1.__name .. "<<使用card puzzle卡牌管理组件需要支持接口>>GetCardList<<，并返回所有的卡牌列表")
	assert(arg0_1.DispatchEvent ~= nil, "该类>>" .. arg0_1.__name .. "<<使用card puzzle卡牌管理组件需要事件派发组件")
	var10_0.New(arg0_1)
end

function var10_0.DetachCardManager(arg0_2)
	if arg0_2._cardManager_ == nil then
		return
	end

	arg0_2._cardManager_:_destroy_()

	arg0_2._cardManager_ = nil
end

function var10_0.Ctor(arg0_3, arg1_3)
	arg0_3._target_ = arg1_3

	arg0_3:_init_()
end

function var10_0._init_(arg0_4)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_SHUFFLE, var10_0._shuffle_)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_POP, var10_0._pop_)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_ADD, var10_0._add_)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_BOTTOM, var10_0._bottom_)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_REMOVE, var10_0._remove_)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_SEARCH, var10_0._search_)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_SORT, var10_0._sort_)
	arg0_4:_overrideAttachFunc(var10_0.FUNC_NAME_GET_LENGTH, var10_0._getLength_)
end

function var10_0._overrideAttachFunc(arg0_5, arg1_5, arg2_5)
	if arg0_5._target_[arg1_5] ~= nil then
		local var0_5 = arg0_5._target_[arg1_5]

		local function var1_5(...)
			var0_5(...)
			arg2_5(...)
		end

		arg0_5._target_[arg1_5] = var1_5
	else
		arg0_5._target_[arg1_5] = arg2_5
	end
end

function var10_0._destroy_(arg0_7)
	arg0_7._target_ = nil
end

function var10_0._add_(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetCardList()

	table.insert(var0_8, arg1_8)
	arg1_8:SetCurrentPile(arg0_8:GetIndexID())
	arg0_8:DispatchEvent(var0_0.Event.New(var3_0.UPDATE_CARDS, {
		type = var10_0.FUNC_NAME_ADD
	}))
end

function var10_0._bottom_(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetCardList()

	table.insert(var0_9, 1, arg1_9)
	arg0_9:DispatchEvent(var0_0.Event.New(var3_0.UPDATE_CARDS, {
		type = var10_0.FUNC_NAME_BOTTOM
	}))
end

function var10_0._remove_(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetCardList()

	for iter0_10, iter1_10 in ipairs(var0_10) do
		if arg1_10 == iter1_10 then
			arg1_10:SetFromPile(arg0_10:GetIndexID())
			table.remove(var0_10, iter0_10)
			arg0_10:DispatchEvent(var0_0.Event.New(var3_0.UPDATE_CARDS, {
				type = var10_0.FUNC_NAME_REMOVE
			}))

			return
		end
	end
end

function var10_0._shuffle_(arg0_11)
	local var0_11 = arg0_11:GetCardList()
	local var1_11 = arg0_11:GetLength()

	while var1_11 > 0 do
		local var2_11 = math.random(var1_11)

		var0_11[var1_11], var0_11[var2_11] = var0_11[var2_11], var0_11[var1_11]
		var1_11 = var1_11 - 1
	end

	arg0_11:DispatchEvent(var0_0.Event.New(var3_0.UPDATE_CARDS, {
		type = var10_0.FUNC_NAME_SHUFFLE
	}))
end

function var10_0._pop_(arg0_12)
	local var0_12 = arg0_12:GetCardList()
	local var1_12 = table.remove(var0_12, #var0_12)

	var1_12:SetFromPile(arg0_12:GetIndexID())

	return var1_12, arg0_12:DispatchEvent(var0_0.Event.New(var3_0.UPDATE_CARDS, {
		type = var10_0.FUNC_NAME_POP
	}))
end

function var10_0._sort_(arg0_13, arg1_13)
	return
end

function var10_0._search_(arg0_14, arg1_14)
	local var0_14 = {}
	local var1_14 = arg0_14:GetCardList()
	local var2_14 = arg1_14.value
	local var3_14 = arg1_14.type

	if var3_14 == var10_0.SEARCH_BY_ID then
		for iter0_14, iter1_14 in ipairs(var1_14) do
			if table.contains(var2_14, iter1_14:GetCardID()) then
				table.insert(var0_14, iter1_14)
			end
		end
	elseif var3_14 == var10_0.SEARCH_BY_LABEL then
		for iter2_14, iter3_14 in ipairs(var1_14) do
			if iter3_14:LabelContain(var2_14) then
				table.insert(var0_14, iter3_14)
			end
		end
	elseif var3_14 == var10_0.SEARCH_BY_TYPE then
		for iter4_14, iter5_14 in ipairs(var1_14) do
			if iter5_14:GetType() == var2_14 then
				table.insert(var0_14, iter5_14)
			end
		end
	end

	if arg1_14.total == true then
		return var0_14
	else
		return {
			var0_14[math.random(#var0_14)]
		}
	end
end

function var10_0._getLength_(arg0_15)
	return #arg0_15:GetCardList()
end
