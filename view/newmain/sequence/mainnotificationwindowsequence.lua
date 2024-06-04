local var0 = class("MainNotificationWindowSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = {}

	if #var0.buildShipNotification > 0 then
		table.insert(var1, function(arg0)
			local var0 = {}
			local var1 = getProxy(BayProxy)

			for iter0, iter1 in ipairs(getProxy(PlayerProxy):getRawData().buildShipNotification) do
				local var2 = var1:getShipById(iter1.uid)

				if var2 then
					var2.virgin = iter1.new

					table.insert(var0, var2)
				else
					pg.TipsMgr.GetInstance():ShowTips("without ship data from uid:" .. iter1.uid)
				end
			end

			pg.m02:sendNotification(GAME.CONFIRM_GET_SHIP, {
				ships = var0,
				callback = arg0
			})
		end)
	end

	local var2 = {}

	for iter0, iter1 in ipairs(getProxy(BagProxy):getItemsByType(Item.SKIN_ASSIGNED_TYPE)) do
		local var3 = iter1:getConfig("usage_arg")[1]

		var2[var3] = var2[var3] or {}

		table.insert(var2[var3], {
			type = DROP_TYPE_ITEM,
			id = iter1.id,
			count = iter1.count
		})
	end

	for iter2, iter3 in pairs(var2) do
		local var4 = getProxy(ActivityProxy):getActivityById(iter2)

		if var4 and not var4:isEnd() then
			local var5 = PlayerPrefs.GetInt(string.format("skin_select_item_act_%d_last_time", iter2), 3)
			local var6 = var4.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

			if var5 > math.floor(var6 / 86400) then
				table.insert(var1, function(arg0)
					PlayerPrefs.SetInt(string.format("skin_select_item_act_%d_last_time", var4.id), math.floor(var6 / 86400))
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("skin_exchange_timelimit", pg.TimeMgr.GetInstance():STimeDescS(var4.stopTime, "%m.%d")),
						items = iter3,
						onYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
								warp = StoreHouseConst.WARP_TO_MATERIAL
							})
						end,
						yesText = i18n("msgbox_text_forward"),
						onNo = arg0,
						weight = LayerWeightConst.TOP_LAYER
					})
				end)
			end
		end
	end

	local var7 = getProxy(MailProxy)

	if not var7.overTip and PlayerPrefs.GetString("mail_msg_tips", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") and var7.total > MAIL_COUNT_LIMIT then
		PlayerPrefs.SetString("mail_msg_tips", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
		table.insert(var1, function(arg0)
			pg.m02:sendNotification(GAME.LOAD_LAYERS, {
				parentContext = getProxy(ContextProxy):getCurrentContext(),
				context = Context.New({
					mediator = MailTipsWindowMediator,
					viewComponent = MailTipsLayer,
					data = {
						onYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAIL)
						end,
						content = i18n("warning_mail_max_3", var7.total)
					}
				})
			})
		end)
	end

	var7.overTip = true

	seriesAsync(var1, arg1)
end

return var0
