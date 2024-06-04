local var0 = class("SVPoisonPanel", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SVPoisonPanel"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.rtName = arg0._tf:Find("window/content/name_mask/name")
	arg0.rtDesc = arg0._tf:Find("window/content/intro_view/Viewport/Content/intro")
	arg0.rtPoisonRate = arg0._tf:Find("window/content/poison_rate")
	arg0.rtBg = arg0._tf:Find("bg")
	arg0.btnClose = arg0._tf:Find("window/top/btnBack")
	arg0.btnConfirm = arg0._tf:Find("window/button_container/confirm_btn")

	onButton(arg0, arg0.rtBg, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnClose, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnConfirm, function()
		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.Setup(arg0, arg1)
	setText(arg0.rtName, i18n("world_sairen_title"))

	local var0 = Clone(pg.gameset.world_sairen_infection.description)

	table.insert(var0, 1, 0)
	table.insert(var0, 999)
	eachChild(arg0.rtPoisonRate:Find("bg/ring"), function(arg0)
		local var0 = arg0:GetSiblingIndex() + 1

		if arg1 >= var0[var0] and arg1 < var0[var0 + 1] then
			setActive(arg0, true)

			arg0:GetComponent(typeof(Image)).fillAmount = arg1 / 100

			setText(arg0.rtDesc, i18n("world_sairen_description" .. var0, arg1))
		else
			setActive(arg0, false)
		end

		setText(arg0.rtPoisonRate:Find("bg/Text"), arg1 .. "%")
	end)
end

return var0
