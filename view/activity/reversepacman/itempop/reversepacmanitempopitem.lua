local var0_0 = class("ReversePacmanItemPopItem", import("view.base.BasePanel"))

var0_0.SKIP_TYPE_SCENE = 2
var0_0.SKIP_TYPE_ACTIVITY = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiGoText, i18n("task_go"))
	onButton(arg0_2, arg0_2.uiGoBtn, function()
		local var0_3 = arg0_2.data[2]

		if arg0_2.data[1] == var0_0.SKIP_TYPE_SCENE then
			pg.m02:sendNotification(GAME.GO_SCENE, var0_3[1], var0_3[2] or {})
		elseif arg0_2.data[1] == var0_0.SKIP_TYPE_ACTIVITY then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
				id = var0_3
			})
		end
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_4, arg1_4)
	arg0_4.data = arg1_4

	setScrollText(arg0_4.uiTitleText, arg1_4[3])
	arg0_4:Show(true)
end

function var0_0.Show(arg0_5, arg1_5)
	setActive(arg0_5._go, arg1_5)
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
	Object.Destroy(arg0_6._go)

	arg0_6._tf = nil
	arg0_6._go = nil
end

return var0_0
