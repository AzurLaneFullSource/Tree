local var0 = class("RefundChargeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	if (PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP) and not pg.SdkMgr.GetInstance():CheckAiriCanBuy() then
		print("wait for a second, Do not click quickly~")

		return
	end

	local var0 = arg1:getBody().shopId
	local var1 = getProxy(ShopsProxy)
	local var2 = var1:getFirstChargeList() or {}

	if not var0 then
		return
	end

	local var3 = not table.contains(var2, var0)
	local var4 = Goods.Create({
		shop_id = var0
	}, Goods.TYPE_CHARGE)

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE_CLICK, var0)
	pg.ConnectionMgr.GetInstance():Send(11513, {
		shop_id = var0,
		device = PLATFORM
	}, 11514, function(arg0)
		if arg0.result == 0 then
			if var1.tradeNoPrev ~= arg0.pay_id then
				if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and pg.SdkMgr.GetInstance():GetIsPlatform() then
					if pg.SdkMgr.GetInstance():CheckAudit() then
						originalPrint("serverTag:audit 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4:getConfig("airijp_id"), "audit", arg0.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckPreAudit() then
						originalPrint("serverTag:preAudit 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4:getConfig("airijp_id"), "preAudit", arg0.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckPretest() then
						originalPrint("serverTag:preTest 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4:getConfig("airijp_id"), "preAudit", arg0.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckGoogleSimulator() then
						originalPrint("serverTag:test 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4:getConfig("airijp_id"), "test", arg0.pay_id)
					else
						originalPrint("serverTag:production 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(var4:getConfig("airijp_id"), "production", arg0.pay_id)
					end

					originalPrint("请求购买的airijp_id为：" .. var4:getConfig("airijp_id"))
					originalPrint("请求购买的id为：" .. arg0.pay_id)
				else
					local var0 = var4:firstPayDouble() and var3
					local var1 = getProxy(PlayerProxy):getData()
					local var2 = var4:getConfig("money") * 100
					local var3 = var4:getConfig("name")
					local var4 = 0

					if var0 then
						var4 = var4:getConfig("gem") * 2
					else
						var4 = var4:getConfig("gem") + var4:getConfig("extra_gem")
					end

					local var5 = arg0.pay_id
					local var6 = var4:getConfig("subject")
					local var7 = "-" .. var1.id .. "-" .. var5
					local var8 = arg0.url or ""
					local var9 = arg0.order_sign or ""

					pg.SdkMgr.GetInstance():SdkPay(var4:getConfig("id_str"), var2, var3, var4, var5, var6, var7, var1.name, var8, var9)
				end

				var1.tradeNoPrev = arg0.pay_id

				pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE, var0)
				getProxy(ShopsProxy):addWaitTimer()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("charge_trade_no_error"))
			end
		elseif arg0.result == 6 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("charge", arg0.result))
		end
	end)
end

return var0
