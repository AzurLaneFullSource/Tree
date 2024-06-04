local var0 = class("RedPacketLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return "RedPacket2023UI"
	else
		return "RedPacket2023UI"
	end
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateUI()
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.activityProxy = getProxy(ActivityProxy)

	local var0 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

	arg0.activityID = var0.id
	arg0.countToStory = {}

	local var1 = var0:getConfig("config_client").story

	if var1 then
		for iter0, iter1 in ipairs(var1) do
			arg0.countToStory[iter1[1]] = iter1[2]
		end
	end
end

function var0.findUI(arg0)
	arg0.packetBtn = arg0:findTF("Container/PacketBtn")
	arg0.packetMask = arg0:findTF("Container/PacketBtnMask")
	arg0.helpBtn = arg0:findTF("Container/HelpBtn")
	arg0.tagTF = arg0:findTF("tag", arg0.packetBtn)
	arg0.countTF = arg0:findTF("Container/Count")
	arg0.specialTF = arg0:findTF("Container/Count/Special")
	arg0.specialCountText = arg0:findTF("Text", arg0.specialTF)
	arg0.normalTF = arg0:findTF("Container/Count/Normal")
	arg0.normalCountText = arg0:findTF("Text", arg0.normalTF)
	arg0.awardBtnList = {}

	table.insert(arg0.awardBtnList, arg0:findTF("Container/Award"))
	table.insert(arg0.awardBtnList, arg0:findTF("Container/Award2"))

	arg0.countText = arg0:findTF("Container/CountText")
	arg0.backBtn = arg0:findTF("Top/BackBtn")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.packetBtn, function()
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0.activityID
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_jiulou.tip
		})
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.awardBtnList) do
		if iter1 then
			onButton(arg0, iter1, function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
			end, SFX_PANEL)
		end
	end
end

function var0.updateUI(arg0)
	local var0 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)
	local var1 = var0.data3
	local var2 = var0.data1
	local var3 = math.min(var0.data1, var0.data2)
	local var4 = var2 - var3

	print(var4, var3, var2)
	setActive(arg0.tagTF, var3 > 0)
	setActive(arg0.normalTF, var4 > 0)
	setActive(arg0.specialTF, var3 > 0)
	setActive(arg0.countTF, var2 > 0)
	setText(arg0.normalCountText, var4)
	setText(arg0.specialCountText, var3)
	setActive(arg0.packetBtn, var2 > 0)
	setActive(arg0.packetMask, not (var2 > 0))

	local var5 = var0.data1_list[2]
	local var6 = var0.data1_list[1]

	setText(arg0.countText, var5 .. "/" .. var6)
end

function var0.tryPlayStory(arg0)
	local var0 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)
	local var1 = var0.data3
	local var2 = var0.data1 - math.min(var0.data1, var0.data2)
	local var3 = var1 - var0.data2
	local var4 = arg0.countToStory[var3]

	if var4 then
		pg.NewStoryMgr.GetInstance():Play(var4)
	end
end

function var0.onSubmitFinished(arg0)
	arg0:updateUI()
	arg0:tryPlayStory()
end

function var0.isShowRedPoint()
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS).data1 > 0
end

return var0
