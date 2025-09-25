local var0_0 = class("IslandShopDrawAwardPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandDrawAwardPage"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2.event, arg2_2.contextData)

	arg0_2.viewComponent = arg2_2
end

function var0_0.OnLoaded(arg0_3)
	local var0_3 = arg0_3._tf:GetComponent(typeof(ItemList)).prefabItem:ToTable()

	for iter0_3, iter1_3 in ipairs({
		"rtMiddle",
		"rtTitle",
		"btnAll",
		"btnDraw",
		"btnDrawTen",
		"rtDisplayPanel"
	}) do
		arg0_3[iter1_3] = var0_3[iter0_3].transform
	end

	setActive(arg0_3.rtDisplayPanel, false)
end

function var0_0.OnInit(arg0_4)
	arg0_4.bannerRectDic = {}

	eachChild(arg0_4.rtMiddle, function(arg0_5, arg1_5)
		setText(arg0_5:Find("got/Text"), i18n("island_draw_get"))

		local var0_5 = arg0_5.name

		switch(var0_5, {
			S = function()
				setText(arg0_5:Find("state_sequence/Text"), i18n("选择"))
				setText(arg0_5:Find("finish/Text"), i18n("island_draw_null"))
				onButton(arg0_4, arg0_5:Find("state_sequence"), function()
					arg0_4:OpenChangeListWindow()
				end, SFX_PANEL)
				onButton(arg0_4, arg0_5:Find("btn_sequence"), function()
					arg0_4:OpenChangeListWindow()
				end, SFX_PANEL)

				arg0_4.bannerRectDic[var0_5] = BannerScrollRect4IslandDrawAward.New(arg0_5:Find("mask/view/container"), arg0_5:Find("dots"))
			end,
			A = function()
				arg0_4.bannerRectDic[var0_5] = BannerScrollRect4IslandDrawAward.New(arg0_5:Find("mask/view/container"), arg0_5:Find("dots"))
			end,
			select = function()
				setText(arg0_5:Find("count_word/Text"), i18n("island_draw_num"))
				setText(arg0_5:Find("btn_select/Text"), i18n("island_draw_pick"))
				onButton(arg0_4, arg0_5:Find("btn_select"), function()
					arg0_4:OpenSelectAwardWindow()
				end, SFX_PANEL)

				arg0_4.bannerRectDic[var0_5] = BannerScrollRect4IslandDrawAward.New(arg0_5:Find("mask/view/container"), arg0_5:Find("dots"))
			end
		})
	end)
	setText(arg0_4.rtTitle:Find("Text"), i18n("island_draw_time"))
	setText(arg0_4.btnAll:Find("Text"), i18n("island_draw_reward"))
	onButton(arg0_4, arg0_4.btnAll, function()
		arg0_4:OpenAllAwardWindow()
	end, SFX_PANEL)
	setText(arg0_4.btnDraw:Find("Text"), i18n("island_draw_lottery"))
	onButton(arg0_4, arg0_4.btnDraw, function()
		if arg0_4.activity:GetTimesLeft() < 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_draw_float"))

			return
		end

		arg0_4:TryDraw(1)
	end, SFX_PANEL)
	setText(arg0_4.btnDrawTen:Find("Text"), i18n("island_draw_lottery"))
	onButton(arg0_4, arg0_4.btnDrawTen, function()
		if arg0_4.activity:GetTimesLeft() < 10 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_draw_float"))

			return
		end

		arg0_4:TryDraw(10)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.rtDisplayPanel:Find("bg"), function()
		if arg0_4.inAnim then
			return
		end

		arg0_4:HideDrawAwardWindow()
	end, SFX_CANCEL)
end

function var0_0.TryDraw(arg0_16, arg1_16)
	local var0_16 = arg0_16.activity:GetDrawTimes()

	if var0_16 < arg1_16 then
		local var1_16 = Goods.Create({
			id = arg0_16.activity:GetDrawConfig("shop")
		}, Goods.TYPE_SHOPSTREET)
		local var2_16 = var1_16:GetConsume()

		arg0_16.rawIconDic.diamond = arg0_16.rawIconDic.diamond or GetSpriteFromAtlas(var2_16:getIcon(), "")

		arg0_16.viewComponent:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_draw_tip3", string.format("<icon name=diamond w=0.76 h=0.76/>×%d", var2_16.count * (arg1_16 - var0_16)), string.format("<icon name=ticket w=0.76 h=0.76/>×%d", arg1_16 - var0_16)),
			onYes = function()
				if var2_16:getOwnedCount() < var2_16.count * (arg1_16 - var0_16) then
					arg0_16:ShowChargeWindow()
				else
					arg0_16:emit(IslandMediator.SHOPPING, var1_16.id, arg1_16 - var0_16)
				end
			end,
			rawIconDic = arg0_16.rawIconDic
		})
	else
		arg0_16.viewComponent:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_draw_ready"),
			onYes = function()
				arg0_16:emit(IslandMediator.DRAW_AWARD_OPERATION, {
					op = "do_draw",
					activity_id = arg0_16.activity.id,
					count = arg1_16
				})
			end
		})
	end
end

function var0_0.ShowChargeWindow(arg0_19)
	arg0_19.viewComponent:ShowMsgBox({
		type = IslandMsgBox.TYPE_COMMON,
		content = i18n("island_draw_tip4"),
		onYes = function()
			arg0_19.viewComponent:emit(IslandMediator.CHANGE_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		end
	})
end

function var0_0.UpdateActivity(arg0_21, arg1_21)
	arg0_21.activity = arg1_21

	local var0_21 = arg0_21.activity:GetList()

	eachChild(arg0_21.rtMiddle, function(arg0_22, arg1_22)
		local var0_22 = arg0_22.name

		switch(var0_22, {
			S = function()
				setActive(arg0_22:Find("mask"), var0_21)
				setActive(arg0_22:Find("btn_sequence"), var0_21)
				setActive(arg0_22:Find("state_sequence"), not var0_21)

				if var0_21 then
					local var0_23 = arg0_21.activity:GetShowRankList(var0_22)

					arg0_21.bannerRectDic[var0_22]:Reset()

					for iter0_23, iter1_23 in ipairs(var0_23) do
						local var1_23 = arg0_21.bannerRectDic[var0_22]:AddChild()
						local var2_23 = pg.island_draw_reward[iter1_23]

						GetImageSpriteFromAtlasAsync("island/IslandDrawAwardIcon/" .. var2_23.show, "", var1_23:Find("Image"), true)
					end

					arg0_21.bannerRectDic[var0_22]:SetTriggerDotCall(function(arg0_24)
						local var0_24 = var0_23[arg0_24]

						setActive(arg0_22:Find("got"), arg0_21.activity:GetLastItemCount(var0_24) == 0)
					end)
					arg0_21.bannerRectDic[var0_22]:SetUp()
				else
					setActive(arg0_22:Find("got"), false)
				end

				local var3_23 = arg0_21.activity:GetTimesLeft(var0_22)

				setText(arg0_22:Find("times_left/Text"), var3_23 > 0 and i18n("island_draw_last") or i18n("island_draw_null"))
				setText(arg0_22:Find("times_left/times"), var3_23 > 0 and var3_23 or "")
			end,
			A = function()
				setActive(arg0_22:Find("got"), false)

				local var0_25 = arg0_21.activity:GetTimesLeft(var0_22)

				setText(arg0_22:Find("times_left/Text"), var0_25 > 0 and i18n("island_draw_last") or i18n("island_draw_null"))
				setText(arg0_22:Find("times_left/times"), var0_25 > 0 and var0_25 or "")

				local var1_25 = arg0_21.activity:GetShowRankList(var0_22)

				arg0_21.bannerRectDic[var0_22]:Reset()

				for iter0_25, iter1_25 in ipairs(var1_25) do
					local var2_25 = arg0_21.bannerRectDic[var0_22]:AddChild()
					local var3_25 = pg.island_draw_reward[iter1_25]

					GetImageSpriteFromAtlasAsync("island/IslandDrawAwardIcon/" .. var3_25.show, "", var2_25:Find("Image"), true)
				end

				arg0_21.bannerRectDic[var0_22]:SetTriggerDotCall(function(arg0_26)
					local var0_26 = var1_25[arg0_26]

					setActive(arg0_22:Find("got"), arg0_21.activity:GetLastItemCount(var0_26) == 0)
				end)
				arg0_21.bannerRectDic[var0_22]:SetUp(1)
			end,
			select = function()
				setActive(arg0_22:Find("got"), false)

				local var0_27 = arg0_21.activity:GetDrawCount()
				local var1_27 = arg0_21.activity:GetNextCountAwardTimes() or 0

				setText(arg0_22:Find("count_word"), string.format("%d/%d", var0_27, var1_27))
				setActive(arg0_22:Find("btn_select/on"), var1_27 > 0 and var1_27 <= var0_27)

				local var2_27 = arg0_21.activity:GetCountAwards()

				arg0_21.bannerRectDic[var0_22]:Reset()

				for iter0_27, iter1_27 in ipairs(var2_27) do
					local var3_27, var4_27 = unpack(iter1_27)
					local var5_27 = arg0_21.bannerRectDic[var0_22]:AddChild()
					local var6_27 = pg.island_draw_reward[var3_27]

					GetImageSpriteFromAtlasAsync("island/IslandDrawAwardIcon/" .. var6_27.show, "", var5_27:Find("Image"), true)
				end

				arg0_21.bannerRectDic[var0_22]:SetTriggerDotCall(function(arg0_28)
					local var0_28, var1_28 = unpack(var2_27[arg0_28])

					setActive(arg0_22:Find("got"), not var1_28)
				end)
				arg0_21.bannerRectDic[var0_22]:SetUp(2)
			end
		}, function()
			setActive(arg0_22:Find("got"), false)

			local var0_29 = arg0_21.activity:GetTimesLeft(var0_22)

			setText(arg0_22:Find("times_left/Text"), var0_29 > 0 and i18n("island_draw_last") or i18n("island_draw_null"))
			setText(arg0_22:Find("times_left/times"), var0_29 > 0 and var0_29 or "")

			local var1_29 = arg0_21.activity:GetShowRankList(var0_22)[1]

			if var1_29 then
				local var2_29 = pg.island_draw_reward[var1_29]

				GetImageSpriteFromAtlasAsync("island/IslandDrawAwardIcon/" .. var2_29.show, "", arg0_22:Find("mask/Image"), true)
				setActive(arg0_22:Find("got"), false)
			end
		end)
	end)

	local var1_21 = pg.TimeMgr.GetInstance()
	local var2_21 = underscore.map({
		arg0_21.activity:getStartTime(),
		arg0_21.activity.stopTime
	}, function(arg0_30)
		return i18n("trade_card_tips4", unpack(string.split(var1_21:STimeDescS(arg0_30, "%Y/%m/%d"), "/")))
	end)

	setText(arg0_21.rtTitle:Find("Text_1"), string.format("%s\n-%s", unpack(var2_21)) .. i18n("island_draw_time_1"))

	local var3_21 = arg0_21.activity:GetTimesLeft()

	setActive(arg0_21.btnDraw:Find("bg/on"), var3_21 >= 1)
	setActive(arg0_21.btnDraw:Find("bg/off"), var3_21 < 1)
	setActive(arg0_21.btnDrawTen:Find("bg/on"), var3_21 >= 10)
	setActive(arg0_21.btnDrawTen:Find("bg/off"), var3_21 < 10)

	local var4_21 = Drop.New({
		type = DROP_TYPE_VITEM,
		id = arg0_21.activity:GetDrawConfig("cost_free")
	})

	arg0_21.rawIconDic = {
		ticket = GetSpriteFromAtlas(var4_21:getIcon(), "")
	}

	GetImageSpriteFromAtlasAsync(var4_21:getIcon(), "", arg0_21.btnDraw:Find("cost/icon"))
	GetImageSpriteFromAtlasAsync(var4_21:getIcon(), "", arg0_21.btnDrawTen:Find("cost/icon"))
end

function var0_0.OpenChangeListWindow(arg0_31)
	arg0_31.viewComponent:ShowMsgBox({
		type = IslandMsgBox.TYPE_DRAW_AWARD_LIST,
		activity = arg0_31.activity
	})
end

function var0_0.OpenAllAwardWindow(arg0_32)
	arg0_32.viewComponent:ShowMsgBox({
		type = IslandMsgBox.TYPE_DRAW_AWARD_ALL,
		activity = arg0_32.activity
	})
end

function var0_0.OpenSelectAwardWindow(arg0_33)
	arg0_33.viewComponent:ShowMsgBox({
		type = IslandMsgBox.TYPE_DRAW_AWARD_COUNT,
		activity = arg0_33.activity
	})
end

function var0_0.DrawOperation(arg0_34, arg1_34)
	switch(arg1_34.op, {
		set_list = function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_draw_sort"))
		end
	}, function()
		if #arg1_34.awards > 0 then
			arg0_34:ShowDrawAwardWindow(arg1_34.awards)
		end
	end)
end

function var0_0.ShowDrawAwardWindow(arg0_37, arg1_37)
	local var0_37 = #arg1_37 > 1 and "ten" or "one"
	local var1_37

	eachChild(arg0_37.rtDisplayPanel:Find("window"), function(arg0_38, arg1_38)
		setActive(arg0_38, arg0_38.name == var0_37)

		if arg0_38.name == var0_37 then
			var1_37 = arg0_38
		end
	end)

	local var2_37 = {}

	UIItemList.StaticAlign(var1_37:Find("container"), var1_37:Find("container/tpl"), #arg1_37, function(arg0_39, arg1_39, arg2_39)
		if var0_37 == "ten" then
			arg1_39 = arg1_39 % 2 * 5 + 5 - math.floor(arg1_39 / 2)
		else
			arg1_39 = arg1_39 + 1
		end

		if arg0_39 == UIItemList.EventUpdate then
			local var0_39 = arg2_39:Find("card")
			local var1_39 = arg1_37[arg1_39]
			local var2_39 = pg.island_draw_reward[var1_39]
			local var3_39 = Drop.New({
				type = var2_39.drop_type,
				id = var2_39.drop_id
			})

			var0_0.ShowDropInfo(var3_39, var0_39:Find("mask/Image"))

			local var4_39 = switch(var2_39.rarity, {
				function()
					return "C"
				end,
				function()
					return "B"
				end,
				function()
					return "A"
				end,
				function()
					return "S"
				end
			})
			local var5_39 = var0_39:Find("mask/Image")

			if var4_39 == "S" then
				setLocalScale(var0_39:Find("mask/Image"), Vector3(1.2, 1.2, 1))
				setLocalPosition(var0_39:Find("mask/Image"), {
					x = -17.5,
					y = -20
				})
			else
				setLocalScale(var0_39:Find("mask/Image"), Vector3(1.7, 1.7, 1))
				setLocalPosition(var0_39:Find("mask/Image"), Vector3.zero)
			end

			eachChild(var0_39:Find("bg"), function(arg0_44, arg1_44)
				setActive(arg0_44, arg0_44.name == var4_39)
			end)
			eachChild(var0_39:Find("word"), function(arg0_45, arg1_45)
				setActive(arg0_45, arg0_45.name == var4_39)
			end)
			eachChild(var0_39:Find("front"), function(arg0_46, arg1_46)
				setActive(arg0_46, arg0_46.name == var4_39)
			end)
			var0_39:Find("Book"):GetComponent("Book"):SetCurrentPage(2)
			setCanvasGroupAlpha(var0_39, 0)
			setCanvasGroupAlpha(var0_39:Find("Book"), 1)

			var2_37[arg1_39] = arg2_39
		end
	end)
	setCanvasGroupAlpha(arg0_37.rtDisplayPanel:Find("page"), 0)

	local var3_37 = {}

	table.insert(var3_37, function(arg0_47)
		arg0_37.inAnim = true

		pg.UIMgr.GetInstance():BlurPanel(arg0_37.rtDisplayPanel, {
			staticBlur = true
		})
		setActive(arg0_37.rtDisplayPanel, true)
		arg0_37.rtDisplayPanel:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(arg0_47)
	end)
	table.insert(var3_37, function(arg0_48)
		local var0_48 = {}

		for iter0_48, iter1_48 in ipairs(var2_37) do
			local var1_48 = iter1_48:Find("card")

			table.insert(var0_48, function(arg0_49)
				local var0_49 = {}
				local var1_49 = (iter0_48 - 1) % 5 * 2 + (iter0_48 > 5 and 1 or 0)

				if var0_37 == "ten" and var1_49 > 0 then
					table.insert(var0_49, function(arg0_50)
						LeanTween.delayedCall(iter1_48.gameObject, 0.03 * var1_49, System.Action(arg0_50))
					end)
				end

				table.insert(var0_49, function(arg0_51)
					var1_48:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_52)
						arg0_51()
					end)
					switch(var0_37, {
						one = function()
							quickPlayAnimation(var1_48, "anim_IslandDrawAwardPage_onetpl_In")
						end,
						ten = function()
							quickPlayAnimation(var1_48, var1_49 % 2 == 0 and "anim_IslandDrawAwardPage_ten" or "anim_IslandDrawAwardPage_ten02")
						end
					})
				end)
				seriesAsync(var0_49, arg0_49)
			end)
		end

		parallelAsync(var0_48, function()
			LeanTween.delayedCall(0.6, System.Action(function()
				arg0_48()
			end))
		end)
	end)
	table.insert(var3_37, function(arg0_57)
		local var0_57 = {}

		for iter0_57, iter1_57 in ipairs(var2_37) do
			local var1_57 = iter1_57:Find("card")

			table.insert(var0_57, function(arg0_58)
				local var0_58 = {}
				local var1_58 = iter0_57 - 1

				if var1_58 > 0 then
					table.insert(var0_58, function(arg0_59)
						LeanTween.delayedCall(iter1_57.gameObject, 0.1 * var1_58, System.Action(arg0_59))
					end)
				end

				table.insert(var0_58, function(arg0_60)
					local var0_60 = var1_57:Find("Book"):GetComponent("AutoFlip")

					var0_60:StartControl()
					var1_57:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						var0_60:StopControl()
						arg0_60()
					end)
					quickPlayAnimation(var1_57, "anim_IslandDrawAwardPage_uncover")
				end)
				seriesAsync(var0_58, arg0_58)
			end)
		end

		quickPlayAnimation(arg0_37.rtDisplayPanel:Find("page"), "anim_IslandDrawAwardPage_page_in")
		parallelAsync(var0_57, arg0_57)
	end)
	seriesAsync(var3_37, function()
		if arg0_37._state == var0_0.STATES.DESTROY then
			return
		end

		quickPlayAnimation(arg0_37.rtDisplayPanel:Find("page"), "anim_IslandDrawAwardPage_page_out")

		arg0_37.inAnim = false
	end)
end

function var0_0.HideDrawAwardWindow(arg0_63)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_63.rtDisplayPanel, arg0_63._tf)
	setActive(arg0_63.rtDisplayPanel, false)
	eachChild(arg0_63.rtDisplayPanel:Find("window"), function(arg0_64, arg1_64)
		eachChild(arg0_64:Find("container"), function(arg0_65, arg1_65)
			LeanTween.cancel(arg0_65.gameObject)

			local var0_65 = arg0_65:Find("card")

			setActive(var0_65:Find("IslandDrawAwardPage_bomb01"), false)
			setActive(var0_65:Find("SCardLoopVX"), false)
			setActive(var0_65:Find("IslandDrawAwardPage_bomb02"), false)
			setActive(var0_65:Find("ACardLoopVX"), false)
		end)
	end)
end

function var0_0.Hide(arg0_66)
	if isActive(arg0_66.rtDisplayPanel) then
		arg0_66:HideDrawAwardWindow()
	end

	var0_0.super.Hide(arg0_66)
end

function var0_0.OnDestroy(arg0_67)
	arg0_67:Hide()

	for iter0_67, iter1_67 in pairs(arg0_67.bannerRectDic) do
		iter1_67:Dispose()
	end

	arg0_67.bannerRectDic = nil
end

function var0_0.ShowDropInfo(arg0_68, arg1_68)
	switch(arg0_68.type, {
		[DROP_TYPE_ISLAND_INVITATION] = function()
			GetImageSpriteFromAtlasAsync("island/IslandCharIcon/" .. arg0_68:getConfig("chara_pic"), "", arg1_68, true)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			GetImageSpriteFromAtlasAsync("Island/IslandFurnitureIcon/" .. arg0_68:getConfig("icon"), "", arg1_68, true)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function()
			GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. arg0_68:getConfig("icon"), "", arg1_68, true)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function()
			GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. arg0_68:getConfig("icon"), "", arg1_68, true)
		end,
		[DROP_TYPE_ISLAND_ACTION] = function()
			GetImageSpriteFromAtlasAsync("Island/IslandActionIcon/" .. arg0_68:getConfig("resource"), "", arg1_68, true)
		end
	})
end

return var0_0
