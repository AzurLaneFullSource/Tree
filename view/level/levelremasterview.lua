local var0 = class("LevelRemasterView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "LevelRemasterView"
end

function var0.OnInit(arg0)
	arg0.content = arg0:findTF("list/content")
	arg0.item = arg0.content:Find("item")
	arg0.numsTxt = arg0:findTF("nums/text")
	arg0.helpBtn = arg0:findTF("help")

	setActive(arg0.item, false)

	arg0.getRemasterTF = arg0:findTF("getBtn/state_before")
	arg0.gotRemasterTF = arg0:findTF("getBtn/state_after")
	arg0.exToggle = arg0:findTF("toggles/EX")
	arg0.spToggle = arg0:findTF("toggles/SP")

	arg0:bind(LevelUIConst.FLUSH_REMASTER_INFO, function(arg0)
		if not arg0:isShowing() then
			return
		end

		arg0:flushOnly()
	end)
	arg0:bind(LevelUIConst.FLUSH_REMASTER_TICKET, function(arg0)
		if not arg0:isShowing() then
			return
		end

		arg0:updateTicketDisplay()
	end)

	local var0 = getProxy(ChapterProxy)
	local var1 = pg.TimeMgr.GetInstance()

	arg0.itemList = UIItemList.New(arg0.content, arg0.item)

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.temp[arg1]

			setActive(arg2:Find("right"), arg1 % 2 > 0)

			local var1 = arg2:Find("bg/icon")
			local var2 = arg2:Find("bg/lock")
			local var3 = arg2:Find("bg/wait")
			local var4 = arg2:Find("bg/tip")

			setActive(var1, false)
			setActive(var2, false)
			setActive(var3, false)
			setActive(var4, false)

			if not var0 then
				setActive(var3, true)
				onButton(arg0, var3, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			elseif not var1:inTime(var0.time) then
				setActive(var2, true)
				onButton(arg0, var2, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			else
				setActive(var1, true)
				GetImageSpriteFromAtlasAsync("activitybanner/" .. var0.bg, "", var1)

				local var5 = var1:Find("info")

				setText(var5:Find("dec1/index"), arg1 < 10 and "0" .. arg1 or arg1)

				local var6 = 0

				for iter0, iter1 in ipairs(var0.config_data) do
					if var0:getChapterById(iter1):isClear() then
						var6 = math.max(var6, var0.chapter_progress[iter0])
					end
				end

				setText(var5:Find("progress/Text"), var6 .. "%")
				onButton(arg0, var1, function()
					local var0 = (function()
						local var0 = pg.chapter_template[var0.config_data[1]].map

						for iter0, iter1 in ipairs({
							PlayerPrefs.GetInt("remaster_lastmap_" .. var0.id, var0),
							var0
						}) do
							if var0:getMapById(iter1):isUnlock() then
								return iter1
							end
						end
					end)()

					if var0 then
						arg0.onSelectMap(var0)
						arg0:Hide()
					end
				end, SFX_PANEL)

				local var7

				for iter2, iter3 in ipairs(var0.drop_gain) do
					if #iter3 > 0 and var0.remasterInfo[iter3[1]][iter2].receive == false then
						var7 = {
							iter2,
							iter3
						}

						break
					end
				end

				local var8 = underscore.rest(var0.drop_display, 1)

				if var7 then
					table.insert(var8, 1, var7)
				elseif #var0.drop_display_sp > 0 then
					var8 = table.mergeArray(var0.drop_display_sp, var8)
				end

				local var9 = var5:Find("content")

				eachChild(var9, function(arg0)
					setActive(arg0, false)
				end)

				for iter4, iter5 in ipairs(var8) do
					local var10 = iter4 > var9.childCount and cloneTplTo(var9:GetChild(0), var9) or var9:GetChild(iter4 - 1)

					setActive(var10, true)

					if var7 and iter4 == 1 then
						local var11 = var7[1]
						local var12, var13, var14, var15 = unpack(var7[2])
						local var16 = var0.remasterInfo[var12][var11]

						setActive(var4, var15 <= var16.count)
						setActive(var10:Find("mark"), var15 > var16.count)
						setActive(var10:Find("Slider"), var15 > var16.count)
						setActive(var10:Find("achieve"), var15 <= var16.count)
						setSlider(var10:Find("Slider"), 0, var15, var16.count)

						local var17 = {
							type = var13,
							id = var14
						}

						updateDrop(var10:Find("IconTpl"), var17)
						onButton(arg0, var10:Find("IconTpl"), function()
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								hideYes = true,
								hideNo = true,
								type = MSGBOX_TYPE_SINGLE_ITEM,
								drop = var17,
								weight = LayerWeightConst.TOP_LAYER,
								remaster = {
									word = i18n("level_remaster_tip4", pg.chapter_template[var12].chapter_name),
									number = var16.count .. "/" .. var15,
									btn_text = i18n(var16.count < var15 and "level_remaster_tip2" or "level_remaster_tip3"),
									btn_call = function()
										if var16.count < var15 then
											local var0 = pg.chapter_template[var12].map
											local var1, var2 = var0:getMapById(var0):isUnlock()

											if not var1 then
												pg.TipsMgr.GetInstance():ShowTips(var2)
											else
												arg0.onSelectMap(var0)
												arg0:Hide()
											end
										else
											arg0:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var12, var11)
										end
									end
								}
							})
						end, SFX_PANEL)
					else
						local var18 = {
							type = iter5[1][1],
							id = iter5[1][2]
						}

						updateDrop(var10:Find("IconTpl"), var18)
						onButton(arg0, var10:Find("IconTpl"), function()
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								hideYes = true,
								hideNo = true,
								type = MSGBOX_TYPE_SINGLE_ITEM,
								drop = var18,
								weight = LayerWeightConst.TOP_LAYER,
								remaster = {
									word = i18n("level_remaster_tip1") .. iter5[2],
									btn_text = i18n("text_confirm")
								}
							})
						end, SFX_PANEL)
						setActive(var10:Find("mark"), false)
						setActive(var10:Find("Slider"), false)
						setActive(var10:Find("achieve"), false)
					end
				end
			end
		end
	end)
	onButton(arg0, arg0.getRemasterTF, function()
		if var0.remasterTickets + pg.gameset.reactivity_ticket_daily.key_value > pg.gameset.reactivity_ticket_max.key_value then
			local var0 = {
				content = i18n("tack_tickets_max_warning", math.max(pg.gameset.reactivity_ticket_max.key_value - var0.remasterTickets, 0)),
				onYes = function()
					arg0:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
				end
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var0)

			return
		end

		arg0:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	arg0.onItem = nil

	if arg0:isShowing() then
		arg0:Hide()
	end
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.set(arg0, arg1, arg2)
	arg0.templates = {}

	for iter0, iter1 in ipairs(pg.re_map_template.all) do
		local var0 = pg.re_map_template[iter1]

		table.insert(arg0.templates, var0)
	end

	arg0.onSelectMap = arg1

	arg0:flush(arg2)
end

function var0.flush(arg0, arg1)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_remaster_help_tip")
		})
	end, SFX_PANEL)
	arg0:updateTicketDisplay()

	local var0 = {
		arg0.exToggle,
		arg0.spToggle
	}
	local var1 = getProxy(ChapterProxy)

	for iter0, iter1 in ipairs(var0) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0.temp = underscore.filter(arg0.templates, function(arg0)
					return arg0.activity_type == iter0
				end)

				table.sort(arg0.temp, CompareFuncs({
					function(arg0)
						for iter0, iter1 in ipairs(arg0.drop_gain) do
							if #iter1 > 0 then
								local var0, var1, var2, var3 = unpack(iter1)
								local var4 = var1.remasterInfo[var0][iter0]

								if not var4.receive and var3 <= var4.count then
									return 0
								end
							end
						end

						return 1
					end,
					function(arg0)
						return arg0.order
					end
				}))
				arg0.itemList:align(math.max(math.ceil(#arg0.temp / 2) * 2, 4))
			end
		end, SFX_PANEL)
	end

	triggerToggle(var0[arg1 and 2 or 1], true)
end

function var0.flushOnly(arg0)
	arg0.itemList:align(math.max(math.ceil(#arg0.temp / 2) * 2, 4))
end

function var0.updateTicketDisplay(arg0)
	local var0 = getProxy(ChapterProxy)
	local var1 = var0.remasterDailyCount > 0

	SetActive(arg0.getRemasterTF, not var1)
	SetActive(arg0.gotRemasterTF, var1)
	setText(arg0.numsTxt, var0.remasterTickets .. "/" .. pg.gameset.reactivity_ticket_max.key_value)
end

return var0
