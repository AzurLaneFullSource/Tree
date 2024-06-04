local var0 = class("BlackFridayPage", import("...base.BaseActivityPage"))
local var1 = 1
local var2 = 2
local var3 = 3

function var0.OnInit(arg0)
	arg0.shopBtn = arg0:findTF("AD/shop_btn")
	arg0.uiList = UIItemList.New(arg0:findTF("AD/list"), arg0:findTF("AD/list/award"))
	arg0.finishCntTxt = arg0:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0.helpBtn = arg0:findTF("AD/help")
end

function var0.OnDataSetting(arg0)
	if arg0.ptData then
		arg0.ptData:Update(arg0.activity)
	else
		arg0.ptData = ActivityPtData.New(arg0.activity)
	end

	arg0.endTime = arg0.activity.stopTime

	local var0 = arg0.activity:getConfig("config_client")

	if var0 and var0[1] and type(var0[1]) == "table" then
		arg0.endTime = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0[1])
	end
end

function var0.OnFirstFlush(arg0)
	if not IsNil(arg0.helpBtn) then
		onButton(arg0, arg0.helpBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.blackfriday_help.tip
			})
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.shopBtn, function()
		if pg.TimeMgr.GetInstance():GetServerTime() >= arg0.endTime then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP, {
				warp = SkinShopScene.PAGE_ENCORE
			})
		end
	end, SFX_PANEL)
	arg0.uiList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateAward(arg1 + 1, arg2)
		end
	end)
end

function var0.GetState(arg0, arg1)
	local var0 = arg1 <= arg0.finishCnt
	local var1 = arg0.ptData.targets[arg1]
	local var2 = table.contains(arg0.finishList, var1)

	if var2 then
		return var3
	elseif not var2 and var0 then
		return var2
	else
		return var1
	end
end

function var0.UpdateAward(arg0, arg1, arg2)
	local var0 = arg0.awards[arg1]
	local var1 = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}

	updateDrop(arg2, var1)
	setActive(arg2:Find("icon_bg/count"), var1.count > 0)

	arg2:Find("icon_bg/frame"):GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0)

	local var2 = arg0:GetState(arg1)

	setActive(arg2:Find("got"), var2 == var3)
	setActive(arg2:Find("get"), var2 == var2)
	setActive(arg2:Find("lock"), var2 == var1)

	if var2 == var2 then
		onButton(arg0, arg2, function()
			local var0 = arg0.ptData.targets[arg1]

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var0
			})
		end, SFX_PANEL)
	else
		onButton(arg0, arg2, function()
			arg0:emit(BaseUI.ON_DROP, var1)
		end, SFX_PANEL)
	end
end

function var0.OnUpdateFlush(arg0)
	arg0.awards = arg0.ptData.dropList
	arg0.finishCnt = arg0.ptData.count
	arg0.finishList = arg0.ptData.activity.data1_list
	arg0.finishCntTxt.text = "X" .. arg0.finishCnt

	arg0.uiList:align(#arg0.awards)
end

function var0.OnDestroy(arg0)
	return
end

return var0
