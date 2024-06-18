local var0_0 = class("SculptureResMsgBoxPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculptureResMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.icon = arg0_2:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0_2.name = arg0_2:findTF("frame/name"):GetComponent(typeof(Text))
	arg0_2.desc = arg0_2:findTF("frame/scrollrect/desc"):GetComponent(typeof(Text))
	arg0_2.outPut = arg0_2:findTF("frame/output/Text"):GetComponent(typeof(Text))
	arg0_2.goBtn = arg0_2:findTF("frame/output/btn")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	arg0_6.id = arg1_6

	arg0_6:UpdateView()
end

function var0_0.UpdateView(arg0_7)
	local var0_7 = pg.activity_workbench_item[arg0_7.id]

	arg0_7.icon.sprite = LoadSprite("props/" .. var0_7.icon)

	arg0_7.icon:SetNativeSize()

	arg0_7.name.text = var0_7.name
	arg0_7.desc.text = var0_7.display
	arg0_7.outPut.text = var0_7.get_access[1]

	onButton(arg0_7, arg0_7.goBtn, function()
		pg.m02:sendNotification(GAME.WORKBENCH_ITEM_GO, arg0_7.id)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
