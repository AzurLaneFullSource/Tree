local var0_0 = class("IslandBookCharPage", import(".IslandBookItemPage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookCharUI"
end

function var0_0.GetIllustrationType(arg0_2)
	return IslandIllustration.TYPES.CHAR
end

function var0_0.OnLoaded(arg0_3)
	var0_0.super.OnLoaded(arg0_3)

	arg0_3.getPointBtn = arg0_3.rightTF:Find("get_btn")

	setText(arg0_3.getPointBtn:Find("Text"), i18n("island_guide_collectionpoint"))

	arg0_3.pointPanel = arg0_3._tf:Find("point_panel")
	arg0_3.pointLevelTF = arg0_3.pointPanel:Find("Text")
	arg0_3.pointAwardTF = arg0_3.pointPanel:Find("award")
	arg0_3.pointAwardIcon = arg0_3.pointPanel:Find("award/icon")
	arg0_3.getPointAwardBtn = arg0_3.pointPanel:Find("award/get")
	arg0_3.gotAllPointAwardTF = arg0_3.pointPanel:Find("award/got")
	arg0_3.openAwardWinBtn = arg0_3.pointPanel:Find("award_btn")
	arg0_3.pointSliderTF = arg0_3.pointPanel:Find("slider")
	arg0_3.pointProgressTF = arg0_3.pointPanel:Find("slider/progress")
	arg0_3.awardListBox = IslandBookAwardListBox.New(arg0_3._tf, arg0_3.event)
	arg0_3.starList = UIItemList.New(arg0_3.rightTF:Find("stars"), arg0_3.rightTF:Find("stars/tpl"))
end

function var0_0.OnInit(arg0_4)
	var0_0.super.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.getPointBtn, function()
		arg0_4.getPointBtn:GetComponent(typeof(Animation)):Play()
		arg0_4:emit(IslandMediator.GET_COLLECT_POINT, arg0_4.canGetPointIds)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.getPointAwardBtn, function()
		arg0_4.pointAwardTF:GetComponent(typeof(Animation)):Play()
		arg0_4:emit(IslandMediator.GET_POINT_AWARD, arg0_4.curLevelId)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.openAwardWinBtn, function()
		arg0_4.openAwardWinBtn:GetComponent(typeof(Animation)):Play()
		arg0_4.awardListBox:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("top/help"), function()
		arg0_4:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_guide_help"),
			title = i18n("island_guide_character_help")
		})
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_9)
	var0_0.super.Flush(arg0_9)
	arg0_9:FlushPointInfos()
	arg0_9:FlushPointAwardInfos()
end

function var0_0.FlushPointInfos(arg0_10)
	arg0_10.canGetPointIds = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.showList) do
		if iter1_10:GetStatus() == IslandIllustration.STATUS.UNLOCK and iter1_10:IsTip() then
			table.insert(arg0_10.canGetPointIds, iter1_10.id)
		end
	end

	setActive(arg0_10.getPointBtn, #arg0_10.canGetPointIds > 0)
end

function var0_0.FlushPointAwardInfos(arg0_11)
	arg0_11.curLevelId = arg0_11.bookAgency:GetCurLevelPointAwardId()
	arg0_11.awardConfig = pg.island_collection_reward[arg0_11.curLevelId]

	setText(arg0_11.pointLevelTF, i18n("island_book_collection_award_title", arg0_11.awardConfig.level))

	arg0_11.curPoint, arg0_11.targetPoint = arg0_11.bookAgency:GetCurPointInfos()

	setText(arg0_11.pointProgressTF, arg0_11.curPoint .. "/" .. arg0_11.targetPoint)
	setSlider(arg0_11.pointSliderTF, 0, 1, arg0_11.curPoint / arg0_11.targetPoint)

	local var0_11 = arg0_11.bookAgency:IsGotAllPointAward()

	setActive(arg0_11.gotAllPointAwardTF, var0_11)
	setActive(arg0_11.getPointAwardBtn, not var0_11 and arg0_11.curPoint >= arg0_11.targetPoint)

	local var1_11 = Drop.Create(arg0_11.awardConfig.award_display)

	GetImageSpriteFromAtlasAsync(var1_11:getIcon(), "", arg0_11.pointAwardIcon)
end

function var0_0.FlushRightPanel(arg0_12)
	if not arg0_12.showIllustration then
		return
	end

	local var0_12 = arg0_12.showIllustration:GetStatus()

	setText(arg0_12.rightNameTF, arg0_12.showIllustration:GetName())
	setText(arg0_12.rightEnNameTF, arg0_12.showIllustration:GetEnName())

	local var1_12 = var0_12 == IslandIllustration.STATUS.UNLOCK
	local var2_12 = var1_12 and arg0_12.showIllustration:GetDesc() or i18n("island_guide_lock_desc")

	setText(arg0_12.rightDescTF, var2_12)
	setActive(arg0_12.unlockBtn, var0_12 == IslandIllustration.STATUS.CAN_UNLOCK)

	local var3_12 = arg0_12.showIllustration:GetLinkConfigID()
	local var4_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var3_12)

	setText(arg0_12.rightNameTF:Find("level"), var1_12 and " - Lv." .. var4_12:GetLevel() or "")

	local var5_12 = var4_12 and var4_12:GetBreakLevel() or 0

	arg0_12.starList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg1_13 + 1

			setActive(arg2_13:Find("Image"), var0_13 <= var5_12)
		end
	end)
	arg0_12.starList:align(arg0_12:GetShipBreakMaxLevel(var3_12))
end

function var0_0.GetShipBreakMaxLevel(arg0_14, arg1_14)
	return pg.island_chara_template[arg1_14].upgrade_level[2] + 1
end

function var0_0.OnDestrory(arg0_15)
	if arg0_15.awardListBox then
		arg0_15.awardListBox:Destroy()

		arg0_15.awardListBox = nil
	end
end

return var0_0
