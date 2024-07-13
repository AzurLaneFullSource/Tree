local var0_0 = class("LittleDaihoPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.helpBtn = arg0_1.bg:Find("help_btn")

	local var0_1 = arg0_1.bg:Find("step_content")

	arg0_1.itemList = UIItemList.New(var0_1, var0_1:Find("tpl"))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.getBtn, function()
		if arg0_2.inLT then
			return
		end

		local var0_3 = {}
		local var1_3 = arg0_2.ptData:GetAward()
		local var2_3 = getProxy(PlayerProxy):getRawData()
		local var3_3 = pg.gameset.urpt_chapter_max.description[1]
		local var4_3 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_3)
		local var5_3, var6_3 = Task.StaticJudgeOverflow(var2_3.gold, var2_3.oil, var4_3, true, true, {
			{
				var1_3.type,
				var1_3.id,
				var1_3.count
			}
		})

		if var5_3 then
			table.insert(var0_3, function(arg0_4)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_3,
					onYes = arg0_4
				})
			end)
		end

		table.insert(var0_3, function(arg0_5)
			arg0_2.inLT = true

			local var0_5 = cloneTplTo(arg0_2.itemList.container:Find("tpl"), arg0_2.itemList.container)

			setLocalScale(var0_5, Vector2.zero)
			LeanTween.scale(var0_5, Vector3.one, 0.6):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(arg0_5))
		end)
		table.insert(var0_3, function(arg0_6)
			LeanTween.delayedCall(0.2, System.Action(arg0_6))
		end)
		seriesAsync(var0_3, function()
			arg0_2.inLT = false

			local var0_7, var1_7 = arg0_2.ptData:GetResProgress()

			arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_2.ptData:GetId(),
				arg1 = var1_7
			})
		end)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("littleTaihou_npc")
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_9)
	var0_0.super.OnUpdateFlush(arg0_9)
	arg0_9.itemList:align(arg0_9.ptData:GetLevel())

	local var0_9, var1_9, var2_9 = arg0_9.ptData:GetResProgress()

	setText(arg0_9.progress, (var2_9 >= 1 and setColorStr(var0_9, "#9F413AFF") or var0_9) .. "/" .. var1_9)
end

return var0_0
