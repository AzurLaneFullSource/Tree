local var0_0 = class("NewEducateTalentLayer", import("view.newEducate.base.NewEducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateTalentUI"
end

function var0_0.init(arg0_2)
	arg0_2.animCom = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetTriggerEvent(function()
		arg0_2.animEvent:SetEndEvent(nil)
		arg0_2:RefreshView()
	end)

	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.bgTF = arg0_2.rootTF:Find("bg")

	local var0_2 = arg0_2.rootTF:Find("window/content")

	arg0_2.uiList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	arg0_2.uiList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg2_4.name = arg1_4 + 1

			local var0_4 = arg0_2.talentList[arg1_4 + 1]

			arg0_2:UpdateItem(var0_4, arg2_4)
		end
	end)
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_5._tf, {
		pbList = {
			arg0_5.bgTF
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = arg0_5:getWeightFromData() + 1
	})
	NewEducateGuideSequence.CheckGuide(arg0_5.__cname)
end

function var0_0.GetRarityBg(arg0_6, arg1_6)
	return switch(arg1_6, {
		[NewEducateBuff.RARITY.BLUE] = function()
			return "bg_blue"
		end,
		[NewEducateBuff.RARITY.PURPLE] = function()
			return "bg_purple"
		end,
		[NewEducateBuff.RARITY.GOLD] = function()
			return "bg_gold"
		end,
		[NewEducateBuff.RARITY.COLOURS] = function()
			return "bg_colours"
		end
	})
end

function var0_0.UpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = pg.child2_benefit_list[arg1_11]

	setText(arg2_11:Find("name/Text"), var0_11.name)
	setText(arg2_11:Find("desc/Text"), var0_11.desc)
	LoadImageSpriteAtlasAsync("ui/neweducatetalentui_atlas", arg0_11:GetRarityBg(var0_11.rare), arg2_11, true)
	LoadImageSpriteAsync("neweducateicon/" .. var0_11.item_icon, arg2_11:Find("icon"), true)

	local var1_11 = not table.contains(arg0_11.reTalentList, arg1_11)

	setGray(arg2_11:Find("refresh_btn"), not var1_11)
	onButton(arg0_11, arg2_11:Find("refresh_btn"), function()
		if arg0_11.isPlaying then
			return
		end

		if not var1_11 then
			return
		end

		arg0_11:emit(NewEducateTalentMediator.ON_REFRESH_TALENT, arg1_11, tonumber(arg2_11.name))
	end, SFX_PANEL)
	setText(arg2_11:Find("refresh_btn/Text"), var1_11 and 1 or 0)
	onButton(arg0_11, arg2_11, function()
		if arg0_11.isPlaying then
			return
		end

		arg0_11:emit(NewEducateTalentMediator.ON_SELECT_TALENT, arg1_11, tonumber(arg2_11.name))
	end, SFX_PANEL)
end

function var0_0.RefreshView(arg0_14)
	local var0_14 = arg0_14.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.TALENT)

	arg0_14.talentList = var0_14:GetTalents()
	arg0_14.reTalentList = var0_14:GetReTalents()

	arg0_14.uiList:align(#arg0_14.talentList)
end

function var0_0.OnRefreshTalent(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.TALENT)

	arg0_15.talentList = var0_15:GetTalents()
	arg0_15.reTalentList = var0_15:GetReTalents()

	eachChild(arg0_15.uiList.container, function(arg0_16)
		if tonumber(arg0_16.name) == arg1_15 then
			local var0_16 = arg0_16:GetComponent(typeof(DftAniEvent))

			var0_16:SetTriggerEvent(function()
				var0_16:SetEndEvent(nil)

				arg0_15.isPlaying = false

				arg0_15:UpdateItem(arg2_15, arg0_16)
			end)
			arg0_16:GetComponent(typeof(Animation)):Play("Anim_educate_talent_tpl_change")

			arg0_15.isPlaying = true
		end
	end)
end

function var0_0.OnSelectedDone(arg0_18, arg1_18)
	arg0_18.animEvent:SetEndEvent(function()
		arg0_18.animEvent:SetEndEvent(nil)

		arg0_18.isPlaying = false

		arg0_18:closeView()
	end)
	arg0_18.animCom:Play("Anim_educate_talent_select")

	arg0_18.isPlaying = true

	eachChild(arg0_18.uiList.container, function(arg0_20)
		if tonumber(arg0_20.name) ~= arg1_18 then
			arg0_20:GetComponent(typeof(Animation)):Play("Anim_educate_talent_tpl_out")
		end
	end)
end

function var0_0.onBackPressed(arg0_21)
	return
end

function var0_0.willExit(arg0_22)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_22._tf)
	existCall(arg0_22.contextData.onExit)
end

return var0_0
