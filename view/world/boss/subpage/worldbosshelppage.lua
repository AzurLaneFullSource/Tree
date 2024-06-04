local var0 = class("WorldBossHelpPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "WorldBossHelpUI"
end

function var0.OnLoaded(arg0)
	arg0.friendBtn = arg0:findTF("window/sliders/content/friend")
	arg0.friendRequested = arg0.friendBtn:Find("requested")
	arg0.friendMark = arg0.friendBtn:Find("mark")
	arg0.friendSupportTimeTxt = arg0.friendBtn:Find("requested/Text"):GetComponent(typeof(Text))
	arg0.guildBtn = arg0:findTF("window/sliders/content/guild")
	arg0.guildRequested = arg0.guildBtn:Find("requested")
	arg0.guildMark = arg0.guildBtn:Find("mark")
	arg0.guildSupportTimeTxt = arg0.guildBtn:Find("requested/Text"):GetComponent(typeof(Text))
	arg0.worldBtn = arg0:findTF("window/sliders/content/world")
	arg0.worldRequested = arg0.worldBtn:Find("requested")
	arg0.worldMark = arg0.worldBtn:Find("mark")
	arg0.worldSupportTimeTxt = arg0.worldBtn:Find("requested/Text"):GetComponent(typeof(Text))
	arg0.timers = {}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("cancel_btn"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("window/top/btnBack"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.friendBtn, function()
		arg0.friendFlag = not arg0.friendFlag

		setActive(arg0.friendMark, arg0.friendFlag)
	end, SFX_PANEL)
	onButton(arg0, arg0.guildBtn, function()
		arg0.guildFlag = not arg0.guildFlag

		setActive(arg0.guildMark, arg0.guildFlag)
	end, SFX_PANEL)
	onButton(arg0, arg0.worldBtn, function()
		if nowWorld():GetBossProxy():WorldSupported() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_boss_ask_help"))

			return
		end

		arg0.worldFlag = not arg0.worldFlag

		setActive(arg0.worldMark, arg0.worldFlag)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("confirm_btn"), function()
		arg0:emit(WorldBossMediator.ON_SURPPORT, {
			arg0.friendFlag,
			arg0.guildFlag,
			arg0.worldFlag
		})
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Reset(arg0)
	arg0.friendFlag = false
	arg0.guildFlag = false
	arg0.worldFlag = false
end

function var0.Update(arg0, arg1)
	arg0.boss = arg1

	arg0:Reset()
	arg0:UpdateFriendRequestItem()
	arg0:UpdateGuildRequetItem()
	arg0:UpdateWorldRequetItem()
	arg0:Show()
end

function var0.UpdateFriendRequestItem(arg0)
	local var0 = arg0.boss
	local var1 = nowWorld():GetBossProxy()
	local var2 = var1:FriendSupported()

	setButtonEnabled(arg0.friendBtn, not var2)
	setActive(arg0.friendRequested, var2)
	setActive(arg0.friendMark, false)
	arg0:RemoveRequestTimer(arg0.friendSupportTimeTxt)

	if var2 then
		local var3 = var1:GetNextFriendSupportTime()

		arg0:AddRequestTimer(var3, arg0.friendSupportTimeTxt, function()
			arg0:UpdateFriendRequestItem()
		end)
	end
end

function var0.UpdateGuildRequetItem(arg0)
	local var0 = arg0.boss
	local var1 = nowWorld():GetBossProxy()
	local var2 = var1:GuildSupported()

	setButtonEnabled(arg0.guildBtn, not var2)
	setActive(arg0.guildRequested, var2)
	setActive(arg0.guildMark, false)
	arg0:RemoveRequestTimer(arg0.guildSupportTimeTxt)

	if var2 then
		local var3 = var1:GetNextGuildSupportTime()

		arg0:AddRequestTimer(var3, arg0.guildSupportTimeTxt, function()
			arg0:UpdateGuildRequetItem()
		end)
	end
end

function var0.UpdateWorldRequetItem(arg0)
	local var0 = nowWorld():GetBossProxy()
	local var1 = var0:WorldSupported()

	setActive(arg0.worldRequested, var1)
	setActive(arg0.worldMark, false)
	arg0:RemoveRequestTimer(arg0.worldSupportTimeTxt)

	if var1 then
		local var2 = var0:GetNextWorldSupportTime()

		arg0:AddRequestTimer(var2, arg0.worldSupportTimeTxt, function()
			arg0:UpdateWorldRequetItem()
		end)
	end
end

function var0.AddRequestTimer(arg0, arg1, arg2, arg3)
	local var0 = nowWorld():GetBossProxy()

	arg0.timers[arg2] = Timer.New(function()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1 = arg1 - var0

		if var1 > 0 then
			arg2.text = pg.TimeMgr.GetInstance():DescCDTime(var1)
		else
			arg2.text = ""

			arg0:RemoveRequestTimer(arg2)
			arg3()
		end
	end, 1, -1)

	arg0.timers[arg2]:Start()
	arg0.timers[arg2].func()
end

function var0.RemoveRequestTimer(arg0, arg1)
	if arg0.timers[arg1] then
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end
end

function var0.RemoveRequestTimers(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = {}
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
	arg0:RemoveRequestTimers()
end

return var0
