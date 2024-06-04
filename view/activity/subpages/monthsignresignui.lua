local var0 = class("MonthSignReSignUI", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "MonthSignReSignUI"
end

function var0.OnInit(arg0)
	arg0:InitUI()
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.InitUI(arg0)
	arg0.destroyBonusList = arg0._tf:Find("frame/bg/scrollview/list")
	arg0.itemTpl = arg0.destroyBonusList:Find("item_tpl")

	setText(arg0:findTF("frame/title_text/Text"), i18n("month_sign_resign"))
	onButton(arg0, arg0:findTF("frame/top/btnBack"), function()
		arg0:Destroy()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("frame/actions/confirm_btn"), function()
		arg0:Destroy()
	end, SFX_UI_EQUIPMENT_RESOLVE)
end

function var0.setAwardShow(arg0, arg1, arg2)
	arg0.awards = arg1
	arg0.callback = arg2

	arg0:displayAwards()
end

function var0.OnDestroy(arg0)
	arg0.selectedIds = nil

	if arg0.callback then
		arg0.callback()

		arg0.callback = nil
	end

	arg0.awards = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.displayAwards(arg0)
	assert(#arg0.awards ~= 0, "items数量不能为0")
	removeAllChildren(arg0.destroyBonusList)

	for iter0 = 1, #arg0.awards do
		local var0 = cloneTplTo(arg0.itemTpl, arg0.destroyBonusList):Find("bg")
		local var1 = arg0.awards[iter0]

		updateDrop(tf(var0), var1, {
			fromAwardLayer = true
		})
		setActive(findTF(var0, "bonus"), var1.riraty)

		local var2 = findTF(var0, "name")
		local var3 = findTF(var0, "name_mask")

		setActive(var2, false)
		setActive(var3, true)

		local var4 = var1.name or getText(var2)

		setScrollText(findTF(var0, "name_mask/name"), var4)
		onButton(arg0, var0, function()
			if arg0.inAniming then
				return
			end

			arg0:emit(BaseUI.ON_DROP, var1)
		end, SFX_PANEL)
	end
end

return var0
