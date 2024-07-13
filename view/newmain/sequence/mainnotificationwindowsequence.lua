local var0_0 = class("MainNotificationWindowSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(PlayerProxy):getData()
	local var1_1 = {}

	if #var0_1.buildShipNotification > 0 then
		table.insert(var1_1, function(arg0_2)
			local var0_2 = {}
			local var1_2 = getProxy(BayProxy)

			for iter0_2, iter1_2 in ipairs(getProxy(PlayerProxy):getRawData().buildShipNotification) do
				local var2_2 = var1_2:getShipById(iter1_2.uid)

				if var2_2 then
					var2_2.virgin = iter1_2.new

					table.insert(var0_2, var2_2)
				else
					pg.TipsMgr.GetInstance():ShowTips("without ship data from uid:" .. iter1_2.uid)
				end
			end

			pg.m02:sendNotification(GAME.CONFIRM_GET_SHIP, {
				ships = var0_2,
				callback = arg0_2
			})
		end)
	end

	local var2_1 = {}

	for iter0_1, iter1_1 in ipairs(getProxy(BagProxy):getItemsByType(Item.SKIN_ASSIGNED_TYPE)) do
		local var3_1 = iter1_1:getConfig("usage_arg")[1]

		var2_1[var3_1] = var2_1[var3_1] or {}

		table.insert(var2_1[var3_1], {
			type = DROP_TYPE_ITEM,
			id = iter1_1.id,
			count = iter1_1.count
		})
	end

	for iter2_1, iter3_1 in pairs(var2_1) do
		local var4_1 = getProxy(ActivityProxy):getActivityById(iter2_1)

		if var4_1 and not var4_1:isEnd() then
			local var5_1 = PlayerPrefs.GetInt(string.format("skin_select_item_act_%d_last_time", iter2_1), 3)
			local var6_1 = var4_1.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

			if var5_1 > math.floor(var6_1 / 86400) then
				table.insert(var1_1, function(arg0_3)
					PlayerPrefs.SetInt(string.format("skin_select_item_act_%d_last_time", var4_1.id), math.floor(var6_1 / 86400))
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("skin_exchange_timelimit", pg.TimeMgr.GetInstance():STimeDescS(var4_1.stopTime, "%m.%d")),
						items = iter3_1,
						onYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
								warp = StoreHouseConst.WARP_TO_MATERIAL
							})
						end,
						yesText = i18n("msgbox_text_forward"),
						onNo = arg0_3,
						weight = LayerWeightConst.TOP_LAYER
					})
				end)
			end
		end
	end

	local var7_1 = getProxy(MailProxy)

	if not var7_1.overTip and PlayerPrefs.GetString("mail_msg_tips", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") and var7_1.total > MAIL_COUNT_LIMIT then
		PlayerPrefs.SetString("mail_msg_tips", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
		table.insert(var1_1, function(arg0_5)
			pg.m02:sendNotification(GAME.LOAD_LAYERS, {
				parentContext = getProxy(ContextProxy):getCurrentContext(),
				context = Context.New({
					mediator = MailTipsWindowMediator,
					viewComponent = MailTipsLayer,
					data = {
						onYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAIL)
						end,
						content = i18n("warning_mail_max_3", var7_1.total)
					}
				})
			})
		end)
	end

	var7_1.overTip = true

	seriesAsync(var1_1, arg1_1)
end

return var0_0
