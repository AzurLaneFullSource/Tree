local var0_0 = class("ChapterAutoPanelTypeWorldSingle", import(".ChapterAutoPanelTypeWorld"))

function var0_0.getUIName(arg0_1)
	return "ChapterAutoPanelTypeWorldSingle"
end

function var0_0.OnInit(arg0_2)
	arg0_2.ticketUIList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.ticketList[arg1_3 + 1]

			setText(arg2_3:Find("Text"), var0_3:GetCount())

			local var1_3 = var0_3:IsForever()

			setActive(arg2_3:Find("time"), not var1_3)

			if not var1_3 then
				local var2_3 = var0_3:GetRemainTime()
				local var3_3 = var2_3 > 86400
				local var4_3 = var3_3 and "auto_battle_book_day" or "auto_battle_book_hour"
				local var5_3 = math.floor(var2_3 / (var3_3 and 86400 or 3600))

				setText(arg2_3:Find("time/Text"), i18n(var4_3, var5_3))
			end
		end
	end)
	arg0_2.awardUIList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_2.awards[arg1_4]

			updateDrop(arg2_4, var0_4)
			onButton(arg0_2, arg2_4, function()
				arg0_2:emit(BaseUI.ON_DROP, var0_4)
			end, SFX_PANEL)
		end
	end)
	onButton(arg0_2, arg0_2.uiStartBtn, function()
		if arg0_2.countMaps < 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_times_zero"))

			return
		end

		if arg0_2.needTicket and arg0_2.bookCount > arg0_2.ownTicketCnt then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_resource"))

			return
		end

		if arg0_2.staminaCount > arg0_2.staminaMgr:GetTotalStamina() then
			arg0_2.staminaMgr:Show()

			return
		end

		arg0_2:OnStart()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:Hide()
	end, SFX_CANCEL)
end

function var0_0.SetSlider(arg0_9)
	arg0_9.countMaps = 1
	arg0_9.staminaCount, arg0_9.bookCount, arg0_9.timeCount, arg0_9.expCount = 0, 0, 0, 0
	arg0_9.awards = {}

	for iter0_9 = 1, arg0_9.countMaps do
		local var0_9 = arg0_9.filterMaps[iter0_9]
		local var1_9 = pg.world_auto_statistics[var0_9.id]

		arg0_9.staminaCount = arg0_9.staminaCount + var1_9.oil_limit
		arg0_9.bookCount = arg0_9.bookCount + 1
		arg0_9.timeCount = arg0_9.timeCount + var1_9.time_correction
		arg0_9.expCount = arg0_9.expCount + var1_9.drop_expbook

		table.insertto(arg0_9.awards, var1_9.award_display)
	end

	local var2_9 = arg0_9.world.staminaMgr:GetTotalStamina()

	setText(arg0_9.uiUtilCost:Find("value"), string.format("<icon name=stamina h=0.8 w=0.8 /><color=%s>%s×%d</color>", var2_9 < arg0_9.staminaCount and COLOR_RED or COLOR_GREEN, i18n("world_ap"), arg0_9.staminaCount))

	local var3_9 = ChapterAutoTicket.GetDrop(ChapterAutoTicket.TYPE.WORLD)

	var3_9.count = arg0_9.bookCount

	local var4_9 = arg0_9.needTicket and string.format("<icon name=ticket h=0.8 w=0.8 /><color=%s>%s×%d</color>", var3_9.count > arg0_9.ownTicketCnt and COLOR_RED or COLOR_GREEN, var3_9:getName(), var3_9.count) or ""

	setText(arg0_9.uiUtilCost:Find("value_1"), var4_9)
	setText(arg0_9.uiUtilTime:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(arg0_9.timeCount))
	setText(arg0_9.uiLeftProficiencyText, arg0_9.expCount)

	local var5_9 = {}
	local var6_9 = {}

	for iter1_9, iter2_9 in ipairs(arg0_9.awards) do
		local var7_9 = Drop.New({
			count = 0,
			type = iter2_9[1],
			id = iter2_9[2]
		})

		if var5_9[var7_9.type .. "_" .. var7_9.id] then
			-- block empty
		else
			var5_9[var7_9.type .. "_" .. var7_9.id] = var7_9

			table.insert(var6_9, var7_9)
		end
	end

	arg0_9.awards = var6_9

	arg0_9.awardUIList:align(#arg0_9.awards)
end

function var0_0.Enter(arg0_10, arg1_10)
	arg0_10.world = nowWorld()
	arg0_10.ticketCnt = 0

	arg0_10:RefreshTickets()

	arg0_10.needTicket = false

	setActive(arg0_10.uiUtilCost:Find("Image_1"), arg0_10.needTicket)

	arg0_10.filterMaps = {
		arg0_10.world:GetMap(arg1_10)
	}

	arg0_10:SetSlider()
end

function var0_0.RefreshView(arg0_11)
	arg0_11:Enter(arg0_11.filterMaps[1].id)
end

function var0_0.OnStart(arg0_12)
	pg.m02:sendNotification(GAME.START_WORLD_CHAPTER_AUTO, {
		type = ChapterAutoProxy.TYPE.WORLD,
		list = {
			arg0_12.filterMaps[1].id
		},
		needTicket = arg0_12.needTicket
	})
end

return var0_0
