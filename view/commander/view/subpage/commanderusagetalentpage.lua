local var0_0 = class("CommanderUsageTalentPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderCatUsageTalentUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.usageList = UIItemList.New(arg0_2:findTF("bg/frame/bg/talents/content"), arg0_2:findTF("bg/frame/bg/talents/content/talent"))
	arg0_2.usageCancelBtn = arg0_2:findTF("bg/frame/cancel_btn")
	arg0_2.usageConfirmBtn = arg0_2:findTF("bg/frame/confirm_btn")
	arg0_2.usageConfirmUpgrade = arg0_2:findTF("bg/frame/confirm_btn/upgrade")
	arg0_2.usageConfirmILearned = arg0_2:findTF("bg/frame/confirm_btn/learned")
	arg0_2.usageTalent = arg0_2:findTF("bg/frame/bg/talent")
	arg0_2.usageCostIconTF = arg0_2:findTF("bg/frame/consume/Image")
	arg0_2.usageCostTxtTF = arg0_2:findTF("bg/frame/consume/Text")
	arg0_2.usageCostTxt = arg0_2.usageCostTxtTF:GetComponent(typeof(Text))
	arg0_2.usageCloseBtn = arg0_2:findTF("bg/frame/close_btn")
	arg0_2.replacePage = CommanderReplaceTalentPage.New(arg0_2._parentTf.parent, arg0_2.event)

	setText(arg0_2:findTF("bg/frame/bg/title/Text"), i18n("commander_choice_talent_1"))
	setText(arg0_2:findTF("bg/frame/bg/talents/title/Text"), i18n("commander_choice_talent_2"))
	setText(arg0_2:findTF("bg/frame/consume/label"), i18n("word_consume"))
end

function var0_0.OnInit(arg0_3)
	arg0_3:RegisterEvent()
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.usageCancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.usageCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.usageConfirmBtn, function()
		local var0_7 = arg0_3.commanderVO

		if arg0_3.talent and var0_7:fullTalentCnt() and not var0_7:hasTalent(arg0_3.talent) then
			arg0_3.replacePage:ExecuteAction("Show", var0_7, arg0_3.talent)
		elseif arg0_3.talent then
			arg0_3:emit(CommanderCatMediator.LEARN_TALENT, var0_7.id, arg0_3.talent.id, 0)
		end
	end, SFX_PANEL)
end

function var0_0.RegisterEvent(arg0_8)
	arg0_8:bind(CommanderCatScene.MSG_FETCH_TALENT_LIST, function(arg0_9)
		if arg0_8.commanderVO then
			local var0_9 = getProxy(CommanderProxy):getCommanderById(arg0_8.commanderVO.id)

			arg0_8:Flush(var0_9)
		end
	end)
	arg0_8:bind(CommanderCatScene.MSG_LEARN_TALENT, function(arg0_10)
		if arg0_8.commanderVO then
			local var0_10 = getProxy(CommanderProxy):getCommanderById(arg0_8.commanderVO.id)

			if var0_10:getTalentPoint() <= 0 then
				arg0_8:Hide()

				return
			end

			arg0_8:Flush(var0_10)
		end
	end)
end

function var0_0.Show(arg0_11, arg1_11)
	var0_0.super.Show(arg0_11)
	arg0_11._tf:SetAsLastSibling()
	arg0_11:Flush(arg1_11)
	arg0_11:UpdateStyle()
end

function var0_0.Flush(arg0_12, arg1_12)
	arg0_12.commanderVO = arg1_12

	local var0_12 = arg1_12:getNotLearnedList()

	if not var0_12 or #var0_12 == 0 then
		arg0_12:FetchList()
	else
		arg0_12:UpdateList()
	end
end

function var0_0.UpdateStyle(arg0_13)
	setActive(arg0_13.usageCostIconTF, false)
	setActive(arg0_13.usageCostTxtTF, false)
end

function var0_0.FetchList(arg0_14)
	arg0_14:emit(CommanderCatMediator.FETCH_NOT_LEARNED_TALENT, arg0_14.commanderVO.id)
end

function var0_0.UpdateList(arg0_15)
	local var0_15 = arg0_15.commanderVO:getNotLearnedList()

	arg0_15.usageList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16 + 1]

			arg0_15:UpdateCard(var0_16, arg2_16)

			if arg1_16 == 0 then
				triggerToggle(arg2_16, true)
			end
		end
	end)
	arg0_15.usageList:align(#var0_15)
end

function var0_0.UpdateCard(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.commanderVO
	local var1_17 = var0_17:hasTalent(arg1_17)

	setActive(arg2_17:Find("up"), var1_17)
	GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg1_17:getConfig("icon"), "", arg2_17)
	onToggle(arg0_17, arg2_17, function(arg0_18)
		if arg0_18 and (not arg0_17.talent or arg0_17.talent.id ~= arg1_17.id) then
			arg0_17.talent = arg1_17

			arg0_17:UpdateTalentCard(arg0_17.usageTalent, arg1_17)

			local var0_18 = arg1_17:getConfig("cost")

			setActive(arg0_17.usageCostIconTF, var0_18 > 0)
			setActive(arg0_17.usageCostTxtTF, var0_18 > 0)

			arg0_17.usageCostTxt.text = var0_18

			setActive(arg0_17.usageConfirmUpgrade, var0_17:hasTalent(arg1_17))
			setActive(arg0_17.usageConfirmILearned, not var0_17:hasTalent(arg1_17))
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTalentCard(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19:Find("unlock")
	local var1_19 = arg1_19:Find("lock")

	if arg2_19 then
		GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2_19:getConfig("icon"), "", var0_19:Find("icon"))

		local var2_19 = var0_19:Find("tree_btn")

		if var2_19 then
			onButton(arg0_19, var2_19, function()
				arg0_19.contextData.treePanel:ExecuteAction("Show", arg2_19)
			end, SFX_PANEL)
		end

		setText(var0_19:Find("name_bg/Text"), arg2_19:getConfig("name"))
		setScrollText(var0_19:Find("desc/Text"), arg2_19:getConfig("desc"))
	end

	setActive(var0_19, arg2_19)

	if var1_19 then
		setActive(var1_19, not arg2_19)
	end
end

function var0_0.CanBack(arg0_21)
	if arg0_21.replacePage and arg0_21.replacePage:GetLoaded() and arg0_21.replacePage:isShowing() then
		arg0_21.replacePage:Hide()

		return false
	end

	return true
end

function var0_0.OnDestroy(arg0_22)
	if arg0_22.replacePage then
		arg0_22.replacePage:Destroy()

		arg0_22.replacePage = nil
	end
end

return var0_0
