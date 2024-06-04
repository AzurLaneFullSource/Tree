local var0 = class("RandomDockYardIndexLayer", import("..common.CustomIndexLayer"))

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

function var0.InitData(arg0)
	return {
		indexDatas = Clone(arg0.indexDatas),
		customPanels = {
			minHeight = 650,
			sortIndex = {
				isSort = true,
				mode = CustomIndexLayer.Mode.OR,
				options = ShipIndexConst.SortIndexs,
				names = ShipIndexConst.SortNames
			},
			sortPropertyIndex = {
				blueSeleted = true,
				mode = CustomIndexLayer.Mode.OR,
				options = ShipIndexConst.SortPropertyIndexs,
				names = ShipIndexConst.SortPropertyNames
			},
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
				mode = CustomIndexLayer.Mode.OR,
				options = ShipIndexConst.ExtraIndexs,
				names = ShipIndexConst.ExtraNames
			},
			layoutPos = Vector2(0, -25)
		},
		groupList = {
			{
				dropdown = false,
				titleTxt = "indexsort_sort",
				titleENTxt = "indexsort_sorteng",
				tags = {
					"sortIndex"
				},
				simpleDropdown = {
					"sortPropertyIndex"
				}
			},
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
