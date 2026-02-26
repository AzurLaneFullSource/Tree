local var0_0 = class("LiquorFloorBookLayer", import("view.base.BaseUI"))
local var1_0 = 3
local var2_0 = 3
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3

function var0_0.getUIName(arg0_1)
	return "LiquorFloorBookUI"
end

function var0_0.init(arg0_2)
	arg0_2.actid = getProxy(ActivityProxy):getActivityById(ActivityConst.LiquorFloor_ACT_ID)
	arg0_2.Placeac = arg0_2.actid:GetPlaceList()
	arg0_2.gather1 = {}
	arg0_2.gather2 = {}
	arg0_2.gather3 = {}
	arg0_2.client = arg0_2.actid:getConfig("config_client").BookData
	arg0_2.pageCollectSiteIds = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.client[1].data1) do
		table.insert(arg0_2.gather1, iter1_2)
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.client[2].data2) do
		table.insert(arg0_2.gather2, iter3_2)
	end

	for iter4_2, iter5_2 in ipairs(arg0_2.client[3].data3) do
		table.insert(arg0_2.gather3, iter5_2)
	end

	arg0_2.taskIds = {}

	for iter6_2 = 1, #arg0_2.client do
		arg0_2.taskId = arg0_2.client[iter6_2].task

		table.insert(arg0_2.taskIds, arg0_2.taskId)
	end
end

function var0_0.didEnter(arg0_3)
	arg0_3._ad = arg0_3._tf:Find("ad")

	setText(arg0_3._ad:Find("bg/title_bg/title"), i18n("LiquorFloor_story_title_4"))
	onButton(arg0_3, arg0_3._tf:Find("ad/close"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("ad/buttom"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)

	arg0_3.tags = {}

	local var0_3 = 0

	for iter0_3 = 1, var1_0 do
		local var1_3 = iter0_3
		local var2_3 = arg0_3._tf:Find("ad/tag/" .. var1_3)

		table.insert(arg0_3.tags, {
			btn = var2_3,
			index = var1_3
		})
		onToggle(arg0_3, var2_3, function(arg0_6)
			if arg0_6 then
				if var0_3 ~= var1_3 then
					arg0_3:selectTag(var1_3, var2_3)
				end

				var0_3 = var1_3
			end
		end, SFX_PANEL)
	end

	arg0_3.pages = {}

	for iter1_3 = 1, var2_0 do
		local var3_3 = iter1_3
		local var4_3 = arg0_3._tf:Find("ad/page_" .. var3_3)

		table.insert(arg0_3.pages, {
			tf = var4_3,
			index = var3_3
		})
	end

	arg0_3.awardPanelTf = arg0_3._tf:Find("ad/award_panel")

	onButton(arg0_3, arg0_3.awardPanelTf:Find("btnGet"), function()
		arg0_3:emit(LiquorFloorBookMediator.ON_GET_TASK, arg0_3.taskIds[arg0_3.selectTagIndex])
	end, SFX_CONFIRM)
	arg0_3:selectTag(1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._ad)
	setText(arg0_3._ad:Find("tag/1/off/text"), i18n("LiquorFloor_story_title_1"))
	setText(arg0_3._ad:Find("tag/1/on/text"), i18n("LiquorFloor_story_title_1"))
	setText(arg0_3._ad:Find("tag/2/off/text"), i18n("LiquorFloor_story_title_2"))
	setText(arg0_3._ad:Find("tag/2/on/text"), i18n("LiquorFloor_story_title_2"))
	setText(arg0_3._ad:Find("tag/3/off/text"), i18n("LiquorFloor_story_title_3"))
	setText(arg0_3._ad:Find("tag/3/on/text"), i18n("LiquorFloor_story_title_3"))
end

function var0_0.selectTag(arg0_8, arg1_8, arg2_8)
	arg0_8.selectTagIndex = arg1_8

	arg0_8:updateTag()
	arg0_8:updatePage()
	arg0_8:updateAwardPanel()
end

function var0_0.updateTag(arg0_9)
	for iter0_9 = 1, #arg0_9.taskIds do
		local var0_9 = arg0_9.taskIds[iter0_9]
		local var1_9 = getProxy(TaskProxy):getTaskById(var0_9)

		if var1_9 and var1_9:getTaskStatus() == 1 then
			setActive(arg0_9._ad:Find("tag/" .. iter0_9 .. "/tip"), true)
		else
			setActive(arg0_9._ad:Find("tag/" .. iter0_9 .. "/tip"), false)
		end
	end
end

function var0_0.updatePage(arg0_10)
	for iter0_10 = 1, #arg0_10.pages do
		local var0_10 = arg0_10.pages[iter0_10]

		setActive(var0_10.tf, var0_10.index == arg0_10.selectTagIndex)

		if var0_10.index == 1 then
			arg0_10:updatePage1(var0_10.tf, arg0_10.gather1)
		elseif var0_10.index == 2 then
			arg0_10:updatePage2(var0_10.tf, arg0_10.gather2)
		elseif var0_10.index == 3 then
			arg0_10:updatePage3(var0_10.tf, arg0_10.gather3)
		end
	end
end

function var0_0.updatePage2(arg0_11, arg1_11, arg2_11)
	if not arg0_11.page2Items then
		arg0_11.page2Items = {}

		local var0_11 = findTF(arg1_11, "list/content/itemTpl")
		local var1_11 = findTF(arg1_11, "list/content")

		setActive(var0_11, false)

		for iter0_11 = 1, #arg2_11 do
			local var2_11 = arg0_11:getCollectDataBySiteId(arg2_11[iter0_11])
			local var3_11 = tf(instantiate(var0_11))

			setParent(var3_11, var1_11)
			setActive(var3_11, true)

			local var4_11 = var3_11:Find("bg/icon")

			setImageSprite(var4_11, LoadSprite("ui/LiquorFloorUI_atlas", var2_11.icon), true)

			local var5_11 = var3_11:Find("bg/GameObject/name")

			setScrollText(var5_11, var2_11.name)

			local var6_11 = var3_11:Find("bg/lock/name")

			setText(var6_11, "???????")

			local var7_11 = var3_11:Find("bg/lock/Text")

			setText(var7_11, var2_11.unlock_desc)
			table.insert(arg0_11.page2Items, {
				tf = var3_11,
				index = iter0_11
			})
		end
	end

	for iter1_11 = 1, #arg0_11.page2Items do
		local var8_11 = arg0_11.page2Items[iter1_11].tf
		local var9_11 = arg0_11:getCollectDataBySiteId(arg2_11[iter1_11])
		local var10_11 = var9_11.unlock[2] <= arg0_11.Placeac[var9_11.unlock[1]]:GetLevel()
		local var11_11 = var8_11:Find("bg/icon")

		setActive(var11_11, var10_11)

		local var12_11 = var8_11:Find("bg/lock")

		setActive(var12_11, not var10_11)

		local var13_11 = var8_11:Find("bg/GameObject/name")
		local var14_11 = var8_11:Find("bg/lock")

		setActive(var13_11, var10_11)
		setActive(var14_11, not var10_11)
	end
end

function var0_0.updatePage1(arg0_12, arg1_12, arg2_12)
	if not arg0_12.page1Items then
		arg0_12.page1Items = {}

		local var0_12 = arg1_12:Find("list/content/itemTpl")
		local var1_12 = arg1_12:Find("list/content")

		setActive(var0_12, false)

		for iter0_12 = 1, #arg2_12 do
			local var2_12 = arg0_12:getCollectDataBySiteId(arg2_12[iter0_12])
			local var3_12 = tf(instantiate(var0_12))

			setParent(var3_12, var1_12)
			setActive(var3_12, true)

			local var4_12 = var3_12:Find("icon")

			LoadImageSpriteAsync("bg/" .. var2_12.icon, var4_12)

			local var5_12 = var3_12:Find("desc_bg/desc")

			SetActive(var3_12:Find("desc_bg"), memoryData)

			if var2_12.name then
				setText(var5_12, var2_12.name)
			end

			table.insert(arg0_12.page1Items, {
				tf = var3_12,
				index = iter0_12
			})
		end
	end

	for iter1_12 = 1, #arg0_12.page1Items do
		local var6_12 = arg0_12.page1Items[iter1_12].tf
		local var7_12 = arg0_12:getCollectDataBySiteId(arg2_12[iter1_12]).unlock[2] <= arg0_12.actid:GetTownLevel()
		local var8_12 = arg0_12:getCollectDataBySiteId(arg2_12[iter1_12]).unlock[2]
		local var9_12 = var6_12:Find("lock")
		local var10_12 = var6_12:Find("bg2")
		local var11_12 = var6_12:Find("desc_bg")
		local var12_12 = var6_12:Find("icon")
		local var13_12 = var6_12:Find("lock/Text")

		setText(var13_12, arg0_12:getCollectDataBySiteId(arg2_12[iter1_12]).unlock_desc)
		setActive(var12_12, var7_12)
		setActive(var11_12, var7_12)
		setActive(var9_12, not var7_12)
		setActive(var10_12, not var7_12)
	end
end

function var0_0.updatePage3(arg0_13, arg1_13, arg2_13)
	if not arg0_13.page3Items then
		arg0_13.page3Items = {}

		local var0_13 = findTF(arg1_13, "list/content/itemTpl")
		local var1_13 = findTF(arg1_13, "list/content")

		setActive(var0_13, false)

		for iter0_13 = 1, #arg2_13 do
			local var2_13 = arg0_13:getCollectDataBySiteId(arg2_13[iter0_13])
			local var3_13 = tf(instantiate(var0_13))

			setParent(var3_13, var1_13)
			setActive(var3_13, true)

			local var4_13 = var3_13:Find("ad/mask/icon")
			local var5_13 = tonumber(var2_13.icon)
			local var6_13 = pg.ship_skin_template[var5_13]
			local var7_13 = ""

			if var6_13 then
				var7_13 = HXSet.hxLan(var2_13.name)

				local var8_13 = var6_13.painting
				local var9_13 = var0_0.StaticGetPaintingName(var8_13)

				LoadPaintingPrefabAsync(var4_13, var8_13, var9_13, "biandui", function()
					return
				end)
			else
				print("skin_id no exist" .. var5_13)
			end

			onButton(arg0_13, var3_13, function()
				if arg0_13:getSiteOpen(var2_13.site_id) then
					pg.NewStoryMgr.GetInstance():Play(var2_13.luaID, function()
						return
					end, true)
				end
			end, SFX_CONFIRM)

			local var10_13 = var3_13:Find("ad")
			local var11_13 = var3_13:Find("ad/name_bg/name")

			setText(var11_13, var7_13)

			local var12_13 = var3_13:Find("ad/lock")
			local var13_13 = var3_13:Find("ad/lock/Text")

			setText(var13_13, var2_13.unlock_desc)
			table.insert(arg0_13.page3Items, {
				tf = var3_13,
				index = iter0_13
			})
		end
	end

	for iter1_13 = 1, #arg0_13.page3Items do
		local var14_13 = arg0_13.page3Items[iter1_13].tf
		local var15_13 = arg0_13:getCollectDataBySiteId(arg2_13[iter1_13])
		local var16_13 = arg0_13:getCollectDataBySiteId(arg2_13[iter1_13]).unlock[2] <= arg0_13.Placeac[arg0_13:getCollectDataBySiteId(arg2_13[iter1_13]).unlock[1]]:GetLevel()
		local var17_13 = var14_13:Find("ad/mask/icon")
		local var18_13 = var14_13:Find("ad/name_bg")
		local var19_13 = var14_13:Find("ad/lock")

		setActive(var17_13, var16_13)
		setActive(var18_13, var16_13)
		setActive(var19_13, not var16_13)
	end
end

function var0_0.getSiteOpen(arg0_17, arg1_17)
	return table.contains(arg0_17.collectInfo, arg1_17)
end

function var0_0.getCollectDataBySiteId(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(pg.activity_town_collection_2.all) do
		if pg.activity_town_collection_2[iter1_18].id == arg1_18 then
			return pg.activity_town_collection_2[iter1_18]
		end
	end

	return nil
end

function var0_0.StaticGetPaintingName(arg0_19)
	local var0_19 = arg0_19

	if checkABExist("painting/" .. var0_19 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_19, 0) ~= 0 then
		var0_19 = var0_19 .. "_n"
	end

	if HXSet.isHx() then
		return var0_19
	end

	local var1_19 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0_19) == var0_0.PAINTING_VARIANT_EX

	if var1_19 and not checkABExist("painting/" .. var0_19 .. "_ex") then
		return var0_19
	end

	return var1_19 and var0_19 .. "_ex" or var0_19
end

function var0_0.updateAwardPanel(arg0_20)
	local var0_20 = arg0_20.taskIds[arg0_20.selectTagIndex]
	local var1_20 = getProxy(TaskProxy):getTaskVO(var0_20)
	local var2_20 = arg0_20.awardPanelTf:Find("awardIcon")
	local var3_20 = var1_20:getConfig("award_display")[1]
	local var4_20 = {
		type = var3_20[1],
		id = var3_20[2],
		count = var3_20[3]
	}

	updateDrop(var2_20, var4_20)
	onButton(arg0_20, var2_20, function()
		arg0_20:emit(var0_0.ON_DROP, var4_20)
	end, SFX_PANEL)

	local var5_20 = findTF(arg0_20.awardPanelTf, "progress")

	setText(var5_20, var1_20:getProgress() .. "/" .. var1_20:getConfig("target_num"))

	local var6_20 = findTF(arg0_20.awardPanelTf, "Slider")

	setSlider(var6_20, 0, 1, var1_20:getProgress() / var1_20:getConfig("target_num"))

	local var7_20 = findTF(arg0_20.awardPanelTf, "desc")

	setText(var7_20, var1_20:getConfig("desc"))

	local var8_20 = findTF(arg0_20.awardPanelTf, "btnGet")
	local var9_20 = findTF(arg0_20.awardPanelTf, "btnGot")
	local var10_20 = findTF(arg0_20.awardPanelTf, "btnGo")

	setText(findTF(var8_20, "text"), i18n("LiquorFloor_story_get"))
	setText(findTF(var9_20, "text"), i18n("LiquorFloor_story_got"))
	setText(findTF(var10_20, "text"), i18n("LiquorFloor_story_go"))
	setActive(var8_20, false)
	setActive(var9_20, false)
	setActive(imgGot, false)
	setActive(var10_20, false)

	if var1_20:getTaskStatus() == 0 then
		setActive(var10_20, true)
	elseif var1_20:getTaskStatus() == 1 then
		setActive(var8_20, true)
	elseif var1_20:getTaskStatus() == 2 then
		setActive(var9_20, true)
		setActive(imgGot, true)
	end

	onButton(arg0_20, var10_20, function()
		arg0_20:closeView()
	end, SFX_CANCEL)
end

function var0_0.willExit(arg0_23)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23._ad, arg0_23._tf)
end

return var0_0
