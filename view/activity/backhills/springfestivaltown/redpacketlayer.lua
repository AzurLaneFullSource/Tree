local var0_0 = class("RedPacketLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	if PLATFORM_CODE == PLATFORM_CHT then
		return "RedPacket2023UI"
	else
		return "RedPacket2023UI"
	end
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateUI()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.activityProxy = getProxy(ActivityProxy)

	local var0_5 = arg0_5.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

	arg0_5.activityID = var0_5.id
	arg0_5.countToStory = {}

	local var1_5 = var0_5:getConfig("config_client").story

	if var1_5 then
		for iter0_5, iter1_5 in ipairs(var1_5) do
			arg0_5.countToStory[iter1_5[1]] = iter1_5[2]
		end
	end
end

function var0_0.findUI(arg0_6)
	arg0_6.packetBtn = arg0_6:findTF("Container/PacketBtn")
	arg0_6.packetMask = arg0_6:findTF("Container/PacketBtnMask")
	arg0_6.helpBtn = arg0_6:findTF("Container/HelpBtn")
	arg0_6.tagTF = arg0_6:findTF("tag", arg0_6.packetBtn)
	arg0_6.countTF = arg0_6:findTF("Container/Count")
	arg0_6.specialTF = arg0_6:findTF("Container/Count/Special")
	arg0_6.specialCountText = arg0_6:findTF("Text", arg0_6.specialTF)
	arg0_6.normalTF = arg0_6:findTF("Container/Count/Normal")
	arg0_6.normalCountText = arg0_6:findTF("Text", arg0_6.normalTF)
	arg0_6.awardBtnList = {}

	table.insert(arg0_6.awardBtnList, arg0_6:findTF("Container/Award"))
	table.insert(arg0_6.awardBtnList, arg0_6:findTF("Container/Award2"))

	arg0_6.countText = arg0_6:findTF("Container/CountText")
	arg0_6.backBtn = arg0_6:findTF("Top/BackBtn")
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:closeView()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.packetBtn, function()
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_7.activityID
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_jiulou.tip
		})
	end, SFX_PANEL)

	for iter0_7, iter1_7 in ipairs(arg0_7.awardBtnList) do
		if iter1_7 then
			onButton(arg0_7, iter1_7, function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
			end, SFX_PANEL)
		end
	end
end

function var0_0.updateUI(arg0_12)
	local var0_12 = arg0_12.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)
	local var1_12 = var0_12.data3
	local var2_12 = var0_12.data1
	local var3_12 = math.min(var0_12.data1, var0_12.data2)
	local var4_12 = var2_12 - var3_12

	print(var4_12, var3_12, var2_12)
	setActive(arg0_12.tagTF, var3_12 > 0)
	setActive(arg0_12.normalTF, var4_12 > 0)
	setActive(arg0_12.specialTF, var3_12 > 0)
	setActive(arg0_12.countTF, var2_12 > 0)
	setText(arg0_12.normalCountText, var4_12)
	setText(arg0_12.specialCountText, var3_12)
	setActive(arg0_12.packetBtn, var2_12 > 0)
	setActive(arg0_12.packetMask, not (var2_12 > 0))

	local var5_12 = var0_12.data1_list[2]
	local var6_12 = var0_12.data1_list[1]

	setText(arg0_12.countText, var5_12 .. "/" .. var6_12)
end

function var0_0.tryPlayStory(arg0_13)
	local var0_13 = arg0_13.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)
	local var1_13 = var0_13.data3
	local var2_13 = var0_13.data1 - math.min(var0_13.data1, var0_13.data2)
	local var3_13 = var1_13 - var0_13.data2
	local var4_13 = arg0_13.countToStory[var3_13]

	if var4_13 then
		pg.NewStoryMgr.GetInstance():Play(var4_13)
	end
end

function var0_0.onSubmitFinished(arg0_14)
	arg0_14:updateUI()
	arg0_14:tryPlayStory()
end

function var0_0.isShowRedPoint()
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS).data1 > 0
end

return var0_0
