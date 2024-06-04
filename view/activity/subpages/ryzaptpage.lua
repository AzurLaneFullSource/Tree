local var0 = class("RyzaPtPage", import(".TemplatePage.PtTemplatePage"))
local var1 = 9

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.kalaSpine = arg0:findTF("shadow/kala", arg0.bg)
	arg0.kalaAnim = arg0.kalaSpine:GetComponent("SpineAnimUI")
	arg0.puniSpine = arg0:findTF("puni", arg0.bg)
	arg0.puniAnim = arg0.puniSpine:GetComponent("SpineAnimUI")
	arg0.feedBtn = arg0:findTF("feed_btn", arg0.bg)
	arg0.clickMask = arg0:findTF("click_mask", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	arg0:InitAnimData()
	onButton(arg0, arg0.feedBtn, function()
		local var0 = {}

		table.insert(var0, function(arg0)
			arg0:PlayFeedAnim(arg0)
		end)

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

		seriesAsync(var0, function()
			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1
			})
		end)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.ptData:GetLevelProgress()

	if isActive(arg0.getBtn) and arg0.specialPhase[var0] then
		setActive(arg0.getBtn, false)
		setActive(arg0.feedBtn, true)
	else
		setActive(arg0.feedBtn, false)
	end
end

function var0.UpdateSpineIdle(arg0, arg1)
	arg0.kalaAnim:SetAction("pt_ui", 0)

	if arg1 > arg0.puniPhaseCfg[#arg0.puniPhaseCfg] then
		local var0 = arg0.puniPhaseCfg[math.random(#arg0.puniPhaseCfg)]
		local var1, var2, var3 = arg0:GetAnimName(var0)

		arg0.puniAnim:SetAction(var1, 0)
		arg0:PlayIdleFeedAnim(var2, var3)
	else
		local var4 = arg0:GetAnimName()

		arg0.puniAnim:SetAction(var4, 0)
	end
end

function var0.PlayIdleFeedAnim(arg0, arg1, arg2)
	arg0:PlayKalaAnim()
	arg0.puniAnim:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			arg0.puniAnim:SetActionCallBack(nil)
			arg0.puniAnim:SetAction(arg2, 0)
		end
	end)
	arg0.puniAnim:SetAction(arg1, 0)
end

function var0.PlayFeedAnim(arg0, arg1)
	setActive(arg0.clickMask, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.clickMask)
	arg0:PlayKalaAnim()
	arg0:PlayPuniChangeAnim(function()
		setActive(arg0.clickMask, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.clickMask, arg0.bg)

		if arg1 then
			arg1()
		end
	end)
end

function var0.PlayKalaAnim(arg0, arg1)
	arg0.kalaAnim:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			arg0.kalaAnim:SetActionCallBack(nil)
			arg0.kalaAnim:SetAction("pt_ui", 0)

			if arg1 then
				arg1()
			end
		end
	end)
	arg0.kalaAnim:SetAction("event_weishi", 0)
end

function var0.PlayPuniChangeAnim(arg0, arg1)
	local var0, var1, var2 = arg0:GetAnimName()

	arg0.puniAnim:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			arg0.puniAnim:SetActionCallBack(nil)
			arg0.puniAnim:SetAction(var2, 0)

			if arg1 then
				arg1()
			end
		end
	end)
	arg0.puniAnim:SetAction(var1, 0)
end

function var0.InitAnimData(arg0)
	arg0.puniPhaseCfg = arg0.activity:getConfig("config_client").puni_phase
	arg0.specialPhase = {}

	for iter0, iter1 in ipairs(arg0.puniPhaseCfg) do
		arg0.specialPhase[iter1] = true
	end

	arg0.phase2anims = {}

	local var0, var1 = arg0.ptData:GetLevelProgress()
	local var2 = 1

	for iter2 = 1, arg0.puniPhaseCfg[#arg0.puniPhaseCfg] do
		local var3 = {}

		table.insert(var3, "normal_" .. var2)

		if arg0.specialPhase[iter2] then
			table.insert(var3, "action" .. var2)
			table.insert(var3, "normal_" .. var2 + 1)

			var2 = var2 + 1
		end

		table.insert(arg0.phase2anims, var3)
	end
end

function var0.GetAnimName(arg0, arg1)
	local var0 = arg1 and arg1 or arg0.ptData:GetLevelProgress()

	if var0 > arg0.puniPhaseCfg[#arg0.puniPhaseCfg] then
		return "normal_" .. math.random(var1)
	else
		local var1 = arg0.phase2anims[var0]

		return var1[1], var1[2], var1[3]
	end
end

function var0.OnShowFlush(arg0)
	arg0:UpdateSpineIdle(arg0.ptData:GetLevelProgress())
end

return var0
