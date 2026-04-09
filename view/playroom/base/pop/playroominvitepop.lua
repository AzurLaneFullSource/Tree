local var0_0 = class("PlayRoomInvitePop", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)
	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiAgreeBtn, function()
		local var0_3 = getProxy(PlayRoomProxy):GetInviteList()

		if var0_3[1] then
			local var1_3 = var0_3[1].roomData
			local var2_3 = var1_3.id

			arg0_2:emit(IslandMediator.PLAY_ROOM_INVITE_AGREE, {
				id = var1_3.id,
				gameType = var1_3.gameType
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPlayRoomInvate("bar", var1_3.id, 1))
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		local var0_4 = getProxy(PlayRoomProxy):GetInviteList()

		if var0_4[1] then
			local var1_4 = var0_4[1].roomData.id

			arg0_2:emit(IslandMediator.PLAY_ROOM_INVITE_REFUSE, var1_4)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPlayRoomInvate("bar", var1_4, 0))
		end
	end, SFX_PANEL)
	setText(arg0_2.uiAgreeText, i18n("match_ui_matching_consent"))
end

function var0_0.didEnter(arg0_5)
	arg0_5.showState = false

	arg0_5:Hide()
	arg0_5:Show(false)
end

function var0_0.willExit(arg0_6)
	arg0_6:StopLeanTween()
	arg0_6:detach()
	Object.Destroy(arg0_6._go)

	arg0_6._go = nil
	arg0_6._tf = nil
end

function var0_0.Show(arg0_7, arg1_7)
	if arg0_7.showState == false and arg1_7 == true then
		setActive(arg0_7._go, arg1_7)

		arg0_7.showState = arg1_7

		arg0_7.uiAnimation:Play("Anim_IslandCheatBarEntranceUI_invitePanel_in")
		arg0_7.uiAnimation:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_8)
			return
		end)
	elseif arg0_7.showState == true and arg1_7 == false then
		arg0_7.showState = arg1_7

		arg0_7.uiAnimation:Play("Anim_IslandCheatBarEntranceUI_invitePanel_out")
		arg0_7.uiAnimation:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_9)
			arg0_7:Hide()
		end)
	end
end

function var0_0.Hide(arg0_10)
	arg0_10.showState = false

	setActive(arg0_10._go, false)
end

function var0_0.RefreshInvite(arg0_11)
	local var0_11 = getProxy(PlayRoomProxy):GetInviteList()

	arg0_11:Show(var0_11[1] ~= nil)

	if var0_11[1] and arg0_11.endTime ~= var0_11[1].timestamp then
		arg0_11:RefreshUI(var0_11[1])

		arg0_11.endTime = var0_11[1].timestamp

		local var1_11 = pg.gameset.match_refuseCD.key_value

		arg0_11:StartLeanTween(pg.TimeMgr.GetInstance():GetServerTime(), var0_11[1].timestamp + var1_11)
	end
end

function var0_0.RefreshUI(arg0_12, arg1_12)
	local var0_12 = arg1_12.invitor
	local var1_12 = arg1_12.roomData

	setText(arg0_12.uiNameText, var0_12.name)
	setText(arg0_12.uiCntText, string.format("%s/%s", var1_12.teamCnt, PlayRoomTools.GetMaxPlayerCnt(var1_12.gameType)))

	local var2_12 = Ship.New({
		configId = var0_12.display.icon
	})

	LoadSpriteAsync("qicon/" .. var2_12:getPrefab(), function(arg0_13)
		arg0_12.uiIcon.sprite = arg0_13
	end)
end

function var0_0.StartLeanTween(arg0_14, arg1_14, arg2_14)
	arg0_14:StopLeanTween()

	if arg2_14 <= arg1_14 then
		return
	end

	LeanTween.value(arg0_14._go, (arg2_14 - arg1_14) / pg.gameset.match_refuseCD.key_value, 0, arg2_14 - arg1_14):setOnUpdate(System.Action_float(function(arg0_15)
		arg0_14.uiSlider.fillAmount = arg0_15
	end)):setOnComplete(System.Action(function()
		arg0_14:StopLeanTween()
	end))
end

function var0_0.StopLeanTween(arg0_17)
	LeanTween.cancel(arg0_17._go)
end

return var0_0
