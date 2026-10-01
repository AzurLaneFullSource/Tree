local var0_0 = class("LevelRemasterView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelRemasterView"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}

	local function var1_2(arg0_3, arg1_3)
		local var0_3 = Drop.New({
			type = arg0_3,
			id = arg1_3
		}):getIcon()

		if noEmptyStr(var0_3) then
			table.insert(var0_2, var0_3)
		end
	end

	local function var2_2(arg0_4, arg1_4)
		if arg0_4 ~= DROP_TYPE_SHIP then
			return
		end

		local var0_4 = Ship.getPaintingName(arg1_4)

		table.insertto(var0_2, ResPathSupport.GetPaintingSquareIconListByPaintingName(var0_4))
	end

	local function var3_2(arg0_5)
		if arg0_5 == nil then
			return
		end

		table.insert(var0_2, ResPathSupport.ConstPath.LevelMap .. "/" .. arg0_5)
	end

	local function var4_2(arg0_6)
		if arg0_6 == nil then
			return
		end

		table.insert(var0_2, "ui/" .. arg0_6)
	end

	_.each(pg.re_map_template.all, function(arg0_7)
		local var0_7 = pg.re_map_template[arg0_7]

		if var0_7 and noEmptyStr(var0_7.bg) then
			local var1_7 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.ActivityBanner, var0_7.bg)

			table.insert(var0_2, var1_7)
		end

		_.each(var0_7.drop_gain or {}, function(arg0_8)
			if #arg0_8 > 0 then
				var1_2(arg0_8[2], arg0_8[3])
				var2_2(arg0_8[2], arg0_8[3])
			end
		end)
		_.each(var0_7.drop_display or {}, function(arg0_9)
			if arg0_9[1] then
				var1_2(arg0_9[1][1], arg0_9[1][2])
				var2_2(arg0_9[1][1], arg0_9[1][2])
			end
		end)
		_.each(var0_7.drop_display_sp or {}, function(arg0_10)
			if arg0_10[1] then
				var1_2(arg0_10[1][1], arg0_10[1][2])
				var2_2(arg0_10[1][1], arg0_10[1][2])
			end
		end)
		_.each(var0_7.config_data, function(arg0_11)
			local var0_11 = pg.chapter_template[arg0_11]

			if var0_11 then
				local var1_11 = pg.expedition_data_by_map[var0_11.map]

				if var1_11 then
					var3_2(var1_11.bg)
					var4_2(var1_11.ani_name)
				end
			end
		end)
	end)

	return ResPathSupport.UniqueLuaArr(table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2)))
end

function var0_0.OnInit(arg0_12)
	arg0_12.content = arg0_12._tf:Find("list/content")
	arg0_12.item = arg0_12.content:Find("item")
	arg0_12.numsTxt = arg0_12._tf:Find("nums/text")
	arg0_12.helpBtn = arg0_12._tf:Find("help")

	setActive(arg0_12.item, false)

	arg0_12.getRemasterTF = arg0_12._tf:Find("getBtn/state_before")
	arg0_12.gotRemasterTF = arg0_12._tf:Find("getBtn/state_after")
	arg0_12.exToggle = arg0_12._tf:Find("toggles/EX")
	arg0_12.spToggle = arg0_12._tf:Find("toggles/SP")

	arg0_12:bind(LevelUIConst.FLUSH_REMASTER_INFO, function(arg0_13)
		if not arg0_12:isShowing() then
			return
		end

		arg0_12:flushOnly()
	end)
	arg0_12:bind(LevelUIConst.FLUSH_REMASTER_TICKET, function(arg0_14)
		if not arg0_12:isShowing() then
			return
		end

		arg0_12:updateTicketDisplay()
	end)

	local var0_12 = getProxy(ChapterProxy)
	local var1_12 = pg.TimeMgr.GetInstance()

	arg0_12.itemList = UIItemList.New(arg0_12.content, arg0_12.item)

	arg0_12.itemList:make(function(arg0_15, arg1_15, arg2_15)
		arg1_15 = arg1_15 + 1

		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_12.temp[arg1_15]

			setActive(arg2_15:Find("right"), arg1_15 % 2 > 0)

			local var1_15 = arg2_15:Find("bg/icon")
			local var2_15 = arg2_15:Find("bg/lock")
			local var3_15 = arg2_15:Find("bg/wait")
			local var4_15 = arg2_15:Find("bg/tip")

			setActive(var1_15, false)
			setActive(var2_15, false)
			setActive(var3_15, false)
			setActive(var4_15, false)

			if not var0_15 then
				setActive(var3_15, true)
				onButton(arg0_12, var3_15, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			elseif not var1_12:inTime(var0_15.time) then
				setActive(var2_15, true)
				onButton(arg0_12, var2_15, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			else
				setActive(var1_15, true)
				GetImageSpriteFromAtlasAsync("activitybanner/" .. var0_15.bg, "", var1_15)

				local var5_15 = var1_15:Find("info")

				setText(var5_15:Find("dec1/index"), arg1_15 < 10 and "0" .. arg1_15 or arg1_15)

				local var6_15 = BossRushChapterRemasterHelper.GetProgress(var0_15.id)

				setText(var5_15:Find("progress/Text"), var6_15 .. "%")
				onButton(arg0_12, var1_15, function()
					if BossRushChapterRemasterHelper.IsRemasterByActivity(var0_15.id) then
						arg0_12:HandleActTypeRemaster(var0_15)

						return
					end

					local var0_18 = (function()
						local var0_19 = pg.chapter_template[var0_15.config_data[1]].map

						for iter0_19, iter1_19 in ipairs({
							PlayerPrefs.GetInt("remaster_lastmap_" .. var0_15.id, var0_19),
							var0_19
						}) do
							if var0_12:getMapById(iter1_19):isUnlock() then
								return iter1_19
							end
						end
					end)()

					if var0_18 then
						arg0_12.onSelectMap(var0_18)
						arg0_12:Hide()
					end
				end, SFX_PANEL)

				local var7_15 = BossRushChapterRemasterHelper.ChapterAwardInfo(var0_15.id)
				local var8_15 = underscore.to_array(var0_15.drop_display)

				if var7_15 then
					table.insert(var8_15, 1, var7_15)
				elseif #var0_15.drop_display_sp > 0 then
					var8_15 = table.mergeArray(var0_15.drop_display_sp, var8_15)
				end

				local var9_15 = var5_15:Find("content")

				eachChild(var9_15, function(arg0_20)
					setActive(arg0_20, false)
				end)

				for iter0_15, iter1_15 in ipairs(var8_15) do
					local var10_15 = iter0_15 > var9_15.childCount and cloneTplTo(var9_15:GetChild(0), var9_15) or var9_15:GetChild(iter0_15 - 1)

					setActive(var10_15, true)

					if var7_15 and iter0_15 == 1 then
						local var11_15 = var7_15[1]
						local var12_15, var13_15, var14_15, var15_15, var16_15 = unpack(var7_15[2])
						local var17_15 = var7_15[3]
						local var18_15 = var0_12:getRemasterInfo(var17_15, var12_15, var11_15)

						setActive(var4_15, var15_15 <= var18_15.count)
						setActive(var10_15:Find("mark"), var15_15 > var18_15.count)
						setActive(var10_15:Find("Slider"), var15_15 > var18_15.count)
						setActive(var10_15:Find("achieve"), var15_15 <= var18_15.count)
						setSlider(var10_15:Find("Slider"), 0, var15_15, var18_15.count)

						local var19_15 = {
							type = var13_15,
							id = var14_15
						}

						updateDrop(var10_15:Find("IconTpl"), var19_15)
						onButton(arg0_12, var10_15:Find("IconTpl"), function()
							local var0_21 = BossRushChapterRemasterHelper.GetAwardName(var17_15, var12_15)

							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								hideYes = true,
								hideNo = true,
								type = MSGBOX_TYPE_SINGLE_ITEM,
								drop = var19_15,
								remaster = {
									word = i18n("level_remaster_tip4", var0_21),
									number = var18_15.count .. "/" .. var15_15,
									btn_text = i18n(var18_15.count < var15_15 and "level_remaster_tip2" or "level_remaster_tip3"),
									btn_call = function()
										if var18_15.count < var15_15 then
											if var17_15 and var17_15 > 0 then
												arg0_12:emit(LevelMediator2.ON_BOSSRUSH_REMASTER_ACTIVITY, var17_15)
												arg0_12:Hide()

												return
											end

											local var0_22 = pg.chapter_template[var12_15].map
											local var1_22, var2_22 = var0_12:getMapById(var0_22):isUnlock()

											if not var1_22 then
												pg.TipsMgr.GetInstance():ShowTips(var2_22)
											else
												arg0_12.onSelectMap(var0_22)
												arg0_12:Hide()
											end
										else
											arg0_12:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var12_15, var11_15, var17_15)
										end
									end
								}
							})
						end, SFX_PANEL)
					else
						local var20_15 = {
							type = iter1_15[1][1],
							id = iter1_15[1][2]
						}

						updateDrop(var10_15:Find("IconTpl"), var20_15)
						onButton(arg0_12, var10_15:Find("IconTpl"), function()
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								hideYes = true,
								hideNo = true,
								type = MSGBOX_TYPE_SINGLE_ITEM,
								drop = var20_15,
								remaster = {
									word = i18n("level_remaster_tip1") .. iter1_15[2],
									btn_text = i18n("text_confirm")
								}
							})
						end, SFX_PANEL)
						setActive(var10_15:Find("mark"), false)
						setActive(var10_15:Find("Slider"), false)
						setActive(var10_15:Find("achieve"), false)
					end
				end
			end
		end
	end)
	onButton(arg0_12, arg0_12.getRemasterTF, function()
		if var0_12.remasterTickets + pg.gameset.reactivity_ticket_daily.key_value > pg.gameset.reactivity_ticket_max.key_value then
			local var0_24 = {
				content = i18n("tack_tickets_max_warning", math.max(pg.gameset.reactivity_ticket_max.key_value - var0_12.remasterTickets, 0)),
				onYes = function()
					arg0_12:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
				end
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_24)

			return
		end

		arg0_12:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
	end, SFX_PANEL)
end

function var0_0.HandleActTypeRemaster(arg0_26, arg1_26)
	local var0_26 = arg1_26.activity_id
	local var1_26 = getProxy(ActivityPermanentProxy)
	local var2_26 = var1_26:GetActivityTypeById(var0_26)
	local var3_26 = var2_26 and var1_26:getDoingActivityId(var2_26)

	local function var4_26()
		arg0_26:emit(LevelMediator2.ON_BOSSRUSH_REMASTER_ACTIVITY, var0_26)
	end

	if var3_26 and var3_26 ~= var0_26 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("bossrush_act_remaster_close_prev_one_tip"),
			onYes = var4_26
		})

		return
	end

	var4_26()
end

function var0_0.OnDestroy(arg0_28)
	arg0_28.onItem = nil

	if arg0_28:isShowing() then
		arg0_28:Hide()
	end
end

function var0_0.Show(arg0_29)
	var0_0.super.Show(arg0_29)
	pg.UIMgr.GetInstance():BlurPanel(arg0_29._tf)
end

function var0_0.Hide(arg0_30)
	var0_0.super.Hide(arg0_30)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30._tf, arg0_30._parentTf)
end

function var0_0.set(arg0_31, arg1_31, arg2_31)
	arg0_31.templates = {}

	for iter0_31, iter1_31 in ipairs(pg.re_map_template.all) do
		local var0_31 = pg.re_map_template[iter1_31]

		table.insert(arg0_31.templates, var0_31)
	end

	arg0_31.onSelectMap = arg1_31

	arg0_31:flush(arg2_31)
end

function var0_0.flush(arg0_32, arg1_32)
	onButton(arg0_32, arg0_32._tf:Find("bg"), function()
		arg0_32:Hide()
	end, SFX_CANCEL)
	onButton(arg0_32, arg0_32.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_remaster_help_tip")
		})
	end, SFX_PANEL)
	arg0_32:updateTicketDisplay()

	local var0_32 = {
		arg0_32.exToggle,
		arg0_32.spToggle
	}
	local var1_32 = getProxy(ChapterProxy)

	for iter0_32, iter1_32 in ipairs(var0_32) do
		onToggle(arg0_32, iter1_32, function(arg0_35)
			if arg0_35 then
				arg0_32.temp = underscore.filter(arg0_32.templates, function(arg0_36)
					return BossRushChapterRemasterHelper.GetExOrSp4Filter(arg0_36.activity_type) == iter0_32
				end)

				local var0_35 = {}

				for iter0_35, iter1_35 in ipairs(arg0_32.temp) do
					var0_35[iter1_35.id] = BossRushChapterRemasterHelper.ExistCanGetAward(iter1_35.id) and 0 or 1
				end

				table.sort(arg0_32.temp, CompareFuncs({
					function(arg0_37)
						return var0_35[arg0_37.id] or 1
					end,
					function(arg0_38)
						return arg0_38.order
					end
				}))
				arg0_32.itemList:align(math.max(math.ceil(#arg0_32.temp / 2) * 2, 4))
			end
		end, SFX_PANEL)
	end

	triggerToggle(var0_32[arg1_32 and 2 or 1], true)
end

function var0_0.MatchType(arg0_39, arg1_39, arg2_39)
	return arg1_39 == arg2_39
end

function var0_0.flushOnly(arg0_40)
	arg0_40.itemList:align(math.max(math.ceil(#arg0_40.temp / 2) * 2, 4))
end

function var0_0.updateTicketDisplay(arg0_41)
	local var0_41 = getProxy(ChapterProxy)
	local var1_41 = var0_41.remasterDailyCount > 0

	SetActive(arg0_41.getRemasterTF, not var1_41)
	SetActive(arg0_41.gotRemasterTF, var1_41)
	setText(arg0_41.numsTxt, var0_41.remasterTickets .. "/" .. pg.gameset.reactivity_ticket_max.key_value)
end

return var0_0
