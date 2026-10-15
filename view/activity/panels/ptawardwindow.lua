local var0_0 = class("PtAwardWindow")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1.binder = arg2_1
	arg0_1.scrollPanel = arg0_1._tf:Find("window/panel")
	arg0_1.UIlist = UIItemList.New(arg0_1._tf:Find("window/panel/list"), arg0_1._tf:Find("window/panel/list/item"))
	arg0_1.ptTF = arg0_1._tf:Find("window/pt")
	arg0_1.totalTxt = arg0_1._tf:Find("window/pt/Text"):GetComponent(typeof(Text))
	arg0_1.totalTitleTxt = arg0_1._tf:Find("window/pt/title"):GetComponent(typeof(Text))
	arg0_1.totalTitleIcon = arg0_1._tf:Find("window/pt/icon/image"):GetComponent(typeof(Image))
	arg0_1.closeBtn = arg0_1._tf:Find("window/top/btnBack")
	arg0_1.ptIcon = arg0_1._tf:Find("window/pt/icon")
	arg0_1.getBtn = arg0_1._tf:Find("window/btn_get")

	onButton(arg0_1.binder, arg0_1._tf, function()
		arg0_1:Hide()
	end, SFX_PANEL)
	onButton(arg0_1.binder, arg0_1.closeBtn, function()
		arg0_1:Hide()
	end, SFX_PANEL)
	onButton(arg0_1.binder, arg0_1.getBtn, function()
		if not arg0_1.ptData or arg0_1.ptData:GetMaxAvailableTargetIndex() == arg0_1.ptData:GetLevel() then
			return
		end

		local var0_4 = {}
		local var1_4 = getProxy(PlayerProxy):getRawData()
		local var2_4 = pg.gameset.urpt_chapter_max.description[1]
		local var3_4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var2_4)
		local var4_4 = arg0_1.ptData:GetAllAvailableAwards()
		local var5_4, var6_4 = Task.StaticJudgeOverflow(var1_4.gold, var1_4.oil, var3_4, true, true, var4_4)

		if var5_4 then
			table.insert(var0_4, function(arg0_5)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_4,
					onYes = arg0_5
				})
			end)
		end

		seriesAsync(var0_4, function()
			local var0_6 = arg0_1.ptData:GetCurrTarget()

			arg0_1.binder:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 4,
				activity_id = arg0_1.ptData:GetId(),
				arg1 = var0_6,
				callback = function()
					arg0_1:Refresh()
				end
			})
		end)
	end, SFX_PANEL)
end

function var0_0.UpdateList(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	assert(#arg1_8 == #arg2_8)
	arg0_8.UIlist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8[arg1_9 + 1]
			local var1_9 = arg2_8[arg1_9 + 1]
			local var2_9 = GetPerceptualSize(arg0_8.resTitle)

			setText(arg2_9:Find("title/Text"), "PHASE " .. arg1_9 + 1)
			setText(arg2_9:Find("target/Text"), var1_9)

			if arg2_9:Find("target/icon") then
				if arg0_8.resIcon == "" then
					arg0_8.resIcon = nil
				end

				if arg0_8.resIcon then
					LoadImageSpriteAsync(arg0_8.resIcon, arg2_9:Find("target/icon"), false)
				end

				setActive(arg2_9:Find("target/icon"), arg0_8.resIcon)
				setActive(arg2_9:Find("target/mark"), arg0_8.resIcon)
			end

			setText(arg2_9:Find("target/title"), arg0_8.resTitle)

			local var3_9 = Drop.Create(var0_9)

			updateDrop(arg2_9:Find("award"), var3_9, {
				hideName = true
			})
			onButton(arg0_8.binder, arg2_9:Find("award"), function()
				arg0_8.binder:emit(BaseUI.ON_DROP, var3_9)
			end, SFX_PANEL)
			setActive(arg2_9:Find("award/mask"), arg1_9 + 1 <= arg3_8)

			if not IsNil(arg2_9:Find("mask")) then
				if arg4_8 then
					local var4_9 = pg.TimeMgr.GetInstance()
					local var5_9 = arg4_8[arg1_9 + 1]

					setActive(arg2_9:Find("mask"), var5_9 > var4_9:GetServerTime())

					local var6_9 = var4_9:STimeDescS(var5_9, "%m")
					local var7_9 = var4_9:STimeDescS(var5_9, "%d")

					setText(arg2_9:Find("mask/Text"), i18n("unlock_date_tip", var6_9, var7_9))
				else
					setActive(arg2_9:Find("mask"), false)
				end
			end
		end
	end)
	arg0_8.UIlist:align(#arg1_8)
	scrollTo(arg0_8.scrollPanel, 0, 1 - arg3_8 * 166 / (#arg2_8 * 166 + 20 - 570))
end

function var0_0.Show(arg0_11, arg1_11)
	local var0_11 = arg1_11.dropList
	local var1_11 = arg1_11.targets
	local var2_11 = arg1_11.level
	local var3_11 = arg1_11.count
	local var4_11 = arg1_11.resDrop
	local var5_11 = arg1_11.type

	arg0_11.blur = arg1_11.blur

	local var6_11 = arg1_11.unlockStamps

	arg0_11.ptActId = arg1_11.ptActId
	arg0_11.resIcon = nil

	arg0_11:UpdateTitle(var5_11)
	arg0_11:updateResIcon(arg1_11.resDrop, arg1_11.type)
	arg0_11:UpdateList(var0_11, var1_11, var2_11, var6_11)

	arg0_11.totalTxt.text = var3_11
	arg0_11.totalTitleTxt.text = arg0_11.cntTitle

	Canvas.ForceUpdateCanvases()
	setActive(arg0_11._tf, true)

	if arg0_11.blur then
		pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf)
	end

	arg0_11:Refresh()
end

function var0_0.UpdateTitle(arg0_12, arg1_12)
	local var0_12 = ""

	switch(arg1_12, {
		function()
			arg0_12.resTitle, arg0_12.cntTitle = i18n("target_get_tip"), i18n("pt_total_count", var0_12)
			arg0_12.cntTitle = string.gsub(arg0_12.cntTitle, "：", "")
		end,
		function()
			arg0_12.resTitle, arg0_12.cntTitle = i18n("pt_cosume", var0_12), i18n("pt_total_count", i18n("pt_cosume", var0_12))
			arg0_12.cntTitle = string.gsub(arg0_12.cntTitle, "：", "")
		end,
		function()
			arg0_12.resTitle, arg0_12.cntTitle = i18n("pt_ship_goal"), i18n("pt_ship_now")
		end,
		function()
			arg0_12.resTitle, arg0_12.cntTitle = i18n("cumulative_victory_target_tip"), i18n("cumulative_victory_now_tip")
		end,
		function()
			arg0_12.resTitle, arg0_12.cntTitle = i18n("npcfriendly_count"), i18n("npcfriendly_total_count")
		end,
		function()
			arg0_12.resTitle, arg0_12.cntTitle = i18n("activity_yanhua_tip2"), i18n("activity_yanhua_tip3")
		end,
		[9] = 2,
		[8] = 1
	}, function()
		arg0_12.resTitle, arg0_12.cntTitle = i18n("target_get_tip"), i18n("pt_total_count", var0_12)
		arg0_12.cntTitle = string.gsub(arg0_12.cntTitle, "：", "")
	end)
end

local var1_0 = {
	nil,
	true,
	false,
	false,
	false,
	false
}

function var0_0.updateResIcon(arg0_20, arg1_20, arg2_20)
	if defaultValue(var1_0[arg2_20], true) then
		arg0_20.resIcon = arg1_20:getIcon()
	end

	setActive(arg0_20.ptIcon, arg0_20.resIcon)

	if arg0_20.resIcon then
		LoadImageSpriteAsync(arg0_20.resIcon, arg0_20.totalTitleIcon, false)
	end
end

function var0_0.Refresh(arg0_21)
	if arg0_21.ptActId then
		local var0_21 = getProxy(ActivityProxy):getActivityById(arg0_21.ptActId)

		if not arg0_21.ptData then
			arg0_21.ptData = ActivityPtData.New(var0_21)
		else
			arg0_21.ptData:Update(var0_21)
		end

		setActive(arg0_21.getBtn:Find("off"), arg0_21.ptData:GetMaxAvailableTargetIndex() == arg0_21.ptData:GetLevel())
		setActive(arg0_21.getBtn:Find("on"), arg0_21.ptData:GetMaxAvailableTargetIndex() ~= arg0_21.ptData:GetLevel())
	end
end

function var0_0.Hide(arg0_22)
	if arg0_22.blur then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_22._tf)
	end

	setActive(arg0_22._tf, false)
end

function var0_0.Dispose(arg0_23)
	arg0_23:Hide()
	removeOnButton(arg0_23._tf)
	removeOnButton(arg0_23.closeBtn)
end

return var0_0
