local var0 = class("SkinIndexLayer", import("...common.CustomIndexLayer"))

var0.ExtraL2D = bit.lshift(1, 0)
var0.ExtraDBG = bit.lshift(1, 1)
var0.ExtraBG = bit.lshift(1, 2)
var0.ExtraBGM = bit.lshift(1, 3)
var0.ExtraIndexs = {
	var0.ExtraL2D,
	var0.ExtraDBG,
	var0.ExtraBG,
	var0.ExtraBGM
}
var0.ExtraALL = IndexConst.BitAll(var0.ExtraIndexs)

table.insert(var0.ExtraIndexs, 1, var0.ExtraALL)

var0.ExtraNames = {
	"index_all",
	"index_L2D",
	"index_DBG",
	"index_BG",
	"index_BGM"
}

local var1 = {
	function()
		return true
	end,
	function(arg0)
		return arg0:IsLive2d()
	end,
	function(arg0)
		return arg0:IsDbg()
	end,
	function(arg0)
		return arg0:IsBG()
	end,
	function(arg0)
		return arg0:isBgm()
	end
}

function var0.filterByExtra(arg0, arg1)
	if not arg1 or arg1 == var0.ExtraALL then
		return true
	end

	for iter0 = 2, #var1 do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 and var1[iter0](arg0) then
			return true
		end
	end

	return false
end

function var0.init(arg0)
	var0.super.init(arg0)

	local var0 = arg0.contextData

	arg0.OnFilter = var0.OnFilter
	arg0.indexDatas = var0.defaultIndex or {}
end

function var0.didEnter(arg0)
	arg0.contextData = arg0:InitData()

	var0.super.didEnter(arg0)
end

function var0.BlurPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.InitData(arg0)
	return {
		indexDatas = Clone(arg0.indexDatas),
		customPanels = {
			minHeight = 650,
			typeIndex = {
				blueSeleted = true,
				mode = CustomIndexLayer.Mode.AND,
				options = ShipIndexConst.TypeIndexs,
				names = ShipIndexConst.TypeNames
			},
			campIndex = {
				blueSeleted = true,
				mode = CustomIndexLayer.Mode.AND,
				options = ShipIndexConst.CampIndexs,
				names = ShipIndexConst.CampNames
			},
			rarityIndex = {
				blueSeleted = true,
				mode = CustomIndexLayer.Mode.AND,
				options = ShipIndexConst.RarityIndexs,
				names = ShipIndexConst.RarityNames
			},
			extraIndex = {
				blueSeleted = true,
				mode = CustomIndexLayer.Mode.AND,
				options = var0.ExtraIndexs,
				names = var0.ExtraNames
			},
			layoutPos = Vector2(0, -25)
		},
		groupList = {
			{
				dropdown = false,
				titleTxt = "indexsort_index",
				titleENTxt = "indexsort_indexeng",
				tags = {
					"typeIndex"
				}
			},
			{
				dropdown = false,
				titleTxt = "indexsort_camp",
				titleENTxt = "indexsort_campeng",
				tags = {
					"campIndex"
				}
			},
			{
				dropdown = false,
				titleTxt = "indexsort_rarity",
				titleENTxt = "indexsort_rarityeng",
				tags = {
					"rarityIndex"
				}
			},
			{
				dropdown = false,
				titleTxt = "indexsort_extraindex",
				titleENTxt = "indexsort_indexeng",
				tags = {
					"extraIndex"
				}
			}
		},
		callback = function(arg0)
			arg0.OnFilter(arg0)
		end
	}
end

return var0
