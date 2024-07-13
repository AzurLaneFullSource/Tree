local var0_0 = class("KFCPTPage", import(".TemplatePage.PtTemplatePage"))

var0_0.SpineCharName = {
	"lafei_11",
	"lingbo_14"
}
var0_0.SpineCharActionName = "stand_normal"
var0_0.SpineShopActionSpeed = {
	0.8,
	1,
	1.2
}

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1:findTF("sdBtn", arg0_1.bg), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.getBtn, function()
		local var0_4 = {}
		local var1_4 = arg0_1.ptData:GetAward()
		local var2_4 = getProxy(PlayerProxy):getRawData()
		local var3_4 = pg.gameset.urpt_chapter_max.description[1]
		local var4_4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_4)
		local var5_4, var6_4 = Task.StaticJudgeOverflow(var2_4.gold, var2_4.oil, var4_4, true, true, {
			{
				var1_4.type,
				var1_4.id,
				var1_4.count
			}
		})

		if var5_4 then
			table.insert(var0_4, function(arg0_5)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_4,
					onYes = arg0_5
				})
			end)
		end

		seriesAsync(var0_4, function()
			local var0_6, var1_6 = arg0_1.ptData:GetResProgress()

			arg0_1:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_1.ptData:GetId(),
				arg1 = var1_6
			})
			arg0_1:SetLocalData()
		end)
	end, SFX_PANEL)

	arg0_1.sdContainer = arg0_1:findTF("sdcontainer", arg0_1.bg)
	arg0_1.sdSpine = nil
	arg0_1.sdName = arg0_1.GetRandomName()
	arg0_1.sdSpineLRQ = GetSpineRequestPackage.New(arg0_1.sdName, function(arg0_7)
		SetParent(arg0_7, arg0_1.sdContainer)

		arg0_1.sdSpine = arg0_7
		arg0_1.sdSpine.transform.localScale = Vector3.one

		local var0_7 = arg0_1.sdSpine:GetComponent("SpineAnimUI")

		if var0_7 then
			var0_7:SetAction(var0_0.SpineCharActionName, 0)
		end

		arg0_1.sdSpineLRQ = nil
	end):Start()
	arg0_1.shopSpine = arg0_1:findTF("shop/shop", arg0_1.bg)
	arg0_1.shopAnim = arg0_1.shopSpine:GetComponent("SpineAnimUI")
	arg0_1.shopGraphic = arg0_1.shopSpine:GetComponent("SkeletonGraphic")

	arg0_1.shopAnim:SetAction("normal", 0)
end

function var0_0.OnUpdateFlush(arg0_8)
	var0_0.super.OnUpdateFlush(arg0_8)

	local var0_8, var1_8, var2_8 = arg0_8.ptData:GetResProgress()

	setText(arg0_8.progress, (var2_8 >= 1 and setColorStr(var0_8, "#ffc563") or var0_8) .. "/" .. var1_8)

	if arg0_8.ptData:CanGetMorePt() then
		arg0_8:GetLocalData()

		if arg0_8.finishCount == 0 then
			arg0_8.shopAnim:SetAction("normal", 0)
		else
			arg0_8.shopAnim:SetAction("action", 0)

			arg0_8.shopGraphic.timeScale = var0_0.SpineShopActionSpeed[arg0_8.finishCount]
		end
	else
		arg0_8.shopAnim:SetAction("action", 0)

		arg0_8.shopGraphic.timeScale = var0_0.SpineShopActionSpeed[#var0_0.SpineShopActionSpeed]
	end
end

function var0_0.GetLocalData(arg0_9)
	arg0_9.playerId = getProxy(PlayerProxy):getData().id

	local var0_9 = pg.TimeMgr.GetInstance()

	arg0_9.curDay = var0_9:DiffDay(arg0_9.ptData.startTime, var0_9:GetServerTime()) + 1
	arg0_9.finishCount = PlayerPrefs.GetInt("kfc_pt_" .. arg0_9.playerId .. "_day_" .. arg0_9.curDay)
end

function var0_0.SetLocalData(arg0_10)
	arg0_10.finishCount = arg0_10.finishCount + 1

	local var0_10 = #var0_0.SpineShopActionSpeed

	arg0_10.finishCount = var0_10 > arg0_10.finishCount and arg0_10.finishCount or var0_10

	PlayerPrefs.SetInt("kfc_pt_" .. arg0_10.playerId .. "_day_" .. arg0_10.curDay, arg0_10.finishCount)
	PlayerPrefs.Save()
end

function var0_0.GetRandomName()
	return var0_0.SpineCharName[math.random(#var0_0.SpineCharName)]
end

function var0_0.OnDestroy(arg0_12)
	if arg0_12.sdSpineLRQ then
		arg0_12.sdSpineLRQ:Stop()

		arg0_12.sdSpineLRQ = nil
	end

	if arg0_12.sdSpine then
		arg0_12.sdSpine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar(arg0_12.sdName, arg0_12.sdSpine)

		arg0_12.sdSpine = nil
		arg0_12.sdName = nil
	end
end

return var0_0
