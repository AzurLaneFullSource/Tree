local var0 = class("NewCommanderScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "GetCommanderUI"
end

function var0.init(arg0)
	arg0.bgTF = arg0:findTF("main/bg")
	arg0.clickTF = arg0:findTF("click")
	arg0.paintTF = arg0:findTF("main/paint")
	arg0.paintTFCG = arg0.paintTF:GetComponent(typeof(CanvasGroup))
	arg0.infoTF = arg0:findTF("main/info")
	arg0.leftPanel = arg0:findTF("left_panel")
	arg0.lockBtn = arg0:findTF("left_panel/btns/lock")
	arg0.unlockBtn = arg0:findTF("left_panel/btns/unlock")
	arg0.shareBtn = arg0:findTF("left_panel/btns/share")
	arg0.nameTF = arg0:findTF("content/name/value", arg0.infoTF):GetComponent(typeof(Text))
	arg0.nationTF = arg0:findTF("content/nation/value", arg0.infoTF):GetComponent(typeof(Text))
	arg0.rarityTF = arg0:findTF("content/rarity/value", arg0.infoTF):GetComponent(typeof(Image))
	arg0.skillTF = arg0:findTF("content/skill/value", arg0.infoTF):GetComponent(typeof(Text))
	arg0.abilitysTF = arg0:findTF("content/abilitys/attrs", arg0.infoTF)
	arg0.talentsTF = arg0:findTF("content/talents", arg0.infoTF)
	arg0.talentsList = UIItemList.New(arg0.talentsTF, arg0.talentsTF:Find("talent"))
	arg0.dateTF = arg0:findTF("content/copyright/Text", arg0.infoTF)
	arg0.treePanel = CommanderTreePage.New(arg0._tf, arg0.event)
	arg0.msgbox = CommanderMsgBoxPage.New(arg0._tf, arg0.event)
	arg0.antor = arg0._tf:GetComponent(typeof(Animator))
	arg0.skipBtn = arg0._tf:Find("skip")
	arg0.getEffect = arg0:findTF("main/effect")
	arg0.skipAnim = true

	if pg.NewGuideMgr.GetInstance():IsBusy() then
		arg0.skipAnim = false
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER + 1
	})
	setText(arg0:findTF("main/info/content/abilitys/attrs/command/name/Text"), i18n("commander_command_ability"))
	setText(arg0:findTF("main/info/content/abilitys/attrs/tactic/name/Text"), i18n("commander_tactical_ability"))
	setText(arg0:findTF("main/info/content/abilitys/attrs/support/name/Text"), i18n("commander_logistics_ability"))
	setText(arg0:findTF("main/info/content/copyright/title"), i18n("commander_get_commander_coptyright"))
end

function var0.openTreePanel(arg0, arg1)
	local function var0()
		arg0.treePanel:ActionInvoke("Show", arg1, LayerWeightConst.SECOND_LAYER + 2)
	end

	if arg0.treePanel:GetLoaded() then
		var0()
	else
		arg0.treePanel:Load()
		arg0.treePanel:CallbackInvoke(var0)
	end
end

function var0.closeTreePanel(arg0)
	arg0.treePanel:ActionInvoke("closeTreePanel")
end

function var0.onUIAnimEnd(arg0, arg1)
	arg0.antor:SetBool("play", true)

	arg0.isAnim = true

	setActive(arg0.clickTF, arg0.skipAnim)

	local var0 = arg0._tf:GetComponent(typeof(DftAniEvent))

	var0:SetTriggerEvent(function(arg0)
		if arg0.contextData.commander:isSSR() then
			arg0:playerEffect()
		end

		var0:SetTriggerEvent(nil)
	end)
	var0:SetEndEvent(function()
		arg0.isAnim = false

		setActive(arg0.clickTF, true)
		var0:SetEndEvent(nil)
		arg1()
	end)
end

function var0.playerEffect(arg0)
	PoolMgr.GetInstance():GetUI("AL_zhihuimiao_zhipian", true, function(arg0)
		arg0.effect = arg0

		SetParent(arg0, arg0._tf)
		setActive(arg0, true)
	end)
end

function var0.openMsgBox(arg0, arg1)
	arg0.isShowMsgBox = true

	local function var0()
		arg0.msgbox:ActionInvoke("Show", arg1)
	end

	if arg0.msgbox:GetLoaded() then
		var0()
	else
		arg0.msgbox:Load()
		arg0.msgbox:CallbackInvoke(var0)
	end
end

function var0.closeMsgBox(arg0)
	arg0.isShowMsgBox = nil

	arg0.msgbox:ActionInvoke("Hide")
end

function var0.didEnter(arg0)
	arg0:updateInfo()
	onButton(arg0, arg0.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeCommander, pg.ShareMgr.PANEL_TYPE_PINK, {
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.skipBtn, function(arg0)
		if arg0.isAnim then
			return
		end

		getProxy(CommanderProxy).hasSkipFlag = true

		arg0:DoExit()
	end, SFX_CANCEL)
	onButton(arg0, arg0.lockBtn, function()
		local var0 = getProxy(CommanderProxy):getCommanderById(arg0.contextData.commander.id):getLock()

		arg0:emit(NewCommanderMediator.ON_LOCK, arg0.contextData.commander.id, 1 - var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.unlockBtn, function()
		local var0 = getProxy(CommanderProxy):getCommanderById(arg0.contextData.commander.id):getLock()

		arg0:emit(NewCommanderMediator.ON_LOCK, arg0.contextData.commander.id, 1 - var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.clickTF, function()
		if arg0.isAnim then
			arg0.antor:SetBool("play", false)

			if arg0.contextData.commander:isSSR() and not arg0.effect then
				arg0:playerEffect()
			end

			arg0.isAnim = nil
		else
			arg0:DoExit()
		end
	end, SFX_CANCEL)
end

function var0.DoExit(arg0)
	if arg0.contextData.commander:ShouldTipLock() then
		arg0:openMsgBox({
			content = i18n("commander_lock_tip"),
			onYes = function()
				arg0:emit(NewCommanderMediator.ON_LOCK, arg0.contextData.commander.id, 1)
				arg0:emit(var0.ON_CLOSE)
			end,
			layer = LayerWeightConst.SECOND_LAYER + 2,
			onNo = function()
				arg0:emit(var0.ON_CLOSE)
			end
		})
	else
		arg0:emit(var0.ON_CLOSE)
	end
end

function var0.updateLockState(arg0)
	local var0 = getProxy(CommanderProxy):getCommanderById(arg0.contextData.commander.id):getLock()

	setActive(arg0.lockBtn, var0 ~= 0)
	setActive(arg0.unlockBtn, var0 == 0)
end

function var0.updateInfo(arg0, arg1)
	local var0 = arg0.contextData.commander

	arg0:updateLockState(var0:getLock())

	arg0.nameTF.text = var0:getName()
	arg0.nationTF.text = Nation.Nation2Name(var0:getConfig("nationality"))

	local var1 = var0:getSkills()[1]

	arg0.skillTF.text = var1:getConfig("name")

	local var2 = Commander.rarity2Print(var0:getRarity())

	LoadImageSpriteAsync("CommanderRarity/" .. var2, arg0.rarityTF, true)
	setCommanderPaintingPrefab(arg0.paintTF, var0:getPainting(), "get")

	arg0.painting = var0

	arg0:updateAbilitys()
	arg0:updateTalents()
	setText(arg0.dateTF, pg.TimeMgr.GetInstance():CurrentSTimeDesc("%y%m%d"))

	if arg1 then
		arg1()
	end
end

function var0.updateAbilitys(arg0)
	local var0 = arg0.contextData.commander:getAbilitys()

	eachChild(arg0.abilitysTF, function(arg0)
		local var0 = go(arg0).name
		local var1 = var0[var0]

		setText(arg0:Find("slider/point"), var1.value)

		arg0:Find("slider"):GetComponent(typeof(Slider)).value = var1.value / CommanderConst.MAX_ABILITY
	end)
end

function var0.updateTalents(arg0)
	local var0 = arg0.contextData.commander:getTalents()

	arg0.talentsList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setActive(arg2:Find("empty"), not var0)
			setActive(arg2:Find("icon"), var0)

			if var0 then
				GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0:getConfig("icon"), "", arg2:Find("icon"))
			end

			onButton(arg0, arg2, function()
				arg0:openTreePanel(var0)
			end, SFX_PANEL)
		end
	end)
	arg0.talentsList:align(3)
end

function var0.onBackPressed(arg0)
	if arg0.isShowMsgBox then
		arg0:closeMsgBox()

		return
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
	arg0.treePanel:Destroy()
	arg0.msgbox:Destroy()
	retCommanderPaintingPrefab(arg0.paintTF, arg0.painting:getPainting())

	if arg0.effect then
		PoolMgr.GetInstance():ReturnUI("AL_zhihuimiao_zhipian", arg0.effect)
	end

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
