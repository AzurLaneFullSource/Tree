local var0_0 = class("BlackFridayPage", import("...base.BaseActivityPage"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.OnInit(arg0_1)
	arg0_1.shopBtn = arg0_1:findTF("AD/shop_btn")
	arg0_1.uiList = UIItemList.New(arg0_1:findTF("AD/list"), arg0_1:findTF("AD/list/award"))
	arg0_1.finishCntTxt = arg0_1:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0_1.helpBtn = arg0_1:findTF("AD/help")
end

function var0_0.OnDataSetting(arg0_2)
	if arg0_2.ptData then
		arg0_2.ptData:Update(arg0_2.activity)
	else
		arg0_2.ptData = ActivityPtData.New(arg0_2.activity)
	end

	arg0_2.endTime = arg0_2.activity.stopTime

	local var0_2 = arg0_2.activity:getConfig("config_client")

	if var0_2 and var0_2[1] and type(var0_2[1]) == "table" then
		arg0_2.endTime = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_2[1])
	end
end

function var0_0.OnFirstFlush(arg0_3)
	if not IsNil(arg0_3.helpBtn) then
		onButton(arg0_3, arg0_3.helpBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.blackfriday_help.tip
			})
		end, SFX_PANEL)
	end

	onButton(arg0_3, arg0_3.shopBtn, function()
		if pg.TimeMgr.GetInstance():GetServerTime() >= arg0_3.endTime then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP, {
				warp = NewSkinShopScene.PAGE_RETURN
			})
		end
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateAward(arg1_6 + 1, arg2_6)
		end
	end)
end

function var0_0.GetState(arg0_7, arg1_7)
	local var0_7 = arg1_7 <= arg0_7.finishCnt
	local var1_7 = arg0_7.ptData.targets[arg1_7]
	local var2_7 = table.contains(arg0_7.finishList, var1_7)

	if var2_7 then
		return var3_0
	elseif not var2_7 and var0_7 then
		return var2_0
	else
		return var1_0
	end
end

function var0_0.UpdateAward(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.awards[arg1_8]
	local var1_8 = {
		type = var0_8[1],
		id = var0_8[2],
		count = var0_8[3]
	}

	updateDrop(arg2_8, var1_8)
	setActive(arg2_8:Find("icon_bg/count"), var1_8.count > 0)

	arg2_8:Find("icon_bg/frame"):GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0)

	local var2_8 = arg0_8:GetState(arg1_8)

	setActive(arg2_8:Find("got"), var2_8 == var3_0)
	setActive(arg2_8:Find("get"), var2_8 == var2_0)
	setActive(arg2_8:Find("lock"), var2_8 == var1_0)

	if var2_8 == var2_0 then
		onButton(arg0_8, arg2_8, function()
			local var0_9 = arg0_8.ptData.targets[arg1_8]

			arg0_8:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_8.ptData:GetId(),
				arg1 = var0_9
			})
		end, SFX_PANEL)
	else
		onButton(arg0_8, arg2_8, function()
			arg0_8:emit(BaseUI.ON_DROP, var1_8)
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateFlush(arg0_11)
	arg0_11.awards = arg0_11.ptData.dropList
	arg0_11.finishCnt = arg0_11.ptData.count
	arg0_11.finishList = arg0_11.ptData.activity.data1_list
	arg0_11.finishCntTxt.text = "X" .. arg0_11.finishCnt

	arg0_11.uiList:align(#arg0_11.awards)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
