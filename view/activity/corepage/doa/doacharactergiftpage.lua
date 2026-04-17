local var0_0 = class("DOACharacterGiftPage", import("view.activity.CorePage.CorePtTemplatePage"))
local var1_0 = 7

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.task = arg0_1.AD:Find("task")
	arg0_1.awardTF = arg0_1.task:Find("award")
	arg0_1.slider = arg0_1.task:Find("slider")
	arg0_1.friendText = arg0_1.task:Find("friendText")
	arg0_1.targetText = arg0_1.task:Find("targetText")
	arg0_1.displayBtn = arg0_1.AD:Find("display_btn")
	arg0_1.getAwardTxt = arg0_1.displayBtn:Find("Text")
	arg0_1.hearts = UIItemList.New(arg0_1.AD:Find("heart"), arg0_1.AD:Find("heart/1"))
	arg0_1.btnGroup = arg0_1.AD:Find("btnGroup")
	arg0_1.battleBtn = arg0_1.btnGroup:Find("battle_btn")
	arg0_1.getBtn = arg0_1.btnGroup:Find("get_btn")
	arg0_1.gotBtn = arg0_1.btnGroup:Find("got_btn")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	arg0_2:InitLocal()
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.InitLocal(arg0_4)
	arg0_4.imgHeart = GetSpriteFromAtlas("ui/DOACharacterGiftPage_atlas", "heart")
	arg0_4.imgHeratGreay = GetSpriteFromAtlas("ui/DOACharacterGiftPage_atlas", "heart_greay")

	setText(arg0_4.friendText, i18n("doa3_activityPageUI_7"))
	setText(arg0_4.getAwardTxt, i18n("doa3_activityPageUI_6"))
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5:UpdateSlider()
	arg0_5:UpdateBtnGroup()
	arg0_5:UpdateAward()
	arg0_5:UpdateHearts()
end

function var0_0.UpdateSlider(arg0_6)
	local var0_6, var1_6, var2_6 = arg0_6.ptData:GetResProgress()

	setText(arg0_6.targetText, "<color=#353c70>" .. var0_6 .. "</color>" .. "/" .. "<color=#AEB7D0>" .. var1_6 .. "</color>")
	setSlider(arg0_6.slider, 0, 1, var2_6)
end

function var0_0.UpdateBtnGroup(arg0_7)
	local var0_7 = arg0_7.ptData:CanGetAward()
	local var1_7 = arg0_7.ptData:CanGetNextAward()
	local var2_7 = arg0_7.ptData:CanGetMorePt()

	setActive(arg0_7.battleBtn, var2_7 and not var0_7 and var1_7)
	setActive(arg0_7.getBtn, var0_7)
	setActive(arg0_7.gotBtn, not var1_7)
end

function var0_0.UpdateHearts(arg0_8)
	arg0_8.hearts:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			if arg1_9 < arg0_8.ptData.level then
				setImageSprite(arg2_9, arg0_8.imgHeart)
			else
				setImageSprite(arg2_9, arg0_8.imgHeratGreay)
			end
		end
	end)
	arg0_8.hearts:align(var1_0)
end

function var0_0.UpdateAward(arg0_10)
	local var0_10 = arg0_10.ptData:GetAward()

	updateDrop(arg0_10.awardTF, var0_10)
	onButton(arg0_10, arg0_10.awardTF, function()
		arg0_10:emit(BaseUI.ON_DROP, var0_10)
	end, SFX_PANEL)
end

return var0_0
