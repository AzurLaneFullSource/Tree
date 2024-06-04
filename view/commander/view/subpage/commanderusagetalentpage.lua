local var0 = class("CommanderUsageTalentPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderCatUsageTalentUI"
end

function var0.OnLoaded(arg0)
	arg0.usageList = UIItemList.New(arg0:findTF("bg/frame/bg/talents/content"), arg0:findTF("bg/frame/bg/talents/content/talent"))
	arg0.usageCancelBtn = arg0:findTF("bg/frame/cancel_btn")
	arg0.usageConfirmBtn = arg0:findTF("bg/frame/confirm_btn")
	arg0.usageConfirmUpgrade = arg0:findTF("bg/frame/confirm_btn/upgrade")
	arg0.usageConfirmILearned = arg0:findTF("bg/frame/confirm_btn/learned")
	arg0.usageTalent = arg0:findTF("bg/frame/bg/talent")
	arg0.usageCostIconTF = arg0:findTF("bg/frame/consume/Image")
	arg0.usageCostTxtTF = arg0:findTF("bg/frame/consume/Text")
	arg0.usageCostTxt = arg0.usageCostTxtTF:GetComponent(typeof(Text))
	arg0.usageCloseBtn = arg0:findTF("bg/frame/close_btn")
	arg0.replacePage = CommanderReplaceTalentPage.New(arg0._parentTf.parent, arg0.event)

	setText(arg0:findTF("bg/frame/bg/title/Text"), i18n("commander_choice_talent_1"))
	setText(arg0:findTF("bg/frame/bg/talents/title/Text"), i18n("commander_choice_talent_2"))
	setText(arg0:findTF("bg/frame/consume/label"), i18n("word_consume"))
end

function var0.OnInit(arg0)
	arg0:RegisterEvent()
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.usageCancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.usageCloseBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.usageConfirmBtn, function()
		local var0 = arg0.commanderVO

		if arg0.talent and var0:fullTalentCnt() and not var0:hasTalent(arg0.talent) then
			arg0.replacePage:ExecuteAction("Show", var0, arg0.talent)
		elseif arg0.talent then
			arg0:emit(CommanderCatMediator.LEARN_TALENT, var0.id, arg0.talent.id, 0)
		end
	end, SFX_PANEL)
end

function var0.RegisterEvent(arg0)
	arg0:bind(CommanderCatScene.MSG_FETCH_TALENT_LIST, function(arg0)
		if arg0.commanderVO then
			local var0 = getProxy(CommanderProxy):getCommanderById(arg0.commanderVO.id)

			arg0:Flush(var0)
		end
	end)
	arg0:bind(CommanderCatScene.MSG_LEARN_TALENT, function(arg0)
		if arg0.commanderVO then
			local var0 = getProxy(CommanderProxy):getCommanderById(arg0.commanderVO.id)

			if var0:getTalentPoint() <= 0 then
				arg0:Hide()

				return
			end

			arg0:Flush(var0)
		end
	end)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0._tf:SetAsLastSibling()
	arg0:Flush(arg1)
	arg0:UpdateStyle()
end

function var0.Flush(arg0, arg1)
	arg0.commanderVO = arg1

	local var0 = arg1:getNotLearnedList()

	if not var0 or #var0 == 0 then
		arg0:FetchList()
	else
		arg0:UpdateList()
	end
end

function var0.UpdateStyle(arg0)
	setActive(arg0.usageCostIconTF, false)
	setActive(arg0.usageCostTxtTF, false)
end

function var0.FetchList(arg0)
	arg0:emit(CommanderCatMediator.FETCH_NOT_LEARNED_TALENT, arg0.commanderVO.id)
end

function var0.UpdateList(arg0)
	local var0 = arg0.commanderVO:getNotLearnedList()

	arg0.usageList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			arg0:UpdateCard(var0, arg2)

			if arg1 == 0 then
				triggerToggle(arg2, true)
			end
		end
	end)
	arg0.usageList:align(#var0)
end

function var0.UpdateCard(arg0, arg1, arg2)
	local var0 = arg0.commanderVO
	local var1 = var0:hasTalent(arg1)

	setActive(arg2:Find("up"), var1)
	GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg1:getConfig("icon"), "", arg2)
	onToggle(arg0, arg2, function(arg0)
		if arg0 and (not arg0.talent or arg0.talent.id ~= arg1.id) then
			arg0.talent = arg1

			arg0:UpdateTalentCard(arg0.usageTalent, arg1)

			local var0 = arg1:getConfig("cost")

			setActive(arg0.usageCostIconTF, var0 > 0)
			setActive(arg0.usageCostTxtTF, var0 > 0)

			arg0.usageCostTxt.text = var0

			setActive(arg0.usageConfirmUpgrade, var0:hasTalent(arg1))
			setActive(arg0.usageConfirmILearned, not var0:hasTalent(arg1))
		end
	end, SFX_PANEL)
end

function var0.UpdateTalentCard(arg0, arg1, arg2)
	local var0 = arg1:Find("unlock")
	local var1 = arg1:Find("lock")

	if arg2 then
		GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2:getConfig("icon"), "", var0:Find("icon"))

		local var2 = var0:Find("tree_btn")

		if var2 then
			onButton(arg0, var2, function()
				arg0.contextData.treePanel:ExecuteAction("Show", arg2)
			end, SFX_PANEL)
		end

		setText(var0:Find("name_bg/Text"), arg2:getConfig("name"))
		setScrollText(var0:Find("desc/Text"), arg2:getConfig("desc"))
	end

	setActive(var0, arg2)

	if var1 then
		setActive(var1, not arg2)
	end
end

function var0.CanBack(arg0)
	if arg0.replacePage and arg0.replacePage:GetLoaded() and arg0.replacePage:isShowing() then
		arg0.replacePage:Hide()

		return false
	end

	return true
end

function var0.OnDestroy(arg0)
	if arg0.replacePage then
		arg0.replacePage:Destroy()

		arg0.replacePage = nil
	end
end

return var0
