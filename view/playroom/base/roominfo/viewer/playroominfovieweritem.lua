local var0_0 = class("PlayRoomInfoViewerItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3, arg1_3, arg2_3)
	setText(arg0_3.uiNameText, arg1_3.name)
	setText(arg0_3.uiPtCntText, arg1_3.ptCnt)
	setText(arg0_3.uiServeText, "区服")
	setActive(arg0_3.uiKickBtn, arg2_3)
	onButton(arg0_3, arg0_3.uiKickBtn, function()
		arg0_3:emit(PlayRoomInfoViewerMediator.ON_CLICK_KICK, {
			id = arg1_3.id
		})
	end, SFX_PANEL)

	local var0_3 = Ship.New({
		configId = arg1_3.displayicon
	})

	LoadSpriteAsync("qicon/" .. var0_3:getPrefab(), function(arg0_5)
		arg0_3.uiIcon.sprite = arg0_5
	end)
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
end

return var0_0
