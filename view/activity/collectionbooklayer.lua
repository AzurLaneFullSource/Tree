local var0_0 = class("CollectionBookLayer", import("view.base.BaseUI"))
local var1_0 = 3
local var2_0 = 3
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3

function var0_0.getUIName(arg0_1)
	return "CollectionBookUI"
end

function var0_0.init(arg0_2)
	local var0_2 = CollectionBookMediator.ACT_ID
	local var1_2 = getProxy(ActivityProxy):getActivityById(var0_2)

	arg0_2.collectInfo = var1_2:getData1List()

	if not arg0_2.collectInfo then
		arg0_2.collectInfo = {}
	end

	arg0_2.taskIds = var1_2:getConfig("config_client").collect_task
	arg0_2.pageCollectSiteIds = {}

	for iter0_2 = 1, var2_0 do
		local var2_2 = pg.task_data_template[arg0_2.taskIds[iter0_2]]

		table.insert(arg0_2.pageCollectSiteIds, var2_2.target_id)
	end
end

function var0_0.didEnter(arg0_3)
	arg0_3._ad = findTF(arg0_3._tf, "ad")

	onButton(arg0_3, findTF(arg0_3._tf, "ad/close"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, findTF(arg0_3._tf, "ad/buttom"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)

	arg0_3.tags = {}

	for iter0_3 = 1, var1_0 do
		local var0_3 = iter0_3
		local var1_3 = findTF(arg0_3._tf, "ad/tag/bg_part_" .. var0_3)
		local var2_3 = findTF(arg0_3._tf, "ad/tag/btn_part_" .. var0_3)

		table.insert(arg0_3.tags, {
			btn = var2_3,
			bg = var1_3,
			index = var0_3
		})
		onButton(arg0_3, var2_3, function()
			arg0_3:selectTag(var0_3)
		end, SFX_CONFIRM)
		setText(findTF(var1_3, "ad/text"), i18n("collection_book_tag_" .. var0_3))
		setText(findTF(var2_3, "ad/text"), i18n("collection_book_tag_" .. var0_3))
	end

	arg0_3.pages = {}

	for iter1_3 = 1, var2_0 do
		local var3_3 = iter1_3
		local var4_3 = findTF(arg0_3._tf, "ad/page_" .. var3_3)

		table.insert(arg0_3.pages, {
			tf = var4_3,
			index = var3_3
		})
	end

	arg0_3.awardPanelTf = findTF(arg0_3._tf, "ad/award_panel")

	onButton(arg0_3, findTF(arg0_3.awardPanelTf, "btnGet"), function()
		pg.m02:sendNotification(GAME.SUBMIT_TASK, arg0_3.taskIds[arg0_3.selectTagIndex])
	end, SFX_CONFIRM)
	arg0_3:selectTag(1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._ad)
end

function var0_0.selectTag(arg0_8, arg1_8)
	arg0_8.selectTagIndex = arg1_8

	arg0_8:updateTag()
	arg0_8:updatePage()
	arg0_8:updateAwardPanel()
end

function var0_0.updateTag(arg0_9)
	for iter0_9 = 1, #arg0_9.tags do
		local var0_9 = arg0_9.tags[iter0_9]

		setActive(var0_9.bg, var0_9.index == arg0_9.selectTagIndex)
		setActive(var0_9.btn, var0_9.index ~= arg0_9.selectTagIndex)

		local var1_9 = arg0_9.taskIds[iter0_9]
		local var2_9 = getProxy(TaskProxy):getTaskById(var1_9)

		if var2_9 and var2_9:getTaskStatus() == 1 then
			setActive(findTF(var0_9.btn, "ad/tip"), true)
		else
			setActive(findTF(var0_9.btn, "ad/tip"), false)
		end
	end
end

function var0_0.updatePage(arg0_10)
	for iter0_10 = 1, #arg0_10.pages do
		local var0_10 = arg0_10.pages[iter0_10]

		setActive(var0_10.tf, var0_10.index == arg0_10.selectTagIndex)

		if var0_10.index == 1 then
			arg0_10:updatePage1(var0_10.tf, arg0_10.pageCollectSiteIds[var0_10.index])
		elseif var0_10.index == 2 then
			arg0_10:updatePage2(var0_10.tf, arg0_10.pageCollectSiteIds[var0_10.index])
		elseif var0_10.index == 3 then
			arg0_10:updatePage3(var0_10.tf, arg0_10.pageCollectSiteIds[var0_10.index])
		end
	end
end

function var0_0.updatePage1(arg0_11, arg1_11, arg2_11)
	if not arg0_11.page1Items then
		arg0_11.page1Items = {}

		local var0_11 = findTF(arg1_11, "list/content/itemTpl")
		local var1_11 = findTF(arg1_11, "list/content")

		setActive(var0_11, false)

		for iter0_11 = 1, #arg2_11 do
			local var2_11 = arg0_11:getCollectDataBySiteId(arg2_11[iter0_11])
			local var3_11 = tf(instantiate(var0_11))

			setParent(var3_11, var1_11)
			setActive(var3_11, true)

			local var4_11 = findTF(var3_11, "place/mask/icon")

			LoadImageSpriteAsync(pg.activity_holiday_site[var2_11.site_id].jumpto[3][1], var4_11, true)

			local var5_11 = findTF(var3_11, "bg_title/text")

			setText(var5_11, pg.activity_holiday_site[var2_11.site_id].jumpto[1][1])

			local var6_11 = findTF(var3_11, "desc/text")

			setText(var6_11, pg.activity_holiday_site[var2_11.site_id].jumpto[2][1])

			local var7_11 = findTF(var3_11, "desc/lock")

			setText(var7_11, i18n("collection_book_lock_place"))
			arg0_11:setNumText(findTF(var3_11, "place/num_1"), findTF(var3_11, "place/num_2"), iter0_11)
			table.insert(arg0_11.page1Items, {
				tf = var3_11,
				index = iter0_11,
				site_id = var2_11.site_id
			})
		end
	end

	for iter1_11 = 1, #arg0_11.page1Items do
		local var8_11 = arg0_11.page1Items[iter1_11].tf
		local var9_11 = arg0_11:getSiteOpen(arg0_11.page1Items[iter1_11].site_id)
		local var10_11 = findTF(var8_11, "place/mask")

		setActive(var10_11, var9_11)

		local var11_11 = findTF(var8_11, "place/bg/icon_lock")

		setActive(var11_11, not var9_11)

		local var12_11 = findTF(var8_11, "bg_title/text")

		setActive(var12_11, var9_11)

		local var13_11 = findTF(var8_11, "bg_title/lock")

		setActive(var13_11, not var9_11)

		local var14_11 = findTF(var8_11, "desc/text")

		setActive(var14_11, var9_11)

		local var15_11 = findTF(var8_11, "desc/lock")

		setActive(var15_11, not var9_11)
	end
end

function var0_0.updatePage2(arg0_12, arg1_12, arg2_12)
	if not arg0_12.page2Items then
		arg0_12.page2Items = {}

		local var0_12 = findTF(arg1_12, "list/content/itemTpl")
		local var1_12 = findTF(arg1_12, "list/content")

		setActive(var0_12, false)

		for iter0_12 = 1, #arg2_12 do
			local var2_12 = arg0_12:getCollectDataBySiteId(arg2_12[iter0_12])
			local var3_12 = tf(instantiate(var0_12))

			setParent(var3_12, var1_12)
			setActive(var3_12, true)
			onButton(arg0_12, var3_12, function()
				if arg0_12:getSiteOpen(var2_12.site_id) then
					pg.NewStoryMgr.GetInstance():Play(var2_12.luaID, function()
						return
					end, true)
				end
			end, SFX_CONFIRM)

			local var4_12 = findTF(var3_12, "mask/icon")

			LoadImageSpriteAsync("bg/" .. var2_12.icon, var4_12, true)

			local var5_12 = arg0_12:getMemoryData(var2_12.luaID)
			local var6_12 = findTF(var3_12, "desc")

			if var5_12 then
				setText(var6_12, var5_12.title)
			else
				setText(var6_12, "")
			end

			arg0_12:setNumText(findTF(var3_12, "num_1"), findTF(var3_12, "num_2"), iter0_12)
			table.insert(arg0_12.page2Items, {
				tf = var3_12,
				index = iter0_12,
				site_id = var2_12.site_id
			})
		end
	end

	for iter1_12 = 1, #arg0_12.page2Items do
		local var7_12 = arg0_12.page2Items[iter1_12].tf
		local var8_12 = arg0_12:getSiteOpen(arg0_12.page2Items[iter1_12].site_id)
		local var9_12 = findTF(var7_12, "desc")
		local var10_12 = findTF(var7_12, "desc_lock")
		local var11_12 = findTF(var7_12, "lock")
		local var12_12 = findTF(var7_12, "mask/icon")

		setActive(var9_12, var8_12)
		setActive(var10_12, not var8_12)
		setActive(var11_12, not var8_12)
		setActive(var12_12, var8_12)
	end
end

var0_0.StoryData = {}

function var0_0.getMemoryData(arg0_15, arg1_15)
	if var0_0.StoryData[arg1_15] then
		return var0_0.StoryData[arg1_15]
	end

	for iter0_15, iter1_15 in ipairs(pg.memory_template.all) do
		local var0_15 = pg.memory_template[iter1_15]

		if var0_15.story == arg1_15 then
			var0_0.StoryData[arg1_15] = Clone(var0_15)

			return var0_0.StoryData[arg1_15]
		end
	end

	return nil
end

function var0_0.updatePage3(arg0_16, arg1_16, arg2_16)
	if not arg0_16.page3Items then
		arg0_16.page3Items = {}

		local var0_16 = findTF(arg1_16, "list/content/itemTpl")
		local var1_16 = findTF(arg1_16, "list/content")

		arg0_16.page3ScrollRect = GetComponent(findTF(arg1_16, "list"), typeof(ScrollRect))
		arg0_16.leftA = findTF(arg1_16, "left_aix")
		arg0_16.rightA = findTF(arg1_16, "right_aix")

		setActive(arg0_16.leftA, false)
		arg0_16.page3ScrollRect.onValueChanged:AddListener(function()
			if arg0_16.page3ScrollRect.normalizedPosition.x <= 0.01 then
				setActive(arg0_16.leftA, false)
			elseif arg0_16.page3ScrollRect.normalizedPosition.x >= 1 then
				setActive(arg0_16.rightA, false)
			else
				setActive(arg0_16.leftA, true)
				setActive(arg0_16.rightA, true)
			end
		end)
		setActive(var0_16, false)

		for iter0_16 = 1, #arg2_16 do
			local var2_16 = arg0_16:getCollectDataBySiteId(arg2_16[iter0_16])
			local var3_16 = tf(instantiate(var0_16))

			setParent(var3_16, var1_16)
			setActive(var3_16, true)

			local var4_16 = findTF(var3_16, "ad/mask/icon")
			local var5_16 = tonumber(var2_16.icon)
			local var6_16 = pg.ship_skin_template[var5_16]
			local var7_16 = ""

			if var6_16 then
				var7_16 = HXSet.hxLan(var2_16.name)

				local var8_16 = var6_16.painting
				local var9_16 = var0_0.StaticGetPaintingName(var8_16)

				LoadPaintingPrefabAsync(var4_16, var8_16, var9_16, "biandui", function()
					return
				end)
			else
				print("skin_id no exist" .. var5_16)
			end

			onButton(arg0_16, var3_16, function()
				if arg0_16:getSiteOpen(var2_16.site_id) then
					pg.NewStoryMgr.GetInstance():Play(var2_16.luaID, function()
						return
					end, true)
				end
			end, SFX_CONFIRM)

			findTF(var3_16, "ad").anchoredPosition = Vector2(0, iter0_16 % 2 == 0 and 0 or 25)

			local var10_16 = findTF(var3_16, "ad/name")

			setText(var10_16, var7_16)

			local var11_16 = findTF(var3_16, "ad/name_lock")

			arg0_16:setNumText(findTF(var3_16, "ad/num_1"), findTF(var3_16, "ad/num_2"), iter0_16)
			table.insert(arg0_16.page3Items, {
				tf = var3_16,
				index = iter0_16,
				site_id = var2_16.site_id
			})
		end
	end

	for iter1_16 = 1, #arg0_16.page3Items do
		local var12_16 = arg0_16.page3Items[iter1_16].tf
		local var13_16 = arg0_16:getSiteOpen(arg0_16.page3Items[iter1_16].site_id)
		local var14_16 = findTF(var12_16, "ad/mask/icon")
		local var15_16 = findTF(var12_16, "ad/name")
		local var16_16 = findTF(var12_16, "ad/name_lock")
		local var17_16 = findTF(var12_16, "ad/lock")

		setActive(var14_16, var13_16)
		setActive(var15_16, var13_16)
		setActive(var16_16, not var13_16)
		setActive(var17_16, not var13_16)
	end
end

function var0_0.getSiteOpen(arg0_21, arg1_21)
	return table.contains(arg0_21.collectInfo, arg1_21)
end

function var0_0.getCollectDataBySiteId(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(pg.activity_holiday_collection.all) do
		if pg.activity_holiday_collection[iter1_22].site_id == arg1_22 then
			return pg.activity_holiday_collection[iter1_22]
		end
	end

	return nil
end

function var0_0.StaticGetPaintingName(arg0_23)
	local var0_23 = arg0_23

	if checkABExist("painting/" .. var0_23 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_23, 0) ~= 0 then
		var0_23 = var0_23 .. "_n"
	end

	if HXSet.isHx() then
		return var0_23
	end

	local var1_23 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0_23) == var0_0.PAINTING_VARIANT_EX

	if var1_23 and not checkABExist("painting/" .. var0_23 .. "_ex") then
		return var0_23
	end

	return var1_23 and var0_23 .. "_ex" or var0_23
end

function var0_0.setNumText(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = tostring(math.floor(arg3_24 / 10))
	local var1_24 = tostring(arg3_24 % 10)

	arg0_24:setChildVisible(arg1_24, false)
	arg0_24:setChildVisible(arg2_24, false)
	setActive(findTF(arg1_24, "num_" .. var1_24), true)
	setActive(findTF(arg2_24, "num_" .. var0_24), true)
end

function var0_0.setChildVisible(arg0_25, arg1_25, arg2_25)
	for iter0_25 = 1, arg1_25.childCount do
		local var0_25 = arg1_25:GetChild(iter0_25 - 1)

		setActive(var0_25, arg2_25)
	end
end

function var0_0.updateAwardPanel(arg0_26)
	local var0_26 = arg0_26.taskIds[arg0_26.selectTagIndex]
	local var1_26 = getProxy(TaskProxy):getTaskById(var0_26) or getProxy(TaskProxy):getFinishTaskById(var0_26)
	local var2_26 = findTF(arg0_26.awardPanelTf, "awardIcon")
	local var3_26 = var1_26:getConfig("award_display")[1]
	local var4_26 = {
		type = var3_26[1],
		id = var3_26[2],
		count = var3_26[3]
	}

	updateDrop(var2_26, var4_26)
	onButton(arg0_26, var2_26, function()
		arg0_26:emit(var0_0.ON_DROP, var4_26)
	end, SFX_PANEL)

	local var5_26 = findTF(arg0_26.awardPanelTf, "progress")

	setText(var5_26, var1_26:getProgress() .. "/" .. var1_26:getConfig("target_num"))

	local var6_26 = findTF(arg0_26.awardPanelTf, "desc")

	setText(var6_26, var1_26:getConfig("desc"))

	local var7_26 = findTF(arg0_26.awardPanelTf, "btnGet")
	local var8_26 = findTF(arg0_26.awardPanelTf, "btnGot")
	local var9_26 = findTF(arg0_26.awardPanelTf, "btnGo")
	local var10_26 = findTF(arg0_26.awardPanelTf, "imgGot")

	setText(findTF(var7_26, "text"), i18n("task_get"))
	setText(findTF(var8_26, "text"), i18n("avatarframe_got"))
	setText(findTF(var9_26, "text"), i18n("task_get"))
	setActive(var7_26, false)
	setActive(var8_26, false)
	setActive(var10_26, false)
	setActive(var9_26, false)

	if var1_26:getTaskStatus() == 0 then
		var9_26:GetComponent("UIGrayScale").enabled = false
		var9_26:GetComponent("UIGrayScale").enabled = true

		setActive(var9_26, true)
	elseif var1_26:getTaskStatus() == 1 then
		setActive(var7_26, true)
	elseif var1_26:getTaskStatus() == 2 then
		setActive(var8_26, true)
		setActive(var10_26, true)
	end
end

function var0_0.willExit(arg0_28)
	arg0_28.page3ScrollRect.onValueChanged:RemoveAllListeners()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_28._ad, arg0_28._tf)
end

return var0_0
