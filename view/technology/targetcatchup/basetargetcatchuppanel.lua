local var0 = class("BaseTargetCatchupPanel", import("...base.BaseUI"))

var0.SELECT_CHAR_LIGHT_FADE_TIME = 0.3

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0)
	PoolMgr.GetInstance():GetUI(arg0:getUIName(), true, function(arg0)
		arg0.transform:SetParent(arg1, false)
		arg0:onUILoaded(arg0)

		if arg2 then
			arg2()
		end
	end)
end

function var0.getUIName(arg0)
	assert(false)

	return ""
end

function var0.init(arg0)
	return
end

function var0.initData(arg0)
	arg0.curSelectedIndex = 0
	arg0.technologyProxy = getProxy(TechnologyProxy)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.bagProxy = getProxy(BagProxy)
	arg0.configCatchup = pg.technology_catchup_template
	arg0.charIDList = arg0.configCatchup[arg0.tecID].char_choice
	arg0.urList = arg0.configCatchup[arg0.tecID].ur_char
	arg0.state = arg0.technologyProxy:getCatchupState(arg0.tecID)
end

function var0.initUI(arg0)
	arg0.choosePanel = arg0:findTF("ChoosePanel")

	local var0 = arg0:findTF("SelectedImgTpl", arg0.choosePanel)
	local var1 = arg0:findTF("SelectedImgList", arg0.choosePanel)

	arg0.selectedImgUIItemList = UIItemList.New(var1, var0)

	arg0.selectedImgUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0:findTF("Selected", arg2)

			setActive(var0, arg1 == arg0.curSelectedIndex)

			if arg1 == arg0.curSelectedIndex then
				setImageAlpha(var0, 0)
				arg0:updateProgress(arg0.charIDList[arg0.curSelectedIndex])
				arg0:managedTween(LeanTween.alpha, nil, rtf(var0), 1, var0.SELECT_CHAR_LIGHT_FADE_TIME):setFrom(0)
			end
		end
	end)
	arg0.selectedImgUIItemList:align(#arg0.charIDList)

	local var2 = arg0:findTF("CharTpl", arg0.choosePanel)
	local var3 = arg0:findTF("CharList", arg0.choosePanel)

	arg0.charUIItemList = UIItemList.New(var3, var2)

	arg0.charUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			arg0:updateCharTpl(arg1, arg2)
			onButton(arg0, arg2, function()
				if arg1 ~= arg0.curSelectedIndex then
					arg0.curSelectedIndex = arg1

					arg0.selectedImgUIItemList:align(#arg0.charIDList)
				end
			end, SFX_PANEL)
		end
	end)
	arg0.charUIItemList:align(#arg0.charIDList)

	arg0.confirmBtn = arg0:findTF("ConfirmBtn", arg0.choosePanel)

	onButton(arg0, arg0.confirmBtn, function()
		if arg0.curSelectedIndex and arg0.curSelectedIndex ~= 0 then
			local var0 = arg0.charIDList[arg0.curSelectedIndex]

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tec_target_catchup_select_tip", ShipGroup.getDefaultShipNameByGroupID(var0)),
				onYes = function()
					pg.m02:sendNotification(GAME.SELECT_TEC_TARGET_CATCHUP, {
						tecID = arg0.tecID,
						charID = var0
					})
				end
			})
		end
	end, SFX_PANEL)

	arg0.proTitle = arg0:findTF("ProgressTitle/Text", arg0.choosePanel)

	setText(arg0.proTitle, i18n("tec_target_catchup_progress"))

	arg0.ssrProgress = arg0:findTF("ProgressTitle/Progress_SSR", arg0.choosePanel)
	arg0.urProgress = arg0:findTF("ProgressTitle/Progress_UR", arg0.choosePanel)
	arg0.showPanel = arg0:findTF("ShowPanel", arg0.targetCatchupPanel)
	arg0.showBG = arg0:findTF("BG", arg0.showPanel)
	arg0.nameText = arg0:findTF("NameText", arg0.showPanel)
	arg0.progressText = arg0:findTF("Progress/ProgressText", arg0.showPanel)
	arg0.tipText = arg0:findTF("Progress/Text", arg0.showPanel)

	setText(arg0.tipText, i18n("tec_target_catchup_progress"))

	arg0.selectedImg = arg0:findTF("Selected", arg0.showPanel)
	arg0.giveupBtn = arg0:findTF("GiveupBtn", arg0.showPanel)
	arg0.finishedImg = arg0:findTF("Finished", arg0.showPanel)
	arg0.helpBtn = arg0:findTF("HelpBtn", arg0.targetCatchupPanel)

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tec_target_catchup_help_tip.tip
		})
	end, SFX_PANEL)
	setText(arg0:findTF("FinishAll/BG/Text", arg0.choosePanel), i18n("tec_target_catchup_all_finish_tip"))
	setText(arg0:findTF("CharListBG/SSRTag/Text", arg0.choosePanel), i18n("tec_target_catchup_pry_char"))

	if #arg0.urList > 0 then
		setText(arg0:findTF("FinishPart/BG/Text", arg0.choosePanel), i18n("tec_target_catchup_dr_finish_tip"))
		setText(arg0:findTF("CharListBG/URTag/Text", arg0.choosePanel), i18n("tec_target_catchup_dr_char"))
	end

	for iter0, iter1 in ipairs(arg0.urList) do
		setText(arg0:findTF("Finish_" .. iter1 .. "/BG/Text", arg0.choosePanel), i18n("tec_target_catchup_dr_finish_tip"))
	end
end

function var0.updateTargetCatchupPage(arg0)
	arg0.state = arg0.technologyProxy:getCatchupState(arg0.tecID)

	if arg0.state == TechnologyCatchup.STATE_CATCHUPING then
		arg0:updateShowPanel()
	else
		arg0:updateChoosePanel()
	end
end

function var0.updateCharTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("PrintNum/Text", arg2)

	setText(var0, i18n("tec_target_need_print"))

	local var1 = arg0:findTF("PrintNum/NumText", arg2)
	local var2 = arg0:findTF("NameText", arg2)
	local var3 = arg0:findTF("LevelText", arg2)
	local var4 = arg0:findTF("NotGetTag", arg2)
	local var5 = arg0.charIDList[arg1]
	local var6 = arg0.bayProxy:findShipByGroup(var5)
	local var7 = arg0.technologyProxy:getBluePrintVOByGroupID(var5)
	local var8 = pg.ship_data_blueprint[var5].strengthen_item
	local var9 = var6 and math.floor(arg0:getShipBluePrintCurExp(var7) / Item.getConfigData(var8).usage_arg[1]) or 0
	local var10 = arg0.configCatchup[arg0.tecID].blueprint_max[arg1]
	local var11 = arg0.bagProxy:getItemCountById(var8)
	local var12 = math.max(var10 - var9 - var11, 0)

	setText(var1, var12)

	local var13 = ShipGroup.getDefaultShipNameByGroupID(var5)

	setText(var2, var13)
	setActive(var3, var6)
	setActive(var4, not var6)

	if var6 then
		local var14 = arg0.technologyProxy:getBluePrintVOByGroupID(var5)

		setText(var3, "Lv. " .. var14.level .. "/" .. var14:getMaxLevel())
	end
end

function var0.updateShowPanel(arg0)
	setActive(arg0.showPanel, true)
	setActive(arg0.choosePanel, false)

	local var0 = arg0.technologyProxy:getCurCatchupTecInfo()
	local var1 = var0.tecID
	local var2 = var0.groupID
	local var3 = var0.printNum

	setImageSprite(arg0.showBG, LoadSprite("TecCatchup/selbg" .. var2, var2))

	local var4 = ShipGroup.getDefaultShipNameByGroupID(var2)

	setText(arg0.nameText, var4)
	setText(arg0.progressText, var3 .. "/" .. arg0:getMaxNum(var2))

	local var5 = arg0.state == TechnologyCatchup.STATE_FINISHED_ALL

	setActive(arg0.finishedImg, var5)
	setActive(arg0.selectedImg, not var5)
	onButton(arg0, arg0.selectedImg, function()
		arg0:updateChoosePanel()
		setActive(arg0:findTF("ProgressTitle", arg0.choosePanel), false)
	end, SFX_PANEL)
end

function var0.updateChoosePanel(arg0)
	setActive(arg0.showPanel, false)
	setActive(arg0.choosePanel, true)

	local var0 = arg0.technologyProxy:getCatchupData(arg0.tecID)

	if arg0.state == TechnologyCatchup.STATE_FINISHED_ALL then
		setActive(arg0:findTF("FinishAll", arg0.choosePanel), true)
		setActive(arg0:findTF("ProgressTitle", arg0.choosePanel), false)
	elseif #arg0.urList > 0 then
		setActive(arg0:findTF("FinishAll", arg0.choosePanel), false)

		local var1 = var0:isFinishSSR()

		setActive(arg0:findTF("FinishPart", arg0.choosePanel), var1)

		for iter0, iter1 in ipairs(arg0.urList) do
			local var2 = var0:isFinish(iter1)

			setActive(arg0:findTF("Finish_" .. iter1, arg0.choosePanel), var2)
		end
	end
end

function var0.updateProgress(arg0, arg1)
	setActive(arg0:findTF("ProgressTitle", arg0.choosePanel), true)

	local var0 = arg0.technologyProxy:getCatchupData(arg0.tecID):getTargetNum(arg1)
	local var1 = arg0:getMaxNum(arg1)

	if arg0:isUR(arg1) then
		setActive(arg0.urProgress, true)
		setActive(arg0.ssrProgress, false)
		setText(arg0:findTF("Text", arg0.urProgress), var0 .. "/" .. var1)
	else
		setActive(arg0.urProgress, false)
		setActive(arg0.ssrProgress, true)
		setText(arg0:findTF("Text", arg0.ssrProgress), var0 .. "/" .. var1)
	end
end

function var0.isUR(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.urList) do
		if arg1 == iter1 then
			return true
		end
	end

	return false
end

function var0.getMaxNum(arg0, arg1)
	return arg0:isUR(arg1) and pg.technology_catchup_template[arg0.tecID].obtain_max_per_ur or pg.technology_catchup_template[arg0.tecID].obtain_max
end

function var0.willExit(arg0)
	PoolMgr.GetInstance():ReturnUI(arg0:getUIName(), arg0._go)
end

function var0.getShipBluePrintCurExp(arg0, arg1)
	local var0 = arg1.level
	local var1 = arg1.fateLevel
	local var2 = arg1.exp
	local var3 = arg1:getConfig("strengthen_effect")
	local var4 = arg1:getConfig("fate_strengthen")
	local var5 = 0 + var2

	for iter0 = 1, var0 do
		var5 = var5 + pg.ship_strengthen_blueprint[var3[iter0]].need_exp
	end

	for iter1 = 1, var1 do
		var5 = var5 + pg.ship_strengthen_blueprint[var4[iter1]].need_exp
	end

	return var5
end

return var0
