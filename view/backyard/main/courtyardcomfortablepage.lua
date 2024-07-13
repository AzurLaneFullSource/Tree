local var0_0 = class("CourtYardComfortablePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CourtYardComfortablePanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.subTitleTxt = arg0_2:findTF("frame/view/subtitle2/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/view/subtitle1/Text"), i18n("backyard_backyardScene_comforChatContent1"))

	arg0_2.expressionTxt = arg0_2:findTF("frame/view/express/Text"):GetComponent(typeof(Text))
	arg0_2.comfortableImg = arg0_2:findTF("frame/view/express/icon"):GetComponent(typeof(Image))
	arg0_2.comfortableBg = arg0_2:findTF("frame/view/express"):GetComponent(typeof(Image))
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("frame/view/list/content"), arg0_2:findTF("frame/view/list/content/tpl"))
	arg0_2.animation = arg0_2:findTF("frame/view"):GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2:findTF("frame/view"):GetComponent(typeof(DftAniEvent))
	arg0_2.foldBtn = arg0_2:findTF("frame/view/fold")
	arg0_2.arr = arg0_2:findTF("frame/view/fold/up")
	arg0_2.subTitle = arg0_2:findTF("frame/view/subtitle2")
	arg0_2.expAdditionTxt = arg0_2:findTF("frame/exp/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/exp"), i18n("courtyard_label_comfortable_addition"))
	setText(arg0_2:findTF("frame/title"), i18n("word_comfort_level"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)

	local var0_3 = false

	onButton(arg0_3, arg0_3.foldBtn, function()
		var0_3 = not var0_3

		if var0_3 then
			setActive(arg0_3.subTitle, true)
		end

		arg0_3.dftAniEvent:SetEndEvent(function()
			arg0_3.dftAniEvent:SetEndEvent(nil)
			setActive(arg0_3.subTitle, false)
		end)
		arg0_3.animation:Play(var0_3 and "anim_courtyard_comfortable_viewin" or "anim_courtyard_comfortable_viewhide")
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8, arg1_8)
	var0_0.super.Show(arg0_8)

	arg0_8.dorm = arg1_8

	local var0_8 = arg1_8:getComfortable()

	arg0_8:FlushSubTitle()
	arg0_8:FlushExpression(var0_8)
	arg0_8:FlushList()
	arg0_8:FlushAddition(var0_8)
end

function var0_0.FlushSubTitle(arg0_9)
	local var0_9 = arg0_9.dorm.level

	arg0_9.subTitleTxt.text = i18n("backyard_backyardScene_comforChatContent2", var0_9 - 1)
end

function var0_0.FlushExpression(arg0_10, arg1_10)
	local var0_10 = arg0_10.dorm:GetComfortableLevel(arg1_10)

	arg0_10.expressionTxt.text = i18n("backyard_backyardScene_expression_label_" .. var0_10)

	LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "express_" .. var0_10, function(arg0_11)
		if arg0_10.exited then
			return
		end

		arg0_10.comfortableImg.sprite = arg0_11

		arg0_10.comfortableImg:SetNativeSize()
	end)

	arg0_10.comfortableBg.color = arg0_10.dorm:GetComfortableColor(var0_10)
end

local var1_0 = {
	i18n("word_wallpaper"),
	i18n("word_furniture"),
	i18n("word_decorate"),
	i18n("word_floorpaper"),
	i18n("word_mat"),
	i18n("word_wall"),
	i18n("word_collection")
}

function var0_0.FlushList(arg0_12)
	local var0_12 = arg0_12.dorm:getConfig("comfortable_count")

	arg0_12.uiItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg1_13 + 1

			LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "icon_" .. var0_13, function(arg0_14)
				if arg0_12.exited then
					return
				end

				local var0_14 = arg2_13:Find("icon"):GetComponent(typeof(Image))

				var0_14.sprite = arg0_14

				var0_14:SetNativeSize()
			end)
			setText(arg2_13:Find("name"), var1_0[var0_13])
			setText(arg2_13:Find("Text"), "X" .. var0_12[var0_13][2])

			local var1_13 = var0_13 % 2 ~= 0

			setActive(arg2_13:Find("line"), var1_13)
			setActive(arg2_13:Find("bg"), var1_13)
		end
	end)
	arg0_12.uiItemList:align(7)
end

function var0_0.FlushAddition(arg0_15, arg1_15)
	local var0_15 = pg.gameset.dorm_exp_ratio_comfort_degree.key_value
	local var1_15 = 0

	if var0_15 + arg1_15 ~= 0 then
		var1_15 = arg1_15 / (var0_15 + arg1_15) * 100
	end

	arg0_15.expAdditionTxt.text = string.format("%d", var1_15) .. "%"
end

function var0_0.OnDestroy(arg0_16)
	arg0_16.dftAniEvent:SetTriggerEvent(nil)

	arg0_16.exited = true
end

return var0_0
