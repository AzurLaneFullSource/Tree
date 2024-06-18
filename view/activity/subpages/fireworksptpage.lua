local var0_0 = class("FireworksPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.fireworkNameText = arg0_1:findTF("firework_text", arg0_1.bg)
	arg0_1.fireworkNumText = arg0_1:findTF("firework_text/num_text", arg0_1.bg)
	arg0_1.ptText = arg0_1:findTF("pt_text", arg0_1.bg)
	arg0_1.fireBtn = arg0_1:findTF("fire_btn", arg0_1.bg)
	arg0_1.fireworkPanel = arg0_1:findTF("frame", arg0_1.bg)
	arg0_1.dots = {
		arg0_1:findTF("dots/1", arg0_1.fireworkPanel),
		arg0_1:findTF("dots/2", arg0_1.fireworkPanel),
		arg0_1:findTF("dots/3", arg0_1.fireworkPanel)
	}
	arg0_1.fireworkPages = {
		arg0_1:findTF("content/1", arg0_1.fireworkPanel),
		arg0_1:findTF("content/2", arg0_1.fireworkPanel),
		arg0_1:findTF("content/3", arg0_1.fireworkPanel)
	}
	arg0_1.nextPageBtn = arg0_1:findTF("right_btn", arg0_1.fireworkPanel)
	arg0_1.lastPageBtn = arg0_1:findTF("left_btn", arg0_1.fireworkPanel)
end

function var0_0.OnDataSetting(arg0_2)
	var0_0.super.OnDataSetting(arg0_2)

	arg0_2.fireworkActID = arg0_2.activity:getConfig("config_client").fireworkActID

	local var0_2 = pg.activity_template[arg0_2.fireworkActID].config_data

	arg0_2.ptID = var0_2[2][1]
	arg0_2.ptConsume = var0_2[2][2]
	arg0_2.fireworkIds = var0_2[3]
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.fireBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SPRING_FESTIVAL_BACKHILL_2023, {
			openFireworkLayer = true
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.nextPageBtn, function()
		arg0_3:UpdateFrieworkPanel(arg0_3.pageIndex + 1)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.lastPageBtn, function()
		arg0_3:UpdateFrieworkPanel(arg0_3.pageIndex - 1)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	setText(arg0_3.fireworkNameText, i18n("activity_yanhua_tip1"))
	arg0_3:UpdataPageIndex()
end

function var0_0.UpdataPageIndex(arg0_8)
	arg0_8.fireworkAct = getProxy(ActivityProxy):getActivityById(arg0_8.fireworkActID)

	assert(arg0_8.fireworkAct and not arg0_8.fireworkAct:isEnd(), "烟花活动(type92)已结束")

	arg0_8.unlockCount = arg0_8.fireworkAct:getData1()
	arg0_8.unlockIds = arg0_8.fireworkAct:getData1List()

	for iter0_8 = #arg0_8.fireworkPages, 1, -1 do
		local var0_8 = 0

		eachChild(arg0_8.fireworkPages[iter0_8], function(arg0_9)
			local var0_9 = tonumber(arg0_9.name)

			if table.contains(arg0_8.unlockIds, var0_9) then
				var0_8 = var0_8 + 1
			end
		end)

		if var0_8 ~= arg0_8.fireworkPages[iter0_8].childCount then
			arg0_8.pageIndex = iter0_8
		end
	end

	if #arg0_8.unlockIds == #arg0_8.fireworkIds then
		arg0_8.pageIndex = 1
	end
end

function var0_0.OnUpdateFlush(arg0_10)
	var0_0.super.OnUpdateFlush(arg0_10)
	arg0_10:UpdateFrieworkPanel(arg0_10.pageIndex)

	if #arg0_10.unlockIds == 0 then
		local var0_10 = pg.activity_template[arg0_10.fireworkActID].config_client.story

		if var0_10 and type(var0_10) == "table" then
			for iter0_10, iter1_10 in ipairs(var0_10) do
				if iter1_10[1] == 0 then
					pg.NewStoryMgr.GetInstance():Play(iter1_10[2])
				end
			end
		end
	end
end

function var0_0.UpdateFrieworkPanel(arg0_11, arg1_11)
	arg0_11.fireworkAct = getProxy(ActivityProxy):getActivityById(arg0_11.fireworkActID)

	assert(arg0_11.fireworkAct and not arg0_11.fireworkAct:isEnd(), "烟花活动(type92)已结束")

	arg0_11.unlockCount = arg0_11.fireworkAct:getData1()
	arg0_11.unlockIds = arg0_11.fireworkAct:getData1List()

	for iter0_11 = #arg0_11.fireworkPages, 1, -1 do
		eachChild(arg0_11.fireworkPages[iter0_11], function(arg0_12)
			local var0_12 = tonumber(arg0_12.name)

			if table.contains(arg0_11.unlockIds, var0_12) then
				setActive(arg0_12, false)
			else
				setActive(arg0_12, true)
				onButton(arg0_11, arg0_12, function()
					arg0_11:OnUnlockClick(var0_12)
				end, SFX_PANEL)
			end
		end)
	end

	local var0_11 = #arg0_11.fireworkPages

	if var0_11 < arg1_11 or arg1_11 < 1 then
		return
	end

	arg0_11.pageIndex = arg1_11

	for iter1_11, iter2_11 in ipairs(arg0_11.fireworkPages) do
		setActive(iter2_11, tonumber(iter2_11.name) == arg1_11)
	end

	for iter3_11, iter4_11 in ipairs(arg0_11.dots) do
		setActive(iter4_11, tonumber(iter4_11.name) == arg1_11)
	end

	setButtonEnabled(arg0_11.nextPageBtn, arg1_11 ~= var0_11)
	setButtonEnabled(arg0_11.lastPageBtn, arg1_11 ~= 1)
	setText(arg0_11.fireworkNumText, #arg0_11.unlockIds .. "/" .. #arg0_11.fireworkIds)

	arg0_11.ptNum = getProxy(PlayerProxy):getRawData():getResource(arg0_11.ptID)

	setText(arg0_11.ptText, arg0_11.ptNum)
end

function var0_0.OnUnlockClick(arg0_14, arg1_14)
	if arg0_14.unlockCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip6"))

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("activity_yanhua_tip4", arg0_14.ptConsume),
		onYes = function()
			if arg0_14.ptNum < arg0_14.ptConsume then
				pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip5"))
			else
				arg0_14:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0_14.fireworkActID,
					arg1 = arg1_14
				})
			end
		end
	})
end

return var0_0
