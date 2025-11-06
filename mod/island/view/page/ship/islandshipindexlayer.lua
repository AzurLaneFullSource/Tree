local var0_0 = class("IslandShipIndexLayer", import("view.common.CustomIndexLayer"))

function var0_0.SortFunc(arg0_1)
	return {
		function(arg0_2)
			if arg0_2 then
				local var0_2 = arg0_2["Get" .. arg0_1](arg0_2)

				return arg0_2["Get" .. arg0_1](arg0_2)
			else
				return 0
			end
		end,
		function(arg0_3)
			return arg0_3.configId
		end
	}
end

var0_0.SortNames = {
	"island_chara_list_level",
	"island_chara_list_attribute",
	"island_index_name"
}
var0_0.sort = {
	{
		sortFuncs = var0_0.SortFunc("Level"),
		name = var0_0.SortNames[1]
	},
	{
		sortFuncs = var0_0.SortFunc("Power"),
		name = var0_0.SortNames[2]
	},
	{
		sortFuncs = var0_0.SortFunc("CurrentEnergy"),
		name = var0_0.SortNames[3]
	},
	{
		name = "island_chara_list_workspeed",
		sortFuncs = var0_0.SortFunc("WorkSpeed")
	}
}

function var0_0.getSortFuncAndName(arg0_4, arg1_4)
	for iter0_4 = 1, #var0_0.sort do
		local var0_4 = bit.lshift(1, iter0_4 - 1)

		if bit.band(var0_4, arg0_4) > 0 then
			return underscore.map(var0_0.sort[iter0_4].sortFuncs, function(arg0_5)
				return function(arg0_6)
					local var0_6 = arg0_5(arg0_6)

					return (arg1_4 and -1 or 1) * arg0_5(arg0_6)
				end
			end), var0_0.sort[iter0_4].name
		end
	end
end

var0_0.SortLevel = bit.lshift(1, 0)
var0_0.SortPower = bit.lshift(1, 1)
var0_0.SortEnergy = bit.lshift(1, 2)
var0_0.SortWorkSpeed = bit.lshift(1, 3)
var0_0.SortIndexs = {
	var0_0.SortLevel,
	var0_0.SortPower,
	var0_0.SortEnergy
}
var0_0.ExtraPotency = bit.lshift(1, 0)
var0_0.ExtraCanUpgSkill = bit.lshift(1, 1)
var0_0.ExtraSpeStatus = bit.lshift(1, 2)
var0_0.ExtraIndexs = {
	var0_0.ExtraPotency,
	var0_0.ExtraCanUpgSkill,
	var0_0.ExtraSpeStatus
}
var0_0.ExtraALL = IndexConst.BitAll(var0_0.ExtraIndexs)

table.insert(var0_0.ExtraIndexs, 1, var0_0.ExtraALL)

var0_0.ExtraNames = {
	"island_index_extra_all",
	"island_index_potency",
	"island_index_skill",
	"island_index_status"
}

local var1_0 = {
	function()
		return true
	end,
	function(arg0_8)
		if not arg0_8 then
			return false
		end

		return arg0_8:ExistPotency()
	end,
	function(arg0_9)
		if not arg0_9 then
			return false
		end

		return arg0_9:AnySkillCanUpgrade()
	end,
	function(arg0_10)
		if not arg0_10 then
			return false
		end

		return arg0_10:HasStatus()
	end
}

function var0_0.filterByExtra(arg0_11, arg1_11)
	if not arg1_11 or arg1_11 == var0_0.ExtraALL then
		return true
	end

	for iter0_11 = 2, #var1_0 do
		local var0_11 = bit.lshift(1, iter0_11 - 2)

		if bit.band(var0_11, arg1_11) > 0 and var1_0[iter0_11](arg0_11) then
			return true
		end
	end

	return false
end

function var0_0.getUIName(arg0_12)
	return "IslandCustomIndexUI"
end

function var0_0.init(arg0_13)
	var0_0.super.init(arg0_13)

	arg0_13.titleTxt = arg0_13._tf:Find("index_panel/layout/tip"):GetComponent(typeof(Text))
	arg0_13.closeBtn = arg0_13._tf:Find("index_panel/layout/clsoe")
	arg0_13.tplContainer = arg0_13._tf:Find("index_panel/layout/container")

	local var0_13 = arg0_13.contextData

	arg0_13.OnFilter = var0_13.OnFilter
	arg0_13.indexDatas = var0_13.defaultIndex or {}
	arg0_13.needWorkSpeed = var0_13.needWorkSpeed or false
end

function var0_0.BlurPanel(arg0_14)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
end

function var0_0.DoEnterAnimation(arg0_15)
	return
end

function var0_0.didEnter(arg0_16)
	arg0_16.contextData = arg0_16:InitData()

	var0_0.super.didEnter(arg0_16)

	arg0_16.titleTxt.text = i18n("child_filter_title")

	onButton(arg0_16, arg0_16.closeBtn, function()
		arg0_16:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
end

function var0_0.InitGroup(arg0_18)
	var0_0.super.InitGroup(arg0_18)

	local function var0_18(arg0_19)
		setActive(arg0_19:Find("line"), false)
	end

	for iter0_18 = 1, arg0_18.tplContainer.childCount do
		local var1_18 = arg0_18.tplContainer:GetChild(iter0_18 - 1):Find("bg")

		if var1_18.childCount > 7 then
			var0_18(var1_18:GetChild(6))
		end

		if var1_18.childCount > 0 then
			var0_18(var1_18:GetChild(var1_18.childCount - 1))
		end
	end
end

function var0_0.InitData(arg0_20)
	local var0_20 = Clone(var0_0.SortNames)
	local var1_20 = Clone(var0_0.SortIndexs)

	if arg0_20.needWorkSpeed then
		table.insert(var0_20, "island_chara_list_workspeed")
		table.insert(var1_20, var0_0.SortWorkSpeed)
	end

	return {
		indexDatas = Clone(arg0_20.indexDatas),
		customPanels = {
			sortIndex = {
				isSort = true,
				mode = CustomIndexLayer.Mode.OR,
				options = var1_20,
				names = var0_20
			},
			extraIndex = {
				blueSeleted = true,
				mode = CustomIndexLayer.Mode.AND,
				options = var0_0.ExtraIndexs,
				names = var0_0.ExtraNames
			}
		},
		groupList = {
			{
				dropdown = false,
				titleTxt = "indexsort_sort",
				titleENTxt = "indexsort_sorteng",
				tags = {
					"sortIndex"
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
		callback = function(arg0_21)
			arg0_20.OnFilter(arg0_21)
		end
	}
end

function var0_0.UpdateBtnStyle(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg2_22 ~= arg0_22.greySprite

	arg1_22:GetComponent(typeof(Image)).color = var0_22 and Color.New(0, 0, 0, 1) or Color.New(1, 1, 1, 1)
	arg1_22:Find("Image"):GetComponent(typeof(Text)).color = var0_22 and Color.New(1, 1, 1, 1) or Color.New(0.2235294, 0.227451, 0.2352941, 1)

	setActive(arg1_22:Find("selected"), var0_22)
end

return var0_0
