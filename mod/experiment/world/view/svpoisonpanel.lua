local var0_0 = class("SVPoisonPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SVPoisonPanel"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.rtName = arg0_3._tf:Find("window/content/name_mask/name")
	arg0_3.rtDesc = arg0_3._tf:Find("window/content/intro_view/Viewport/Content/intro")
	arg0_3.rtPoisonRate = arg0_3._tf:Find("window/content/poison_rate")
	arg0_3.rtBg = arg0_3._tf:Find("bg")
	arg0_3.btnClose = arg0_3._tf:Find("window/top/btnBack")
	arg0_3.btnConfirm = arg0_3._tf:Find("window/button_container/confirm_btn")

	onButton(arg0_3, arg0_3.rtBg, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.btnClose, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.btnConfirm, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
end

function var0_0.OnDestroy(arg0_7)
	return
end

function var0_0.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
	setActive(arg0_8._tf, true)
end

function var0_0.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
	setActive(arg0_9._tf, false)
end

function var0_0.Setup(arg0_10, arg1_10)
	setText(arg0_10.rtName, i18n("world_sairen_title"))

	local var0_10 = Clone(pg.gameset.world_sairen_infection.description)

	table.insert(var0_10, 1, 0)
	table.insert(var0_10, 999)
	eachChild(arg0_10.rtPoisonRate:Find("bg/ring"), function(arg0_11)
		local var0_11 = arg0_11:GetSiblingIndex() + 1

		if arg1_10 >= var0_10[var0_11] and arg1_10 < var0_10[var0_11 + 1] then
			setActive(arg0_11, true)

			arg0_11:GetComponent(typeof(Image)).fillAmount = arg1_10 / 100

			setText(arg0_10.rtDesc, i18n("world_sairen_description" .. var0_11, arg1_10))
		else
			setActive(arg0_11, false)
		end

		setText(arg0_10.rtPoisonRate:Find("bg/Text"), arg1_10 .. "%")
	end)
end

return var0_0
