local var0 = class("SculptureResMsgBoxPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculptureResMsgBoxUI"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.icon = arg0:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0.name = arg0:findTF("frame/name"):GetComponent(typeof(Text))
	arg0.desc = arg0:findTF("frame/scrollrect/desc"):GetComponent(typeof(Text))
	arg0.outPut = arg0:findTF("frame/output/Text"):GetComponent(typeof(Text))
	arg0.goBtn = arg0:findTF("frame/output/btn")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.id = arg1

	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0 = pg.activity_workbench_item[arg0.id]

	arg0.icon.sprite = LoadSprite("props/" .. var0.icon)

	arg0.icon:SetNativeSize()

	arg0.name.text = var0.name
	arg0.desc.text = var0.display
	arg0.outPut.text = var0.get_access[1]

	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.WORKBENCH_ITEM_GO, arg0.id)
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	return
end

return var0
