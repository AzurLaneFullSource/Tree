local var0 = class("BeachPacketLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "BeachPacketUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateUI()
end

function var0.willExit(arg0)
	return
end

function var0.initData(arg0)
	arg0.activityProxy = getProxy(ActivityProxy)

	local var0 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER)

	arg0.activityID = var0.id
	arg0.awardList = {}
	arg0.awardListMap = {}

	local var1 = var0:getConfig("config_client")

	if var1 then
		for iter0, iter1 in ipairs(var1) do
			local var2 = iter1[1]
			local var3 = iter1[2][2]
			local var4 = iter1[2][1]
			local var5 = iter1[3]
			local var6 = iter1[4]

			if not arg0.awardListMap[var6] then
				arg0.awardListMap[var6] = {}
			end

			local var7 = {
				id = var3,
				type = var4,
				count = var5,
				awardID = var2
			}

			table.insert(arg0.awardListMap[var6], var7)

			arg0.awardList[var2] = var7
		end
	end

	arg0:updateActData()
end

function var0.findUI(arg0)
	local var0 = arg0:findTF("Adapt")

	arg0.backBtn = arg0:findTF("BackBtn", var0)
	arg0.homeBtn = arg0:findTF("HomeBtn", var0)
	arg0.helpBtn = arg0:findTF("HelpBtn", var0)

	local var1 = arg0:findTF("PacketPanel")

	arg0.countText = arg0:findTF("Count/CountText", var1)
	arg0.packetTFList = {}

	local var2 = arg0:findTF("ContainerBehide", var1)

	for iter0 = 1, 5 do
		local var3 = var2:GetChild(iter0 - 1)

		table.insert(arg0.packetTFList, var3)
	end

	local var4 = arg0:findTF("ContainerFront", var1)

	for iter1 = 1, 5 do
		local var5 = var4:GetChild(iter1 - 1)

		table.insert(arg0.packetTFList, var5)
	end

	local var6 = arg0:findTF("AwardPanel")

	arg0.awardTpl = arg0:findTF("AwardTpl", var6)
	arg0.iconTpl = Instantiate(arg0._tf:GetComponent(typeof(ItemList)).prefabItem[0])

	setLocalScale(arg0.iconTpl, {
		x = 0.4,
		y = 0.4
	})
	setParent(arg0.iconTpl, arg0:findTF("Icon", arg0.awardTpl))

	arg0.awardTFList = {}

	local function var7(arg0, arg1, arg2)
		local var0 = arg0:getAwardListByLevel(arg0)

		for iter0, iter1 in ipairs(var0) do
			local var1 = cloneTplTo(arg1, arg2)
			local var2 = iter1.awardID

			arg0.awardTFList[var2] = var1
		end
	end

	var7(1, arg0.awardTpl, arg0:findTF("Container_1", var6))
	var7(2, arg0.awardTpl, arg0:findTF("Container_2", var6))
	var7(3, arg0.awardTpl, arg0:findTF("Container_3", var6))
	var7(4, arg0.awardTpl, arg0:findTF("Container_4", var6))

	arg0.aniPanel = arg0:findTF("AniPanel")
	arg0.aniTF = arg0:findTF("Ani", arg0.aniPanel)
	arg0.aniSC = GetComponent(arg0.aniTF, "SpineAnimUI")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tips_yuandanhuoyue2023.tip
		})
	end, SFX_PANEL)
end

function var0.updateActData(arg0)
	local var0 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER)
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = var0.data1
	local var3 = var0.data2
	local var4 = var1:GetServerTime()

	arg0.curCount = math.min(10, var1:DiffDay(var3, var4) + 1) - var2
	arg0.gotIndexList = {}

	for iter0, iter1 in pairs(var0.data2_list) do
		if not table.contains(arg0.gotIndexList, iter1) then
			table.insert(arg0.gotIndexList, iter1)
		end
	end

	arg0.gotIDList = {}

	for iter2, iter3 in pairs(var0.data1_list) do
		if not table.contains(arg0.gotIDList, iter3) then
			table.insert(arg0.gotIDList, iter3)
		end
	end
end

function var0.updatePacketTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("Normal", arg2)
	local var1 = arg0:findTF("Got", arg2)
	local var2 = arg0:findTF("Selected", arg2)
	local var3 = arg0:isPacketIndexGot(arg1)

	setActive(var1, var3)
	setActive(var0, not var3)
	onButton(arg0, arg2, function()
		if not var3 and arg0.curCount > 0 then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg0.activityID,
				arg1 = arg1
			})
		end
	end, SFX_PANEL)
end

function var0.updatePacketList(arg0)
	for iter0, iter1 in ipairs(arg0.packetTFList) do
		arg0:updatePacketTpl(iter0, iter1)
	end
end

function var0.updateAwardTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("Icon/IconTpl(Clone)", arg2)
	local var1 = arg0:findTF("Got", arg2)
	local var2 = arg0.awardList[arg1]

	updateDrop(var0, var2)

	local var3 = arg0:isAwardGot(arg1)

	setActive(var1, var3)
	onButton(arg0, arg2, function()
		if not var3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = var2
			})
		end
	end, SFX_PANEL)
end

function var0.updateAwardList(arg0)
	for iter0, iter1 in ipairs(arg0.awardTFList) do
		arg0:updateAwardTpl(iter0, iter1)
	end
end

function var0.updateUI(arg0)
	arg0:updatePacketList()
	arg0:updateAwardList()
	setText(arg0.countText, arg0.curCount)
end

function var0.playAni(arg0, arg1)
	arg0.isPlaying = true

	setActive(arg0.aniPanel, true)
	arg0.aniSC:SetActionCallBack(nil)

	local var0 = 0

	arg0.aniSC:SetActionCallBack(function(arg0)
		if arg0 == "action" then
			var0 = var0 + 1

			if var0 == 2 then
				arg0.aniSC:SetActionCallBack(nil)
				setActive(arg0.aniPanel, false)

				arg0.isPlaying = false

				if arg1 then
					arg1()
				end

				var0 = 0
			end
		end
	end)
	arg0.aniSC:SetAction("4", 0)
end

function var0.isPacketIndexGot(arg0, arg1)
	return table.contains(arg0.gotIndexList, arg1)
end

function var0.isAwardGot(arg0, arg1)
	return table.contains(arg0.gotIDList, arg1)
end

function var0.getAwardCountByLevel(arg0, arg1)
	return #arg0:getAwardListByLevel(arg1)
end

function var0.getAwardListByLevel(arg0, arg1)
	return arg0.awardListMap[arg1]
end

function var0.onSubmitFinished(arg0)
	arg0:updateActData()
	arg0:updateUI()
end

function var0.isShowRedPoint()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKET_LOTTER)
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = var0.data1
	local var3 = var0.data2
	local var4 = var1:GetServerTime()
	local var5 = var1:DiffDay(var3, var4) + 1

	return math.min(10, var1:DiffDay(var3, var4) + 1) - var2 > 0
end

return var0
