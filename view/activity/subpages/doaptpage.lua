local var0_0 = class("DOAPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.buffModule = arg0_1:findTF("buff_module", arg0_1.bg)
	arg0_1.buffPanel = arg0_1:findTF("skill", arg0_1.buffModule)
	arg0_1.buffLvs = {}

	eachChild(arg0_1.buffPanel, function(arg0_2)
		table.insert(arg0_1.buffLvs, arg0_2)
	end)

	arg0_1.getGreyBtn = arg0_1:findTF("get_grey_btn", arg0_1.bg)
	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)
	arg0_1.levelPanel = arg0_1:findTF("level", arg0_1.buffModule)
	arg0_1.f2aPanel = arg0_1:findTF("f_to_a", arg0_1.levelPanel)
	arg0_1.sPanel = arg0_1:findTF("s_ss", arg0_1.levelPanel)
	arg0_1.sssPanel = arg0_1:findTF("sss", arg0_1.levelPanel)
	arg0_1.lvBarImages = arg0_1:findTF("lv_bars", arg0_1.bg)
	arg0_1.lvTagImages = arg0_1:findTF("lv_tags", arg0_1.bg)
	arg0_1.shieldEffect = arg0_1:findTF("level/shield_effect", arg0_1.buffModule)
	arg0_1.starEffect = arg0_1:findTF("level/star_effect", arg0_1.buffModule)
	arg0_1.mask = arg0_1:findTF("mask", arg0_1.bg)
	arg0_1.trainWindow = arg0_1:findTF("TrainWindow")
	arg0_1.trainBtn = arg0_1:findTF("panel/train_btn", arg0_1.trainWindow)
	arg0_1.trainSkills = arg0_1:findTF("panel/skills", arg0_1.trainWindow)
	arg0_1.trainSkillBtns = {}

	eachChild(arg0_1.trainSkills, function(arg0_3)
		table.insert(arg0_1.trainSkillBtns, arg0_3)
	end)

	arg0_1.curInfoPanel = arg0_1:findTF("panel/info_bg", arg0_1.trainWindow)
	arg0_1.curInfo = arg0_1:findTF("panel/info_bg/cur", arg0_1.trainWindow)
	arg0_1.nextInfo = arg0_1:findTF("panel/info_bg/next", arg0_1.trainWindow)
	arg0_1.msgBox = arg0_1:findTF("MsgBox")
	arg0_1.msgContent = arg0_1:findTF("panel/content", arg0_1.msgBox)
	arg0_1.msgBoxMask = arg0_1:findTF("mengban", arg0_1.msgBox)
	arg0_1.cancelBtn = arg0_1:findTF("panel/cancel_btn", arg0_1.msgBox)
	arg0_1.confirmBtn = arg0_1:findTF("panel/confirm_btn", arg0_1.msgBox)
	arg0_1.tipPanel = arg0_1:findTF("Tip")
	arg0_1.buffBox = arg0_1:findTF("BuffBox")
	arg0_1.buffMask = arg0_1:findTF("mask", arg0_1.buffBox)
	arg0_1.buffIconParent = arg0_1:findTF("window/panel/icon", arg0_1.buffBox)
	arg0_1.buffDescContent = arg0_1:findTF("window/panel/intro_view/Viewport/Content", arg0_1.buffBox)
	arg0_1.buffDescTpl = arg0_1:findTF("window/panel/intro_view/buff_desc_tpl", arg0_1.buffBox)
	arg0_1.singleBuffBox = arg0_1:findTF("SingleBuffBox")
	arg0_1.singleBuffMask = arg0_1:findTF("bg", arg0_1.singleBuffBox)
	arg0_1.singleSureBtn = arg0_1:findTF("window/top/btnBack", arg0_1.singleBuffBox)
	arg0_1.singleCloseBtn = arg0_1:findTF("window/sure_btn", arg0_1.singleBuffBox)
	arg0_1.singleIconParent = arg0_1:findTF("window/panel/icon", arg0_1.singleBuffBox)
	arg0_1.singleDescContent = arg0_1:findTF("window/panel/intro_view/Viewport/Content", arg0_1.singleBuffBox)
	arg0_1.singleDescTpl = arg0_1:findTF("window/panel/intro_view/buff_desc_tpl", arg0_1.singleBuffBox)

	setText(arg0_1:findTF("window/top/bg/infomation/title", arg0_1.singleBuffBox), i18n("words_information"))
	setText(arg0_1:findTF("window/sure_btn/pic", arg0_1.singleBuffBox), i18n("text_confirm"))
end

function var0_0.OnFirstFlush(arg0_4)
	var0_0.super.OnFirstFlush(arg0_4)
	setActive(arg0_4.bg, true)
	removeOnButton(arg0_4.getBtn)
	onButton(arg0_4, arg0_4.getBtn, function()
		local var0_5 = {}
		local var1_5 = arg0_4.ptData:GetAward()
		local var2_5 = getProxy(PlayerProxy):getData()

		if var1_5.type == DROP_TYPE_RESOURCE and var1_5.id == PlayerConst.ResGold and var2_5:GoldMax(var1_5.count) then
			table.insert(var0_5, function(arg0_6)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0_6
				})
			end)
		end

		seriesAsync(var0_5, function()
			arg0_4.isShowEffect = true

			local var0_7 = arg0_4.ptData:CanTrain() and arg0_4.ptData:isInBuffTime()

			local function var1_7()
				if var0_7 then
					arg0_4:showUpEffect()
				else
					arg0_4:updateLevelPanel()
				end
			end

			local var2_7, var3_7 = arg0_4.ptData:GetResProgress()

			arg0_4:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_4.ptData:GetId(),
				arg1 = var3_7,
				callback = var1_7
			})
		end)
	end, SFX_PANEL)
	removeOnButton(arg0_4.battleBtn)
	onButton(arg0_4, arg0_4.battleBtn, function()
		local var0_9
		local var1_9

		if arg0_4.activity:getConfig("config_client") ~= "" then
			var0_9 = arg0_4.activity:getConfig("config_client").linkActID

			if var0_9 then
				var1_9 = getProxy(ActivityProxy):getActivityById(var0_9)
			end
		end

		if not var0_9 then
			arg0_4:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1_9 and not var1_9:isEnd() then
			arg0_4:emit(ActivityMediator.BATTLE_OPERA)
		else
			arg0_4:showTip(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("doa_pt_help")
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.buffModule, function()
		arg0_4:showBuffBox()
	end, SFX_PANEL)

	if arg0_4.contextData.singleActivity then
		setActive(arg0_4.bg, false)
		arg0_4:showSingleBuffBox()
	end

	arg0_4.starEffect:GetComponent("DftAniEvent"):SetEndEvent(function()
		arg0_4:updateLevelPanel()
		arg0_4:managedTween(LeanTween.delayedCall, function()
			arg0_4:showTrianPanel()
			setActive(arg0_4.starEffect, false)
			setActive(arg0_4.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4.mask, arg0_4.bg)
		end, 0.2, nil)
	end)
	arg0_4.shieldEffect:GetComponent("DftAniEvent"):SetEndEvent(function()
		arg0_4:updateLevelPanel()
		arg0_4:managedTween(LeanTween.delayedCall, function()
			arg0_4:showTrianPanel()
			setActive(arg0_4.starEffect, false)
			setActive(arg0_4.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4.mask, arg0_4.bg)
		end, 0.2, nil)
	end)

	arg0_4.isShowEffect = false
end

function var0_0.showUpEffect(arg0_16, arg1_16)
	setSlider(arg0_16.curPanel, 0, 1, 1)

	local var0_16 = arg0_16.ptData:GetBuffLevelProgress()

	if var0_16 == 8 or var0_16 == 9 then
		setActive(arg0_16.starEffect, true)
		arg0_16.starEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	else
		setActive(arg0_16.shieldEffect, true)
		arg0_16.shieldEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	end

	setActive(arg0_16.mask, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_16.mask)
end

function var0_0.updateLevelPanel(arg0_17)
	local var0_17, var1_17 = arg0_17.ptData:GetBuffLevelProgress()

	setActive(arg0_17.f2aPanel, false)
	setActive(arg0_17.sPanel, false)
	setActive(arg0_17.sssPanel, false)

	arg0_17.curPanel = nil

	if var0_17 == 9 then
		arg0_17.curPanel = arg0_17.sssPanel
	elseif var0_17 > 6 then
		arg0_17.curPanel = arg0_17.sPanel
	else
		arg0_17.curPanel = arg0_17.f2aPanel
	end

	setActive(arg0_17.curPanel, true)
	setImageSprite(arg0_17:findTF("bar", arg0_17.curPanel), arg0_17.lvBarImages:Find(var0_17):GetComponent(typeof(Image)).sprite)
	setImageSprite(arg0_17:findTF("lv_tag", arg0_17.curPanel), arg0_17.lvTagImages:Find(var0_17):GetComponent(typeof(Image)).sprite, true)
	setSlider(arg0_17.curPanel, 0, 1, var1_17)

	return arg0_17.curPanel
end

function var0_0.OnUpdateFlush(arg0_18)
	setActive(arg0_18.starEffect, false)
	setActive(arg0_18.shieldEffect, false)

	local var0_18 = arg0_18.ptData:CanTrain()

	if var0_18 and var0_18 <= arg0_18.ptData.level and arg0_18.ptData:isInBuffTime() and not arg0_18.contextData.singleActivity and not arg0_18.isShowEffect then
		arg0_18:showTrianPanel()
	end

	local var1_18, var2_18, var3_18 = arg0_18.ptData:GetLevelProgress()
	local var4_18, var5_18, var6_18 = arg0_18.ptData:GetResProgress()

	setText(arg0_18.step, var1_18 .. "/" .. var2_18)
	setText(arg0_18.progress, (var6_18 >= 1 and setColorStr(var4_18, COLOR_GREEN) or var4_18) .. "/" .. var5_18)
	setSlider(arg0_18.slider, 0, 1, var6_18)

	if not arg0_18.isShowEffect then
		arg0_18:updateLevelPanel()
	end

	local var7_18 = arg0_18.ptData:CanGetAward()
	local var8_18 = arg0_18.ptData:CanGetNextAward()
	local var9_18 = arg0_18.ptData:CanGetMorePt()
	local var10_18 = arg0_18.ptData:CanTrain()

	setActive(arg0_18.battleBtn, var9_18 and not var7_18 and var8_18)
	setActive(arg0_18.getBtn, var7_18)
	setActive(arg0_18.getGreyBtn, not var7_18)
	setActive(arg0_18.gotBtn, not var8_18 and not var10_18)
	setActive(arg0_18.buffModule, arg0_18.ptData:isInBuffTime())

	local var11_18 = arg0_18.ptData:GetAward()

	updateDrop(arg0_18.awardTF, var11_18)
	onButton(arg0_18, arg0_18.awardTF, function()
		arg0_18:emit(BaseUI.ON_DROP, var11_18)
	end, SFX_PANEL)

	for iter0_18, iter1_18 in ipairs(arg0_18.ptData:GetCurBuffInfos()) do
		setText(arg0_18.buffLvs[iter1_18.group], iter1_18.next and "LV." .. iter1_18.lv or "MAX")
	end
end

function var0_0.showTrianPanel(arg0_20)
	setActive(arg0_20.trainWindow, true)

	local var0_20 = arg0_20.ptData:GetCurBuffInfos()

	arg0_20.selectIndex = nil
	arg0_20.selectBuffId = nil
	arg0_20.selectBuffLv = nil
	arg0_20.selectNewBuffId = nil

	for iter0_20, iter1_20 in ipairs(arg0_20.trainSkillBtns) do
		onButton(arg0_20, iter1_20, function()
			for iter0_21, iter1_21 in ipairs(var0_20) do
				if iter0_20 == iter1_21.group then
					if iter1_21.next then
						arg0_20.selectIndex = iter0_20
						arg0_20.selectBuffId = iter1_21.id
						arg0_20.selectNewBuffId = iter1_21.next
						arg0_20.selectBuffLv = iter1_21.lv
					else
						arg0_20.selectIndex = nil
						arg0_20.selectBuffId = nil
						arg0_20.selectNewBuffId = nil
						arg0_20.selectBuffLv = nil
					end
				end
			end

			arg0_20:flushTrainPanel()
		end, SFX_PANEL)
	end

	onButton(arg0_20, arg0_20.trainBtn, function()
		arg0_20:showMsgBox()
	end, SFX_PANEL)
	;(function()
		for iter0_23, iter1_23 in ipairs(var0_20) do
			if iter1_23.next then
				arg0_20.selectIndex = iter1_23.group
				arg0_20.selectBuffId = iter1_23.id
				arg0_20.selectNewBuffId = iter1_23.next
				arg0_20.selectBuffLv = iter1_23.lv

				return
			end
		end
	end)()
	arg0_20:flushTrainPanel()
end

function var0_0.hideTrianPanel(arg0_24)
	setActive(arg0_24.trainWindow, false)
end

function var0_0.flushTrainPanel(arg0_25)
	local var0_25 = arg0_25.ptData:GetCurBuffInfos()

	if var0_25 then
		for iter0_25, iter1_25 in ipairs(var0_25) do
			setText(arg0_25:findTF("lv_bg/lv", arg0_25.trainSkillBtns[iter1_25.group]), iter1_25.next and "LV." .. iter1_25.lv or "MAX")
		end
	end

	for iter2_25, iter3_25 in ipairs(arg0_25.trainSkillBtns) do
		if iter2_25 == arg0_25.selectIndex then
			setActive(arg0_25:findTF("selected", iter3_25), true)
		else
			setActive(arg0_25:findTF("selected", iter3_25), false)
		end
	end

	if arg0_25.selectIndex then
		setActive(arg0_25.curInfoPanel, true)
		setActive(arg0_25.trainBtn, true)
		setText(arg0_25.curInfo, pg.benefit_buff_template[arg0_25.selectBuffId].desc)
		setText(arg0_25.nextInfo, pg.benefit_buff_template[arg0_25.selectNewBuffId].desc)
	else
		setActive(arg0_25.curInfoPanel, false)
		setActive(arg0_25.trainBtn, false)
	end
end

function var0_0.getBuffNameIndex(arg0_26, arg1_26)
	if arg1_26 == 35 or arg1_26 == 36 or arg1_26 == 37 then
		return 1
	elseif arg1_26 == 38 or arg1_26 == 39 or arg1_26 == 40 then
		return 2
	elseif arg1_26 == 41 or arg1_26 == 42 or arg1_26 == 43 then
		return 3
	elseif arg1_26 == 44 or arg1_26 == 45 or arg1_26 == 46 then
		return 4
	end

	return 1
end

function var0_0.getTip(arg0_27, arg1_27)
	if arg1_27 == 35 or arg1_27 == 36 or arg1_27 == 37 then
		return i18n("doa_liliang")
	elseif arg1_27 == 38 or arg1_27 == 39 or arg1_27 == 40 then
		return i18n("doa_jiqiao")
	elseif arg1_27 == 41 or arg1_27 == 42 or arg1_27 == 43 then
		return i18n("doa_tili")
	elseif arg1_27 == 44 or arg1_27 == 45 or arg1_27 == 46 then
		return i18n("doa_meili")
	end

	return ""
end

function var0_0.showMsgBox(arg0_28)
	if arg0_28.selectBuffId then
		setActive(arg0_28.msgBox, true)
		setText(arg0_28.msgContent, i18n("doa_pt_up", arg0_28:getTip(pg.benefit_buff_template[arg0_28.selectBuffId].id)))
		onButton(arg0_28, arg0_28.msgBoxMask, function()
			arg0_28:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_28, arg0_28.cancelBtn, function()
			arg0_28:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0_28, arg0_28.confirmBtn, function()
			arg0_28:hideMsgBox()
			arg0_28:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 3,
				activity_id = arg0_28.ptData:GetId(),
				arg1 = arg0_28.ptData:CanTrain(),
				arg2 = arg0_28.selectNewBuffId,
				oldBuffId = arg0_28.selectBuffId
			})
			arg0_28:hideTrianPanel()
			arg0_28:showTip(i18n("doa_pt_complete"))
		end, SFX_PANEL)
	end
end

function var0_0.hideMsgBox(arg0_32)
	setActive(arg0_32.msgBox, false)
end

function var0_0.showTip(arg0_33, arg1_33)
	local var0_33 = cloneTplTo(arg0_33.tipPanel, arg0_33._tf)

	setActive(var0_33, true)
	setText(arg0_33:findTF("Text", var0_33), arg1_33)

	var0_33.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0_33, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0_33, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local var1_33 = GetOrAddComponent(var0_33, "CanvasGroup")

	Timer.New(function()
		if IsNil(var0_33) then
			return
		end

		LeanTween.scale(var0_33, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			LeanTween.scale(var0_33, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				Destroy(var0_33)
			end))
		end))
	end, 3):Start()
end

function var0_0.showBuffBox(arg0_37)
	setActive(arg0_37.buffBox, true)
	removeAllChildren(arg0_37.buffIconParent)

	local var0_37 = cloneTplTo(arg0_37:updateLevelPanel(), arg0_37.buffIconParent)

	setLocalPosition(var0_37, Vector3(0, 0, 0))
	setLocalScale(var0_37, Vector3(1.3, 1.3, 1))

	local var1_37 = arg0_37.ptData:GetCurBuffInfos()

	if var1_37 then
		for iter0_37, iter1_37 in ipairs(var1_37) do
			local var2_37

			if iter0_37 <= arg0_37.buffDescContent.childCount then
				var2_37 = arg0_37.buffDescContent:GetChild(iter0_37 - 1)
			else
				var2_37 = cloneTplTo(arg0_37.buffDescTpl, arg0_37.buffDescContent)
			end

			setText(var2_37, pg.benefit_buff_template[iter1_37.id].name .. pg.benefit_buff_template[iter1_37.id].desc)
		end
	end

	onButton(arg0_37, arg0_37.buffMask, function()
		setActive(arg0_37.buffBox, false)
	end, SFX_PANEL)
end

function var0_0.showSingleBuffBox(arg0_39)
	setActive(arg0_39.singleBuffBox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_39.singleBuffBox, false, {
		overlayType = LayerWeightConst.OVERLAY_UI_TOP
	})
	removeAllChildren(arg0_39.singleIconParent)

	local var0_39 = cloneTplTo(arg0_39:updateLevelPanel(), arg0_39.singleIconParent)

	setLocalPosition(var0_39, Vector3(0, 0, 0))
	setLocalScale(var0_39, Vector3(1.3, 1.3, 1))

	local var1_39 = arg0_39.ptData:GetCurBuffInfos()

	if var1_39 then
		for iter0_39, iter1_39 in ipairs(var1_39) do
			local var2_39

			if iter0_39 <= arg0_39.singleDescContent.childCount then
				var2_39 = arg0_39.singleDescContent:GetChild(iter0_39 - 1)
			else
				var2_39 = cloneTplTo(arg0_39.singleDescTpl, arg0_39.singleDescContent)
			end

			setText(var2_39, pg.benefit_buff_template[iter1_39.id].name .. pg.benefit_buff_template[iter1_39.id].desc)
		end
	end

	local function var3_39()
		setActive(arg0_39.singleBuffBox, false)
		arg0_39:emit(ActivitySingleScene.EXIT)
		arg0_39:emit(ActivitySingleScene.ON_CLOSE)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_39.singleBuffBox, arg0_39._tf)
	end

	onButton(arg0_39, arg0_39.singleBuffMask, function()
		var3_39()
	end, SFX_PANEL)
	onButton(arg0_39, arg0_39.singleCloseBtn, function()
		var3_39()
	end, SFX_PANEL)
	onButton(arg0_39, arg0_39.singleSureBtn, function()
		var3_39()
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_44)
	if arg0_44.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_44.singleBuffBox, arg0_44._tf)
	end
end

function var0_0.willExit(arg0_45)
	if arg0_45.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_45.singleBuffBox, arg0_45._tf)
	end
end

return var0_0
