local var0 = class("CommanderReplaceTalentPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderCatReplaceTalentUI"
end

function var0.OnLoaded(arg0)
	arg0.replaceList = UIItemList.New(arg0:findTF("bg/frame/bg/talents/content"), arg0:findTF("bg/frame/bg/talents/content/talent"))
	arg0.replaceTargetTF = arg0:findTF("bg/frame/bg/talent")
	arg0.replaceTalent = arg0:findTF("bg/frame/bg/replace")
	arg0.replaceCloseBtn = arg0:findTF("bg/frame/close_btn")
	arg0.replaceCancelBtn = arg0:findTF("bg/frame/cancel_btn")
	arg0.confirmBtn = arg0:findTF("bg/frame/confirm_btn")

	setActive(arg0:findTF("bg/frame/consume"), false)
	setText(arg0:findTF("bg/frame/bg/title/Text"), i18n("commander_choice_talent_3"))
	setText(arg0:findTF("bg/frame/bg/talents/title/Text"), i18n("commander_choice_talent_2"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.replaceCloseBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.replaceCancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)
	arg0._tf:SetAsLastSibling()

	arg0.commander = arg1

	arg0:UpdateTalents(arg2, nil)
	arg0:UpdateList(arg2)
end

function var0.UpdateList(arg0, arg1)
	local var0 = arg0.commander:getTalents()

	arg0.replaceList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			onButton(arg0, arg2, function()
				if arg0.prevToggle ~= arg2 then
					arg0:UpdateTalents(arg1, var0)

					if arg0.prevToggle then
						setActive(arg0.prevToggle:Find("mark"), false)
					end

					arg0.prevToggle = arg2

					setActive(arg2:Find("mark"), true)
				end
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0:getConfig("icon"), "", arg2)
		end
	end)
	arg0.replaceList:align(#var0)
end

function var0.UpdateTalents(arg0, arg1, arg2)
	local var0 = arg0.commander

	arg0:UpdateTalentCard(arg0.replaceTargetTF, arg1)
	arg0:UpdateTalentCard(arg0.replaceTalent, arg2)
	onButton(arg0, arg0.confirmBtn, function()
		if arg2 and arg1 and var0 then
			if arg2:getConfig("worth") > 1 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("commander_ability_replace_warning"),
					onYes = function()
						arg0:emit(CommanderCatMediator.LEARN_TALENT, var0.id, arg1.id, arg2.id)
						arg0:Hide()
					end
				})
			else
				arg0:emit(CommanderCatMediator.LEARN_TALENT, var0.id, arg1.id, arg2.id)
				arg0:Hide()
			end
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

function var0.Hide(arg0)
	var0.super.Hide(arg0)

	if arg0.prevToggle then
		setActive(arg0.prevToggle:Find("mark"), false)

		arg0.prevToggle = nil
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
