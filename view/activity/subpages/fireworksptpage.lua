local var0 = class("FireworksPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.fireworkNameText = arg0:findTF("firework_text", arg0.bg)
	arg0.fireworkNumText = arg0:findTF("firework_text/num_text", arg0.bg)
	arg0.ptText = arg0:findTF("pt_text", arg0.bg)
	arg0.fireBtn = arg0:findTF("fire_btn", arg0.bg)
	arg0.fireworkPanel = arg0:findTF("frame", arg0.bg)
	arg0.dots = {
		arg0:findTF("dots/1", arg0.fireworkPanel),
		arg0:findTF("dots/2", arg0.fireworkPanel),
		arg0:findTF("dots/3", arg0.fireworkPanel)
	}
	arg0.fireworkPages = {
		arg0:findTF("content/1", arg0.fireworkPanel),
		arg0:findTF("content/2", arg0.fireworkPanel),
		arg0:findTF("content/3", arg0.fireworkPanel)
	}
	arg0.nextPageBtn = arg0:findTF("right_btn", arg0.fireworkPanel)
	arg0.lastPageBtn = arg0:findTF("left_btn", arg0.fireworkPanel)
end

function var0.OnDataSetting(arg0)
	var0.super.OnDataSetting(arg0)

	arg0.fireworkActID = arg0.activity:getConfig("config_client").fireworkActID

	local var0 = pg.activity_template[arg0.fireworkActID].config_data

	arg0.ptID = var0[2][1]
	arg0.ptConsume = var0[2][2]
	arg0.fireworkIds = var0[3]
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.fireBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SPRING_FESTIVAL_BACKHILL_2023, {
			openFireworkLayer = true
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.nextPageBtn, function()
		arg0:UpdateFrieworkPanel(arg0.pageIndex + 1)
	end, SFX_PANEL)
	onButton(arg0, arg0.lastPageBtn, function()
		arg0:UpdateFrieworkPanel(arg0.pageIndex - 1)
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	setText(arg0.fireworkNameText, i18n("activity_yanhua_tip1"))
	arg0:UpdataPageIndex()
end

function var0.UpdataPageIndex(arg0)
	arg0.fireworkAct = getProxy(ActivityProxy):getActivityById(arg0.fireworkActID)

	assert(arg0.fireworkAct and not arg0.fireworkAct:isEnd(), "烟花活动(type92)已结束")

	arg0.unlockCount = arg0.fireworkAct:getData1()
	arg0.unlockIds = arg0.fireworkAct:getData1List()

	for iter0 = #arg0.fireworkPages, 1, -1 do
		local var0 = 0

		eachChild(arg0.fireworkPages[iter0], function(arg0)
			local var0 = tonumber(arg0.name)

			if table.contains(arg0.unlockIds, var0) then
				var0 = var0 + 1
			end
		end)

		if var0 ~= arg0.fireworkPages[iter0].childCount then
			arg0.pageIndex = iter0
		end
	end

	if #arg0.unlockIds == #arg0.fireworkIds then
		arg0.pageIndex = 1
	end
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	arg0:UpdateFrieworkPanel(arg0.pageIndex)

	if #arg0.unlockIds == 0 then
		local var0 = pg.activity_template[arg0.fireworkActID].config_client.story

		if var0 and type(var0) == "table" then
			for iter0, iter1 in ipairs(var0) do
				if iter1[1] == 0 then
					pg.NewStoryMgr.GetInstance():Play(iter1[2])
				end
			end
		end
	end
end

function var0.UpdateFrieworkPanel(arg0, arg1)
	arg0.fireworkAct = getProxy(ActivityProxy):getActivityById(arg0.fireworkActID)

	assert(arg0.fireworkAct and not arg0.fireworkAct:isEnd(), "烟花活动(type92)已结束")

	arg0.unlockCount = arg0.fireworkAct:getData1()
	arg0.unlockIds = arg0.fireworkAct:getData1List()

	for iter0 = #arg0.fireworkPages, 1, -1 do
		eachChild(arg0.fireworkPages[iter0], function(arg0)
			local var0 = tonumber(arg0.name)

			if table.contains(arg0.unlockIds, var0) then
				setActive(arg0, false)
			else
				setActive(arg0, true)
				onButton(arg0, arg0, function()
					arg0:OnUnlockClick(var0)
				end, SFX_PANEL)
			end
		end)
	end

	local var0 = #arg0.fireworkPages

	if var0 < arg1 or arg1 < 1 then
		return
	end

	arg0.pageIndex = arg1

	for iter1, iter2 in ipairs(arg0.fireworkPages) do
		setActive(iter2, tonumber(iter2.name) == arg1)
	end

	for iter3, iter4 in ipairs(arg0.dots) do
		setActive(iter4, tonumber(iter4.name) == arg1)
	end

	setButtonEnabled(arg0.nextPageBtn, arg1 ~= var0)
	setButtonEnabled(arg0.lastPageBtn, arg1 ~= 1)
	setText(arg0.fireworkNumText, #arg0.unlockIds .. "/" .. #arg0.fireworkIds)

	arg0.ptNum = getProxy(PlayerProxy):getRawData():getResource(arg0.ptID)

	setText(arg0.ptText, arg0.ptNum)
end

function var0.OnUnlockClick(arg0, arg1)
	if arg0.unlockCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip6"))

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("activity_yanhua_tip4", arg0.ptConsume),
		onYes = function()
			if arg0.ptNum < arg0.ptConsume then
				pg.TipsMgr.GetInstance():ShowTips(i18n("activity_yanhua_tip5"))
			else
				arg0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0.fireworkActID,
					arg1 = arg1
				})
			end
		end
	})
end

return var0
