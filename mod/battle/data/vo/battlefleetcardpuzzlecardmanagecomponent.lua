ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleConst
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleAttr
local var8 = var0.Battle.BattleDataFunction
local var9 = var0.Battle.BattleAttr
local var10 = class("BattleFleetCardPuzzleCardManageComponent")

var0.Battle.BattleFleetCardPuzzleCardManageComponent = var10
var10.__name = "BattleFleetCardPuzzleCardManageComponent"
var10.FUNC_NAME_SHUFFLE = "Shuffle"
var10.FUNC_NAME_POP = "Pop"
var10.FUNC_NAME_ADD = "Add"
var10.FUNC_NAME_BOTTOM = "Bottom"
var10.FUNC_NAME_REMOVE = "Remove"
var10.FUNC_NAME_SEARCH = "Search"
var10.FUNC_NAME_SORT = "Sort"
var10.FUNC_NAME_GET_LENGTH = "GetLength"
var10.SEARCH_BY_ID = "ID"
var10.SEARCH_BY_LABEL = "LABEL"
var10.SEARCH_BY_TYPE = "TYPE"

function var10.AttachCardManager(arg0)
	assert(arg0.GetCardList ~= nil, "该类>>" .. arg0.__name .. "<<使用card puzzle卡牌管理组件需要支持接口>>GetCardList<<，并返回所有的卡牌列表")
	assert(arg0.DispatchEvent ~= nil, "该类>>" .. arg0.__name .. "<<使用card puzzle卡牌管理组件需要事件派发组件")
	var10.New(arg0)
end

function var10.DetachCardManager(arg0)
	if arg0._cardManager_ == nil then
		return
	end

	arg0._cardManager_:_destroy_()

	arg0._cardManager_ = nil
end

function var10.Ctor(arg0, arg1)
	arg0._target_ = arg1

	arg0:_init_()
end

function var10._init_(arg0)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_SHUFFLE, var10._shuffle_)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_POP, var10._pop_)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_ADD, var10._add_)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_BOTTOM, var10._bottom_)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_REMOVE, var10._remove_)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_SEARCH, var10._search_)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_SORT, var10._sort_)
	arg0:_overrideAttachFunc(var10.FUNC_NAME_GET_LENGTH, var10._getLength_)
end

function var10._overrideAttachFunc(arg0, arg1, arg2)
	if arg0._target_[arg1] ~= nil then
		local var0 = arg0._target_[arg1]

		local function var1(...)
			var0(...)
			arg2(...)
		end

		arg0._target_[arg1] = var1
	else
		arg0._target_[arg1] = arg2
	end
end

function var10._destroy_(arg0)
	arg0._target_ = nil
end

function var10._add_(arg0, arg1)
	local var0 = arg0:GetCardList()

	table.insert(var0, arg1)
	arg1:SetCurrentPile(arg0:GetIndexID())
	arg0:DispatchEvent(var0.Event.New(var3.UPDATE_CARDS, {
		type = var10.FUNC_NAME_ADD
	}))
end

function var10._bottom_(arg0, arg1)
	local var0 = arg0:GetCardList()

	table.insert(var0, 1, arg1)
	arg0:DispatchEvent(var0.Event.New(var3.UPDATE_CARDS, {
		type = var10.FUNC_NAME_BOTTOM
	}))
end

function var10._remove_(arg0, arg1)
	local var0 = arg0:GetCardList()

	for iter0, iter1 in ipairs(var0) do
		if arg1 == iter1 then
			arg1:SetFromPile(arg0:GetIndexID())
			table.remove(var0, iter0)
			arg0:DispatchEvent(var0.Event.New(var3.UPDATE_CARDS, {
				type = var10.FUNC_NAME_REMOVE
			}))

			return
		end
	end
end

function var10._shuffle_(arg0)
	local var0 = arg0:GetCardList()
	local var1 = arg0:GetLength()

	while var1 > 0 do
		local var2 = math.random(var1)

		var0[var1], var0[var2] = var0[var2], var0[var1]
		var1 = var1 - 1
	end

	arg0:DispatchEvent(var0.Event.New(var3.UPDATE_CARDS, {
		type = var10.FUNC_NAME_SHUFFLE
	}))
end

function var10._pop_(arg0)
	local var0 = arg0:GetCardList()
	local var1 = table.remove(var0, #var0)

	var1:SetFromPile(arg0:GetIndexID())

	return var1, arg0:DispatchEvent(var0.Event.New(var3.UPDATE_CARDS, {
		type = var10.FUNC_NAME_POP
	}))
end

function var10._sort_(arg0, arg1)
	return
end

function var10._search_(arg0, arg1)
	local var0 = {}
	local var1 = arg0:GetCardList()
	local var2 = arg1.value
	local var3 = arg1.type

	if var3 == var10.SEARCH_BY_ID then
		for iter0, iter1 in ipairs(var1) do
			if table.contains(var2, iter1:GetCardID()) then
				table.insert(var0, iter1)
			end
		end
	elseif var3 == var10.SEARCH_BY_LABEL then
		for iter2, iter3 in ipairs(var1) do
			if iter3:LabelContain(var2) then
				table.insert(var0, iter3)
			end
		end
	elseif var3 == var10.SEARCH_BY_TYPE then
		for iter4, iter5 in ipairs(var1) do
			if iter5:GetType() == var2 then
				table.insert(var0, iter5)
			end
		end
	end

	if arg1.total == true then
		return var0
	else
		return {
			var0[math.random(#var0)]
		}
	end
end

function var10._getLength_(arg0)
	return #arg0:GetCardList()
end
