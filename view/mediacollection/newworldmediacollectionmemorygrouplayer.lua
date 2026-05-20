local var0_0 = class("NewWorldMediaCollectionMemoryGroupLayer", import(".WorldMediaCollectionSubLayer"))

var0_0.Role = 3
var0_0.FORM_MODE = 1
var0_0.LINE_MODE = -1
var0_0.index = -1
var0_0.sort = false

function var0_0.getUIName(arg0_1)
	return "NewWorldMediaCollectionMemoryGroupUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2.baseMemoryGroups = underscore(pg.memory_group.all):chain():map(function(arg0_3)
		return pg.memory_group[arg0_3]
	end):filter(function(arg0_4)
		return arg0_4.type == var0_0.Role
	end):value()
	arg0_2.memoryGroups = underscore.to_array(arg0_2.baseMemoryGroups)
	arg0_2.memoryGroupList = arg0_2._tf:Find("GroupRect"):GetComponent("LScrollRect")

	function arg0_2.memoryGroupList.onInitItem(arg0_5)
		arg0_2:onInitMemoryGroup(arg0_5)
	end

	function arg0_2.memoryGroupList.onUpdateItem(arg0_6, arg1_6)
		arg0_2:onUpdateMemoryGroup(arg0_6 + 1, arg1_6)
	end

	arg0_2.memoryGroupInfos = {}

	local var0_2 = tf(arg0_2.memoryGroupList):Find("GroupItem")

	setActive(var0_2, false)

	arg0_2.memoryGroupViewport = tf(arg0_2.memoryGroupList):Find("Viewport")
	arg0_2.memoryGroupsGrid = tf(arg0_2.memoryGroupList):Find("Viewport/Content"):GetComponent(typeof(GridLayoutGroup))
	arg0_2.loader = AutoLoader.New()
	arg0_2.searchBtn = arg0_2._tf:Find("ActivityToggle/search_btn/btn")
	arg0_2.nameSearchInput = arg0_2._tf:Find("ActivityToggle/search_btn/search")
	arg0_2.closeSearch = arg0_2._tf:Find("ActivityToggle/search_btn/icon")

	setText(arg0_2.searchBtn:Find("label"), i18n("storyline_memorysearch2"))
	onButton(arg0_2, arg0_2.searchBtn, function()
		setActive(arg0_2.nameSearchInput, true)
		setActive(arg0_2.searchBtn, false)
		setText(arg0_2.nameSearchInput:Find("holder"), i18n("storyline_memorysearch1"))

		arg0_2.searchOpen = true
	end)
	onButton(arg0_2, arg0_2.closeSearch, function()
		if arg0_2.searchOpen then
			setActive(arg0_2.nameSearchInput, false)
			setActive(arg0_2.searchBtn, true)
			setText(arg0_2.searchBtn:Find("label"), i18n("storyline_memorysearch2"))
		else
			triggerButton(arg0_2.searchBtn)
		end
	end)
	setInputText(arg0_2.nameSearchInput, "")
	onInputChanged(arg0_2, arg0_2.nameSearchInput, function()
		arg0_2:searchFilter()
	end)
	onButton(arg0_2, arg0_2._tf:Find("ActivityToggle/search/up"), function()
		arg0_2.selectAsc = false

		setActive(arg0_2._tf:Find("ActivityToggle/search/up"), arg0_2.selectAsc)
		setActive(arg0_2._tf:Find("ActivityToggle/search/below"), not arg0_2.selectAsc)
		arg0_2:searchFilter()
	end)
	onButton(arg0_2, arg0_2._tf:Find("ActivityToggle/search/below"), function()
		arg0_2.selectAsc = true

		setActive(arg0_2._tf:Find("ActivityToggle/search/up"), arg0_2.selectAsc)
		setActive(arg0_2._tf:Find("ActivityToggle/search/below"), not arg0_2.selectAsc)
		arg0_2:searchFilter()
	end)
	onButton(arg0_2, arg0_2._tf:Find("ActivityToggle/btn"), function()
		local var0_12 = {
			indexDatas = Clone(arg0_2.contextData.indexDatas),
			customPanels = {
				minHeight = 650,
				sortIndex = {
					isSort = true,
					mode = CustomIndexLayer.Mode.OR,
					options = ShipIndexConst.SortRoleStory,
					names = ShipIndexConst.SortRoleStoryName
				},
				progressIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.AND,
					options = ShipIndexConst.RoleProgress,
					names = ShipIndexConst.RoleProgressName
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
				layoutPos = Vector2(0, -25)
			},
			groupList = {
				{
					dropdown = false,
					titleTxt = "indexsort_sort",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"sortIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "world_collection_2",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"progressIndex"
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
				}
			},
			callback = function(arg0_13)
				arg0_2.sortIndex = arg0_13.sortIndex
				arg0_2.typeIndex = arg0_13.typeIndex
				arg0_2.campIndex = arg0_13.campIndex
				arg0_2.progressIndex = arg0_13.progressIndex

				arg0_2:updateIndexDatas()
				arg0_2:filterCommon()
				arg0_2:searchFilter()
				arg0_2:UpdateFilterBtn()
			end
		}
		local var1_12 = Context.New({
			mediator = CustomIndexMediator,
			viewComponent = RoleStoryCustomIndexLayer,
			data = var0_12
		})

		arg0_2:emit(WorldMediaCollectionMediator.ON_ADD_SUBLAYER, var1_12)
	end)

	arg0_2.HallGloryTF = arg0_2._tf:Find("HonorBtn")

	onButton(arg0_2, arg0_2.HallGloryTF, function()
		arg0_2.index = 2

		arg0_2.viewParent:ShowHallGloryLayer()
	end)

	if arg0_2.contextData.indexDatas then
		arg0_2.contextData.indexDatas = nil
	end

	triggerButton(arg0_2._tf:Find("ActivityToggle/search/below"))
	arg0_2:UpdateFilterBtn()
end

function var0_0.updateIndexDatas(arg0_15)
	arg0_15.contextData.indexDatas = arg0_15.contextData.indexDatas or {}
	arg0_15.contextData.indexDatas.sortIndex = arg0_15.sortIndex
	arg0_15.contextData.indexDatas.typeIndex = arg0_15.typeIndex
	arg0_15.contextData.indexDatas.campIndex = arg0_15.campIndex
	arg0_15.contextData.indexDatas.progressIndex = arg0_15.progressIndex
end

function var0_0.filterCommon(arg0_16)
	local var0_16 = arg0_16.sortIndex

	arg0_16.GroupList = {}
	arg0_16.memoryGroups = {}

	if not arg0_16.shipDic then
		arg0_16.shipDic = {}

		for iter0_16, iter1_16 in ipairs(arg0_16.baseMemoryGroups) do
			if iter1_16.ship_group ~= 0 then
				local var1_16 = ShipGroup.getDefaultShipConfig(iter1_16.ship_group)

				arg0_16.shipDic[iter1_16.id] = Ship.New({
					configId = var1_16.id
				})
			end
		end
	end

	for iter2_16, iter3_16 in ipairs(arg0_16.baseMemoryGroups) do
		assert(iter3_16.ship_group ~= 0, "MemoryGroup " .. iter3_16.id .. " missing ship group")

		local var2_16 = arg0_16.shipDic[iter3_16.id]

		if ShipIndexConst.filterByType(var2_16, arg0_16.typeIndex) and ShipIndexConst.filterByCamp(var2_16, arg0_16.campIndex) and ShipIndexConst.filterRoleProgressBar(iter3_16, arg0_16.progressIndex) then
			table.insert(arg0_16.memoryGroups, iter3_16)
		end
	end

	local var3_16 = ShipIndexConst.getSortName(var0_16)

	if var3_16 == 1 then
		-- block empty
	elseif var3_16 == 2 then
		table.sort(arg0_16.memoryGroups, CompareFuncs({
			function(arg0_17)
				local var0_17, var1_17 = arg0_16:OnSchedule(arg0_17)

				return var0_17 / var1_17
			end,
			function(arg0_18)
				return arg0_18.id
			end
		}))
	end
end

function var0_0.StoryLineBtnSetActive(arg0_19, arg1_19)
	setActive(arg0_19.storyLineEntranceBtn, arg1_19)
	setActive(arg0_19.storyLineHideBtn, arg1_19)
	setActive(arg0_19._tf:Find("StoryLineBtn/on"), not arg1_19)
end

function var0_0.Hide(arg0_20)
	var0_0.super.Hide(arg0_20)
end

function var0_0.GetCurrentMode(arg0_21)
	return arg0_21.currentMode
end

function var0_0.OnLockRole(arg0_22, arg1_22)
	local var0_22 = arg1_22
	local var1_22 = getProxy(BayProxy)
	local var2_22 = false
	local var3_22 = var1_22:getShips()

	for iter0_22, iter1_22 in ipairs(var3_22) do
		if tonumber(iter1_22:getGroupId()) == tonumber(var0_22.ship_group) then
			var2_22 = true

			break
		end
	end

	return var2_22
end

function var0_0.OnSchedule(arg0_23, arg1_23)
	local var0_23 = arg1_23
	local var1_23 = #var0_23.memories

	return _.reduce(var0_23.memories, 0, function(arg0_24, arg1_24)
		local var0_24 = pg.memory_template[arg1_24]

		if var0_24.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_24.unlock_pre, true) then
			arg0_24 = arg0_24 + 1
		end

		return arg0_24
	end), var1_23
end

function var0_0.MemoryFilter(arg0_25)
	arg0_25:searchFilter()
end

function var0_0.searchFilter(arg0_26)
	local var0_26 = getInputText(arg0_26.nameSearchInput)

	arg0_26.searchGroupList = arg0_26:GetMatchGroupList(var0_26)

	if not arg0_26.selectAsc then
		arg0_26.searchGroupList = underscore.reverse(arg0_26.searchGroupList)
	end

	arg0_26.memoryGroupList:SetTotalCount(#arg0_26.searchGroupList, 0)
end

function var0_0.Show(arg0_27)
	var0_0.super.Show(arg0_27)

	arg0_27.index = -1
end

function var0_0.onInitMemoryGroup(arg0_28, arg1_28)
	if arg0_28.exited then
		return
	end

	onButton(arg0_28, arg1_28, function()
		arg0_28.index = 1

		local var0_29 = arg0_28.memoryGroupInfos[arg1_28]

		if var0_29 then
			local var1_29 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.DeleteKey("MEMORY_GROUP_NOTIFICATION" .. var1_29 .. " " .. var0_29.id)
			arg0_28.viewParent:ShowSubMemories(var0_29)
		end
	end, SOUND_BACK)
end

function var0_0.onUpdateMemoryGroup(arg0_30, arg1_30, arg2_30)
	if arg0_30.exited then
		return
	end

	local var0_30 = getProxy(CollectionProxy)
	local var1_30 = arg0_30.searchGroupList[arg1_30]

	assert(var1_30, "MemoryGroup Missing Config Index " .. arg1_30)

	arg0_30.memoryGroupInfos[arg2_30] = var1_30

	local var2_30 = #var1_30.memories
	local var3_30 = _.reduce(var1_30.memories, 0, function(arg0_31, arg1_31)
		local var0_31 = pg.memory_template[arg1_31]

		if var0_31.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_31.unlock_pre, true) then
			arg0_31 = arg0_31 + 1
		end

		return arg0_31
	end)
	local var4_30 = getProxy(PlayerProxy):getRawData().id
	local var5_30

	var5_30 = PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var4_30 .. " " .. var1_30.id, 0) == 1

	local var6_30 = tobool(var0_30 and var0_30.shipGroups[var1_30.ship_group])
	local var7_30 = var6_30 or var3_30 > 0

	setActive(tf(arg2_30):Find("on"), var7_30)
	setActive(tf(arg2_30):Find("off"), not var7_30)

	local var8_30 = var3_30 == 0 and var6_30 and var1_30.id ~= 501

	setActive(tf(arg2_30):Find("Tip"), var8_30)
	setActive(tf(arg2_30):Find("on/get"), var8_30)
	setActive(tf(arg2_30):Find("on/title_get"), var8_30)
	setText(tf(arg2_30):Find("on/title"), var1_30.title)
	setText(tf(arg2_30):Find("off/title"), i18n("memory_filter_option_6"))
	setText(tf(arg2_30):Find("on/title_get/title"), i18n("memory_filter_option_4"))
	setText(tf(arg2_30):Find("on/count"), var3_30 .. "/" .. var2_30)
	arg0_30.loader:GetSpriteQuiet("memoryicon/" .. var1_30.icon, "", tf(arg2_30):Find("on/BG"))
	arg0_30.loader:GetSpriteQuiet("memoryicon/" .. var1_30.icon, "", tf(arg2_30):Find("off/BG"))
end

function var0_0.Return2MemoryGroup(arg0_32)
	local var0_32 = arg0_32.contextData.memoryGroup

	if not var0_32 or arg0_32:GetCurrentMode() == var0_0.LINE_MODE then
		return
	end

	local var1_32 = 0

	for iter0_32, iter1_32 in ipairs(arg0_32.searchGroupList) do
		if iter1_32.id == var0_32 then
			var1_32 = iter0_32

			break
		end
	end

	setInputText(arg0_32.nameSearchInput, "")

	local var2_32 = arg0_32:GetIndexRatio(var1_32)

	arg0_32.memoryGroupList:SetTotalCount(#arg0_32.searchGroupList, var2_32)
end

function var0_0.SwitchReddotMemory(arg0_33)
	local var0_33 = 0
	local var1_33 = getProxy(PlayerProxy):getRawData().id

	for iter0_33, iter1_33 in ipairs(arg0_33.searchGroupList) do
		if PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1_33 .. " " .. iter1_33.id, 0) == 1 then
			var0_33 = iter0_33

			break
		end
	end

	if var0_33 == 0 then
		return
	end

	local var2_33 = arg0_33:GetIndexRatio(var0_33)

	arg0_33.memoryGroupList:SetTotalCount(#arg0_33.searchGroupList, var2_33)
end

function var0_0.GetIndexRatio(arg0_34, arg1_34)
	local var0_34 = 0

	if arg1_34 > 0 then
		local var1_34 = arg0_34.memoryGroupList
		local var2_34 = arg0_34.memoryGroupsGrid.cellSize.y + arg0_34.memoryGroupsGrid.spacing.y
		local var3_34 = arg0_34.memoryGroupsGrid.constraintCount
		local var4_34 = var2_34 * math.ceil(#arg0_34.searchGroupList / var3_34)

		var0_34 = (var2_34 * math.floor((arg1_34 - 1) / var3_34) + var1_34.paddingFront) / (var4_34 - arg0_34.memoryGroupViewport.rect.height)
		var0_34 = Mathf.Clamp01(var0_34)
	end

	return var0_34
end

function var0_0.GetMatchGroupList(arg0_35, arg1_35, arg2_35)
	if not noEmptyStr(arg1_35) then
		return underscore.to_array(arg0_35.memoryGroups)
	end

	arg1_35 = string.lower(string.gsub(arg1_35, "%.", "%%."))

	local var0_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.memoryGroups) do
		if string.find(string.lower(iter1_35.title), arg1_35) then
			table.insert(var0_35, iter1_35)
		else
			local var1_35 = ShipGroup.getDefaultShipNameByGroupID(iter1_35.ship_group)

			if string.find(string.lower(var1_35), arg1_35) then
				table.insert(var0_35, iter1_35)
			end
		end
	end

	return var0_35
end

function var0_0.UpdateFilterBtn(arg0_36)
	local var0_36 = arg0_36.contextData.indexDatas
	local var1_36 = var0_36 and (var0_36.sortIndex ~= ShipIndexConst.SortDefault or var0_36.typeIndex ~= ShipIndexConst.TypeAll or var0_36.campIndex ~= ShipIndexConst.CampAll or var0_36.progressIndex ~= ShipIndexConst.All)

	setActive(arg0_36._tf:Find("ActivityToggle/btn/active"), var1_36)
end

function var0_0.UpdateView(arg0_37)
	return
end

return var0_0
