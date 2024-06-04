local var0 = class("BackYardDecorationFilterPanel", import("....base.BaseSubView"))

var0.SORT_MODE = {
	BY_DEFAULT = 1,
	BY_CONFIG = 3,
	BY_FUNC = 2
}
var0.SORT_TAG = {
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
var0.ORDER_MODE_ASC = 1
var0.ORDER_MODE_DASC = 2

function var0.getUIName(arg0)
	return "BackYardIndexUI"
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.filterConfig = pg.backyard_theme_template
	arg0.sortData = var0.SORT_TAG[1][1]
	arg0.sortTxt = var0.SORT_TAG[1][2]
	arg0.filterData = _.select(arg0.filterConfig.all, function(arg0)
		return arg0.filterConfig[arg0].is_view == 1
	end)
	arg0.totalThemeCnt = #arg0.filterData
	arg0.themes = pg.furniture_data_template.get_id_list_by_themeId
end

function var0.OnLoaded(arg0)
	arg0.sortTpl = arg0:findTF("bg/sort_tpl")
	arg0.filterTpl = arg0:findTF("bg/filter_tpl")
	arg0.sortContainer = arg0:findTF("bg/frame/sorts/sort_container")
	arg0.filterContainer = arg0:findTF("bg/frame/filters/rect_view/conent/theme_panel")
	arg0.selectedAllBtn = arg0:findTF("bg/frame/filters/rect_view/conent/all_panel/sort_tpl")
	arg0.close = arg0:findTF("bg/close")

	setText(arg0:findTF("bg/frame/title"), i18n("indexsort_sort"))
	setText(arg0:findTF("bg/frame/title_filter"), i18n("indexsort_index"))
	setText(arg0.selectedAllBtn:Find("Text"), i18n("index_all"))
	setText(arg0:findTF("bg/frame/confirm_btn/Text"), i18n("word_ok"))
	setText(arg0:findTF("bg/title"), i18n("courtyard_label_filter"))
end

function var0.setFilterData(arg0, arg1)
	arg0.furnitures = arg1 or {}
end

function var0.GetFilterData(arg0)
	return arg0.furnitures
end

function var0.SetDorm(arg0, arg1)
	arg0.dorm = arg1
end

function var0.updateOrderMode(arg0, arg1)
	arg0.orderMode = arg1 or var0.ORDER_MODE_ASC
end

function var0.OnInit(arg0)
	onButton(arg0, arg0:findTF("bg/frame/confirm_btn"), function()
		arg0:filter()
		arg0:Hide()

		if arg0.confirmFunc then
			arg0.confirmFunc()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._go, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.close, function()
		arg0:Hide()
	end, SFX_PANEL)
	arg0:initSortPanel()
	arg0:initFilterPanel()
	triggerToggle(arg0.selectedAllBtn, true)
	triggerToggle(arg0.sortBtns[1], true)
end

function var0.initSortPanel(arg0)
	arg0.sortBtns = {}

	for iter0, iter1 in pairs(var0.SORT_TAG) do
		local var0 = cloneTplTo(arg0.sortTpl, arg0.sortContainer)

		setText(var0:Find("Text"), iter1[2])

		arg0.sortBtns[iter0] = var0

		arg0:onSwitch(var0, function(arg0)
			if arg0 then
				arg0.sortData = iter1[1]
				arg0.sortTxt = iter1[2]
			end
		end)
	end
end

function var0.onSwitch(arg0, arg1, arg2)
	onToggle(arg0, arg1, function(arg0)
		arg1:Find("Text"):GetComponent(typeof(Text)).color = arg0 and Color.New(1, 1, 1, 1) or Color.New(0.2235294, 0.227451, 0.2352941, 1)

		arg2(arg0)
	end, SFX_PANEL)
end

function var0.initFilterPanel(arg0)
	arg0.filterBtns = {}

	local var0 = Clone(arg0.filterConfig.all)

	table.sort(var0, function(arg0, arg1)
		return arg0.filterConfig[arg0].order < arg0.filterConfig[arg1].order
	end)

	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		local var2 = arg0.filterConfig[iter1]

		if var2.is_view == 1 then
			var1 = var1 + 1

			local var3 = cloneTplTo(arg0.filterTpl, arg0.filterContainer)

			setText(var3:Find("Text"), var2.name)

			arg0.filterBtns[iter1] = var3

			arg0:onSwitch(var3, function(arg0)
				if arg0 then
					table.insert(arg0.filterData, iter1)
					triggerToggle(arg0.selectedAllBtn, arg0:isSelectedAll())
				else
					arg0.filterData = _.reject(arg0.filterData, function(arg0)
						return iter1 == arg0
					end)

					if arg0:isSelectedNone() then
						triggerToggle(arg0.selectedAllBtn, true)

						arg0.selectedAllBtn:Find("Text"):GetComponent(typeof(Text)).color = Color.New(1, 1, 1, 1)
					end
				end
			end)
			setActive(var3:Find("line"), var1 % 4 ~= 0)
		end
	end

	arg0.otherTF = cloneTplTo(arg0.filterTpl, arg0.filterContainer)

	setText(arg0.otherTF:Find("Text"), i18n("backyard_filter_tag_other"))

	arg0.otherTFToggle = arg0.otherTF:GetComponent(typeof(Toggle))
	arg0.selectedOther = false

	arg0:onSwitch(arg0.otherTF, function(arg0)
		arg0.selectedOther = arg0

		if arg0 then
			triggerToggle(arg0.selectedAllBtn, arg0:isSelectedAll())
		elseif arg0:isSelectedNone() then
			triggerToggle(arg0.selectedAllBtn, true)

			arg0.selectedAllBtn:Find("Text"):GetComponent(typeof(Text)).color = Color.New(0.2235294, 0.227451, 0.2352941, 1)
		end
	end)
	onToggle(arg0, arg0.selectedAllBtn, function(arg0)
		if arg0:isSelectedNone() then
			return
		end

		if arg0 then
			_.each(arg0.filterData, function(arg0)
				triggerToggle(arg0.filterBtns[arg0], false)
			end)

			arg0.filterData = {}

			triggerToggle(arg0.otherTF, false)

			arg0.selectedOther = false
		end

		arg0.selectedAllBtn:Find("Text"):GetComponent(typeof(Text)).color = arg0 and Color.New(1, 1, 1, 1) or Color.New(0.2235294, 0.227451, 0.2352941, 1)
	end, SFX_PANEL)
end

function var0.isSelectedAll(arg0)
	return _.all(_.select(arg0.filterConfig.all, function(arg0)
		return arg0.filterConfig[arg0].is_view == 1
	end), function(arg0)
		return table.contains(arg0.filterData, arg0)
	end) and arg0.otherTFToggle.isOn == true or arg0:isSelectedNone()
end

function var0.isSelectedNone(arg0)
	return #arg0.filterData == 0 and arg0.otherTFToggle.isOn == false
end

function var0.filter(arg0)
	if table.getCount(arg0.furnitures) == 0 then
		return
	end

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.filterData) do
		local var1 = arg0.themes[iter1] or {}

		for iter2, iter3 in ipairs(var1) do
			table.insert(var0, iter3)
		end
	end

	local function var2(arg0)
		local var0 = arg0.id
		local var1 = arg0:getConfig("themeId") == 0
		local var2 = arg0.selectedOther and var1

		if #arg0.filterData == arg0.totalThemeCnt and var1 then
			return false
		end

		if var2 then
			return false
		end

		return not table.contains(var0, var0)
	end

	if #var0 ~= 0 or not not arg0.selectedOther then
		for iter4 = #arg0.furnitures, 1, -1 do
			local var3 = arg0.furnitures[iter4].id

			if var2(arg0.furnitures[iter4]) then
				table.remove(arg0.furnitures, iter4)
			end
		end
	end

	arg0:sort(arg0.furnitures)
end

function var0.SORT_BY_FUNC(arg0, arg1, arg2, arg3, arg4)
	if arg0[arg2](arg0) == arg1[arg2](arg1) then
		return arg4()
	elseif arg3 == var0.ORDER_MODE_ASC then
		return arg0[arg2](arg0) < arg1[arg2](arg1)
	else
		return arg0[arg2](arg0) > arg1[arg2](arg1)
	end
end

function var0.SORT_BY_CONFIG(arg0, arg1, arg2, arg3, arg4)
	if arg0:getConfig(arg2) == arg1:getConfig(arg2) then
		return arg4()
	elseif arg3 == var0.ORDER_MODE_ASC then
		return arg0:getConfig(arg2) < arg1:getConfig(arg2)
	else
		return arg0:getConfig(arg2) > arg1:getConfig(arg2)
	end
end

function var0.SortForDecorate(arg0, arg1, arg2)
	local var0 = arg2[1]
	local var1 = arg2[2]
	local var2 = arg2[3]
	local var3 = arg2[4]
	local var4 = arg2[5]
	local var5 = arg2[6]

	function var0.SortByDefault1(arg0, arg1)
		return arg0.id < arg1.id
	end

	function var0.SortByDefault2(arg0, arg1)
		return arg0.id > arg1.id
	end

	local var6 = (var5[arg0.configId] or 0) == arg0.count and 1 or 0
	local var7 = (var5[arg1.configId] or 0) == arg1.count and 1 or 0

	if var6 == var7 then
		if var0 == var0.SORT_MODE.BY_DEFAULT then
			return var0["SortByDefault" .. var3](arg0, arg1)
		elseif var0 == var0.SORT_MODE.BY_FUNC then
			return var0.SORT_BY_FUNC(arg0, arg1, var1, var3, function()
				return var0["SortByDefault" .. var3](arg0, arg1)
			end)
		elseif var0 == var0.SORT_MODE.BY_CONFIG then
			return var0.SORT_BY_CONFIG(arg0, arg1, var1, var3, function()
				return var0["SortByDefault" .. var3](arg0, arg1)
			end)
		end
	else
		return var7 < var6
	end
end

function var0.sort(arg0, arg1)
	local var0 = arg0:GetConfigIdAndCntMapInAllFloor(arg0.dorm)

	table.sort(arg1, function(arg0, arg1)
		return var0.SortForDecorate(arg0, arg1, {
			arg0.sortData[1],
			arg0.sortData[2],
			arg0.dorm,
			arg0.orderMode,
			{},
			var0
		})
	end)

	arg0.furnitures = arg1
end

function var0.GetConfigIdAndCntMapInAllFloor(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg1:GetThemeList()) do
		for iter2, iter3 in pairs(iter1:GetAllFurniture()) do
			var0[iter2] = iter3
		end
	end

	local var1 = {}

	for iter4, iter5 in pairs(var0) do
		local var2 = iter5.configId

		if not var1[var2] then
			var1[var2] = 0
		end

		var1[var2] = var1[var2] + 1
	end

	return var1
end

function var0.Sort(arg0)
	arg0:sort(arg0.furnitures)
end

function var0.Show(arg0)
	setActive(arg0._go, true)
end

function var0.Hide(arg0)
	setActive(arg0._go, false)

	if arg0.onHideFunc then
		arg0.onHideFunc()
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
