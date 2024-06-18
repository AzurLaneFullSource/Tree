local var0_0 = class("BeachPacketLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BeachPacketUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateUI()
end

function var0_0.willExit(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.activityProxy = getProxy(ActivityProxy)

	local var0_5 = arg0_5.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER)

	arg0_5.activityID = var0_5.id
	arg0_5.awardList = {}
	arg0_5.awardListMap = {}

	local var1_5 = var0_5:getConfig("config_client")

	if var1_5 then
		for iter0_5, iter1_5 in ipairs(var1_5) do
			local var2_5 = iter1_5[1]
			local var3_5 = iter1_5[2][2]
			local var4_5 = iter1_5[2][1]
			local var5_5 = iter1_5[3]
			local var6_5 = iter1_5[4]

			if not arg0_5.awardListMap[var6_5] then
				arg0_5.awardListMap[var6_5] = {}
			end

			local var7_5 = {
				id = var3_5,
				type = var4_5,
				count = var5_5,
				awardID = var2_5
			}

			table.insert(arg0_5.awardListMap[var6_5], var7_5)

			arg0_5.awardList[var2_5] = var7_5
		end
	end

	arg0_5:updateActData()
end

function var0_0.findUI(arg0_6)
	local var0_6 = arg0_6:findTF("Adapt")

	arg0_6.backBtn = arg0_6:findTF("BackBtn", var0_6)
	arg0_6.homeBtn = arg0_6:findTF("HomeBtn", var0_6)
	arg0_6.helpBtn = arg0_6:findTF("HelpBtn", var0_6)

	local var1_6 = arg0_6:findTF("PacketPanel")

	arg0_6.countText = arg0_6:findTF("Count/CountText", var1_6)
	arg0_6.packetTFList = {}

	local var2_6 = arg0_6:findTF("ContainerBehide", var1_6)

	for iter0_6 = 1, 5 do
		local var3_6 = var2_6:GetChild(iter0_6 - 1)

		table.insert(arg0_6.packetTFList, var3_6)
	end

	local var4_6 = arg0_6:findTF("ContainerFront", var1_6)

	for iter1_6 = 1, 5 do
		local var5_6 = var4_6:GetChild(iter1_6 - 1)

		table.insert(arg0_6.packetTFList, var5_6)
	end

	local var6_6 = arg0_6:findTF("AwardPanel")

	arg0_6.awardTpl = arg0_6:findTF("AwardTpl", var6_6)
	arg0_6.iconTpl = Instantiate(arg0_6._tf:GetComponent(typeof(ItemList)).prefabItem[0])

	setLocalScale(arg0_6.iconTpl, {
		x = 0.4,
		y = 0.4
	})
	setParent(arg0_6.iconTpl, arg0_6:findTF("Icon", arg0_6.awardTpl))

	arg0_6.awardTFList = {}

	local function var7_6(arg0_7, arg1_7, arg2_7)
		local var0_7 = arg0_6:getAwardListByLevel(arg0_7)

		for iter0_7, iter1_7 in ipairs(var0_7) do
			local var1_7 = cloneTplTo(arg1_7, arg2_7)
			local var2_7 = iter1_7.awardID

			arg0_6.awardTFList[var2_7] = var1_7
		end
	end

	var7_6(1, arg0_6.awardTpl, arg0_6:findTF("Container_1", var6_6))
	var7_6(2, arg0_6.awardTpl, arg0_6:findTF("Container_2", var6_6))
	var7_6(3, arg0_6.awardTpl, arg0_6:findTF("Container_3", var6_6))
	var7_6(4, arg0_6.awardTpl, arg0_6:findTF("Container_4", var6_6))

	arg0_6.aniPanel = arg0_6:findTF("AniPanel")
	arg0_6.aniTF = arg0_6:findTF("Ani", arg0_6.aniPanel)
	arg0_6.aniSC = GetComponent(arg0_6.aniTF, "SpineAnimUI")
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.homeBtn, function()
		arg0_8:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tips_yuandanhuoyue2023.tip
		})
	end, SFX_PANEL)
end

function var0_0.updateActData(arg0_12)
	local var0_12 = arg0_12.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER)
	local var1_12 = pg.TimeMgr.GetInstance()
	local var2_12 = var0_12.data1
	local var3_12 = var0_12.data2
	local var4_12 = var1_12:GetServerTime()

	arg0_12.curCount = math.min(10, var1_12:DiffDay(var3_12, var4_12) + 1) - var2_12
	arg0_12.gotIndexList = {}

	for iter0_12, iter1_12 in pairs(var0_12.data2_list) do
		if not table.contains(arg0_12.gotIndexList, iter1_12) then
			table.insert(arg0_12.gotIndexList, iter1_12)
		end
	end

	arg0_12.gotIDList = {}

	for iter2_12, iter3_12 in pairs(var0_12.data1_list) do
		if not table.contains(arg0_12.gotIDList, iter3_12) then
			table.insert(arg0_12.gotIDList, iter3_12)
		end
	end
end

function var0_0.updatePacketTpl(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13:findTF("Normal", arg2_13)
	local var1_13 = arg0_13:findTF("Got", arg2_13)
	local var2_13 = arg0_13:findTF("Selected", arg2_13)
	local var3_13 = arg0_13:isPacketIndexGot(arg1_13)

	setActive(var1_13, var3_13)
	setActive(var0_13, not var3_13)
	onButton(arg0_13, arg2_13, function()
		if not var3_13 and arg0_13.curCount > 0 then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg0_13.activityID,
				arg1 = arg1_13
			})
		end
	end, SFX_PANEL)
end

function var0_0.updatePacketList(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.packetTFList) do
		arg0_15:updatePacketTpl(iter0_15, iter1_15)
	end
end

function var0_0.updateAwardTpl(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:findTF("Icon/IconTpl(Clone)", arg2_16)
	local var1_16 = arg0_16:findTF("Got", arg2_16)
	local var2_16 = arg0_16.awardList[arg1_16]

	updateDrop(var0_16, var2_16)

	local var3_16 = arg0_16:isAwardGot(arg1_16)

	setActive(var1_16, var3_16)
	onButton(arg0_16, arg2_16, function()
		if not var3_16 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = var2_16
			})
		end
	end, SFX_PANEL)
end

function var0_0.updateAwardList(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.awardTFList) do
		arg0_18:updateAwardTpl(iter0_18, iter1_18)
	end
end

function var0_0.updateUI(arg0_19)
	arg0_19:updatePacketList()
	arg0_19:updateAwardList()
	setText(arg0_19.countText, arg0_19.curCount)
end

function var0_0.playAni(arg0_20, arg1_20)
	arg0_20.isPlaying = true

	setActive(arg0_20.aniPanel, true)
	arg0_20.aniSC:SetActionCallBack(nil)

	local var0_20 = 0

	arg0_20.aniSC:SetActionCallBack(function(arg0_21)
		if arg0_21 == "action" then
			var0_20 = var0_20 + 1

			if var0_20 == 2 then
				arg0_20.aniSC:SetActionCallBack(nil)
				setActive(arg0_20.aniPanel, false)

				arg0_20.isPlaying = false

				if arg1_20 then
					arg1_20()
				end

				var0_20 = 0
			end
		end
	end)
	arg0_20.aniSC:SetAction("4", 0)
end

function var0_0.isPacketIndexGot(arg0_22, arg1_22)
	return table.contains(arg0_22.gotIndexList, arg1_22)
end

function var0_0.isAwardGot(arg0_23, arg1_23)
	return table.contains(arg0_23.gotIDList, arg1_23)
end

function var0_0.getAwardCountByLevel(arg0_24, arg1_24)
	return #arg0_24:getAwardListByLevel(arg1_24)
end

function var0_0.getAwardListByLevel(arg0_25, arg1_25)
	return arg0_25.awardListMap[arg1_25]
end

function var0_0.onSubmitFinished(arg0_26)
	arg0_26:updateActData()
	arg0_26:updateUI()
end

function var0_0.isShowRedPoint()
	local var0_27 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER)
	local var1_27 = pg.TimeMgr.GetInstance()
	local var2_27 = var0_27.data1
	local var3_27 = var0_27.data2
	local var4_27 = var1_27:GetServerTime()
	local var5_27 = var1_27:DiffDay(var3_27, var4_27) + 1

	return math.min(10, var1_27:DiffDay(var3_27, var4_27) + 1) - var2_27 > 0
end

return var0_0
