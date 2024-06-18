local var0_0 = class("BackYardDecorationFilterPanel", import("....base.BaseSubView"))

var0_0.SORT_MODE = {
	BY_DEFAULT = 1,
	BY_CONFIG = 3,
	BY_FUNC = 2
}
var0_0.SORT_TAG = {
	{
		{
			1,
			"default"
		},
		i18n("backyard_sort_tag_default")
	},
	{
		{
			2,
			"sortPriceFunc"
		},
		i18n("backyard_sort_tag_price")
	},
	{
		{
			3,
			"comfortable"
		},
		i18n("backyard_sort_tag_comfortable")
	},
	{
		{
			2,
			"sortSizeFunc"
		},
		i18n("backyard_sort_tag_size")
	}
}
var0_0.ORDER_MODE_ASC = 1
var0_0.ORDER_MODE_DASC = 2

function var0_0.getUIName(arg0_1)
	return "BackYardIndexUI"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)

	arg0_2.filterConfig = pg.backyard_theme_template
	arg0_2.sortData = var0_0.SORT_TAG[1][1]
	arg0_2.sortTxt = var0_0.SORT_TAG[1][2]
	arg0_2.filterData = _.select(arg0_2.filterConfig.all, function(arg0_3)
		return arg0_2.filterConfig[arg0_3].is_view == 1
	end)
	arg0_2.totalThemeCnt = #arg0_2.filterData
	arg0_2.themes = pg.furniture_data_template.get_id_list_by_themeId
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.sortTpl = arg0_4:findTF("bg/sort_tpl")
	arg0_4.filterTpl = arg0_4:findTF("bg/filter_tpl")
	arg0_4.sortContainer = arg0_4:findTF("bg/frame/sorts/sort_container")
	arg0_4.filterContainer = arg0_4:findTF("bg/frame/filters/rect_view/conent/theme_panel")
	arg0_4.selectedAllBtn = arg0_4:findTF("bg/frame/filters/rect_view/conent/all_panel/sort_tpl")
	arg0_4.close = arg0_4:findTF("bg/close")

	setText(arg0_4:findTF("bg/frame/title"), i18n("indexsort_sort"))
	setText(arg0_4:findTF("bg/frame/title_filter"), i18n("indexsort_index"))
	setText(arg0_4.selectedAllBtn:Find("Text"), i18n("index_all"))
	setText(arg0_4:findTF("bg/frame/confirm_btn/Text"), i18n("word_ok"))
	setText(arg0_4:findTF("bg/title"), i18n("courtyard_label_filter"))
end

function var0_0.setFilterData(arg0_5, arg1_5)
	arg0_5.furnitures = arg1_5 or {}
end

function var0_0.GetFilterData(arg0_6)
	return arg0_6.furnitures
end

function var0_0.SetDorm(arg0_7, arg1_7)
	arg0_7.dorm = arg1_7
end

function var0_0.updateOrderMode(arg0_8, arg1_8)
	arg0_8.orderMode = arg1_8 or var0_0.ORDER_MODE_ASC
end

function var0_0.OnInit(arg0_9)
	onButton(arg0_9, arg0_9:findTF("bg/frame/confirm_btn"), function()
		arg0_9:filter()
		arg0_9:Hide()

		if arg0_9.confirmFunc then
			arg0_9.confirmFunc()
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._go, function()
		arg0_9:Hide()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.close, function()
		arg0_9:Hide()
	end, SFX_PANEL)
	arg0_9:initSortPanel()
	arg0_9:initFilterPanel()
	triggerToggle(arg0_9.selectedAllBtn, true)
	triggerToggle(arg0_9.sortBtns[1], true)
end

function var0_0.initSortPanel(arg0_13)
	arg0_13.sortBtns = {}

	for iter0_13, iter1_13 in pairs(var0_0.SORT_TAG) do
		local var0_13 = cloneTplTo(arg0_13.sortTpl, arg0_13.sortContainer)

		setText(var0_13:Find("Text"), iter1_13[2])

		arg0_13.sortBtns[iter0_13] = var0_13

		arg0_13:onSwitch(var0_13, function(arg0_14)
			if arg0_14 then
				arg0_13.sortData = iter1_13[1]
				arg0_13.sortTxt = iter1_13[2]
			end
		end)
	end
end

function var0_0.onSwitch(arg0_15, arg1_15, arg2_15)
	onToggle(arg0_15, arg1_15, function(arg0_16)
		arg1_15:Find("Text"):GetComponent(typeof(Text)).color = arg0_16 and Color.New(1, 1, 1, 1) or Color.New(0.2235294, 0.227451, 0.2352941, 1)

		arg2_15(arg0_16)
	end, SFX_PANEL)
end

function var0_0.initFilterPanel(arg0_17)
	arg0_17.filterBtns = {}

	local var0_17 = Clone(arg0_17.filterConfig.all)

	table.sort(var0_17, function(arg0_18, arg1_18)
		return arg0_17.filterConfig[arg0_18].order < arg0_17.filterConfig[arg1_18].order
	end)

	local var1_17 = 0

	for iter0_17, iter1_17 in ipairs(var0_17) do
		local var2_17 = arg0_17.filterConfig[iter1_17]

		if var2_17.is_view == 1 then
			var1_17 = var1_17 + 1

			local var3_17 = cloneTplTo(arg0_17.filterTpl, arg0_17.filterContainer)

			setText(var3_17:Find("Text"), var2_17.name)

			arg0_17.filterBtns[iter1_17] = var3_17

			arg0_17:onSwitch(var3_17, function(arg0_19)
				if arg0_19 then
					table.insert(arg0_17.filterData, iter1_17)
					triggerToggle(arg0_17.selectedAllBtn, arg0_17:isSelectedAll())
				else
					arg0_17.filterData = _.reject(arg0_17.filterData, function(arg0_20)
						return iter1_17 == arg0_20
					end)

					if arg0_17:isSelectedNone() then
						triggerToggle(arg0_17.selectedAllBtn, true)

						arg0_17.selectedAllBtn:Find("Text"):GetComponent(typeof(Text)).color = Color.New(1, 1, 1, 1)
					end
				end
			end)
			setActive(var3_17:Find("line"), var1_17 % 4 ~= 0)
		end
	end

	arg0_17.otherTF = cloneTplTo(arg0_17.filterTpl, arg0_17.filterContainer)

	setText(arg0_17.otherTF:Find("Text"), i18n("backyard_filter_tag_other"))

	arg0_17.otherTFToggle = arg0_17.otherTF:GetComponent(typeof(Toggle))
	arg0_17.selectedOther = false

	arg0_17:onSwitch(arg0_17.otherTF, function(arg0_21)
		arg0_17.selectedOther = arg0_21

		if arg0_21 then
			triggerToggle(arg0_17.selectedAllBtn, arg0_17:isSelectedAll())
		elseif arg0_17:isSelectedNone() then
			triggerToggle(arg0_17.selectedAllBtn, true)

			arg0_17.selectedAllBtn:Find("Text"):GetComponent(typeof(Text)).color = Color.New(0.2235294, 0.227451, 0.2352941, 1)
		end
	end)
	onToggle(arg0_17, arg0_17.selectedAllBtn, function(arg0_22)
		if arg0_17:isSelectedNone() then
			return
		end

		if arg0_22 then
			_.each(arg0_17.filterData, function(arg0_23)
				triggerToggle(arg0_17.filterBtns[arg0_23], false)
			end)

			arg0_17.filterData = {}

			triggerToggle(arg0_17.otherTF, false)

			arg0_17.selectedOther = false
		end

		arg0_17.selectedAllBtn:Find("Text"):GetComponent(typeof(Text)).color = arg0_22 and Color.New(1, 1, 1, 1) or Color.New(0.2235294, 0.227451, 0.2352941, 1)
	end, SFX_PANEL)
end

function var0_0.isSelectedAll(arg0_24)
	return _.all(_.select(arg0_24.filterConfig.all, function(arg0_25)
		return arg0_24.filterConfig[arg0_25].is_view == 1
	end), function(arg0_26)
		return table.contains(arg0_24.filterData, arg0_26)
	end) and arg0_24.otherTFToggle.isOn == true or arg0_24:isSelectedNone()
end

function var0_0.isSelectedNone(arg0_27)
	return #arg0_27.filterData == 0 and arg0_27.otherTFToggle.isOn == false
end

function var0_0.filter(arg0_28)
	if table.getCount(arg0_28.furnitures) == 0 then
		return
	end

	local var0_28 = {}

	for iter0_28, iter1_28 in ipairs(arg0_28.filterData) do
		local var1_28 = arg0_28.themes[iter1_28] or {}

		for iter2_28, iter3_28 in ipairs(var1_28) do
			table.insert(var0_28, iter3_28)
		end
	end

	local function var2_28(arg0_29)
		local var0_29 = arg0_29.id
		local var1_29 = arg0_29:getConfig("themeId") == 0
		local var2_29 = arg0_28.selectedOther and var1_29

		if #arg0_28.filterData == arg0_28.totalThemeCnt and var1_29 then
			return false
		end

		if var2_29 then
			return false
		end

		return not table.contains(var0_28, var0_29)
	end

	if #var0_28 ~= 0 or not not arg0_28.selectedOther then
		for iter4_28 = #arg0_28.furnitures, 1, -1 do
			local var3_28 = arg0_28.furnitures[iter4_28].id

			if var2_28(arg0_28.furnitures[iter4_28]) then
				table.remove(arg0_28.furnitures, iter4_28)
			end
		end
	end

	arg0_28:sort(arg0_28.furnitures)
end

function var0_0.SORT_BY_FUNC(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	if arg0_30[arg2_30](arg0_30) == arg1_30[arg2_30](arg1_30) then
		return arg4_30()
	elseif arg3_30 == var0_0.ORDER_MODE_ASC then
		return arg0_30[arg2_30](arg0_30) < arg1_30[arg2_30](arg1_30)
	else
		return arg0_30[arg2_30](arg0_30) > arg1_30[arg2_30](arg1_30)
	end
end

function var0_0.SORT_BY_CONFIG(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31)
	if arg0_31:getConfig(arg2_31) == arg1_31:getConfig(arg2_31) then
		return arg4_31()
	elseif arg3_31 == var0_0.ORDER_MODE_ASC then
		return arg0_31:getConfig(arg2_31) < arg1_31:getConfig(arg2_31)
	else
		return arg0_31:getConfig(arg2_31) > arg1_31:getConfig(arg2_31)
	end
end

function var0_0.SortForDecorate(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg2_32[1]
	local var1_32 = arg2_32[2]
	local var2_32 = arg2_32[3]
	local var3_32 = arg2_32[4]
	local var4_32 = arg2_32[5]
	local var5_32 = arg2_32[6]

	function var0_0.SortByDefault1(arg0_33, arg1_33)
		return arg0_33.id < arg1_33.id
	end

	function var0_0.SortByDefault2(arg0_34, arg1_34)
		return arg0_34.id > arg1_34.id
	end

	local var6_32 = (var5_32[arg0_32.configId] or 0) == arg0_32.count and 1 or 0
	local var7_32 = (var5_32[arg1_32.configId] or 0) == arg1_32.count and 1 or 0

	if var6_32 == var7_32 then
		if var0_32 == var0_0.SORT_MODE.BY_DEFAULT then
			return var0_0["SortByDefault" .. var3_32](arg0_32, arg1_32)
		elseif var0_32 == var0_0.SORT_MODE.BY_FUNC then
			return var0_0.SORT_BY_FUNC(arg0_32, arg1_32, var1_32, var3_32, function()
				return var0_0["SortByDefault" .. var3_32](arg0_32, arg1_32)
			end)
		elseif var0_32 == var0_0.SORT_MODE.BY_CONFIG then
			return var0_0.SORT_BY_CONFIG(arg0_32, arg1_32, var1_32, var3_32, function()
				return var0_0["SortByDefault" .. var3_32](arg0_32, arg1_32)
			end)
		end
	else
		return var7_32 < var6_32
	end
end

function var0_0.sort(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetConfigIdAndCntMapInAllFloor(arg0_37.dorm)

	table.sort(arg1_37, function(arg0_38, arg1_38)
		return var0_0.SortForDecorate(arg0_38, arg1_38, {
			arg0_37.sortData[1],
			arg0_37.sortData[2],
			arg0_37.dorm,
			arg0_37.orderMode,
			{},
			var0_37
		})
	end)

	arg0_37.furnitures = arg1_37
end

function var0_0.GetConfigIdAndCntMapInAllFloor(arg0_39, arg1_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in pairs(arg1_39:GetThemeList()) do
		for iter2_39, iter3_39 in pairs(iter1_39:GetAllFurniture()) do
			var0_39[iter2_39] = iter3_39
		end
	end

	local var1_39 = {}

	for iter4_39, iter5_39 in pairs(var0_39) do
		local var2_39 = iter5_39.configId

		if not var1_39[var2_39] then
			var1_39[var2_39] = 0
		end

		var1_39[var2_39] = var1_39[var2_39] + 1
	end

	return var1_39
end

function var0_0.Sort(arg0_40)
	arg0_40:sort(arg0_40.furnitures)
end

function var0_0.Show(arg0_41)
	setActive(arg0_41._go, true)
end

function var0_0.Hide(arg0_42)
	setActive(arg0_42._go, false)

	if arg0_42.onHideFunc then
		arg0_42.onHideFunc()
	end
end

function var0_0.OnDestroy(arg0_43)
	return
end

return var0_0
