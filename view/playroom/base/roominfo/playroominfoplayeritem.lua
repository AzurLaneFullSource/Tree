local var0_0 = class("PlayRoomInfoPlayerItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiBgTf, function()
		arg0_2:emit(PlayRoomInfoMediator.ON_CLICK_INVITE)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiKickTf, function()
		arg0_2:emit(PlayRoomInfoMediator.ON_CLICK_KICK, {
			id = arg0_2.playerData.id
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSwitchCharacterBtn, function()
		arg0_2:emit(PlayRoomInfoMediator.ON_CLICK_CHANGE_CHARACTER)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6, arg5_6)
	arg0_6.isSelf = false

	if arg1_6 then
		arg0_6.playerData = arg1_6

		local var0_6 = getProxy(PlayerProxy):getPlayerId()
		local var1_6 = var0_6 == arg1_6.id

		arg0_6.isSelf = var1_6

		setActive(arg0_6.uiBgTf, false)
		setActive(arg0_6.uiMainTf, true)
		setText(arg0_6.uiNameText, arg1_6.name)
		setActive(arg0_6.uiRoomOwnerGo, arg2_6 == arg1_6.id)
		setActive(arg0_6.uiKickTf, arg2_6 == var0_6 and not var1_6)

		local var2_6 = getProxy(PlayRoomProxy):GetRoomData()

		setActive(arg0_6.uiSwitchCharacterBtn, (arg2_6 == var0_6 or not arg4_6) and var1_6 and arg3_6 ~= IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom and not arg5_6)
	else
		setActive(arg0_6.uiBgTf, true)
		setActive(arg0_6.uiMainTf, false)
	end

	if arg5_6 then
		setActive(arg0_6.uiLoadProcessBg, true)

		arg0_6.uiLoadProcess.fillAmount = arg5_6 / 100
	else
		setActive(arg0_6.uiLoadProcessBg, false)
	end

	setActive(arg0_6._go, true)
end

function var0_0.RefreshSelfLoad(arg0_7, arg1_7)
	if arg0_7.isSelf then
		setActive(arg0_7.uiLoadProcessBg, true)

		arg0_7.uiLoadProcess.fillAmount = arg1_7 / 100
	end
end

function var0_0.willExit(arg0_8)
	arg0_8:detach()
	Object.Destroy(arg0_8._go)

	arg0_8._go = nil
	arg0_8._tf = nil
end

return var0_0
