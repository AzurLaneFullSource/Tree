local var0_0 = class("BaseTargetCatchupPanel", import("...base.BaseUI"))

var0_0.SELECT_CHAR_LIGHT_FADE_TIME = 0.3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)
	PoolMgr.GetInstance():GetUI(arg0_1:getUIName(), true, function(arg0_2)
		arg0_2.transform:SetParent(arg1_1, false)
		arg0_1:onUILoaded(arg0_2)

		if arg2_1 then
			arg2_1()
		end
	end)
end

function var0_0.getUIName(arg0_3)
	assert(false)

	return ""
end

function var0_0.init(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.curSelectedIndex = 0
	arg0_5.technologyProxy = getProxy(TechnologyProxy)
	arg0_5.bayProxy = getProxy(BayProxy)
	arg0_5.bagProxy = getProxy(BagProxy)
	arg0_5.configCatchup = pg.technology_catchup_template
	arg0_5.charIDList = arg0_5.configCatchup[arg0_5.tecID].char_choice
	arg0_5.urList = arg0_5.configCatchup[arg0_5.tecID].ur_char
	arg0_5.state = arg0_5.technologyProxy:getCatchupState(arg0_5.tecID)
end

function var0_0.initUI(arg0_6)
	arg0_6.choosePanel = arg0_6:findTF("ChoosePanel")

	local var0_6 = arg0_6:findTF("SelectedImgTpl", arg0_6.choosePanel)
	local var1_6 = arg0_6:findTF("SelectedImgList", arg0_6.choosePanel)

	arg0_6.selectedImgUIItemList = UIItemList.New(var1_6, var0_6)

	arg0_6.selectedImgUIItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg1_7 = arg1_7 + 1

			local var0_7 = arg0_6:findTF("Selected", arg2_7)

			setActive(var0_7, arg1_7 == arg0_6.curSelectedIndex)

			if arg1_7 == arg0_6.curSelectedIndex then
				setImageAlpha(var0_7, 0)
				arg0_6:updateProgress(arg0_6.charIDList[arg0_6.curSelectedIndex])
				arg0_6:managedTween(LeanTween.alpha, nil, rtf(var0_7), 1, var0_0.SELECT_CHAR_LIGHT_FADE_TIME):setFrom(0)
			end
		end
	end)
	arg0_6.selectedImgUIItemList:align(#arg0_6.charIDList)

	local var2_6 = arg0_6:findTF("CharTpl", arg0_6.choosePanel)
	local var3_6 = arg0_6:findTF("CharList", arg0_6.choosePanel)

	arg0_6.charUIItemList = UIItemList.New(var3_6, var2_6)

	arg0_6.charUIItemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg1_8 = arg1_8 + 1

			arg0_6:updateCharTpl(arg1_8, arg2_8)
			onButton(arg0_6, arg2_8, function()
				if arg1_8 ~= arg0_6.curSelectedIndex then
					arg0_6.curSelectedIndex = arg1_8

					arg0_6.selectedImgUIItemList:align(#arg0_6.charIDList)
				end
			end, SFX_PANEL)
		end
	end)
	arg0_6.charUIItemList:align(#arg0_6.charIDList)

	arg0_6.confirmBtn = arg0_6:findTF("ConfirmBtn", arg0_6.choosePanel)

	onButton(arg0_6, arg0_6.confirmBtn, function()
		if arg0_6.curSelectedIndex and arg0_6.curSelectedIndex ~= 0 then
			local var0_10 = arg0_6.charIDList[arg0_6.curSelectedIndex]

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tec_target_catchup_select_tip", ShipGroup.getDefaultShipNameByGroupID(var0_10)),
				onYes = function()
					pg.m02:sendNotification(GAME.SELECT_TEC_TARGET_CATCHUP, {
						tecID = arg0_6.tecID,
						charID = var0_10
					})
				end
			})
		end
	end, SFX_PANEL)

	arg0_6.proTitle = arg0_6:findTF("ProgressTitle/Text", arg0_6.choosePanel)

	setText(arg0_6.proTitle, i18n("tec_target_catchup_progress"))

	arg0_6.ssrProgress = arg0_6:findTF("ProgressTitle/Progress_SSR", arg0_6.choosePanel)
	arg0_6.urProgress = arg0_6:findTF("ProgressTitle/Progress_UR", arg0_6.choosePanel)
	arg0_6.showPanel = arg0_6:findTF("ShowPanel", arg0_6.targetCatchupPanel)
	arg0_6.showBG = arg0_6:findTF("BG", arg0_6.showPanel)
	arg0_6.nameText = arg0_6:findTF("NameText", arg0_6.showPanel)
	arg0_6.progressText = arg0_6:findTF("Progress/ProgressText", arg0_6.showPanel)
	arg0_6.tipText = arg0_6:findTF("Progress/Text", arg0_6.showPanel)

	setText(arg0_6.tipText, i18n("tec_target_catchup_progress"))

	arg0_6.selectedImg = arg0_6:findTF("Selected", arg0_6.showPanel)
	arg0_6.giveupBtn = arg0_6:findTF("GiveupBtn", arg0_6.showPanel)
	arg0_6.finishedImg = arg0_6:findTF("Finished", arg0_6.showPanel)
	arg0_6.helpBtn = arg0_6:findTF("HelpBtn", arg0_6.targetCatchupPanel)

	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tec_target_catchup_help_tip.tip
		})
	end, SFX_PANEL)
	setText(arg0_6:findTF("FinishAll/BG/Text", arg0_6.choosePanel), i18n("tec_target_catchup_all_finish_tip"))
	setText(arg0_6:findTF("CharListBG/SSRTag/Text", arg0_6.choosePanel), i18n("tec_target_catchup_pry_char"))

	if #arg0_6.urList > 0 then
		setText(arg0_6:findTF("FinishPart/BG/Text", arg0_6.choosePanel), i18n("tec_target_catchup_dr_finish_tip"))
		setText(arg0_6:findTF("CharListBG/URTag/Text", arg0_6.choosePanel), i18n("tec_target_catchup_dr_char"))
	end

	for iter0_6, iter1_6 in ipairs(arg0_6.urList) do
		setText(arg0_6:findTF("Finish_" .. iter1_6 .. "/BG/Text", arg0_6.choosePanel), i18n("tec_target_catchup_dr_finish_tip"))
	end
end

function var0_0.updateTargetCatchupPage(arg0_13)
	arg0_13.state = arg0_13.technologyProxy:getCatchupState(arg0_13.tecID)

	if arg0_13.state == TechnologyCatchup.STATE_CATCHUPING then
		arg0_13:updateShowPanel()
	else
		arg0_13:updateChoosePanel()
	end
end

function var0_0.updateCharTpl(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:findTF("PrintNum/Text", arg2_14)

	setText(var0_14, i18n("tec_target_need_print"))

	local var1_14 = arg0_14:findTF("PrintNum/NumText", arg2_14)
	local var2_14 = arg0_14:findTF("NameText", arg2_14)
	local var3_14 = arg0_14:findTF("LevelText", arg2_14)
	local var4_14 = arg0_14:findTF("NotGetTag", arg2_14)
	local var5_14 = arg0_14.charIDList[arg1_14]
	local var6_14 = arg0_14.bayProxy:findShipByGroup(var5_14)
	local var7_14 = arg0_14.technologyProxy:getBluePrintVOByGroupID(var5_14)
	local var8_14 = pg.ship_data_blueprint[var5_14].strengthen_item
	local var9_14 = var6_14 and math.floor(arg0_14:getShipBluePrintCurExp(var7_14) / Item.getConfigData(var8_14).usage_arg[1]) or 0
	local var10_14 = arg0_14.configCatchup[arg0_14.tecID].blueprint_max[arg1_14]
	local var11_14 = arg0_14.bagProxy:getItemCountById(var8_14)
	local var12_14 = math.max(var10_14 - var9_14 - var11_14, 0)

	setText(var1_14, var12_14)

	local var13_14 = ShipGroup.getDefaultShipNameByGroupID(var5_14)

	setText(var2_14, var13_14)
	setActive(var3_14, var6_14)
	setActive(var4_14, not var6_14)

	if var6_14 then
		local var14_14 = arg0_14.technologyProxy:getBluePrintVOByGroupID(var5_14)

		setText(var3_14, "Lv. " .. var14_14.level .. "/" .. var14_14:getMaxLevel())
	end
end

function var0_0.updateShowPanel(arg0_15)
	setActive(arg0_15.showPanel, true)
	setActive(arg0_15.choosePanel, false)

	local var0_15 = arg0_15.technologyProxy:getCurCatchupTecInfo()
	local var1_15 = var0_15.tecID
	local var2_15 = var0_15.groupID
	local var3_15 = var0_15.printNum

	setImageSprite(arg0_15.showBG, LoadSprite("TecCatchup/selbg" .. var2_15, var2_15))

	local var4_15 = ShipGroup.getDefaultShipNameByGroupID(var2_15)

	setText(arg0_15.nameText, var4_15)
	setText(arg0_15.progressText, var3_15 .. "/" .. arg0_15:getMaxNum(var2_15))

	local var5_15 = arg0_15.state == TechnologyCatchup.STATE_FINISHED_ALL

	setActive(arg0_15.finishedImg, var5_15)
	setActive(arg0_15.selectedImg, not var5_15)
	onButton(arg0_15, arg0_15.selectedImg, function()
		arg0_15:updateChoosePanel()
		setActive(arg0_15:findTF("ProgressTitle", arg0_15.choosePanel), false)
	end, SFX_PANEL)
end

function var0_0.updateChoosePanel(arg0_17)
	setActive(arg0_17.showPanel, false)
	setActive(arg0_17.choosePanel, true)

	local var0_17 = arg0_17.technologyProxy:getCatchupData(arg0_17.tecID)

	if arg0_17.state == TechnologyCatchup.STATE_FINISHED_ALL then
		setActive(arg0_17:findTF("FinishAll", arg0_17.choosePanel), true)
		setActive(arg0_17:findTF("ProgressTitle", arg0_17.choosePanel), false)
	elseif #arg0_17.urList > 0 then
		setActive(arg0_17:findTF("FinishAll", arg0_17.choosePanel), false)

		local var1_17 = var0_17:isFinishSSR()

		setActive(arg0_17:findTF("FinishPart", arg0_17.choosePanel), var1_17)

		for iter0_17, iter1_17 in ipairs(arg0_17.urList) do
			local var2_17 = var0_17:isFinish(iter1_17)

			setActive(arg0_17:findTF("Finish_" .. iter1_17, arg0_17.choosePanel), var2_17)
		end
	end
end

function var0_0.updateProgress(arg0_18, arg1_18)
	setActive(arg0_18:findTF("ProgressTitle", arg0_18.choosePanel), true)

	local var0_18 = arg0_18.technologyProxy:getCatchupData(arg0_18.tecID):getTargetNum(arg1_18)
	local var1_18 = arg0_18:getMaxNum(arg1_18)

	if arg0_18:isUR(arg1_18) then
		setActive(arg0_18.urProgress, true)
		setActive(arg0_18.ssrProgress, false)
		setText(arg0_18:findTF("Text", arg0_18.urProgress), var0_18 .. "/" .. var1_18)
	else
		setActive(arg0_18.urProgress, false)
		setActive(arg0_18.ssrProgress, true)
		setText(arg0_18:findTF("Text", arg0_18.ssrProgress), var0_18 .. "/" .. var1_18)
	end
end

function var0_0.isUR(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.urList) do
		if arg1_19 == iter1_19 then
			return true
		end
	end

	return false
end

function var0_0.getMaxNum(arg0_20, arg1_20)
	return arg0_20:isUR(arg1_20) and pg.technology_catchup_template[arg0_20.tecID].obtain_max_per_ur or pg.technology_catchup_template[arg0_20.tecID].obtain_max
end

function var0_0.willExit(arg0_21)
	PoolMgr.GetInstance():ReturnUI(arg0_21:getUIName(), arg0_21._go)
end

function var0_0.getShipBluePrintCurExp(arg0_22, arg1_22)
	local var0_22 = arg1_22.level
	local var1_22 = arg1_22.fateLevel
	local var2_22 = arg1_22.exp
	local var3_22 = arg1_22:getConfig("strengthen_effect")
	local var4_22 = arg1_22:getConfig("fate_strengthen")
	local var5_22 = 0 + var2_22

	for iter0_22 = 1, var0_22 do
		var5_22 = var5_22 + pg.ship_strengthen_blueprint[var3_22[iter0_22]].need_exp
	end

	for iter1_22 = 1, var1_22 do
		var5_22 = var5_22 + pg.ship_strengthen_blueprint[var4_22[iter1_22]].need_exp
	end

	return var5_22
end

return var0_0
