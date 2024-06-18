local var0_0 = class("FeastResWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FeastResWindow"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.icon = arg0_2:findTF("frame/item/icon"):GetComponent(typeof(Image))
	arg0_2.name = arg0_2:findTF("frame/name/Text"):GetComponent(typeof(Text))
	arg0_2.desc = arg0_2:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_2.outPut = arg0_2:findTF("frame/output/Text"):GetComponent(typeof(Text))
	arg0_2.goBtn = arg0_2:findTF("frame/go")

	setText(arg0_2.goBtn:Find("Text"), i18n("feast_res_window_go_label"))
	setText(arg0_2:findTF("frame/title"), i18n("feast_res_window_title"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)

	arg0_5.id = arg1_5

	arg0_5:UpdateView()
end

function var0_0.UpdateView(arg0_6)
	local var0_6 = pg.activity_workbench_item[arg0_6.id]

	arg0_6.icon.sprite = LoadSprite("props/" .. var0_6.icon)

	arg0_6.icon:SetNativeSize()

	arg0_6.name.text = var0_6.name
	arg0_6.desc.text = var0_6.display
	arg0_6.outPut.text = var0_6.get_access[1]

	onButton(arg0_6, arg0_6.goBtn, function()
		pg.m02:sendNotification(GAME.WORKBENCH_ITEM_GO, arg0_6.id)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
