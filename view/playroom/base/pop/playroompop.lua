local var0_0 = class("PlayRoomPop", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.playRoomInvitePop = PlayRoomInvitePop.New(arg0_2._tf:Find("invitePanel"), arg0_2._parentClass)
	arg0_2.playRoomMatchPop = PlayRoomMatchPop.New(arg0_2._tf:Find("matchPanel"), arg0_2._parentClass)
end

function var0_0.didEnter(arg0_3)
	setParent(arg0_3._go, pg.UIMgr.GetInstance().OverlayToast)
	arg0_3.playRoomInvitePop:Hide()
	arg0_3.playRoomMatchPop:Hide()
	arg0_3:RefreshUI()

	arg0_3.timer = Timer.New(function()
		arg0_3:RefreshUI()
	end, 0.5, -1)

	arg0_3.timer:Start()
	arg0_3.playRoomInvitePop:didEnter()
	arg0_3.playRoomMatchPop:didEnter()
end

function var0_0.RefreshUI(arg0_5)
	if getProxy(PlayRoomProxy):GetMatchFlag() then
		arg0_5.playRoomMatchPop:RefreshMatch()
		arg0_5.playRoomInvitePop:Show(false)
	else
		arg0_5.playRoomInvitePop:RefreshInvite()
		arg0_5.playRoomMatchPop:Show(false)
	end
end

function var0_0.willExit(arg0_6)
	if arg0_6.timer then
		arg0_6.timer:Stop()

		arg0_6.timer = nil
	end

	arg0_6:detach()
	arg0_6.playRoomInvitePop:willExit()

	arg0_6.playRoomInvitePop = nil

	arg0_6.playRoomMatchPop:willExit()

	arg0_6.playRoomMatchPop = nil

	Object.Destroy(arg0_6._go)
end

function var0_0.Show(arg0_7, arg1_7)
	setActive(arg0_7._go, arg1_7)
	arg0_7.playRoomInvitePop:Hide(false)
	arg0_7.playRoomMatchPop:Hide(false)
end

return var0_0
