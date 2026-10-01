local var0_0 = class("WorldMediaCollectionScene", require("view.base.BaseUI"))

var0_0.PAGE_MEMORTY = 1
var0_0.PAGE_FILE = 2
var0_0.PAGE_RECORD = 3
var0_0.PAGE_ALBUM = 4
var0_0.PAGE_SHIP = 5

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionUI"
end

function var0_0.getBGM(arg0_2)
	local var0_2 = arg0_2.contextData.revertBgm

	arg0_2.contextData.revertBgm = nil

	if var0_2 then
		return var0_2
	else
		return var0_0.super.getBGM(arg0_2)
	end
end

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"ui/worldmediacollectionui",
		"ui/worldmediacollectionmemoryui_atlas",
		"ui/worldmediacollectionfileui_atlas",
		"ui/worldmediacollectionfiledetailui_atlas",
		"ui/worldmediacollectionrecordui_atlas",
		"memoryicon/memory_dashijie"
	}

	local function var1_3()
		local var0_4 = {}
		local var1_4 = pg.memory_storyline.all
		local var2_4 = pg.memory_group.all

		for iter0_4, iter1_4 in ipairs(var1_4) do
			local var3_4 = pg.memory_storyline[iter1_4].icon

			if var3_4 ~= "" then
				table.insert(var0_4, "memorystoryline/" .. var3_4)
			end
		end

		for iter2_4, iter3_4 in ipairs(var2_4) do
			local var4_4 = pg.memory_group[iter3_4].icon

			if var4_4 ~= "" then
				table.insert(var0_4, "memoryicon/" .. var4_4)
			end
		end

		return ResPathSupport.UniqueLuaArr(var0_4)
	end

	local function var2_3()
		local var0_5 = {}

		_.each(pg.world_collection_file_group.all, function(arg0_6)
			local var0_6 = pg.world_collection_file_group[arg0_6].name_abbreviate

			if var0_6 then
				table.insert(var0_5, "CollectionFileTitle/" .. var0_6)
			end
		end)
		_.each(pg.world_collection_file_template.all, function(arg0_7)
			local var0_7 = pg.world_collection_file_template[arg0_7].pic

			if var0_7 then
				table.insert(var0_5, "CollectionFileIllustration/" .. var0_7)
			end
		end)

		return var0_5
	end

	local function var3_3()
		local var0_8 = {}

		_.each(pg.memory_template.all, function(arg0_9)
			local var0_9 = pg.memory_template[arg0_9].icon

			if var0_9 then
				table.insert(var0_8, "memoryicon/" .. var0_9)
			end
		end)

		return ResPathSupport.UniqueLuaArr(var0_8)
	end

	local function var4_3()
		local var0_10 = {}

		_.each(pg.memory_group.all, function(arg0_11)
			local var0_11 = pg.memory_group[arg0_11]

			if var0_11 and var0_11.type == 3 and var0_11.ship_group and var0_11.ship_group ~= 0 then
				local var1_11 = ShipGroup.getDefaultShipConfig(var0_11.ship_group)
				local var2_11 = var1_11 and pg.ship_skin_template[var1_11.skin_id]
				local var3_11 = var2_11 and var2_11.painting

				if noEmptyStr(var3_11) then
					table.insertto(var0_10, ResPathSupport.GetPaintingListByPaintingName(var3_11))
				end
			end
		end)

		return ResPathSupport.UniqueLuaArr(var0_10)
	end

	local function var5_3()
		local var0_12 = {}

		for iter0_12, iter1_12 in ipairs(pg.activity_medal_group.all) do
			local var1_12 = pg.activity_medal_group[iter1_12]

			if var1_12 and var1_12.entrance_picture and var1_12.entrance_picture ~= "" then
				table.insert(var0_12, var1_12.entrance_picture)
			end

			for iter2_12, iter3_12 in ipairs(pg.activity_medal_template.get_id_list_by_group[iter1_12] or {}) do
				table.insert(var0_12, "activitymedal/" .. iter3_12)
				table.insert(var0_12, "activitymedal/" .. iter3_12 .. "_l")
			end
		end

		return ResPathSupport.UniqueLuaArr(var0_12)
	end

	local function var6_3()
		local var0_13 = {}
		local var1_13 = {}
		local var2_13 = {}

		for iter0_13, iter1_13 in ipairs(pg.lover_character_template.all) do
			local var3_13 = pg.lover_character_template[iter1_13]
			local var4_13 = var3_13.exp_up
			local var5_13 = var3_13.exp_upper_limit

			if var4_13 and var4_13 > 0 and var5_13 and var5_13 > 0 then
				local var6_13 = math.floor(var5_13 / var4_13)
				local var7_13 = math.floor((var6_13 - 1) / 10) + 1

				for iter2_13 = 1, var7_13 do
					table.insert(var0_13, "lovelettermedal/default_" .. iter2_13)
				end
			end
		end

		for iter3_13, iter4_13 in ipairs(getProxy(LoveLetterProxy):GetDisplayGroupList()) do
			table.insertto(var1_13, ResPathSupport.GetPaintingShipYardIconListByPaintingName(iter4_13:getPainting()))
			table.insert(var2_13, string.format(ResPathSupport.ConstPath.BG.ShipCard, iter4_13:rarity2bgPrint()))
		end

		return ResPathSupport.MergeLuaArr(var1_13, var0_13, var2_13)
	end

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_3, arg1_3), var0_3, var1_3(), var2_3(), var3_3(), var4_3(), var6_3(), var5_3()))
end

function var0_0.init(arg0_14)
	arg0_14.top = arg0_14._tf:Find("Top")
	arg0_14.viewContainer = arg0_14._tf:Find("Main")
	arg0_14.subViews = {}

	arg0_14:OverlayPanel(arg0_14.top)
end

local var1_0 = {
	import(".WorldMediaCollectionMemoryLayer"),
	import(".WorldMediaCollectionRecordLayer"),
	import(".WorldMediaCollectionFileLayer"),
	import(".WorldMediaCollectionAlbumLayer"),
	import(".NewWorldMediaCollectionMemoryLayer")
}

function var0_0.GetCurrentPage(arg0_15)
	return arg0_15.contextData.page and arg0_15.subViews[arg0_15.contextData.page]
end

function var0_0.didEnter(arg0_16)
	onButton(arg0_16, arg0_16.top:Find("blur_panel/adapt/top/option"), function()
		arg0_16:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.top:Find("blur_panel/adapt/top/back_btn"), function()
		arg0_16:Backward()
	end, SFX_UI_CANCEL)

	local var0_16 = arg0_16.contextData.page or var0_0.PAGE_MEMORTY

	arg0_16.contextData.page = nil

	arg0_16:EnterPage(var0_16)
	arg0_16:UpdateView()
end

function var0_0.EnterPage(arg0_19, arg1_19)
	local var0_19 = arg1_19 == arg0_19.contextData.page
	local var1_19 = arg0_19.subViews[arg1_19]

	if not var1_19 then
		local var2_19 = var1_0[arg1_19]

		if not var2_19 then
			return
		end

		arg0_19.contextData[var2_19] = arg0_19.contextData[var2_19] or {}
		var1_19 = var2_19.New(arg0_19, arg0_19.viewContainer, arg0_19.event, arg0_19.contextData)

		var1_19:RegisterView(arg0_19)
		var1_19:Load()
	end

	if arg0_19.contextData.page and arg0_19.subViews[arg0_19.contextData.page] and not var0_19 then
		arg0_19.subViews[arg0_19.contextData.page].buffer:OnDeselected()
	end

	arg0_19.contextData.page = arg1_19
	arg0_19.subViews[arg1_19] = var1_19

	if not var0_19 then
		var1_19.buffer:OnSelected()
	else
		var1_19.buffer:OnReselected()
	end
end

function var0_0.WarpToRecord(arg0_20, arg1_20, arg2_20, arg3_20)
	arg0_20.contextData.recordGroup = arg1_20
	arg0_20.contextData.storyNodeID = arg3_20

	arg0_20:EnterPage(var0_0.PAGE_FILE)
end

function var0_0.WarpToStoryNode(arg0_21, arg1_21)
	arg0_21:EnterPage(var0_0.PAGE_MEMORTY)
	arg0_21.subViews[var0_0.PAGE_MEMORTY]:WrapToStoryLine(arg1_21)
end

function var0_0.Backward(arg0_22)
	local var0_22 = arg0_22.subViews[arg0_22.contextData.page]
	local var1_22 = var0_22 and var0_22:OnBackward()

	if var1_22 then
		return var1_22
	end

	arg0_22:closeView()
end

function var0_0.onBackPressed(arg0_23)
	arg0_23:Backward()
end

function var0_0.WorldRecordLock()
	local function var0_24()
		local var0_25 = getProxy(PlayerProxy):getRawData().level

		return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_25, "WorldMediaCollectionRecordMediator")
	end

	return LOCK_WORLD_COLLECTION or not var0_24()
end

function var0_0.UpdateView(arg0_26)
	local var0_26 = arg0_26.subViews[arg0_26.contextData.page]

	if not var0_26 then
		return
	end

	var0_26.buffer:UpdateView()
end

function var0_0.willExit(arg0_27)
	local var0_27 = arg0_27:GetCurrentPage()

	if var0_27 then
		var0_27.buffer:Hide()
	end

	for iter0_27, iter1_27 in pairs(arg0_27.subViews) do
		iter1_27:Destroy()
	end

	table.clear(arg0_27.subViews)
	arg0_27:UnOverlayPanel(arg0_27.top, arg0_27._tf)
end

return var0_0
