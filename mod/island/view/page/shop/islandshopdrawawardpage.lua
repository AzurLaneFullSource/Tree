local var0_0 = class("IslandShopDrawAwardPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandDrawAwardPage"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2.event, arg2_2.contextData)

	arg0_2.viewComponent = arg2_2
end

function var0_0.OnLoaded(arg0_3)
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

		eachChild(arg0_38:Find("container"), function(arg0_39, arg1_39)
			local var0_39 = arg0_39:Find("card")

			setActive(var0_39:Find("front/S/IslandDrawAwardPage_bomb01"), false)
			setActive(var0_39:Find("bg/S/SCardLoopVX"), false)
			setActive(var0_39:Find("front/A/IslandDrawAwardPage_bomb02"), false)
			setActive(var0_39:Find("bg/A/ACardLoopVX"), false)
		end)
	end)

	local var2_37 = {}

	UIItemList.StaticAlign(var1_37:Find("container"), var1_37:Find("container/tpl"), #arg1_37, function(arg0_40, arg1_40, arg2_40)
		if var0_37 == "ten" then
			arg1_40 = arg1_40 % 2 * 5 + 5 - math.floor(arg1_40 / 2)
		else
			arg1_40 = arg1_40 + 1
		end

		if arg0_40 == UIItemList.EventUpdate then
			local var0_40 = arg2_40:Find("card")
			local var1_40 = arg1_37[arg1_40]
			local var2_40 = pg.island_draw_reward[var1_40]
			local var3_40 = Drop.New({
				type = var2_40.drop_type,
				id = var2_40.drop_id
			})

			var0_0.ShowDropInfo(var3_40, var0_40:Find("mask/Image"))

			local var4_40 = switch(var2_40.rarity, {
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
			local var5_40 = var0_40:Find("mask/Image")

			if var4_40 == "S" then
				setLocalScale(var0_40:Find("mask/Image"), Vector3(1.2, 1.2, 1))
				setLocalPosition(var0_40:Find("mask/Image"), {
					x = -17.5,
					y = -20
				})
			else
				setLocalScale(var0_40:Find("mask/Image"), Vector3(1.7, 1.7, 1))
				setLocalPosition(var0_40:Find("mask/Image"), Vector3.zero)
			end

			eachChild(var0_40:Find("bg"), function(arg0_45, arg1_45)
				setActive(arg0_45, arg0_45.name == var4_40)
			end)
			eachChild(var0_40:Find("word"), function(arg0_46, arg1_46)
				setActive(arg0_46, arg0_46.name == var4_40)
			end)
			eachChild(var0_40:Find("front"), function(arg0_47, arg1_47)
				setActive(arg0_47, arg0_47.name == var4_40)
			end)
			var0_40:Find("Book"):GetComponent(typeof(Book)):SetCurrentPage(2)
			setCanvasGroupAlpha(var0_40, 0)
			setCanvasGroupAlpha(var0_40:Find("Book"), 1)

			var2_37[arg1_40] = arg2_40
		end
	end)
	setCanvasGroupAlpha(arg0_37.rtDisplayPanel:Find("page"), 0)

	local var3_37 = {}

	table.insert(var3_37, function(arg0_48)
		arg0_37.inAnim = true

		pg.UIMgr.GetInstance():BlurPanel(arg0_37.rtDisplayPanel, {
			staticBlur = true
		})
		setActive(arg0_37.rtDisplayPanel, true)
		arg0_37.rtDisplayPanel:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(arg0_48)
	end)
	table.insert(var3_37, function(arg0_49)
		local var0_49 = {}

		for iter0_49, iter1_49 in ipairs(var2_37) do
			local var1_49 = iter1_49:Find("card")

			table.insert(var0_49, function(arg0_50)
				local var0_50 = {}
				local var1_50 = (iter0_49 - 1) % 5 * 2 + (iter0_49 > 5 and 1 or 0)

				if var0_37 == "ten" and var1_50 > 0 then
					table.insert(var0_50, function(arg0_51)
						LeanTween.delayedCall(iter1_49.gameObject, 0.03 * var1_50, System.Action(arg0_51))
					end)
				end

				table.insert(var0_50, function(arg0_52)
					var1_49:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_53)
						arg0_52()
					end)
					switch(var0_37, {
						one = function()
							quickPlayAnimation(var1_49, "anim_IslandDrawAwardPage_onetpl_In")
						end,
						ten = function()
							quickPlayAnimation(var1_49, var1_50 % 2 == 0 and "anim_IslandDrawAwardPage_ten" or "anim_IslandDrawAwardPage_ten02")
						end
					})
				end)
				seriesAsync(var0_50, arg0_50)
			end)
		end

		parallelAsync(var0_49, function()
			LeanTween.delayedCall(0.6, System.Action(function()
				arg0_49()
			end))
		end)
	end)
	table.insert(var3_37, function(arg0_58)
		local var0_58 = {}

		for iter0_58, iter1_58 in ipairs(var2_37) do
			local var1_58 = iter1_58:Find("card")

			table.insert(var0_58, function(arg0_59)
				local var0_59 = {}
				local var1_59 = iter0_58 - 1

				if var1_59 > 0 then
					table.insert(var0_59, function(arg0_60)
						LeanTween.delayedCall(iter1_58.gameObject, 0.1 * var1_59, System.Action(arg0_60))
					end)
				end

				table.insert(var0_59, function(arg0_61)
					local var0_61 = var1_58:Find("Book"):GetComponent(typeof(AutoFlip))

					var0_61:StartControl()
					var1_58:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						var0_61:StopControl()
						arg0_61()
					end)
					quickPlayAnimation(var1_58, "anim_IslandDrawAwardPage_uncover")
				end)
				seriesAsync(var0_59, arg0_59)
			end)
		end

		quickPlayAnimation(arg0_37.rtDisplayPanel:Find("page"), "anim_IslandDrawAwardPage_page_in")
		parallelAsync(var0_58, arg0_58)
	end)
	table.insert(var3_37, function(arg0_63)
		LeanTween.delayedCall(0.5, System.Action(function()
			arg0_63()
		end))
	end)
	seriesAsync(var3_37, function()
		if arg0_37._state == var0_0.STATES.DESTROY then
			return
		end

		quickPlayAnimation(arg0_37.rtDisplayPanel:Find("page"), "anim_IslandDrawAwardPage_page_out")

		arg0_37.inAnim = false
	end)
end

function var0_0.HideDrawAwardWindow(arg0_66)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_66.rtDisplayPanel, arg0_66._tf)
	setActive(arg0_66.rtDisplayPanel, false)
	eachChild(arg0_66.rtDisplayPanel:Find("window"), function(arg0_67, arg1_67)
		eachChild(arg0_67:Find("container"), function(arg0_68, arg1_68)
			LeanTween.cancel(arg0_68.gameObject)
		end)
	end)
end

function var0_0.Hide(arg0_69)
	if isActive(arg0_69.rtDisplayPanel) then
		arg0_69:HideDrawAwardWindow()
	end

	var0_0.super.Hide(arg0_69)
end

function var0_0.OnDestroy(arg0_70)
	arg0_70:Hide()

	for iter0_70, iter1_70 in pairs(arg0_70.bannerRectDic) do
		iter1_70:Dispose()
	end

	arg0_70.bannerRectDic = nil
end

function var0_0.ShowDropInfo(arg0_71, arg1_71)
	switch(arg0_71.type, {
		[DROP_TYPE_ISLAND_INVITATION] = function()
			GetImageSpriteFromAtlasAsync("island/IslandCharIcon/" .. arg0_71:getConfig("chara_pic"), "", arg1_71, true)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			GetImageSpriteFromAtlasAsync("Island/IslandFurnitureIcon/" .. arg0_71:getConfig("icon"), "", arg1_71, true)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function()
			GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. arg0_71:getConfig("icon"), "", arg1_71, true)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function()
			GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. arg0_71:getConfig("icon"), "", arg1_71, true)
		end,
		[DROP_TYPE_ISLAND_ACTION] = function()
			GetImageSpriteFromAtlasAsync("Island/IslandActionIcon/" .. arg0_71:getConfig("resource"), "", arg1_71, true)
		end
	})
end

return var0_0
