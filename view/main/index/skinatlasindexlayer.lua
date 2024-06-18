local var0_0 = class("SkinAtlasIndexLayer", import("...common.CustomIndexLayer"))

var0_0.ExtraL2D = bit.lshift(1, 0)
var0_0.ExtraDBG = bit.lshift(1, 1)
var0_0.ExtraBG = bit.lshift(1, 2)
var0_0.ExtraBGM = bit.lshift(1, 3)
var0_0.ExtraCANTUSE = bit.lshift(1, 4)
var0_0.ExtraUNUSE = bit.lshift(1, 5)
var0_0.ExtraIndexs = {
	var0_0.ExtraL2D,
	var0_0.ExtraDBG,
	var0_0.ExtraBG,
	var0_0.ExtraBGM,
	var0_0.ExtraCANTUSE,
	var0_0.ExtraUNUSE
}
var0_0.ExtraALL = IndexConst.BitAll(var0_0.ExtraIndexs)

table.insert(var0_0.ExtraIndexs, 1, var0_0.ExtraALL)

var0_0.ExtraNames = {
	"index_all",
	"index_L2D",
	"index_DBG",
	"index_BG",
	"index_BGM",
	"index_CANTUSE",
	"index_UNUSE"
}

local var1_0 = {
	function()
		return true
	end,
	function(arg0_2)
		return arg0_2:IsLive2d()
	end,
	function(arg0_3)
		return arg0_3:IsDbg()
	end,
	function(arg0_4)
		return arg0_4:IsBG()
	end,
	function(arg0_5)
		return arg0_5:isBgm()
	end,
	function(arg0_6)
		return arg0_6:CantUse()
	end,
	function(arg0_7)
		return arg0_7:WithoutUse()
	end
}

function var0_0.filterByExtra(arg0_8, arg1_8)
	if not arg1_8 or arg1_8 == var0_0.ExtraALL then
		return true
	end

	for iter0_8 = 2, #var1_0 do
		local var0_8 = bit.lshift(1, iter0_8 - 2)

		if bit.band(var0_8, arg1_8) > 0 and var1_0[iter0_8](arg0_8) then
			return true
		end
	end

	return false
end

function var0_0.init(arg0_9)
	var0_0.super.init(arg0_9)

	local var0_9 = arg0_9.contextData

	arg0_9.OnFilter = var0_9.OnFilter
	arg0_9.indexDatas = var0_9.defaultIndex or {}
end

function var0_0.BlurPanel(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER + 1
	})
end

function var0_0.didEnter(arg0_11)
	arg0_11.contextData = arg0_11:InitData()

	var0_0.super.didEnter(arg0_11)
end

function var0_0.InitData(arg0_12)
	return {
		indexDatas = Clone(arg0_12.indexDatas),
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
				options = var0_0.ExtraIndexs,
				names = var0_0.ExtraNames
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
		callback = function(arg0_13)
			arg0_12.OnFilter(arg0_13)
		end
	}
end

return var0_0
