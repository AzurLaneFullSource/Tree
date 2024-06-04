local var0 = class("DOAPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.buffModule = arg0:findTF("buff_module", arg0.bg)
	arg0.buffPanel = arg0:findTF("skill", arg0.buffModule)
	arg0.buffLvs = {}

	eachChild(arg0.buffPanel, function(arg0)
		table.insert(arg0.buffLvs, arg0)
	end)

	arg0.getGreyBtn = arg0:findTF("get_grey_btn", arg0.bg)
	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.levelPanel = arg0:findTF("level", arg0.buffModule)
	arg0.f2aPanel = arg0:findTF("f_to_a", arg0.levelPanel)
	arg0.sPanel = arg0:findTF("s_ss", arg0.levelPanel)
	arg0.sssPanel = arg0:findTF("sss", arg0.levelPanel)
	arg0.lvBarImages = arg0:findTF("lv_bars", arg0.bg)
	arg0.lvTagImages = arg0:findTF("lv_tags", arg0.bg)
	arg0.shieldEffect = arg0:findTF("level/shield_effect", arg0.buffModule)
	arg0.starEffect = arg0:findTF("level/star_effect", arg0.buffModule)
	arg0.mask = arg0:findTF("mask", arg0.bg)
	arg0.trainWindow = arg0:findTF("TrainWindow")
	arg0.trainBtn = arg0:findTF("panel/train_btn", arg0.trainWindow)
	arg0.trainSkills = arg0:findTF("panel/skills", arg0.trainWindow)
	arg0.trainSkillBtns = {}

	eachChild(arg0.trainSkills, function(arg0)
		table.insert(arg0.trainSkillBtns, arg0)
	end)

	arg0.curInfoPanel = arg0:findTF("panel/info_bg", arg0.trainWindow)
	arg0.curInfo = arg0:findTF("panel/info_bg/cur", arg0.trainWindow)
	arg0.nextInfo = arg0:findTF("panel/info_bg/next", arg0.trainWindow)
	arg0.msgBox = arg0:findTF("MsgBox")
	arg0.msgContent = arg0:findTF("panel/content", arg0.msgBox)
	arg0.msgBoxMask = arg0:findTF("mengban", arg0.msgBox)
	arg0.cancelBtn = arg0:findTF("panel/cancel_btn", arg0.msgBox)
	arg0.confirmBtn = arg0:findTF("panel/confirm_btn", arg0.msgBox)
	arg0.tipPanel = arg0:findTF("Tip")
	arg0.buffBox = arg0:findTF("BuffBox")
	arg0.buffMask = arg0:findTF("mask", arg0.buffBox)
	arg0.buffIconParent = arg0:findTF("window/panel/icon", arg0.buffBox)
	arg0.buffDescContent = arg0:findTF("window/panel/intro_view/Viewport/Content", arg0.buffBox)
	arg0.buffDescTpl = arg0:findTF("window/panel/intro_view/buff_desc_tpl", arg0.buffBox)
	arg0.singleBuffBox = arg0:findTF("SingleBuffBox")
	arg0.singleBuffMask = arg0:findTF("bg", arg0.singleBuffBox)
	arg0.singleSureBtn = arg0:findTF("window/top/btnBack", arg0.singleBuffBox)
	arg0.singleCloseBtn = arg0:findTF("window/sure_btn", arg0.singleBuffBox)
	arg0.singleIconParent = arg0:findTF("window/panel/icon", arg0.singleBuffBox)
	arg0.singleDescContent = arg0:findTF("window/panel/intro_view/Viewport/Content", arg0.singleBuffBox)
	arg0.singleDescTpl = arg0:findTF("window/panel/intro_view/buff_desc_tpl", arg0.singleBuffBox)

	setText(arg0:findTF("window/top/bg/infomation/title", arg0.singleBuffBox), i18n("words_information"))
	setText(arg0:findTF("window/sure_btn/pic", arg0.singleBuffBox), i18n("text_confirm"))
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setActive(arg0.bg, true)
	removeOnButton(arg0.getBtn)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getData()

		if var1.type == DROP_TYPE_RESOURCE and var1.id == PlayerConst.ResGold and var2:GoldMax(var1.count) then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			arg0.isShowEffect = true

			local var0 = arg0.ptData:CanTrain() and arg0.ptData:isInBuffTime()

			local function var1()
				if var0 then
					arg0:showUpEffect()
				else
					arg0:updateLevelPanel()
				end
			end

			local var2, var3 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var3,
				callback = var1
			})
		end)
	end, SFX_PANEL)
	removeOnButton(arg0.battleBtn)
	onButton(arg0, arg0.battleBtn, function()
		local var0
		local var1

		if arg0.activity:getConfig("config_client") ~= "" then
			var0 = arg0.activity:getConfig("config_client").linkActID

			if var0 then
				var1 = getProxy(ActivityProxy):getActivityById(var0)
			end
		end

		if not var0 then
			arg0:emit(ActivityMediator.BATTLE_OPERA)
		elseif var1 and not var1:isEnd() then
			arg0:emit(ActivityMediator.BATTLE_OPERA)
		else
			arg0:showTip(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("doa_pt_help")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.buffModule, function()
		arg0:showBuffBox()
	end, SFX_PANEL)

	if arg0.contextData.singleActivity then
		setActive(arg0.bg, false)
		arg0:showSingleBuffBox()
	end

	arg0.starEffect:GetComponent("DftAniEvent"):SetEndEvent(function()
		arg0:updateLevelPanel()
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:showTrianPanel()
			setActive(arg0.starEffect, false)
			setActive(arg0.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0.mask, arg0.bg)
		end, 0.2, nil)
	end)
	arg0.shieldEffect:GetComponent("DftAniEvent"):SetEndEvent(function()
		arg0:updateLevelPanel()
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:showTrianPanel()
			setActive(arg0.starEffect, false)
			setActive(arg0.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0.mask, arg0.bg)
		end, 0.2, nil)
	end)

	arg0.isShowEffect = false
end

function var0.showUpEffect(arg0, arg1)
	setSlider(arg0.curPanel, 0, 1, 1)

	local var0 = arg0.ptData:GetBuffLevelProgress()

	if var0 == 8 or var0 == 9 then
		setActive(arg0.starEffect, true)
		arg0.starEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	else
		setActive(arg0.shieldEffect, true)
		arg0.shieldEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	end

	setActive(arg0.mask, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.mask)
end

function var0.updateLevelPanel(arg0)
	local var0, var1 = arg0.ptData:GetBuffLevelProgress()

	setActive(arg0.f2aPanel, false)
	setActive(arg0.sPanel, false)
	setActive(arg0.sssPanel, false)

	arg0.curPanel = nil

	if var0 == 9 then
		arg0.curPanel = arg0.sssPanel
	elseif var0 > 6 then
		arg0.curPanel = arg0.sPanel
	else
		arg0.curPanel = arg0.f2aPanel
	end

	setActive(arg0.curPanel, true)
	setImageSprite(arg0:findTF("bar", arg0.curPanel), arg0.lvBarImages:Find(var0):GetComponent(typeof(Image)).sprite)
	setImageSprite(arg0:findTF("lv_tag", arg0.curPanel), arg0.lvTagImages:Find(var0):GetComponent(typeof(Image)).sprite, true)
	setSlider(arg0.curPanel, 0, 1, var1)

	return arg0.curPanel
end

function var0.OnUpdateFlush(arg0)
	setActive(arg0.starEffect, false)
	setActive(arg0.shieldEffect, false)

	local var0 = arg0.ptData:CanTrain()

	if var0 and var0 <= arg0.ptData.level and arg0.ptData:isInBuffTime() and not arg0.contextData.singleActivity and not arg0.isShowEffect then
		arg0:showTrianPanel()
	end

	local var1, var2, var3 = arg0.ptData:GetLevelProgress()
	local var4, var5, var6 = arg0.ptData:GetResProgress()

	setText(arg0.step, var1 .. "/" .. var2)
	setText(arg0.progress, (var6 >= 1 and setColorStr(var4, COLOR_GREEN) or var4) .. "/" .. var5)
	setSlider(arg0.slider, 0, 1, var6)

	if not arg0.isShowEffect then
		arg0:updateLevelPanel()
	end

	local var7 = arg0.ptData:CanGetAward()
	local var8 = arg0.ptData:CanGetNextAward()
	local var9 = arg0.ptData:CanGetMorePt()
	local var10 = arg0.ptData:CanTrain()

	setActive(arg0.battleBtn, var9 and not var7 and var8)
	setActive(arg0.getBtn, var7)
	setActive(arg0.getGreyBtn, not var7)
	setActive(arg0.gotBtn, not var8 and not var10)
	setActive(arg0.buffModule, arg0.ptData:isInBuffTime())

	local var11 = arg0.ptData:GetAward()

	updateDrop(arg0.awardTF, var11)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var11)
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.ptData:GetCurBuffInfos()) do
		setText(arg0.buffLvs[iter1.group], iter1.next and "LV." .. iter1.lv or "MAX")
	end
end

function var0.showTrianPanel(arg0)
	setActive(arg0.trainWindow, true)

	local var0 = arg0.ptData:GetCurBuffInfos()

	arg0.selectIndex = nil
	arg0.selectBuffId = nil
	arg0.selectBuffLv = nil
	arg0.selectNewBuffId = nil

	for iter0, iter1 in ipairs(arg0.trainSkillBtns) do
		onButton(arg0, iter1, function()
			for iter0, iter1 in ipairs(var0) do
				if iter0 == iter1.group then
					if iter1.next then
						arg0.selectIndex = iter0
						arg0.selectBuffId = iter1.id
						arg0.selectNewBuffId = iter1.next
						arg0.selectBuffLv = iter1.lv
					else
						arg0.selectIndex = nil
						arg0.selectBuffId = nil
						arg0.selectNewBuffId = nil
						arg0.selectBuffLv = nil
					end
				end
			end

			arg0:flushTrainPanel()
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.trainBtn, function()
		arg0:showMsgBox()
	end, SFX_PANEL)
	;(function()
		for iter0, iter1 in ipairs(var0) do
			if iter1.next then
				arg0.selectIndex = iter1.group
				arg0.selectBuffId = iter1.id
				arg0.selectNewBuffId = iter1.next
				arg0.selectBuffLv = iter1.lv

				return
			end
		end
	end)()
	arg0:flushTrainPanel()
end

function var0.hideTrianPanel(arg0)
	setActive(arg0.trainWindow, false)
end

function var0.flushTrainPanel(arg0)
	local var0 = arg0.ptData:GetCurBuffInfos()

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			setText(arg0:findTF("lv_bg/lv", arg0.trainSkillBtns[iter1.group]), iter1.next and "LV." .. iter1.lv or "MAX")
		end
	end

	for iter2, iter3 in ipairs(arg0.trainSkillBtns) do
		if iter2 == arg0.selectIndex then
			setActive(arg0:findTF("selected", iter3), true)
		else
			setActive(arg0:findTF("selected", iter3), false)
		end
	end

	if arg0.selectIndex then
		setActive(arg0.curInfoPanel, true)
		setActive(arg0.trainBtn, true)
		setText(arg0.curInfo, pg.benefit_buff_template[arg0.selectBuffId].desc)
		setText(arg0.nextInfo, pg.benefit_buff_template[arg0.selectNewBuffId].desc)
	else
		setActive(arg0.curInfoPanel, false)
		setActive(arg0.trainBtn, false)
	end
end

function var0.getBuffNameIndex(arg0, arg1)
	if arg1 == 35 or arg1 == 36 or arg1 == 37 then
		return 1
	elseif arg1 == 38 or arg1 == 39 or arg1 == 40 then
		return 2
	elseif arg1 == 41 or arg1 == 42 or arg1 == 43 then
		return 3
	elseif arg1 == 44 or arg1 == 45 or arg1 == 46 then
		return 4
	end

	return 1
end

function var0.getTip(arg0, arg1)
	if arg1 == 35 or arg1 == 36 or arg1 == 37 then
		return i18n("doa_liliang")
	elseif arg1 == 38 or arg1 == 39 or arg1 == 40 then
		return i18n("doa_jiqiao")
	elseif arg1 == 41 or arg1 == 42 or arg1 == 43 then
		return i18n("doa_tili")
	elseif arg1 == 44 or arg1 == 45 or arg1 == 46 then
		return i18n("doa_meili")
	end

	return ""
end

function var0.showMsgBox(arg0)
	if arg0.selectBuffId then
		setActive(arg0.msgBox, true)
		setText(arg0.msgContent, i18n("doa_pt_up", arg0:getTip(pg.benefit_buff_template[arg0.selectBuffId].id)))
		onButton(arg0, arg0.msgBoxMask, function()
			arg0:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0, arg0.cancelBtn, function()
			arg0:hideMsgBox()
		end, SFX_PANEL)
		onButton(arg0, arg0.confirmBtn, function()
			arg0:hideMsgBox()
			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 3,
				activity_id = arg0.ptData:GetId(),
				arg1 = arg0.ptData:CanTrain(),
				arg2 = arg0.selectNewBuffId,
				oldBuffId = arg0.selectBuffId
			})
			arg0:hideTrianPanel()
			arg0:showTip(i18n("doa_pt_complete"))
		end, SFX_PANEL)
	end
end

function var0.hideMsgBox(arg0)
	setActive(arg0.msgBox, false)
end

function var0.showTip(arg0, arg1)
	local var0 = cloneTplTo(arg0.tipPanel, arg0._tf)

	setActive(var0, true)
	setText(arg0:findTF("Text", var0), arg1)

	var0.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local var1 = GetOrAddComponent(var0, "CanvasGroup")

	Timer.New(function()
		if IsNil(var0) then
			return
		end

		LeanTween.scale(var0, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			LeanTween.scale(var0, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				Destroy(var0)
			end))
		end))
	end, 3):Start()
end

function var0.showBuffBox(arg0)
	setActive(arg0.buffBox, true)
	removeAllChildren(arg0.buffIconParent)

	local var0 = cloneTplTo(arg0:updateLevelPanel(), arg0.buffIconParent)

	setLocalPosition(var0, Vector3(0, 0, 0))
	setLocalScale(var0, Vector3(1.3, 1.3, 1))

	local var1 = arg0.ptData:GetCurBuffInfos()

	if var1 then
		for iter0, iter1 in ipairs(var1) do
			local var2

			if iter0 <= arg0.buffDescContent.childCount then
				var2 = arg0.buffDescContent:GetChild(iter0 - 1)
			else
				var2 = cloneTplTo(arg0.buffDescTpl, arg0.buffDescContent)
			end

			setText(var2, pg.benefit_buff_template[iter1.id].name .. pg.benefit_buff_template[iter1.id].desc)
		end
	end

	onButton(arg0, arg0.buffMask, function()
		setActive(arg0.buffBox, false)
	end, SFX_PANEL)
end

function var0.showSingleBuffBox(arg0)
	setActive(arg0.singleBuffBox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.singleBuffBox, false, {
		overlayType = LayerWeightConst.OVERLAY_UI_TOP
	})
	removeAllChildren(arg0.singleIconParent)

	local var0 = cloneTplTo(arg0:updateLevelPanel(), arg0.singleIconParent)

	setLocalPosition(var0, Vector3(0, 0, 0))
	setLocalScale(var0, Vector3(1.3, 1.3, 1))

	local var1 = arg0.ptData:GetCurBuffInfos()

	if var1 then
		for iter0, iter1 in ipairs(var1) do
			local var2

			if iter0 <= arg0.singleDescContent.childCount then
				var2 = arg0.singleDescContent:GetChild(iter0 - 1)
			else
				var2 = cloneTplTo(arg0.singleDescTpl, arg0.singleDescContent)
			end

			setText(var2, pg.benefit_buff_template[iter1.id].name .. pg.benefit_buff_template[iter1.id].desc)
		end
	end

	local function var3()
		setActive(arg0.singleBuffBox, false)
		arg0:emit(ActivitySingleScene.EXIT)
		arg0:emit(ActivitySingleScene.ON_CLOSE)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.singleBuffBox, arg0._tf)
	end

	onButton(arg0, arg0.singleBuffMask, function()
		var3()
	end, SFX_PANEL)
	onButton(arg0, arg0.singleCloseBtn, function()
		var3()
	end, SFX_PANEL)
	onButton(arg0, arg0.singleSureBtn, function()
		var3()
	end, SFX_PANEL)
end

function var0.onBackPressed(arg0)
	if arg0.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.singleBuffBox, arg0._tf)
	end
end

function var0.willExit(arg0)
	if arg0.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.singleBuffBox, arg0._tf)
	end
end

return var0
