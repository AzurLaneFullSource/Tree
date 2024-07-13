local var0_0 = class("WorldBossHelpPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldBossHelpUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.friendBtn = arg0_2:findTF("window/sliders/content/friend")
	arg0_2.friendRequested = arg0_2.friendBtn:Find("requested")
	arg0_2.friendMark = arg0_2.friendBtn:Find("mark")
	arg0_2.friendSupportTimeTxt = arg0_2.friendBtn:Find("requested/Text"):GetComponent(typeof(Text))
	arg0_2.guildBtn = arg0_2:findTF("window/sliders/content/guild")
	arg0_2.guildRequested = arg0_2.guildBtn:Find("requested")
	arg0_2.guildMark = arg0_2.guildBtn:Find("mark")
	arg0_2.guildSupportTimeTxt = arg0_2.guildBtn:Find("requested/Text"):GetComponent(typeof(Text))
	arg0_2.worldBtn = arg0_2:findTF("window/sliders/content/world")
	arg0_2.worldRequested = arg0_2.worldBtn:Find("requested")
	arg0_2.worldMark = arg0_2.worldBtn:Find("mark")
	arg0_2.worldSupportTimeTxt = arg0_2.worldBtn:Find("requested/Text"):GetComponent(typeof(Text))
	arg0_2.timers = {}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("cancel_btn"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("window/top/btnBack"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.friendBtn, function()
		arg0_3.friendFlag = not arg0_3.friendFlag

		setActive(arg0_3.friendMark, arg0_3.friendFlag)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.guildBtn, function()
		arg0_3.guildFlag = not arg0_3.guildFlag

		setActive(arg0_3.guildMark, arg0_3.guildFlag)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.worldBtn, function()
		if nowWorld():GetBossProxy():WorldSupported() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_boss_ask_help"))

			return
		end

		arg0_3.worldFlag = not arg0_3.worldFlag

		setActive(arg0_3.worldMark, arg0_3.worldFlag)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("confirm_btn"), function()
		arg0_3:emit(WorldBossMediator.ON_SURPPORT, {
			arg0_3.friendFlag,
			arg0_3.guildFlag,
			arg0_3.worldFlag
		})
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Reset(arg0_11)
	arg0_11.friendFlag = false
	arg0_11.guildFlag = false
	arg0_11.worldFlag = false
end

function var0_0.Update(arg0_12, arg1_12)
	arg0_12.boss = arg1_12

	arg0_12:Reset()
	arg0_12:UpdateFriendRequestItem()
	arg0_12:UpdateGuildRequetItem()
	arg0_12:UpdateWorldRequetItem()
	arg0_12:Show()
end

function var0_0.UpdateFriendRequestItem(arg0_13)
	local var0_13 = arg0_13.boss
	local var1_13 = nowWorld():GetBossProxy()
	local var2_13 = var1_13:FriendSupported()

	setButtonEnabled(arg0_13.friendBtn, not var2_13)
	setActive(arg0_13.friendRequested, var2_13)
	setActive(arg0_13.friendMark, false)
	arg0_13:RemoveRequestTimer(arg0_13.friendSupportTimeTxt)

	if var2_13 then
		local var3_13 = var1_13:GetNextFriendSupportTime()

		arg0_13:AddRequestTimer(var3_13, arg0_13.friendSupportTimeTxt, function()
			arg0_13:UpdateFriendRequestItem()
		end)
	end
end

function var0_0.UpdateGuildRequetItem(arg0_15)
	local var0_15 = arg0_15.boss
	local var1_15 = nowWorld():GetBossProxy()
	local var2_15 = var1_15:GuildSupported()

	setButtonEnabled(arg0_15.guildBtn, not var2_15)
	setActive(arg0_15.guildRequested, var2_15)
	setActive(arg0_15.guildMark, false)
	arg0_15:RemoveRequestTimer(arg0_15.guildSupportTimeTxt)

	if var2_15 then
		local var3_15 = var1_15:GetNextGuildSupportTime()

		arg0_15:AddRequestTimer(var3_15, arg0_15.guildSupportTimeTxt, function()
			arg0_15:UpdateGuildRequetItem()
		end)
	end
end

function var0_0.UpdateWorldRequetItem(arg0_17)
	local var0_17 = nowWorld():GetBossProxy()
	local var1_17 = var0_17:WorldSupported()

	setActive(arg0_17.worldRequested, var1_17)
	setActive(arg0_17.worldMark, false)
	arg0_17:RemoveRequestTimer(arg0_17.worldSupportTimeTxt)

	if var1_17 then
		local var2_17 = var0_17:GetNextWorldSupportTime()

		arg0_17:AddRequestTimer(var2_17, arg0_17.worldSupportTimeTxt, function()
			arg0_17:UpdateWorldRequetItem()
		end)
	end
end

function var0_0.AddRequestTimer(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = nowWorld():GetBossProxy()

	arg0_19.timers[arg2_19] = Timer.New(function()
		local var0_20 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_20 = arg1_19 - var0_20

		if var1_20 > 0 then
			arg2_19.text = pg.TimeMgr.GetInstance():DescCDTime(var1_20)
		else
			arg2_19.text = ""

			arg0_19:RemoveRequestTimer(arg2_19)
			arg3_19()
		end
	end, 1, -1)

	arg0_19.timers[arg2_19]:Start()
	arg0_19.timers[arg2_19].func()
end

function var0_0.RemoveRequestTimer(arg0_21, arg1_21)
	if arg0_21.timers[arg1_21] then
		arg0_21.timers[arg1_21]:Stop()

		arg0_21.timers[arg1_21] = nil
	end
end

function var0_0.RemoveRequestTimers(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.timers) do
		iter1_22:Stop()
	end

	arg0_22.timers = {}
end

function var0_0.Show(arg0_23)
	var0_0.super.Show(arg0_23)
	pg.UIMgr.GetInstance():BlurPanel(arg0_23._tf)
end

function var0_0.Hide(arg0_24)
	var0_0.super.Hide(arg0_24)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_24._tf, arg0_24._parentTf)
end

function var0_0.OnDestroy(arg0_25)
	arg0_25:Hide()
	arg0_25:RemoveRequestTimers()
end

return var0_0
