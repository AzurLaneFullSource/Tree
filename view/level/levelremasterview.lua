local var0_0 = class("LevelRemasterView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelRemasterView"
end

function var0_0.OnInit(arg0_2)
	arg0_2.content = arg0_2:findTF("list/content")
	arg0_2.item = arg0_2.content:Find("item")
	arg0_2.numsTxt = arg0_2:findTF("nums/text")
	arg0_2.helpBtn = arg0_2:findTF("help")

	setActive(arg0_2.item, false)

	arg0_2.getRemasterTF = arg0_2:findTF("getBtn/state_before")
	arg0_2.gotRemasterTF = arg0_2:findTF("getBtn/state_after")
	arg0_2.exToggle = arg0_2:findTF("toggles/EX")
	arg0_2.spToggle = arg0_2:findTF("toggles/SP")

	arg0_2:bind(LevelUIConst.FLUSH_REMASTER_INFO, function(arg0_3)
		if not arg0_2:isShowing() then
			return
		end

		arg0_2:flushOnly()
	end)
	arg0_2:bind(LevelUIConst.FLUSH_REMASTER_TICKET, function(arg0_4)
		if not arg0_2:isShowing() then
			return
		end

		arg0_2:updateTicketDisplay()
	end)

	local var0_2 = getProxy(ChapterProxy)
	local var1_2 = pg.TimeMgr.GetInstance()

	arg0_2.itemList = UIItemList.New(arg0_2.content, arg0_2.item)

	arg0_2.itemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_2.temp[arg1_5]

			setActive(arg2_5:Find("right"), arg1_5 % 2 > 0)

			local var1_5 = arg2_5:Find("bg/icon")
			local var2_5 = arg2_5:Find("bg/lock")
			local var3_5 = arg2_5:Find("bg/wait")
			local var4_5 = arg2_5:Find("bg/tip")

			setActive(var1_5, false)
			setActive(var2_5, false)
			setActive(var3_5, false)
			setActive(var4_5, false)

			if not var0_5 then
				setActive(var3_5, true)
				onButton(arg0_2, var3_5, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			elseif not var1_2:inTime(var0_5.time) then
				setActive(var2_5, true)
				onButton(arg0_2, var2_5, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			else
				setActive(var1_5, true)
				GetImageSpriteFromAtlasAsync("activitybanner/" .. var0_5.bg, "", var1_5)

				local var5_5 = var1_5:Find("info")

				setText(var5_5:Find("dec1/index"), arg1_5 < 10 and "0" .. arg1_5 or arg1_5)

				local var6_5 = 0

				for iter0_5, iter1_5 in ipairs(var0_5.config_data) do
					if var0_2:getChapterById(iter1_5):isClear() then
						var6_5 = math.max(var6_5, var0_5.chapter_progress[iter0_5])
					end
				end

				setText(var5_5:Find("progress/Text"), var6_5 .. "%")
				onButton(arg0_2, var1_5, function()
					local var0_8 = (function()
						local var0_9 = pg.chapter_template[var0_5.config_data[1]].map

						for iter0_9, iter1_9 in ipairs({
							PlayerPrefs.GetInt("remaster_lastmap_" .. var0_5.id, var0_9),
							var0_9
						}) do
							if var0_2:getMapById(iter1_9):isUnlock() then
								return iter1_9
							end
						end
					end)()

					if var0_8 then
						arg0_2.onSelectMap(var0_8)
						arg0_2:Hide()
					end
				end, SFX_PANEL)

				local var7_5

				for iter2_5, iter3_5 in ipairs(var0_5.drop_gain) do
					if #iter3_5 > 0 and var0_2.remasterInfo[iter3_5[1]][iter2_5].receive == false then
						var7_5 = {
							iter2_5,
							iter3_5
						}

						break
					end
				end

				local var8_5 = underscore.rest(var0_5.drop_display, 1)

				if var7_5 then
					table.insert(var8_5, 1, var7_5)
				elseif #var0_5.drop_display_sp > 0 then
					var8_5 = table.mergeArray(var0_5.drop_display_sp, var8_5)
				end

				local var9_5 = var5_5:Find("content")

				eachChild(var9_5, function(arg0_10)
					setActive(arg0_10, false)
				end)

				for iter4_5, iter5_5 in ipairs(var8_5) do
					local var10_5 = iter4_5 > var9_5.childCount and cloneTplTo(var9_5:GetChild(0), var9_5) or var9_5:GetChild(iter4_5 - 1)

					setActive(var10_5, true)

					if var7_5 and iter4_5 == 1 then
						local var11_5 = var7_5[1]
						local var12_5, var13_5, var14_5, var15_5 = unpack(var7_5[2])
						local var16_5 = var0_2.remasterInfo[var12_5][var11_5]

						setActive(var4_5, var15_5 <= var16_5.count)
						setActive(var10_5:Find("mark"), var15_5 > var16_5.count)
						setActive(var10_5:Find("Slider"), var15_5 > var16_5.count)
						setActive(var10_5:Find("achieve"), var15_5 <= var16_5.count)
						setSlider(var10_5:Find("Slider"), 0, var15_5, var16_5.count)

						local var17_5 = {
							type = var13_5,
							id = var14_5
						}

						updateDrop(var10_5:Find("IconTpl"), var17_5)
						onButton(arg0_2, var10_5:Find("IconTpl"), function()
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								hideYes = true,
								hideNo = true,
								type = MSGBOX_TYPE_SINGLE_ITEM,
								drop = var17_5,
								weight = LayerWeightConst.TOP_LAYER,
								remaster = {
									word = i18n("level_remaster_tip4", pg.chapter_template[var12_5].chapter_name),
									number = var16_5.count .. "/" .. var15_5,
									btn_text = i18n(var16_5.count < var15_5 and "level_remaster_tip2" or "level_remaster_tip3"),
									btn_call = function()
										if var16_5.count < var15_5 then
											local var0_12 = pg.chapter_template[var12_5].map
											local var1_12, var2_12 = var0_2:getMapById(var0_12):isUnlock()

											if not var1_12 then
												pg.TipsMgr.GetInstance():ShowTips(var2_12)
											else
												arg0_2.onSelectMap(var0_12)
												arg0_2:Hide()
											end
										else
											arg0_2:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var12_5, var11_5)
										end
									end
								}
							})
						end, SFX_PANEL)
					else
						local var18_5 = {
							type = iter5_5[1][1],
							id = iter5_5[1][2]
						}

						updateDrop(var10_5:Find("IconTpl"), var18_5)
						onButton(arg0_2, var10_5:Find("IconTpl"), function()
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								hideYes = true,
								hideNo = true,
								type = MSGBOX_TYPE_SINGLE_ITEM,
								drop = var18_5,
								weight = LayerWeightConst.TOP_LAYER,
								remaster = {
									word = i18n("level_remaster_tip1") .. iter5_5[2],
									btn_text = i18n("text_confirm")
								}
							})
						end, SFX_PANEL)
						setActive(var10_5:Find("mark"), false)
						setActive(var10_5:Find("Slider"), false)
						setActive(var10_5:Find("achieve"), false)
					end
				end
			end
		end
	end)
	onButton(arg0_2, arg0_2.getRemasterTF, function()
		if var0_2.remasterTickets + pg.gameset.reactivity_ticket_daily.key_value > pg.gameset.reactivity_ticket_max.key_value then
			local var0_14 = {
				content = i18n("tack_tickets_max_warning", math.max(pg.gameset.reactivity_ticket_max.key_value - var0_2.remasterTickets, 0)),
				onYes = function()
					arg0_2:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
				end
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_14)

			return
		end

		arg0_2:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_16)
	arg0_16.onItem = nil

	if arg0_16:isShowing() then
		arg0_16:Hide()
	end
end

function var0_0.Show(arg0_17)
	var0_0.super.Show(arg0_17)
	pg.UIMgr.GetInstance():BlurPanel(arg0_17._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Hide(arg0_18)
	var0_0.super.Hide(arg0_18)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_18._tf, arg0_18._parentTf)
end

function var0_0.set(arg0_19, arg1_19, arg2_19)
	arg0_19.templates = {}

	for iter0_19, iter1_19 in ipairs(pg.re_map_template.all) do
		local var0_19 = pg.re_map_template[iter1_19]

		table.insert(arg0_19.templates, var0_19)
	end

	arg0_19.onSelectMap = arg1_19

	arg0_19:flush(arg2_19)
end

function var0_0.flush(arg0_20, arg1_20)
	onButton(arg0_20, arg0_20._tf:Find("bg"), function()
		arg0_20:Hide()
	end, SFX_CANCEL)
	onButton(arg0_20, arg0_20.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_remaster_help_tip")
		})
	end, SFX_PANEL)
	arg0_20:updateTicketDisplay()

	local var0_20 = {
		arg0_20.exToggle,
		arg0_20.spToggle
	}
	local var1_20 = getProxy(ChapterProxy)

	for iter0_20, iter1_20 in ipairs(var0_20) do
		onToggle(arg0_20, iter1_20, function(arg0_23)
			if arg0_23 then
				arg0_20.temp = underscore.filter(arg0_20.templates, function(arg0_24)
					return arg0_24.activity_type == iter0_20
				end)

				table.sort(arg0_20.temp, CompareFuncs({
					function(arg0_25)
						for iter0_25, iter1_25 in ipairs(arg0_25.drop_gain) do
							if #iter1_25 > 0 then
								local var0_25, var1_25, var2_25, var3_25 = unpack(iter1_25)
								local var4_25 = var1_20.remasterInfo[var0_25][iter0_25]

								if not var4_25.receive and var3_25 <= var4_25.count then
									return 0
								end
							end
						end

						return 1
					end,
					function(arg0_26)
						return arg0_26.order
					end
				}))
				arg0_20.itemList:align(math.max(math.ceil(#arg0_20.temp / 2) * 2, 4))
			end
		end, SFX_PANEL)
	end

	triggerToggle(var0_20[arg1_20 and 2 or 1], true)
end

function var0_0.flushOnly(arg0_27)
	arg0_27.itemList:align(math.max(math.ceil(#arg0_27.temp / 2) * 2, 4))
end

function var0_0.updateTicketDisplay(arg0_28)
	local var0_28 = getProxy(ChapterProxy)
	local var1_28 = var0_28.remasterDailyCount > 0

	SetActive(arg0_28.getRemasterTF, not var1_28)
	SetActive(arg0_28.gotRemasterTF, var1_28)
	setText(arg0_28.numsTxt, var0_28.remasterTickets .. "/" .. pg.gameset.reactivity_ticket_max.key_value)
end

return var0_0
