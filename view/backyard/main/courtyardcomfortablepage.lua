local var0 = class("CourtYardComfortablePage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CourtYardComfortablePanel"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.subTitleTxt = arg0:findTF("frame/view/subtitle2/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/view/subtitle1/Text"), i18n("backyard_backyardScene_comforChatContent1"))

	arg0.expressionTxt = arg0:findTF("frame/view/express/Text"):GetComponent(typeof(Text))
	arg0.comfortableImg = arg0:findTF("frame/view/express/icon"):GetComponent(typeof(Image))
	arg0.comfortableBg = arg0:findTF("frame/view/express"):GetComponent(typeof(Image))
	arg0.uiItemList = UIItemList.New(arg0:findTF("frame/view/list/content"), arg0:findTF("frame/view/list/content/tpl"))
	arg0.animation = arg0:findTF("frame/view"):GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg0:findTF("frame/view"):GetComponent(typeof(DftAniEvent))
	arg0.foldBtn = arg0:findTF("frame/view/fold")
	arg0.arr = arg0:findTF("frame/view/fold/up")
	arg0.subTitle = arg0:findTF("frame/view/subtitle2")
	arg0.expAdditionTxt = arg0:findTF("frame/exp/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/exp"), i18n("courtyard_label_comfortable_addition"))
	setText(arg0:findTF("frame/title"), i18n("word_comfort_level"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	local var0 = false

	onButton(arg0, arg0.foldBtn, function()
		var0 = not var0

		if var0 then
			setActive(arg0.subTitle, true)
		end

		arg0.dftAniEvent:SetEndEvent(function()
			arg0.dftAniEvent:SetEndEvent(nil)
			setActive(arg0.subTitle, false)
		end)
		arg0.animation:Play(var0 and "anim_courtyard_comfortable_viewin" or "anim_courtyard_comfortable_viewhide")
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.dorm = arg1

	local var0 = arg1:getComfortable()

	arg0:FlushSubTitle()
	arg0:FlushExpression(var0)
	arg0:FlushList()
	arg0:FlushAddition(var0)
end

function var0.FlushSubTitle(arg0)
	local var0 = arg0.dorm.level

	arg0.subTitleTxt.text = i18n("backyard_backyardScene_comforChatContent2", var0 - 1)
end

function var0.FlushExpression(arg0, arg1)
	local var0 = arg0.dorm:GetComfortableLevel(arg1)

	arg0.expressionTxt.text = i18n("backyard_backyardScene_expression_label_" .. var0)

	LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "express_" .. var0, function(arg0)
		if arg0.exited then
			return
		end

		arg0.comfortableImg.sprite = arg0

		arg0.comfortableImg:SetNativeSize()
	end)

	arg0.comfortableBg.color = arg0.dorm:GetComfortableColor(var0)
end

local var1 = {
	i18n("word_wallpaper"),
	i18n("word_furniture"),
	i18n("word_decorate"),
	i18n("word_floorpaper"),
	i18n("word_mat"),
	i18n("word_wall"),
	i18n("word_collection")
}

function var0.FlushList(arg0)
	local var0 = arg0.dorm:getConfig("comfortable_count")

	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1

			LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "icon_" .. var0, function(arg0)
				if arg0.exited then
					return
				end

				local var0 = arg2:Find("icon"):GetComponent(typeof(Image))

				var0.sprite = arg0

				var0:SetNativeSize()
			end)
			setText(arg2:Find("name"), var1[var0])
			setText(arg2:Find("Text"), "X" .. var0[var0][2])

			local var1 = var0 % 2 ~= 0

			setActive(arg2:Find("line"), var1)
			setActive(arg2:Find("bg"), var1)
		end
	end)
	arg0.uiItemList:align(7)
end

function var0.FlushAddition(arg0, arg1)
	local var0 = pg.gameset.dorm_exp_ratio_comfort_degree.key_value
	local var1 = 0

	if var0 + arg1 ~= 0 then
		var1 = arg1 / (var0 + arg1) * 100
	end

	arg0.expAdditionTxt.text = string.format("%d", var1) .. "%"
end

function var0.OnDestroy(arg0)
	arg0.dftAniEvent:SetTriggerEvent(nil)

	arg0.exited = true
end

return var0
