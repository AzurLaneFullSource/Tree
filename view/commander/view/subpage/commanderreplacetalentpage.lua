local var0_0 = class("CommanderReplaceTalentPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderCatReplaceTalentUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.replaceList = UIItemList.New(arg0_2:findTF("bg/frame/bg/talents/content"), arg0_2:findTF("bg/frame/bg/talents/content/talent"))
	arg0_2.replaceTargetTF = arg0_2:findTF("bg/frame/bg/talent")
	arg0_2.replaceTalent = arg0_2:findTF("bg/frame/bg/replace")
	arg0_2.replaceCloseBtn = arg0_2:findTF("bg/frame/close_btn")
	arg0_2.replaceCancelBtn = arg0_2:findTF("bg/frame/cancel_btn")
	arg0_2.confirmBtn = arg0_2:findTF("bg/frame/confirm_btn")

	setActive(arg0_2:findTF("bg/frame/consume"), false)
	setText(arg0_2:findTF("bg/frame/bg/title/Text"), i18n("commander_choice_talent_3"))
	setText(arg0_2:findTF("bg/frame/bg/talents/title/Text"), i18n("commander_choice_talent_2"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.replaceCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.replaceCancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7, arg2_7)
	var0_0.super.Show(arg0_7)
	arg0_7._tf:SetAsLastSibling()

	arg0_7.commander = arg1_7

	arg0_7:UpdateTalents(arg2_7, nil)
	arg0_7:UpdateList(arg2_7)
end

function var0_0.UpdateList(arg0_8, arg1_8)
	local var0_8 = arg0_8.commander:getTalents()

	arg0_8.replaceList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = var0_8[arg1_9 + 1]

			onButton(arg0_8, arg2_9, function()
				if arg0_8.prevToggle ~= arg2_9 then
					arg0_8:UpdateTalents(arg1_8, var0_9)

					if arg0_8.prevToggle then
						setActive(arg0_8.prevToggle:Find("mark"), false)
					end

					arg0_8.prevToggle = arg2_9

					setActive(arg2_9:Find("mark"), true)
				end
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0_9:getConfig("icon"), "", arg2_9)
		end
	end)
	arg0_8.replaceList:align(#var0_8)
end

function var0_0.UpdateTalents(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.commander

	arg0_11:UpdateTalentCard(arg0_11.replaceTargetTF, arg1_11)
	arg0_11:UpdateTalentCard(arg0_11.replaceTalent, arg2_11)
	onButton(arg0_11, arg0_11.confirmBtn, function()
		if arg2_11 and arg1_11 and var0_11 then
			if arg2_11:getConfig("worth") > 1 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("commander_ability_replace_warning"),
					onYes = function()
						arg0_11:emit(CommanderCatMediator.LEARN_TALENT, var0_11.id, arg1_11.id, arg2_11.id)
						arg0_11:Hide()
					end
				})
			else
				arg0_11:emit(CommanderCatMediator.LEARN_TALENT, var0_11.id, arg1_11.id, arg2_11.id)
				arg0_11:Hide()
			end
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTalentCard(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg1_14:Find("unlock")
	local var1_14 = arg1_14:Find("lock")

	if arg2_14 then
		GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2_14:getConfig("icon"), "", var0_14:Find("icon"))

		local var2_14 = var0_14:Find("tree_btn")

		if var2_14 then
			onButton(arg0_14, var2_14, function()
				arg0_14.contextData.treePanel:ExecuteAction("Show", arg2_14)
			end, SFX_PANEL)
		end

		setText(var0_14:Find("name_bg/Text"), arg2_14:getConfig("name"))
		setScrollText(var0_14:Find("desc/Text"), arg2_14:getConfig("desc"))
	end

	setActive(var0_14, arg2_14)

	if var1_14 then
		setActive(var1_14, not arg2_14)
	end
end

function var0_0.Hide(arg0_16)
	var0_0.super.Hide(arg0_16)

	if arg0_16.prevToggle then
		setActive(arg0_16.prevToggle:Find("mark"), false)

		arg0_16.prevToggle = nil
	end
end

function var0_0.OnDestroy(arg0_17)
	return
end

return var0_0
