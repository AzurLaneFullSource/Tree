local var0_0 = class("SpringFestival2026RedPacketPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1:findUI()
end

function var0_0.OnUpdateFlush(arg0_2)
	arg0_2:updateUI()
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.activityProxy = getProxy(ActivityProxy)
	arg0_3.activityID = arg0_3.activity.id
	arg0_3.countToStory = {}

	local var0_3 = arg0_3.activity:getConfig("config_client").story

	if var0_3 then
		for iter0_3, iter1_3 in ipairs(var0_3) do
			arg0_3.countToStory[iter1_3[1]] = iter1_3[2]
		end
	end
end

function var0_0.findUI(arg0_4)
	arg0_4.packetBtn = arg0_4._tf:Find("BG/Container/PacketBtn")
	arg0_4.packetMask = arg0_4._tf:Find("BG/Container/PacketBtnMask")
	arg0_4.helpBtn = arg0_4._tf:Find("BG/Container/HelpBtn")
	arg0_4.tagTF = arg0_4.packetBtn:Find("tag")
	arg0_4.countTF = arg0_4._tf:Find("BG/Container/Count")
	arg0_4.specialTF = arg0_4._tf:Find("BG/Container/Count/Special")
	arg0_4.specialCountText = arg0_4.specialTF:Find("Text")
	arg0_4.normalTF = arg0_4._tf:Find("BG/Container/Count/Normal")
	arg0_4.normalCountText = arg0_4.normalTF:Find("Text")
	arg0_4.awardBtnList = {}

	table.insert(arg0_4.awardBtnList, arg0_4._tf:Find("BG/Container/Award"))
	table.insert(arg0_4.awardBtnList, arg0_4._tf:Find("BG/Container/Award2"))

	arg0_4.countText = arg0_4._tf:Find("BG/Container/CountText")
end

function var0_0.OnFirstFlush(arg0_5)
	onButton(arg0_5, arg0_5.packetBtn, function()
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_5.activity.id
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_jiulou_2026.tip
		})
	end, SFX_PANEL)

	for iter0_5, iter1_5 in ipairs(arg0_5.awardBtnList) do
		if iter1_5 then
			onButton(arg0_5, iter1_5, function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
			end, SFX_PANEL)
		end
	end
end

function var0_0.updateUI(arg0_9)
	local var0_9 = arg0_9.activity.data3
	local var1_9 = arg0_9.activity.data1
	local var2_9 = math.min(arg0_9.activity.data1, arg0_9.activity.data2)
	local var3_9 = var1_9 - var2_9

	setActive(arg0_9.tagTF, var2_9 > 0)
	setActive(arg0_9.normalTF, var3_9 > 0)
	setActive(arg0_9.specialTF, var2_9 > 0)
	setActive(arg0_9.countTF, var1_9 > 0)
	setText(arg0_9.normalCountText, var3_9)
	setText(arg0_9.specialCountText, var2_9)
	setActive(arg0_9.packetBtn, var1_9 > 0)
	setActive(arg0_9.packetMask, not (var1_9 > 0))

	local var4_9 = arg0_9.activity.data1_list[2]
	local var5_9 = arg0_9.activity.data1_list[1]

	setText(arg0_9.countText, var4_9 .. "/" .. var5_9)
end

function var0_0.tryPlayStory(arg0_10)
	local var0_10 = arg0_10.activity.data3
	local var1_10 = arg0_10.activity.data1 - math.min(arg0_10.activity.data1, arg0_10.activity.data2)
	local var2_10 = var0_10 - arg0_10.activity.data2
	local var3_10 = arg0_10.countToStory[var2_10]

	if var3_10 then
		pg.NewStoryMgr.GetInstance():Play(var3_10)
	end
end

function var0_0.OnUpdateFlush(arg0_11)
	arg0_11:updateUI()
	arg0_11:tryPlayStory()
end

return var0_0
