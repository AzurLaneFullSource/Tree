local var0_0 = class("ItemTipPanel", import(".MsgboxSubPanel"))

var0_0.DetailConfig = {}

function var0_0.ShowItemTip(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1 = var0_0.GetDropLackConfig(Drop.New({
		type = arg0_1,
		id = arg1_1
	}))

	if not var0_1 then
		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		type = MSGBOX_TYPE_ITEMTIP,
		drop = Drop.New({
			type = arg0_1,
			id = arg1_1
		}),
		descriptions = var0_1.description,
		msgTitle = arg2_1,
		goSceneCallack = arg3_1,
		weight = LayerWeightConst.SECOND_LAYER
	})

	return true
end

function var0_0.GetDropLackConfig(arg0_2)
	if arg0_2.type == DROP_TYPE_RESOURCE then
		arg0_2 = Drop.New({
			type = DROP_TYPE_ITEM,
			id = id2ItemId(arg0_2.id)
		})
	end

	if not var0_0.DetailConfig[arg0_2.type] then
		var0_0.DetailConfig[arg0_2.type] = {}

		for iter0_2, iter1_2 in ipairs(pg.item_lack.get_id_list_by_drop_type[arg0_2.type] or {}) do
			local var0_2 = pg.item_lack[iter1_2]

			for iter2_2, iter3_2 in ipairs(var0_2.itemids) do
				var0_0.DetailConfig[arg0_2.type][iter3_2] = var0_2
			end
		end
	end

	return var0_0.DetailConfig[arg0_2.type][arg0_2.id]
end

function var0_0.ShowItemTipbyID(...)
	return var0_0.ShowItemTip(DROP_TYPE_ITEM, ...)
end

function var0_0.CanShowTip(arg0_4)
	return tobool(var0_0.GetDropLackConfig(Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg0_4
	})))
end

function var0_0.ShowRingBuyTip()
	GoShoppingMsgBox(i18n("switch_to_shop_tip_2", string.format("<color=#92FC63FF>%s</color>", Item.getConfigData(ITEM_ID_FOR_PROPOSE).name)), ChargeScene.TYPE_ITEM)
end

function var0_0.ShowGoldBuyTip(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getRawData()

	GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
		{
			59001,
			arg0_6 - var0_6[id2res(1)],
			arg0_6
		}
	})
end

function var0_0.ShowOilBuyTip(arg0_7, arg1_7)
	local var0_7 = getProxy(PlayerProxy):getRawData()
	local var1_7 = ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, var0_7.buyOilCount)

	if not var1_7 then
		return
	end

	local var2_7 = pg.shop_template[var1_7]
	local var3_7 = var2_7.num

	if var2_7.num == -1 and var2_7.genre == ShopArgs.BuyOil then
		var3_7 = ShopArgs.getOilByLevel(var0_7.level)
	end

	if pg.gameset.buy_oil_limit.key_value <= var0_7.buyOilCount then
		return
	end

	arg1_7 = arg1_7 or "oil_buy_tip_2"

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		yseBtnLetf = true,
		type = MSGBOX_TYPE_SINGLE_ITEM,
		windowSize = {
			y = 570
		},
		content = i18n(arg1_7, var2_7.resource_num, var3_7, var0_7.buyOilCount, arg0_7 - var0_7[id2res(2)]),
		drop = {
			id = 2,
			type = DROP_TYPE_RESOURCE,
			count = var3_7
		},
		onYes = function()
			pg.m02:sendNotification(GAME.SHOPPING, {
				isQuickShopping = true,
				count = 1,
				id = var1_7
			})
		end,
		weight = LayerWeightConst.TOP_LAYER
	})

	return true
end

function var0_0.getUIName(arg0_9)
	return "Msgbox4ItemGo"
end

function var0_0.OnInit(arg0_10)
	arg0_10.list = arg0_10:findTF("skipable_list")
	arg0_10.tpl = arg0_10:findTF("tpl", arg0_10.list)
	arg0_10.title = arg0_10:findTF("name")
end

function var0_0.OnRefresh(arg0_11, arg1_11)
	setActive(arg0_11.viewParent._btnContainer, false)

	local var0_11 = arg1_11.drop:getName()
	local var1_11 = arg1_11.descriptions

	setText(arg0_11.title, arg1_11.msgTitle or i18n("item_lack_title", var0_11, var0_11))
	UIItemList.StaticAlign(arg0_11.list, arg0_11.tpl, #var1_11, function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var1_11[arg1_12 + 1]
			local var1_12, var2_12, var3_12 = unpack(var0_12)
			local var4_12, var5_12 = unpack(var2_12)
			local var6_12 = #var4_12 > 0

			if var3_12 and var3_12 ~= 0 then
				var6_12 = var6_12 and getProxy(ActivityProxy):IsActivityNotEnd(var3_12)
			end

			local var7_12 = arg2_12:Find("skip_btn")

			setActive(var7_12, var6_12)
			onButton(arg0_11, var7_12, function()
				var0_0.ConfigGoScene(var4_12, var5_12, function()
					if arg1_11.goSceneCallack then
						arg1_11.goSceneCallack()
					end

					arg0_11.viewParent:hide()
				end)
			end, SFX_PANEL)
			Canvas.ForceUpdateCanvases()
			changeToScrollText(arg2_12:Find("title"), var1_12)
		end
	end)
end

function var0_0.ConfigGoScene(arg0_15, arg1_15, arg2_15)
	arg1_15 = arg1_15 or {}

	if arg0_15 == SCENE.SHOP and arg1_15.warp == "supplies" and not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "MilitaryExerciseMediator") then
		pg.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

		return
	elseif arg0_15 == SCENE.LEVEL then
		local var0_15 = getProxy(ChapterProxy)
		local var1_15 = getProxy(PlayerProxy):getRawData()

		if arg1_15.leastChapterId then
			local var2_15 = arg1_15.leastChapterId
			local var3_15 = var0_15:getChapterById(var2_15)
			local var4_15 = var0_15:getMapById(var3_15:getConfig("map"))

			if not var4_15 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))

				return
			elseif not var3_15:isUnlock() or var4_15:getMapType() == Map.ELITE and not var4_15:isEliteEnabled() or var3_15:getConfig("unlocklevel") > var1_15.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))

				return
			end
		end

		if arg1_15.eliteDefault and not getProxy(DailyLevelProxy):IsEliteEnabled() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))

			return
		end

		if arg1_15.lastDigit then
			local var5_15 = 0
			local var6_15 = {}

			if arg1_15.mapType then
				var6_15 = var0_15:getMapsByType(arg1_15.mapType)
			else
				for iter0_15, iter1_15 in ipairs({
					Map.SCENARIO,
					Map.ELITE
				}) do
					for iter2_15, iter3_15 in ipairs(var0_15:getMapsByType(iter1_15)) do
						table.insert(var6_15, iter3_15)
					end
				end
			end

			for iter4_15, iter5_15 in ipairs(var6_15) do
				if iter5_15:isUnlock() and (arg1_15.mapType ~= Map.ELITE or iter5_15:isEliteEnabled()) and var5_15 < iter5_15.id then
					for iter6_15, iter7_15 in pairs(iter5_15:getChapters()) do
						if math.fmod(iter7_15.id, 10) == arg1_15.lastDigit and iter7_15:isUnlock() and iter7_15:getConfig("unlocklevel") <= var1_15.level then
							arg1_15.chapterId = iter7_15.id
							var5_15 = iter5_15.id
							arg1_15.mapIdx = iter5_15.id

							break
						end
					end
				end
			end
		end

		if arg1_15.chapterId then
			local var7_15 = arg1_15.chapterId
			local var8_15 = var0_15:getChapterById(var7_15)
			local var9_15 = var0_15:getMapById(var8_15:getConfig("map"))

			if var9_15 and var9_15:getMapType() == Map.ELITE and not getProxy(DailyLevelProxy):IsEliteEnabled() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))

				return
			end

			if var8_15:isUnlock() then
				if var8_15.active then
					arg1_15.mapIdx = var8_15:getConfig("map")
				elseif var0_15:getActiveChapter() then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("collect_chapter_is_activation"),
						onYes = function()
							pg.m02:sendNotification(GAME.CHAPTER_OP, {
								type = ChapterConst.OpRetreat
							})
						end
					})

					return
				else
					arg1_15.mapIdx = var8_15:getConfig("map")
					arg1_15.openChapterId = var7_15
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))
			end
		end
	elseif arg0_15 == SCENE.TASK and arg1_15.awards then
		local var10_15 = {}

		for iter8_15, iter9_15 in ipairs(arg1_15.awards) do
			var10_15[iter9_15] = true
		end

		local var11_15

		if next(var10_15) then
			local var12_15 = getProxy(TaskProxy):getRawData()

			for iter10_15, iter11_15 in pairs(var12_15) do
				local var13_15 = false

				for iter12_15, iter13_15 in ipairs(iter11_15:getConfig("award_display")) do
					if var10_15[iter13_15[2]] then
						var11_15 = iter11_15.id
						var13_15 = true

						break
					end
				end

				if var13_15 then
					break
				end
			end
		end

		if not var11_15 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_has_finished"))

			return
		end

		arg1_15.targetId = var11_15
	elseif arg0_15 == SCENE.COLLECTSHIP then
		arg1_15.toggle = 2
	elseif arg0_15 == SCENE.DAILYLEVEL and arg1_15.dailyLevelId then
		local var14_15, var15_15 = DailyLevelScene.CanOpenDailyLevel(arg1_15.dailyLevelId)

		if not var14_15 then
			pg.TipsMgr.GetInstance():ShowTips(var15_15)

			return
		end
	elseif arg0_15 == SCENE.MILITARYEXERCISE and not getProxy(MilitaryExerciseProxy):getSeasonInfo():canExercise() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("exercise_count_insufficient"))

		return
	end

	existCall(arg2_15)
	pg.m02:sendNotification(GAME.GO_SCENE, arg0_15, arg1_15)
end

return var0_0
