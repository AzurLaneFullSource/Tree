local var0_0 = class("DOAPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.buffModule = arg0_1.bg:Find("buff_module")
	arg0_1.buffPanel = arg0_1.buffModule:Find("skill")
	arg0_1.buffLvs = {
		arg0_1.buffPanel:Find("pow_lv"),
		arg0_1.buffPanel:Find("tec_lv"),
		arg0_1.buffPanel:Find("stm_lv"),
		arg0_1.buffPanel:Find("apl_lv")
	}
	arg0_1.getGreyBtn = arg0_1.bg:Find("get_grey_btn")
	arg0_1.helpBtn = arg0_1.bg:Find("help_btn")
	arg0_1.levelPanel = arg0_1.buffModule:Find("level")
	arg0_1.f2aPanel = arg0_1.levelPanel:Find("f_to_a")
	arg0_1.sPanel = arg0_1.levelPanel:Find("s_ss")
	arg0_1.sssPanel = arg0_1.levelPanel:Find("sss")
	arg0_1.lvBarImages = arg0_1.bg:Find("lv_bars")
	arg0_1.lvTagImages = arg0_1.bg:Find("lv_tags")
	arg0_1.shieldEffect = arg0_1.buffModule:Find("level/shield_effect")
	arg0_1.starEffect = arg0_1.buffModule:Find("level/star_effect")
	arg0_1.mask = arg0_1.bg:Find("mask")
	arg0_1.trainWindow = arg0_1._tf:Find("TrainWindow")
	arg0_1.trainBtn = arg0_1.trainWindow:Find("panel/train_btn")
	arg0_1.trainSkills = arg0_1.trainWindow:Find("panel/skills")
	arg0_1.trainSkillBtns = {
		arg0_1.trainSkills:Find("pow_btn"),
		arg0_1.trainSkills:Find("tec_btn"),
		arg0_1.trainSkills:Find("stm_btn"),
		arg0_1.trainSkills:Find("apl_btn")
	}
	arg0_1.curInfoPanel = arg0_1.trainWindow:Find("panel/info_bg")
	arg0_1.curInfo = arg0_1.trainWindow:Find("panel/info_bg/cur")
	arg0_1.nextInfo = arg0_1.trainWindow:Find("panel/info_bg/next")
	arg0_1.msgBox = arg0_1._tf:Find("MsgBox")
	arg0_1.msgContent = arg0_1.msgBox:Find("panel/content")
	arg0_1.msgBoxMask = arg0_1.msgBox:Find("mengban")
	arg0_1.cancelBtn = arg0_1.msgBox:Find("panel/cancel_btn")
	arg0_1.confirmBtn = arg0_1.msgBox:Find("panel/confirm_btn")
	arg0_1.tipPanel = arg0_1._tf:Find("Tip")
	arg0_1.buffBox = arg0_1._tf:Find("BuffBox")
	arg0_1.buffMask = arg0_1.buffBox:Find("mask")
	arg0_1.buffIconParent = arg0_1.buffBox:Find("window/panel/icon")
	arg0_1.buffDescContent = arg0_1.buffBox:Find("window/panel/intro_view/Viewport/Content")
	arg0_1.buffDescTpl = arg0_1.buffBox:Find("window/panel/intro_view/buff_desc_tpl")
	arg0_1.singleBuffBox = arg0_1._tf:Find("SingleBuffBox")
	arg0_1.singleBuffMask = arg0_1.singleBuffBox:Find("bg")
	arg0_1.singleSureBtn = arg0_1.singleBuffBox:Find("window/top/btnBack")
	arg0_1.singleCloseBtn = arg0_1.singleBuffBox:Find("window/sure_btn")
	arg0_1.singleIconParent = arg0_1.singleBuffBox:Find("window/panel/icon")
	arg0_1.singleDescContent = arg0_1.singleBuffBox:Find("window/panel/intro_view/Viewport/Content")
	arg0_1.singleDescTpl = arg0_1.singleBuffBox:Find("window/panel/intro_view/buff_desc_tpl")

	setText(arg0_1.singleBuffBox:Find("window/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0_1.singleBuffBox:Find("window/sure_btn/pic"), i18n("text_confirm"))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	setActive(arg0_2.bg, true)
	removeOnButton(arg0_2.getBtn)
	onButton(arg0_2, arg0_2.getBtn, function()
		local var0_3 = {}
		local var1_3 = arg0_2.ptData:GetAward()
		local var2_3 = getProxy(PlayerProxy):getData()

		if var1_3.type == DROP_TYPE_RESOURCE and var1_3.id == PlayerConst.ResGold and var2_3:GoldMax(var1_3.count) then
			table.insert(var0_3, function(arg0_4)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0_4
				})
			end)
		end

		seriesAsync(var0_3, function()
			arg0_2.isShowEffect = true

			local var0_5 = arg0_2.ptData:CanTrain() and arg0_2.ptData:isInBuffTime()

			local function var1_5()
				if var0_5 then
					arg0_2:showUpEffect()
				else
					arg0_2:updateLevelPanel()
				end
			end

			local var2_5, var3_5 = arg0_2.ptData:GetResProgress()

			arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_2.ptData:GetId(),
				arg1 = var3_5,
				callback = var1_5
			})
		end)
	end, SFX_PANEL)
	removeOnButton(arg0_2.battleBtn)
	onButton(arg0_2, arg0_2.battleBtn, function()
		local var0_7
		local var1_7
		local var2_7 = arg0_2.activity:getConfig("config_client")

		if var2_7 ~= "" then
			var0_7 = arg0_2.activity:getConfig("config_client").linkActID

			if var0_7 then
				var1_7 = getProxy(ActivityProxy):getActivityById(var0_7)
			end
		end

		local var3_7 = var2_7.fightLinkActID

		if var3_7 then
			arg0_2:emit(ActivityMediator.SKIP_ACTIVITY_MAP, var3_7)

			return
		end

		if not var0_7 then
			arg0_2:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1_7 and not var1_7:isEnd() then
			arg0_2:emit(ActivityMediator.BATTLE_OPERA)
		else
			arg0_2:showTip(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("doa_pt_help")
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.buffModule, function()
		arg0_2:showBuffBox()
	end, SFX_PANEL)

	if arg0_2.contextData.singleActivity then
		setActive(arg0_2.bg, false)
		arg0_2:showSingleBuffBox()
	end

	arg0_2.starEffect:GetComponent("DftAniEvent"):SetEndEvent(function()
		arg0_2:updateLevelPanel()
		arg0_2:managedTween(LeanTween.delayedCall, function()
			arg0_2:showTrianPanel()
			setActive(arg0_2.starEffect, false)
			setActive(arg0_2.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.mask, arg0_2.bg)
		end, 0.2, nil)
	end)
	arg0_2.shieldEffect:GetComponent("DftAniEvent"):SetEndEvent(function()
		arg0_2:updateLevelPanel()
		arg0_2:managedTween(LeanTween.delayedCall, function()
			arg0_2:showTrianPanel()
			setActive(arg0_2.starEffect, false)
			setActive(arg0_2.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.mask, arg0_2.bg)
		end, 0.2, nil)
	end)

	arg0_2.isShowEffect = false
end

function var0_0.showUpEffect(arg0_14, arg1_14)
	setSlider(arg0_14.curPanel, 0, 1, 1)

	local var0_14 = arg0_14.ptData:GetBuffLevelProgress()

	if var0_14 == 8 or var0_14 == 9 then
		setActive(arg0_14.starEffect, true)
		arg0_14.starEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	else
		setActive(arg0_14.shieldEffect, true)
		arg0_14.shieldEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	end

	setActive(arg0_14.mask, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_14.mask)
end

function var0_0.updateLevelPanel(arg0_15)
	local var0_15, var1_15 = arg0_15.ptData:GetBuffLevelProgress()

	setActive(arg0_15.f2aPanel, false)
	setActive(arg0_15.sPanel, false)
	setActive(arg0_15.sssPanel, false)

	arg0_15.curPanel = nil

	if var0_15 == 9 then
		arg0_15.curPanel = arg0_15.sssPanel
	elseif var0_15 > 6 then
		arg0_15.curPanel = arg0_15.sPanel
	else
		arg0_15.curPanel = arg0_15.f2aPanel
	end

	setActive(arg0_15.curPanel, true)
	setImageSprite(arg0_15.curPanel:Find("bar"), arg0_15.lvBarImages:Find(var0_15):GetComponent(typeof(Image)).sprite)
	setImageSprite(arg0_15.curPanel:Find("lv_tag"), arg0_15.lvTagImages:Find(var0_15):GetComponent(typeof(Image)).sprite, true)
	setSlider(arg0_15.curPanel, 0, 1, var1_15)

	return arg0_15.curPanel
end

function var0_0.OnUpdateFlush(arg0_16)
	setActive(arg0_16.starEffect, false)
	setActive(arg0_16.shieldEffect, false)

	local var0_16 = arg0_16.ptData:CanTrain()

	if var0_16 and var0_16 <= arg0_16.ptData.level and arg0_16.ptData:isInBuffTime() and not arg0_16.contextData.singleActivity and not arg0_16.isShowEffect then
		arg0_16:showTrianPanel()
	end

	local var1_16, var2_16, var3_16 = arg0_16.ptData:GetLevelProgress()
	local var4_16, var5_16, var6_16 = arg0_16.ptData:GetResProgress()

	setText(arg0_16.step, var1_16 .. "/" .. var2_16)
	setText(arg0_16.progress, (var6_16 >= 1 and setColorStr(var4_16, COLOR_GREEN) or var4_16) .. "/" .. var5_16)
	setSlider(arg0_16.slider, 0, 1, var6_16)

	if not arg0_16.isShowEffect then
		arg0_16:updateLevelPanel()
	end

	local var7_16 = arg0_16.ptData:CanGetAward()
	local var8_16 = arg0_16.ptData:CanGetNextAward()
	local var9_16 = arg0_16.ptData:CanGetMorePt()
	local var10_16 = arg0_16.ptData:CanTrain()

	setActive(arg0_16.battleBtn, var9_16 and not var7_16 and var8_16)
	setActive(arg0_16.getBtn, var7_16)
	setActive(arg0_16.getGreyBtn, not var7_16)
	setActive(arg0_16.gotBtn, not var8_16 and not var10_16)
	setActive(arg0_16.buffModule, arg0_16.ptData:isInBuffTime())

	local var11_16 = arg0_16.ptData:GetAward()

	updateDrop(arg0_16.awardTF, var11_16)
	onButton(arg0_16, arg0_16.awardTF, function()
		arg0_16:emit(BaseUI.ON_DROP, var11_16)
	end, SFX_PANEL)

	for iter0_16, iter1_16 in ipairs(arg0_16.ptData:GetCurBuffInfos()) do
		setText(arg0_16.buffLvs[iter1_16.group], iter1_16.next and "LV." .. iter1_16.lv or "MAX")
	end
end

function var0_0.showTrianPanel(arg0_18)
	setActive(arg0_18.trainWindow, true)

	local var0_18 = arg0_18.ptData:GetCurBuffInfos()

	arg0_18.selectIndex = nil
	arg0_18.selectBuffId = nil
	arg0_18.selectBuffLv = nil
	arg0_18.selectNewBuffId = nil

	for iter0_18, iter1_18 in ipairs(arg0_18.trainSkillBtns) do
		onButton(arg0_18, iter1_18, function()
			for iter0_19, iter1_19 in ipairs(var0_18) do
				if iter0_18 == iter1_19.group then
					if iter1_19.next then
						arg0_18.selectIndex = iter0_18
						arg0_18.selectBuffId = iter1_19.id
						arg0_18.selectNewBuffId = iter1_19.next
						arg0_18.selectBuffLv = iter1_19.lv
					else
						arg0_18.selectIndex = nil
						arg0_18.selectBuffId = nil
						arg0_18.selectNewBuffId = nil
						arg0_18.selectBuffLv = nil
					end
				end
			end

			arg0_18:flushTrainPanel()
		end, SFX_PANEL)
	end

	onButton(arg0_18, arg0_18.trainBtn, function()
		arg0_18:showMsgBox()
	end, SFX_PANEL)
	;(function()
		for iter0_21, iter1_21 in ipairs(var0_18) do
			if iter1_21.next then
				arg0_18.selectIndex = iter1_21.group
				arg0_18.selectBuffId = iter1_21.id
				arg0_18.selectNewBuffId = iter1_21.next
				arg0_18.selectBuffLv = iter1_21.lv

				return
			end
		end
	end)()
	arg0_18:flushTrainPanel()
end

function var0_0.hideTrianPanel(arg0_22)
	setActive(arg0_22.trainWindow, false)
end

function var0_0.flushTrainPanel(arg0_23)
	local var0_23 = arg0_23.ptData:GetCurBuffInfos()

	if var0_23 then
		for iter0_23, iter1_23 in ipairs(var0_23) do
			setText(arg0_23.trainSkillBtns[iter1_23.group]:Find("lv_bg/lv"), iter1_23.next and "LV." .. iter1_23.lv or "MAX")
		end
	end

	for iter2_23, iter3_23 in ipairs(arg0_23.trainSkillBtns) do
		if iter2_23 == arg0_23.selectIndex then
			setActive(iter3_23:Find("selected"), true)
		else
			setActive(iter3_23:Find("selected"), false)
		end
	end

	if arg0_23.selectIndex then
		setActive(arg0_23.curInfoPanel, true)
		setActive(arg0_23.trainBtn, true)
		setText(arg0_23.curInfo, pg.benefit_buff_template[arg0_23.selectBuffId].desc)
		setText(arg0_23.nextInfo, pg.benefit_buff_template[arg0_23.selectNewBuffId].desc)
	else
		setActive(arg0_23.curInfoPanel, false)
		setActive(arg0_23.trainBtn, false)
	end
end

function var0_0.getBuffNameIndex(arg0_24, arg1_24)
	if arg1_24 == 35 or arg1_24 == 36 or arg1_24 == 37 then
		return 1
	elseif arg1_24 == 38 or arg1_24 == 39 or arg1_24 == 40 then
		return 2
	elseif arg1_24 == 41 or arg1_24 == 42 or arg1_24 == 43 then
		return 3
	elseif arg1_24 == 44 or arg1_24 == 45 or arg1_24 == 46 then
		return 4
	end

	return 1
end

function var0_0.getTip(arg0_25, arg1_25)
	if arg1_25 == 35 or arg1_25 == 36 or arg1_25 == 37 then
		return i18n("doa_liliang")
	elseif arg1_25 == 38 or arg1_25 == 39 or arg1_25 == 40 then
		return i18n("doa_jiqiao")
	elseif arg1_25 == 41 or arg1_25 == 42 or arg1_25 == 43 then
		return i18n("doa_tili")
	elseif arg1_25 == 44 or arg1_25 == 45 or arg1_25 == 46 then
		return i18n("doa_meili")
	end

	return ""
end

function var0_0.showMsgBox(arg0_26)
	if arg0_26.selectBuffId then
		setActive(arg0_26.msgBox, true)
		setText(arg0_26.msgContent, i18n("doa_pt_up", arg0_26:getTip(pg.benefit_buff_template[arg0_26.selectBuffId].id)))
		onButton(arg0_26, arg0_26.msgBoxMask, function()
			arg0_26:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_26, arg0_26.cancelBtn, function()
			arg0_26:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_26, arg0_26.confirmBtn, function()
			arg0_26:hideMsgBox()
			arg0_26:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 3,
				activity_id = arg0_26.ptData:GetId(),
				arg1 = arg0_26.ptData:CanTrain(),
				arg2 = arg0_26.selectNewBuffId,
				oldBuffId = arg0_26.selectBuffId
			})
			arg0_26:hideTrianPanel()
			arg0_26:showTip(i18n("doa_pt_complete"))
		end, SFX_PANEL)
	end
end

function var0_0.hideMsgBox(arg0_30)
	setActive(arg0_30.msgBox, false)
end

function var0_0.showTip(arg0_31, arg1_31)
	local var0_31 = cloneTplTo(arg0_31.tipPanel, arg0_31._tf)

	setActive(var0_31, true)
	setText(var0_31:Find("Text"), arg1_31)

	var0_31.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0_31, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0_31, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local var1_31 = GetOrAddComponent(var0_31, "CanvasGroup")

	Timer.New(function()
		if IsNil(var0_31) then
			return
		end

		LeanTween.scale(var0_31, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			LeanTween.scale(var0_31, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				Destroy(var0_31)
			end))
		end))
	end, 3):Start()
end

function var0_0.showBuffBox(arg0_35)
	setActive(arg0_35.buffBox, true)
	removeAllChildren(arg0_35.buffIconParent)

	local var0_35 = cloneTplTo(arg0_35:updateLevelPanel(), arg0_35.buffIconParent)

	setLocalPosition(var0_35, Vector3(0, 0, 0))
	setLocalScale(var0_35, Vector3(1.3, 1.3, 1))

	local var1_35 = arg0_35.ptData:GetCurBuffInfos()

	if var1_35 then
		for iter0_35, iter1_35 in ipairs(var1_35) do
			local var2_35

			if iter0_35 <= arg0_35.buffDescContent.childCount then
				var2_35 = arg0_35.buffDescContent:GetChild(iter0_35 - 1)
			else
				var2_35 = cloneTplTo(arg0_35.buffDescTpl, arg0_35.buffDescContent)
			end

			setText(var2_35, pg.benefit_buff_template[iter1_35.id].name .. pg.benefit_buff_template[iter1_35.id].desc)
		end
	end

	onButton(arg0_35, arg0_35.buffMask, function()
		setActive(arg0_35.buffBox, false)
	end, SFX_PANEL)
end

function var0_0.showSingleBuffBox(arg0_37)
	setActive(arg0_37.singleBuffBox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_37.singleBuffBox)
	removeAllChildren(arg0_37.singleIconParent)

	local var0_37 = cloneTplTo(arg0_37:updateLevelPanel(), arg0_37.singleIconParent)

	setLocalPosition(var0_37, Vector3(0, 0, 0))
	setLocalScale(var0_37, Vector3(1.3, 1.3, 1))

	local var1_37 = arg0_37.ptData:GetCurBuffInfos()

	if var1_37 then
		for iter0_37, iter1_37 in ipairs(var1_37) do
			local var2_37

			if iter0_37 <= arg0_37.singleDescContent.childCount then
				var2_37 = arg0_37.singleDescContent:GetChild(iter0_37 - 1)
			else
				var2_37 = cloneTplTo(arg0_37.singleDescTpl, arg0_37.singleDescContent)
			end

			setText(var2_37, pg.benefit_buff_template[iter1_37.id].name .. pg.benefit_buff_template[iter1_37.id].desc)
		end
	end

	local function var3_37()
		setActive(arg0_37.singleBuffBox, false)
		arg0_37:emit(ActivitySingleScene.EXIT)
		arg0_37:emit(ActivitySingleScene.ON_CLOSE)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_37.singleBuffBox, arg0_37._tf)
	end

	onButton(arg0_37, arg0_37.singleBuffMask, function()
		var3_37()
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.singleCloseBtn, function()
		var3_37()
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.singleSureBtn, function()
		var3_37()
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_42)
	if arg0_42.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_42.singleBuffBox, arg0_42._tf)
	end
end

function var0_0.willExit(arg0_43)
	if arg0_43.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_43.singleBuffBox, arg0_43._tf)
	end
end

return var0_0
