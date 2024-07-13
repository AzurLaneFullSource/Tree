local var0_0 = class("NewCommanderScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GetCommanderUI"
end

function var0_0.init(arg0_2)
	arg0_2.bgTF = arg0_2:findTF("main/bg")
	arg0_2.clickTF = arg0_2:findTF("click")
	arg0_2.paintTF = arg0_2:findTF("main/paint")
	arg0_2.paintTFCG = arg0_2.paintTF:GetComponent(typeof(CanvasGroup))
	arg0_2.infoTF = arg0_2:findTF("main/info")
	arg0_2.leftPanel = arg0_2:findTF("left_panel")
	arg0_2.lockBtn = arg0_2:findTF("left_panel/btns/lock")
	arg0_2.unlockBtn = arg0_2:findTF("left_panel/btns/unlock")
	arg0_2.shareBtn = arg0_2:findTF("left_panel/btns/share")
	arg0_2.nameTF = arg0_2:findTF("content/name/value", arg0_2.infoTF):GetComponent(typeof(Text))
	arg0_2.nationTF = arg0_2:findTF("content/nation/value", arg0_2.infoTF):GetComponent(typeof(Text))
	arg0_2.rarityTF = arg0_2:findTF("content/rarity/value", arg0_2.infoTF):GetComponent(typeof(Image))
	arg0_2.skillTF = arg0_2:findTF("content/skill/value", arg0_2.infoTF):GetComponent(typeof(Text))
	arg0_2.abilitysTF = arg0_2:findTF("content/abilitys/attrs", arg0_2.infoTF)
	arg0_2.talentsTF = arg0_2:findTF("content/talents", arg0_2.infoTF)
	arg0_2.talentsList = UIItemList.New(arg0_2.talentsTF, arg0_2.talentsTF:Find("talent"))
	arg0_2.dateTF = arg0_2:findTF("content/copyright/Text", arg0_2.infoTF)
	arg0_2.treePanel = CommanderTreePage.New(arg0_2._tf, arg0_2.event)
	arg0_2.msgbox = CommanderMsgBoxPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.antor = arg0_2._tf:GetComponent(typeof(Animator))
	arg0_2.skipBtn = arg0_2._tf:Find("skip")
	arg0_2.getEffect = arg0_2:findTF("main/effect")
	arg0_2.skipAnim = true

	if pg.NewGuideMgr.GetInstance():IsBusy() then
		arg0_2.skipAnim = false
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER + 1
	})
	setText(arg0_2:findTF("main/info/content/abilitys/attrs/command/name/Text"), i18n("commander_command_ability"))
	setText(arg0_2:findTF("main/info/content/abilitys/attrs/tactic/name/Text"), i18n("commander_tactical_ability"))
	setText(arg0_2:findTF("main/info/content/abilitys/attrs/support/name/Text"), i18n("commander_logistics_ability"))
	setText(arg0_2:findTF("main/info/content/copyright/title"), i18n("commander_get_commander_coptyright"))
end

function var0_0.openTreePanel(arg0_3, arg1_3)
	local function var0_3()
		arg0_3.treePanel:ActionInvoke("Show", arg1_3, LayerWeightConst.SECOND_LAYER + 2)
	end

	if arg0_3.treePanel:GetLoaded() then
		var0_3()
	else
		arg0_3.treePanel:Load()
		arg0_3.treePanel:CallbackInvoke(var0_3)
	end
end

function var0_0.closeTreePanel(arg0_5)
	arg0_5.treePanel:ActionInvoke("closeTreePanel")
end

function var0_0.onUIAnimEnd(arg0_6, arg1_6)
	arg0_6.antor:SetBool("play", true)

	arg0_6.isAnim = true

	setActive(arg0_6.clickTF, arg0_6.skipAnim)

	local var0_6 = arg0_6._tf:GetComponent(typeof(DftAniEvent))

	var0_6:SetTriggerEvent(function(arg0_7)
		if arg0_6.contextData.commander:isSSR() then
			arg0_6:playerEffect()
		end

		var0_6:SetTriggerEvent(nil)
	end)
	var0_6:SetEndEvent(function()
		arg0_6.isAnim = false

		setActive(arg0_6.clickTF, true)
		var0_6:SetEndEvent(nil)
		arg1_6()
	end)
end

function var0_0.playerEffect(arg0_9)
	PoolMgr.GetInstance():GetUI("AL_zhihuimiao_zhipian", true, function(arg0_10)
		arg0_9.effect = arg0_10

		SetParent(arg0_10, arg0_9._tf)
		setActive(arg0_10, true)
	end)
end

function var0_0.openMsgBox(arg0_11, arg1_11)
	arg0_11.isShowMsgBox = true

	local function var0_11()
		arg0_11.msgbox:ActionInvoke("Show", arg1_11)
	end

	if arg0_11.msgbox:GetLoaded() then
		var0_11()
	else
		arg0_11.msgbox:Load()
		arg0_11.msgbox:CallbackInvoke(var0_11)
	end
end

function var0_0.closeMsgBox(arg0_13)
	arg0_13.isShowMsgBox = nil

	arg0_13.msgbox:ActionInvoke("Hide")
end

function var0_0.didEnter(arg0_14)
	arg0_14:updateInfo()
	onButton(arg0_14, arg0_14.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeCommander, pg.ShareMgr.PANEL_TYPE_PINK, {
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.skipBtn, function(arg0_16)
		if arg0_14.isAnim then
			return
		end

		getProxy(CommanderProxy).hasSkipFlag = true

		arg0_14:DoExit()
	end, SFX_CANCEL)
	onButton(arg0_14, arg0_14.lockBtn, function()
		local var0_17 = getProxy(CommanderProxy):getCommanderById(arg0_14.contextData.commander.id):getLock()

		arg0_14:emit(NewCommanderMediator.ON_LOCK, arg0_14.contextData.commander.id, 1 - var0_17)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.unlockBtn, function()
		local var0_18 = getProxy(CommanderProxy):getCommanderById(arg0_14.contextData.commander.id):getLock()

		arg0_14:emit(NewCommanderMediator.ON_LOCK, arg0_14.contextData.commander.id, 1 - var0_18)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.clickTF, function()
		if arg0_14.isAnim then
			arg0_14.antor:SetBool("play", false)

			if arg0_14.contextData.commander:isSSR() and not arg0_14.effect then
				arg0_14:playerEffect()
			end

			arg0_14.isAnim = nil
		else
			arg0_14:DoExit()
		end
	end, SFX_CANCEL)
end

function var0_0.DoExit(arg0_20)
	if arg0_20.contextData.commander:ShouldTipLock() then
		arg0_20:openMsgBox({
			content = i18n("commander_lock_tip"),
			onYes = function()
				arg0_20:emit(NewCommanderMediator.ON_LOCK, arg0_20.contextData.commander.id, 1)
				arg0_20:emit(var0_0.ON_CLOSE)
			end,
			layer = LayerWeightConst.SECOND_LAYER + 2,
			onNo = function()
				arg0_20:emit(var0_0.ON_CLOSE)
			end
		})
	else
		arg0_20:emit(var0_0.ON_CLOSE)
	end
end

function var0_0.updateLockState(arg0_23)
	local var0_23 = getProxy(CommanderProxy):getCommanderById(arg0_23.contextData.commander.id):getLock()

	setActive(arg0_23.lockBtn, var0_23 ~= 0)
	setActive(arg0_23.unlockBtn, var0_23 == 0)
end

function var0_0.updateInfo(arg0_24, arg1_24)
	local var0_24 = arg0_24.contextData.commander

	arg0_24:updateLockState(var0_24:getLock())

	arg0_24.nameTF.text = var0_24:getName()
	arg0_24.nationTF.text = Nation.Nation2Name(var0_24:getConfig("nationality"))

	local var1_24 = var0_24:getSkills()[1]

	arg0_24.skillTF.text = var1_24:getConfig("name")

	local var2_24 = Commander.rarity2Print(var0_24:getRarity())

	LoadImageSpriteAsync("CommanderRarity/" .. var2_24, arg0_24.rarityTF, true)
	setCommanderPaintingPrefab(arg0_24.paintTF, var0_24:getPainting(), "get")

	arg0_24.painting = var0_24

	arg0_24:updateAbilitys()
	arg0_24:updateTalents()
	setText(arg0_24.dateTF, pg.TimeMgr.GetInstance():CurrentSTimeDesc("%y%m%d"))

	if arg1_24 then
		arg1_24()
	end
end

function var0_0.updateAbilitys(arg0_25)
	local var0_25 = arg0_25.contextData.commander:getAbilitys()

	eachChild(arg0_25.abilitysTF, function(arg0_26)
		local var0_26 = go(arg0_26).name
		local var1_26 = var0_25[var0_26]

		setText(arg0_26:Find("slider/point"), var1_26.value)

		arg0_26:Find("slider"):GetComponent(typeof(Slider)).value = var1_26.value / CommanderConst.MAX_ABILITY
	end)
end

function var0_0.updateTalents(arg0_27)
	local var0_27 = arg0_27.contextData.commander:getTalents()

	arg0_27.talentsList:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = var0_27[arg1_28 + 1]

			setActive(arg2_28:Find("empty"), not var0_28)
			setActive(arg2_28:Find("icon"), var0_28)

			if var0_28 then
				GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0_28:getConfig("icon"), "", arg2_28:Find("icon"))
			end

			onButton(arg0_27, arg2_28, function()
				arg0_27:openTreePanel(var0_28)
			end, SFX_PANEL)
		end
	end)
	arg0_27.talentsList:align(3)
end

function var0_0.onBackPressed(arg0_30)
	if arg0_30.isShowMsgBox then
		arg0_30:closeMsgBox()

		return
	end
end

function var0_0.willExit(arg0_31)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_31._tf, pg.UIMgr.GetInstance().UIMain)
	arg0_31.treePanel:Destroy()
	arg0_31.msgbox:Destroy()
	retCommanderPaintingPrefab(arg0_31.paintTF, arg0_31.painting:getPainting())

	if arg0_31.effect then
		PoolMgr.GetInstance():ReturnUI("AL_zhihuimiao_zhipian", arg0_31.effect)
	end

	if arg0_31.contextData.onExit then
		arg0_31.contextData.onExit()
	end
end

return var0_0
