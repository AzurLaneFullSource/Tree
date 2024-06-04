local var0 = class("LittleDaihoPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.helpBtn = arg0.bg:Find("help_btn")

	local var0 = arg0.bg:Find("step_content")

	arg0.itemList = UIItemList.New(var0, var0:Find("tpl"))
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.getBtn, function()
		if arg0.inLT then
			return
		end

		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getRawData()
		local var3 = pg.gameset.urpt_chapter_max.description[1]
		local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
		local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
			{
				var1.type,
				var1.id,
				var1.count
			}
		})

		if var5 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6,
					onYes = arg0
				})
			end)
		end

		table.insert(var0, function(arg0)
			arg0.inLT = true

			local var0 = cloneTplTo(arg0.itemList.container:Find("tpl"), arg0.itemList.container)

			setLocalScale(var0, Vector2.zero)
			LeanTween.scale(var0, Vector3.one, 0.6):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(arg0))
		end)
		table.insert(var0, function(arg0)
			LeanTween.delayedCall(0.2, System.Action(arg0))
		end)
		seriesAsync(var0, function()
			arg0.inLT = false

			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1
			})
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("littleTaihou_npc")
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	arg0.itemList:align(arg0.ptData:GetLevel())

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, "#9F413AFF") or var0) .. "/" .. var1)
end

return var0
