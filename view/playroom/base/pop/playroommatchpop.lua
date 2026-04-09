local var0_0 = class("PlayRoomMatchPop", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:emit(IslandMediator.PLAY_ROOM_MATCH_STOP)
	end, SFX_PANEL)
	setText(arg0_2.uiMatchText, i18n("match_ui_matching_waiting2"))
end

function var0_0.didEnter(arg0_4)
	arg0_4.showState = false

	arg0_4:Hide()
	arg0_4:Show(false)
end

function var0_0.willExit(arg0_5)
	arg0_5:detach()
	Object.Destroy(arg0_5._go)

	arg0_5._go = nil
	arg0_5._tf = nil
end

function var0_0.Show(arg0_6, arg1_6)
	if arg0_6.showState == false and arg1_6 == true then
		arg0_6.showState = arg1_6

		setActive(arg0_6._go, false)
		setActive(arg0_6._go, arg1_6)
		arg0_6.uiAnimation:Play("Anim_IslandCheatBarEntranceUI_invitePanel_in")
		arg0_6.uiAnimation:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_7)
			arg0_6.uiAnimation:Play("Anim_IslandCheatBarEntranceUI_invitePanel_loop")
		end)
	elseif arg0_6.showState == true and arg1_6 == false then
		arg0_6.showState = arg1_6

		arg0_6.uiAnimation:Play("Anim_IslandCheatBarEntranceUI_invitePanel_out")
		arg0_6.uiAnimation:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_8)
			arg0_6:Hide()
		end)
	end
end

function var0_0.Hide(arg0_9)
	arg0_9.showState = false

	setActive(arg0_9._go, false)
end

function var0_0.RefreshMatch(arg0_10)
	local var0_10 = getProxy(PlayRoomProxy)

	arg0_10:Show(true)

	local var1_10 = var0_10:GetMatchTime()
	local var2_10 = var0_10:GetMatchStarTime()
	local var3_10 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4_10 = var1_10 - var3_10
	local var5_10 = var3_10 - var2_10

	setText(arg0_10.uiTipsText, i18n("match_ui_matching_waiting1", var5_10))

	if var4_10 <= 0 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPlayRoomMatch("bar", 2, 1, var5_10, 0))
		pg.TipsMgr.GetInstance():ShowTips(i18n("match_ui_matching_fail"))
		arg0_10:emit(IslandMediator.PLAY_ROOM_MATCH_STOP)
	end
end

return var0_0
