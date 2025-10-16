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
	arg0_3.awardListBox = IslandBookAwardListBox.New(arg0_3._tf, arg0_3.event, setmetatable({
		ShowMsgBox = function(arg0_4, arg1_4)
			arg0_3:ShowMsgBox(arg1_4)
		end
	}, {
		__index = arg0_3.contextData
	}))
	arg0_3.starList = UIItemList.New(arg0_3.rightTF:Find("stars"), arg0_3.rightTF:Find("stars/tpl"))
end

function var0_0.OnInit(arg0_5)
	var0_0.super.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.getPointBtn, function()
		arg0_5.getPointBtn:GetComponent(typeof(Animation)):Play()
		arg0_5:emit(IslandMediator.GET_COLLECT_POINT, arg0_5.canGetPointIds)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.getPointAwardBtn, function()
		arg0_5.pointAwardTF:GetComponent(typeof(Animation)):Play()
		arg0_5:emit(IslandMediator.GET_POINT_AWARD, arg0_5.curLevelId)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.openAwardWinBtn, function()
		arg0_5.openAwardWinBtn:GetComponent(typeof(Animation)):Play()
		arg0_5.awardListBox:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("top/help"), function()
		arg0_5:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_guide_help"),
			title = i18n("island_guide_character_help")
		})
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_10)
	var0_0.super.Flush(arg0_10)
	arg0_10:FlushPointInfos()
	arg0_10:FlushPointAwardInfos()
end

function var0_0.FlushPointInfos(arg0_11)
	arg0_11.canGetPointIds = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.showList) do
		if iter1_11:GetStatus() == IslandIllustration.STATUS.UNLOCK and iter1_11:IsTip() then
			table.insert(arg0_11.canGetPointIds, iter1_11.id)
		end
	end

	setActive(arg0_11.getPointBtn, #arg0_11.canGetPointIds > 0)
end

function var0_0.FlushPointAwardInfos(arg0_12)
	arg0_12.curLevelId = arg0_12.bookAgency:GetCurLevelPointAwardId()
	arg0_12.awardConfig = pg.island_collection_reward[arg0_12.curLevelId]

	setText(arg0_12.pointLevelTF, i18n("island_book_collection_award_title", arg0_12.awardConfig.level))

	arg0_12.curPoint, arg0_12.targetPoint = arg0_12.bookAgency:GetCurPointInfos()

	setText(arg0_12.pointProgressTF, arg0_12.curPoint .. "/" .. arg0_12.targetPoint)
	setSlider(arg0_12.pointSliderTF, 0, 1, arg0_12.curPoint / arg0_12.targetPoint)

	local var0_12 = arg0_12.bookAgency:IsGotAllPointAward()

	setActive(arg0_12.gotAllPointAwardTF, var0_12)
	setActive(arg0_12.getPointAwardBtn, not var0_12 and arg0_12.curPoint >= arg0_12.targetPoint)

	local var1_12 = Drop.Create(arg0_12.awardConfig.award_display)

	GetImageSpriteFromAtlasAsync(var1_12:getIcon(), "", arg0_12.pointAwardIcon)
end

function var0_0.FlushRightPanel(arg0_13)
	if not arg0_13.showIllustration then
		return
	end

	local var0_13 = arg0_13.showIllustration:GetStatus()

	setText(arg0_13.rightNameTF, arg0_13.showIllustration:GetName())
	setText(arg0_13.rightEnNameTF, arg0_13.showIllustration:GetEnName())

	local var1_13 = var0_13 == IslandIllustration.STATUS.UNLOCK
	local var2_13 = var1_13 and arg0_13.showIllustration:GetDesc() or i18n("island_guide_lock_desc")

	setText(arg0_13.rightDescTF, var2_13)
	setActive(arg0_13.unlockBtn, var0_13 == IslandIllustration.STATUS.CAN_UNLOCK)

	local var3_13 = arg0_13.showIllustration:GetLinkConfigID()
	local var4_13 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var3_13)

	setText(arg0_13.rightNameTF:Find("level"), var1_13 and " - Lv." .. var4_13:GetLevel() or "")

	local var5_13 = var4_13 and var4_13:GetBreakLevel() or 0

	arg0_13.starList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg1_14 + 1

			setActive(arg2_14:Find("Image"), var0_14 <= var5_13)
		end
	end)
	arg0_13.starList:align(arg0_13:GetShipBreakMaxLevel(var3_13))
end

function var0_0.GetShipBreakMaxLevel(arg0_15, arg1_15)
	return pg.island_chara_template[arg1_15].upgrade_level[2] + 1
end

function var0_0.OnDestrory(arg0_16)
	if arg0_16.awardListBox then
		arg0_16.awardListBox:Destroy()

		arg0_16.awardListBox = nil
	end
end

return var0_0
