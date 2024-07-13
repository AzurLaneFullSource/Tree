local var0_0 = class("RyzaPtPage", import(".TemplatePage.PtTemplatePage"))
local var1_0 = 9

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.kalaSpine = arg0_1:findTF("shadow/kala", arg0_1.bg)
	arg0_1.kalaAnim = arg0_1.kalaSpine:GetComponent("SpineAnimUI")
	arg0_1.puniSpine = arg0_1:findTF("puni", arg0_1.bg)
	arg0_1.puniAnim = arg0_1.puniSpine:GetComponent("SpineAnimUI")
	arg0_1.feedBtn = arg0_1:findTF("feed_btn", arg0_1.bg)
	arg0_1.clickMask = arg0_1:findTF("click_mask", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	arg0_2:InitAnimData()
	onButton(arg0_2, arg0_2.feedBtn, function()
		local var0_3 = {}

		table.insert(var0_3, function(arg0_4)
			arg0_2:PlayFeedAnim(arg0_4)
		end)

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
			table.insert(var0_3, function(arg0_5)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_3,
					onYes = arg0_5
				})
			end)
		end

		seriesAsync(var0_3, function()
			local var0_6, var1_6 = arg0_2.ptData:GetResProgress()

			arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_2.ptData:GetId(),
				arg1 = var1_6
			})
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	var0_0.super.OnUpdateFlush(arg0_7)

	local var0_7 = arg0_7.ptData:GetLevelProgress()

	if isActive(arg0_7.getBtn) and arg0_7.specialPhase[var0_7] then
		setActive(arg0_7.getBtn, false)
		setActive(arg0_7.feedBtn, true)
	else
		setActive(arg0_7.feedBtn, false)
	end
end

function var0_0.UpdateSpineIdle(arg0_8, arg1_8)
	arg0_8.kalaAnim:SetAction("pt_ui", 0)

	if arg1_8 > arg0_8.puniPhaseCfg[#arg0_8.puniPhaseCfg] then
		local var0_8 = arg0_8.puniPhaseCfg[math.random(#arg0_8.puniPhaseCfg)]
		local var1_8, var2_8, var3_8 = arg0_8:GetAnimName(var0_8)

		arg0_8.puniAnim:SetAction(var1_8, 0)
		arg0_8:PlayIdleFeedAnim(var2_8, var3_8)
	else
		local var4_8 = arg0_8:GetAnimName()

		arg0_8.puniAnim:SetAction(var4_8, 0)
	end
end

function var0_0.PlayIdleFeedAnim(arg0_9, arg1_9, arg2_9)
	arg0_9:PlayKalaAnim()
	arg0_9.puniAnim:SetActionCallBack(function(arg0_10)
		if arg0_10 == "finish" then
			arg0_9.puniAnim:SetActionCallBack(nil)
			arg0_9.puniAnim:SetAction(arg2_9, 0)
		end
	end)
	arg0_9.puniAnim:SetAction(arg1_9, 0)
end

function var0_0.PlayFeedAnim(arg0_11, arg1_11)
	setActive(arg0_11.clickMask, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_11.clickMask)
	arg0_11:PlayKalaAnim()
	arg0_11:PlayPuniChangeAnim(function()
		setActive(arg0_11.clickMask, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11.clickMask, arg0_11.bg)

		if arg1_11 then
			arg1_11()
		end
	end)
end

function var0_0.PlayKalaAnim(arg0_13, arg1_13)
	arg0_13.kalaAnim:SetActionCallBack(function(arg0_14)
		if arg0_14 == "finish" then
			arg0_13.kalaAnim:SetActionCallBack(nil)
			arg0_13.kalaAnim:SetAction("pt_ui", 0)

			if arg1_13 then
				arg1_13()
			end
		end
	end)
	arg0_13.kalaAnim:SetAction("event_weishi", 0)
end

function var0_0.PlayPuniChangeAnim(arg0_15, arg1_15)
	local var0_15, var1_15, var2_15 = arg0_15:GetAnimName()

	arg0_15.puniAnim:SetActionCallBack(function(arg0_16)
		if arg0_16 == "finish" then
			arg0_15.puniAnim:SetActionCallBack(nil)
			arg0_15.puniAnim:SetAction(var2_15, 0)

			if arg1_15 then
				arg1_15()
			end
		end
	end)
	arg0_15.puniAnim:SetAction(var1_15, 0)
end

function var0_0.InitAnimData(arg0_17)
	arg0_17.puniPhaseCfg = arg0_17.activity:getConfig("config_client").puni_phase
	arg0_17.specialPhase = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.puniPhaseCfg) do
		arg0_17.specialPhase[iter1_17] = true
	end

	arg0_17.phase2anims = {}

	local var0_17, var1_17 = arg0_17.ptData:GetLevelProgress()
	local var2_17 = 1

	for iter2_17 = 1, arg0_17.puniPhaseCfg[#arg0_17.puniPhaseCfg] do
		local var3_17 = {}

		table.insert(var3_17, "normal_" .. var2_17)

		if arg0_17.specialPhase[iter2_17] then
			table.insert(var3_17, "action" .. var2_17)
			table.insert(var3_17, "normal_" .. var2_17 + 1)

			var2_17 = var2_17 + 1
		end

		table.insert(arg0_17.phase2anims, var3_17)
	end
end

function var0_0.GetAnimName(arg0_18, arg1_18)
	local var0_18 = arg1_18 and arg1_18 or arg0_18.ptData:GetLevelProgress()

	if var0_18 > arg0_18.puniPhaseCfg[#arg0_18.puniPhaseCfg] then
		return "normal_" .. math.random(var1_0)
	else
		local var1_18 = arg0_18.phase2anims[var0_18]

		return var1_18[1], var1_18[2], var1_18[3]
	end
end

function var0_0.OnShowFlush(arg0_19)
	arg0_19:UpdateSpineIdle(arg0_19.ptData:GetLevelProgress())
end

return var0_0
