local var0 = class("ItemTipPanel", import(".MsgboxSubPanel"))

var0.DetailConfig = {}

function var0.ShowItemTip(arg0, arg1, arg2, arg3)
	local var0 = var0.GetDropLackConfig(Drop.New({
		type = arg0,
		id = arg1
	}))

	if not var0 then
		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		type = MSGBOX_TYPE_ITEMTIP,
		drop = Drop.New({
			type = arg0,
			id = arg1
		}),
		descriptions = var0.description,
		msgTitle = arg2,
		goSceneCallack = arg3,
		weight = LayerWeightConst.SECOND_LAYER
	})

	return true
end

function var0.GetDropLackConfig(arg0)
	if arg0.type == DROP_TYPE_RESOURCE then
		arg0 = Drop.New({
			type = DROP_TYPE_ITEM,
			id = id2ItemId(arg0.id)
		})
	end

	if not var0.DetailConfig[arg0.type] then
		var0.DetailConfig[arg0.type] = {}

		for iter0, iter1 in ipairs(pg.item_lack.get_id_list_by_drop_type[arg0.type] or {}) do
			local var0 = pg.item_lack[iter1]

			for iter2, iter3 in ipairs(var0.itemids) do
				var0.DetailConfig[arg0.type][iter3] = var0
			end
		end
	end

	return var0.DetailConfig[arg0.type][arg0.id]
end

function var0.ShowItemTipbyID(...)
	return var0.ShowItemTip(DROP_TYPE_ITEM, ...)
end

function var0.CanShowTip(arg0)
	return tobool(var0.DetailConfig[arg0])
end

function var0.ShowRingBuyTip()
	GoShoppingMsgBox(i18n("switch_to_shop_tip_2", string.format("<color=#92FC63FF>%s</color>", Item.getConfigData(ITEM_ID_FOR_PROPOSE).name)), ChargeScene.TYPE_ITEM)
end

function var0.ShowGoldBuyTip(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
		{
			59001,
			arg0 - var0[id2res(1)],
			arg0
		}
	})
end

function var0.ShowOilBuyTip(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, var0.buyOilCount)

	if not var1 then
		return
	end

	local var2 = pg.shop_template[var1]
	local var3 = var2.num

	if var2.num == -1 and var2.genre == ShopArgs.BuyOil then
		var3 = ShopArgs.getOilByLevel(var0.level)
	end

	if pg.gameset.buy_oil_limit.key_value <= var0.buyOilCount then
		return
	end

	arg1 = arg1 or "oil_buy_tip_2"

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		yseBtnLetf = true,
		type = MSGBOX_TYPE_SINGLE_ITEM,
		windowSize = {
			y = 570
		},
		content = i18n(arg1, var2.resource_num, var3, var0.buyOilCount, arg0 - var0[id2res(2)]),
		drop = {
			id = 2,
			type = DROP_TYPE_RESOURCE,
			count = var3
		},
		onYes = function()
			pg.m02:sendNotification(GAME.SHOPPING, {
				isQuickShopping = true,
				count = 1,
				id = var1
			})
		end,
		weight = LayerWeightConst.TOP_LAYER
	})

	return true
end

function var0.getUIName(arg0)
	return "Msgbox4ItemGo"
end

function var0.OnInit(arg0)
	arg0.list = arg0:findTF("skipable_list")
	arg0.tpl = arg0:findTF("tpl", arg0.list)
	arg0.title = arg0:findTF("name")
end

function var0.OnRefresh(arg0, arg1)
	setActive(arg0.viewParent._btnContainer, false)

	local var0 = arg1.drop:getName()
	local var1 = arg1.descriptions

	setText(arg0.title, arg1.msgTitle or i18n("item_lack_title", var0, var0))
	UIItemList.StaticAlign(arg0.list, arg0.tpl, #var1, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]
			local var1, var2, var3 = unpack(var0)
			local var4, var5 = unpack(var2)
			local var6 = #var4 > 0

			if var3 and var3 ~= 0 then
				var6 = var6 and getProxy(ActivityProxy):IsActivityNotEnd(var3)
			end

			local var7 = arg2:Find("skip_btn")

			setActive(var7, var6)
			onButton(arg0, var7, function()
				var0.ConfigGoScene(var4, var5, function()
					if arg1.goSceneCallack then
						arg1.goSceneCallack()
					end

					arg0.viewParent:hide()
				end)
			end, SFX_PANEL)
			Canvas.ForceUpdateCanvases()
			changeToScrollText(arg2:Find("title"), var1)
		end
	end)
end

function var0.ConfigGoScene(arg0, arg1, arg2)
	arg1 = arg1 or {}

	if arg0 == SCENE.SHOP and arg1.warp == "supplies" and not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "MilitaryExerciseMediator") then
		pg.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

		return
	elseif arg0 == SCENE.LEVEL then
		local var0 = getProxy(ChapterProxy)
		local var1 = getProxy(PlayerProxy):getRawData()

		if arg1.leastChapterId then
			local var2 = arg1.leastChapterId
			local var3 = var0:getChapterById(var2)
			local var4 = var0:getMapById(var3:getConfig("map"))

			if not var4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))

				return
			elseif not var3:isUnlock() or var4:getMapType() == Map.ELITE and not var4:isEliteEnabled() or var3:getConfig("unlocklevel") > var1.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))

				return
			end
		end

		if arg1.eliteDefault and not getProxy(DailyLevelProxy):IsEliteEnabled() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))

			return
		end

		if arg1.lastDigit then
			local var5 = 0
			local var6 = {}

			if arg1.mapType then
				var6 = var0:getMapsByType(arg1.mapType)
			else
				for iter0, iter1 in ipairs({
					Map.SCENARIO,
					Map.ELITE
				}) do
					for iter2, iter3 in ipairs(var0:getMapsByType(iter1)) do
						table.insert(var6, iter3)
					end
				end
			end

			for iter4, iter5 in ipairs(var6) do
				if iter5:isUnlock() and (arg1.mapType ~= Map.ELITE or iter5:isEliteEnabled()) and var5 < iter5.id then
					for iter6, iter7 in pairs(iter5:getChapters()) do
						if math.fmod(iter7.id, 10) == arg1.lastDigit and iter7:isUnlock() and iter7:getConfig("unlocklevel") <= var1.level then
							arg1.chapterId = iter7.id
							var5 = iter5.id
							arg1.mapIdx = iter5.id

							break
						end
					end
				end
			end
		end

		if arg1.chapterId then
			local var7 = arg1.chapterId
			local var8 = var0:getChapterById(var7)
			local var9 = var0:getMapById(var8:getConfig("map"))

			if var9 and var9:getMapType() == Map.ELITE and not getProxy(DailyLevelProxy):IsEliteEnabled() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))

				return
			end

			if var8:isUnlock() then
				if var8.active then
					arg1.mapIdx = var8:getConfig("map")
				elseif var0:getActiveChapter() then
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
					arg1.mapIdx = var8:getConfig("map")
					arg1.openChapterId = var7
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))
			end
		end
	elseif arg0 == SCENE.TASK and arg1.awards then
		local var10 = {}

		for iter8, iter9 in ipairs(arg1.awards) do
			var10[iter9] = true
		end

		local var11

		if next(var10) then
			local var12 = getProxy(TaskProxy):getRawData()

			for iter10, iter11 in pairs(var12) do
				local var13 = false

				for iter12, iter13 in ipairs(iter11:getConfig("award_display")) do
					if var10[iter13[2]] then
						var11 = iter11.id
						var13 = true

						break
					end
				end

				if var13 then
					break
				end
			end
		end

		if not var11 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_has_finished"))

			return
		end

		arg1.targetId = var11
	elseif arg0 == SCENE.COLLECTSHIP then
		arg1.toggle = 2
	elseif arg0 == SCENE.DAILYLEVEL and arg1.dailyLevelId then
		local var14, var15 = DailyLevelScene.CanOpenDailyLevel(arg1.dailyLevelId)

		if not var14 then
			pg.TipsMgr.GetInstance():ShowTips(var15)

			return
		end
	elseif arg0 == SCENE.MILITARYEXERCISE and not getProxy(MilitaryExerciseProxy):getSeasonInfo():canExercise() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("exercise_count_insufficient"))

		return
	end

	existCall(arg2)
	pg.m02:sendNotification(GAME.GO_SCENE, arg0, arg1)
end

return var0
