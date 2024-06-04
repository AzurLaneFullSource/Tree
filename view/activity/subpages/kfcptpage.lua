local var0 = class("KFCPTPage", import(".TemplatePage.PtTemplatePage"))

var0.SpineCharName = {
	"lafei_11",
	"lingbo_14"
}
var0.SpineCharActionName = "stand_normal"
var0.SpineShopActionSpeed = {
	0.8,
	1,
	1.2
}

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0:findTF("sdBtn", arg0.bg), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getRawData()
		local var3 = pg.gameset.urpt_chapter_max.description[1]
		local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
		local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
			{
				var1.type,
				var1.id,
				var1.count
			}
		})

		if var5 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6,
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1
			})
			arg0:SetLocalData()
		end)
	end, SFX_PANEL)

	arg0.sdContainer = arg0:findTF("sdcontainer", arg0.bg)
	arg0.sdSpine = nil
	arg0.sdName = arg0.GetRandomName()
	arg0.sdSpineLRQ = GetSpineRequestPackage.New(arg0.sdName, function(arg0)
		SetParent(arg0, arg0.sdContainer)

		arg0.sdSpine = arg0
		arg0.sdSpine.transform.localScale = Vector3.one

		local var0 = arg0.sdSpine:GetComponent("SpineAnimUI")

		if var0 then
			var0:SetAction(var0.SpineCharActionName, 0)
		end

		arg0.sdSpineLRQ = nil
	end):Start()
	arg0.shopSpine = arg0:findTF("shop/shop", arg0.bg)
	arg0.shopAnim = arg0.shopSpine:GetComponent("SpineAnimUI")
	arg0.shopGraphic = arg0.shopSpine:GetComponent("SkeletonGraphic")

	arg0.shopAnim:SetAction("normal", 0)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, "#ffc563") or var0) .. "/" .. var1)

	if arg0.ptData:CanGetMorePt() then
		arg0:GetLocalData()

		if arg0.finishCount == 0 then
			arg0.shopAnim:SetAction("normal", 0)
		else
			arg0.shopAnim:SetAction("action", 0)

			arg0.shopGraphic.timeScale = var0.SpineShopActionSpeed[arg0.finishCount]
		end
	else
		arg0.shopAnim:SetAction("action", 0)

		arg0.shopGraphic.timeScale = var0.SpineShopActionSpeed[#var0.SpineShopActionSpeed]
	end
end

function var0.GetLocalData(arg0)
	arg0.playerId = getProxy(PlayerProxy):getData().id

	local var0 = pg.TimeMgr.GetInstance()

	arg0.curDay = var0:DiffDay(arg0.ptData.startTime, var0:GetServerTime()) + 1
	arg0.finishCount = PlayerPrefs.GetInt("kfc_pt_" .. arg0.playerId .. "_day_" .. arg0.curDay)
end

function var0.SetLocalData(arg0)
	arg0.finishCount = arg0.finishCount + 1

	local var0 = #var0.SpineShopActionSpeed

	arg0.finishCount = var0 > arg0.finishCount and arg0.finishCount or var0

	PlayerPrefs.SetInt("kfc_pt_" .. arg0.playerId .. "_day_" .. arg0.curDay, arg0.finishCount)
	PlayerPrefs.Save()
end

function var0.GetRandomName()
	return var0.SpineCharName[math.random(#var0.SpineCharName)]
end

function var0.OnDestroy(arg0)
	if arg0.sdSpineLRQ then
		arg0.sdSpineLRQ:Stop()

		arg0.sdSpineLRQ = nil
	end

	if arg0.sdSpine then
		arg0.sdSpine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar(arg0.sdName, arg0.sdSpine)

		arg0.sdSpine = nil
		arg0.sdName = nil
	end
end

return var0
