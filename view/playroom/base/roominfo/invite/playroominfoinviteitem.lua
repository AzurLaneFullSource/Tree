local var0_0 = class("PlayRoomInfoInviteItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiOnlineText, i18n("island_btn_label_online"))
end

function var0_0.didEnter(arg0_3, arg1_3)
	setText(arg0_3.uiNameText, arg1_3.name)
	setText(arg0_3.uiLevelText, arg1_3.level)

	local var0_3 = Ship.New({
		configId = arg1_3.icon
	})

	LoadSpriteAsync("qicon/" .. var0_3:getPrefab(), function(arg0_4)
		arg0_3.uiIcon.sprite = arg0_4
	end)

	local var1_3 = arg1_3:isOnline()

	setActive(arg0_3.uiOnlineTf, var1_3)
	setActive(arg0_3.uiOfflineTf, not var1_3)

	if not var1_3 then
		setText(arg0_3.uiOfflineText, getOfflineTimeStamp(arg1_3.preOnLineTime))
	else
		setText(arg0_3.uiOnlineText, i18n("island_btn_label_online"))
	end

	setText(arg0_3.uiInviteText, i18n("island_btn_label_invitation"))
	setText(arg0_3.uiCancelText, i18n("island_btn_label_invitation_already"))
	onButton(arg0_3, arg0_3.uiInviteBtn, function()
		arg0_3:emit(PlayRoomInfoInviteMediator.ON_CLICK_INVITE, {
			id = arg1_3.id
		})
	end, SFX_PANEL)

	local var2_3 = getProxy(PlayRoomProxy):GetInviteRecordByID(arg1_3.id)

	setActive(arg0_3.uiInviteBtn, var2_3 == nil)
	setActive(arg0_3.uiCancelBtn, var2_3 ~= nil)
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
end

return var0_0
