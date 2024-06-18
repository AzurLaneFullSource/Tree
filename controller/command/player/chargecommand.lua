local var0_0 = class("ChargeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	if (PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP) and not pg.SdkMgr.GetInstance():CheckAiriCanBuy() then
		originalPrint("wait for a second, Do not click quickly~")

		return
	end

	local var0_1 = arg1_1:getBody().shopId
	local var1_1 = getProxy(ShopsProxy)
	local var2_1 = var1_1:getFirstChargeList() or {}

	if not var0_1 then
		return
	end

	local var3_1 = not table.contains(var2_1, var0_1)
	local var4_1 = Goods.Create({
		shop_id = var0_1
	}, Goods.TYPE_CHARGE)

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE_CLICK, var0_1)
	print("=================ChargeCommand test======================")
	print(tostring(PLATFORM))
	pg.ConnectionMgr.GetInstance():Send(11501, {
		shop_id = var0_1,
		device = PLATFORM
	}, 11502, function(arg0_2)
		if arg0_2.result == 0 then
			if var1_1.tradeNoPrev ~= arg0_2.pay_id then
				if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and pg.SdkMgr.GetInstance():GetIsPlatform() then
					if pg.SdkMgr.GetInstance():CheckAudit() then
						originalPrint("serverTag:audit 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4_1:getConfig("airijp_id"), "audit", arg0_2.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckPreAudit() then
						originalPrint("serverTag:preAudit 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4_1:getConfig("airijp_id"), "preAudit", arg0_2.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckPretest() then
						originalPrint("serverTag:preTest 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4_1:getConfig("airijp_id"), "preAudit", arg0_2.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckGoogleSimulator() then
						originalPrint("serverTag:test 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4_1:getConfig("airijp_id"), "test", arg0_2.pay_id)
					else
						originalPrint("serverTag:production 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4_1:getConfig("airijp_id"), "production", arg0_2.pay_id)
					end

					originalPrint("请求购买的airijp_id为：" .. var4_1:getConfig("airijp_id"))
					originalPrint("请求购买的id为：" .. arg0_2.pay_id)
				else
					local var0_2 = var4_1:firstPayDouble() and var3_1
					local var1_2 = getProxy(PlayerProxy):getData()
					local var2_2 = var4_1:RawGetConfig("money") * 100
					local var3_2 = var4_1:getConfig("name")

					if PLATFORM_CODE == PLATFORM_CH and pg.SdkMgr.GetInstance():GetChannelUID() == "21" and var0_1 == 1001 then
						var3_2 = "特许巡游凭证(202111)"
					end

					local var4_2 = 0

					if var0_2 then
						var4_2 = var4_1:getConfig("gem") * 2
					else
						var4_2 = var4_1:getConfig("gem") + var4_1:getConfig("extra_gem")
					end

					local var5_2 = arg0_2.pay_id
					local var6_2 = var4_1:getConfig("subject")
					local var7_2 = "-" .. var1_2.id .. "-" .. var5_2
					local var8_2 = arg0_2.url or ""
					local var9_2 = arg0_2.order_sign or ""

					pg.SdkMgr.GetInstance():SdkPay(var4_1:getConfig("id_str"), var2_2, var3_2, var4_2, var5_2, var6_2, var7_2, var1_2.name, var8_2, var9_2)
				end

				var1_1.tradeNoPrev = arg0_2.pay_id

				pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE, var0_1)
				getProxy(ShopsProxy):addWaitTimer()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("charge_trade_no_error"))
			end
		elseif arg0_2.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("charge_error_count_limit"))
		elseif arg0_2.result == 5002 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("charge_error_disable"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("charge", arg0_2.result))
		end
	end)
end

return var0_0
