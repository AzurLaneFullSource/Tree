local var0_0 = class("MonthSignReSignUI", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MonthSignReSignUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitUI()
	setActive(arg0_2._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.InitUI(arg0_3)
	arg0_3.destroyBonusList = arg0_3._tf:Find("frame/bg/scrollview/list")
	arg0_3.itemTpl = arg0_3.destroyBonusList:Find("item_tpl")

	setText(arg0_3:findTF("frame/title_text/Text"), i18n("month_sign_resign"))
	onButton(arg0_3, arg0_3:findTF("frame/top/btnBack"), function()
		arg0_3:Destroy()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("frame/actions/confirm_btn"), function()
		arg0_3:Destroy()
	end, SFX_UI_EQUIPMENT_RESOLVE)
end

function var0_0.setAwardShow(arg0_6, arg1_6, arg2_6)
	arg0_6.awards = arg1_6
	arg0_6.callback = arg2_6

	arg0_6:displayAwards()
end

function var0_0.OnDestroy(arg0_7)
	arg0_7.selectedIds = nil

	if arg0_7.callback then
		arg0_7.callback()

		arg0_7.callback = nil
	end

	arg0_7.awards = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf, arg0_7._parentTf)
end

function var0_0.displayAwards(arg0_8)
	assert(#arg0_8.awards ~= 0, "items数量不能为0")
	removeAllChildren(arg0_8.destroyBonusList)

	for iter0_8 = 1, #arg0_8.awards do
		local var0_8 = cloneTplTo(arg0_8.itemTpl, arg0_8.destroyBonusList):Find("bg")
		local var1_8 = arg0_8.awards[iter0_8]

		updateDrop(tf(var0_8), var1_8, {
			fromAwardLayer = true
		})
		setActive(findTF(var0_8, "bonus"), var1_8.riraty)

		local var2_8 = findTF(var0_8, "name")
		local var3_8 = findTF(var0_8, "name_mask")

		setActive(var2_8, false)
		setActive(var3_8, true)

		local var4_8 = var1_8.name or getText(var2_8)

		setScrollText(findTF(var0_8, "name_mask/name"), var4_8)
		onButton(arg0_8, var0_8, function()
			if arg0_8.inAniming then
				return
			end

			arg0_8:emit(BaseUI.ON_DROP, var1_8)
		end, SFX_PANEL)
	end
end

return var0_0
