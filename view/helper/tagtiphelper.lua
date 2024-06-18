local var0_0 = class("TagTipHelper")

function var0_0.FuDaiTagTip(arg0_1)
	triggerToggle(arg0_1, false)

	local var0_1 = {}
	local var1_1 = pg.pay_data_display

	for iter0_1, iter1_1 in ipairs(var1_1.all) do
		if var1_1[iter1_1].type == 1 and pg.TimeMgr.GetInstance():inTime(var1_1[iter1_1].time) and type(var1_1[iter1_1].time) == "table" then
			table.insert(var0_1, var1_1[iter1_1])
		end
	end

	if #var0_1 > 0 then
		local function var2_1(arg0_2)
			table.sort(var0_1, function(arg0_3, arg1_3)
				return pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_3.time[1]) > pg.TimeMgr.GetInstance():parseTimeFromConfig(arg1_3.time[1])
			end)

			local var0_2 = var0_1[1]
			local var1_2 = arg0_2[var0_2.id] ~= nil
			local var2_2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_2.time[1])
			local var3_2 = PlayerPrefs.GetInt("Ever_Enter_Mall_", 0)

			if not var1_2 and var3_2 < var2_2 then
				var0_0.FudaiTime = var2_2

				triggerToggle(arg0_1, true)
			end
		end

		local var3_1 = getProxy(ShopsProxy)
		local var4_1 = var3_1:getChargedList()

		if not var4_1 then
			pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
				callback = function()
					var4_1 = var3_1:getChargedList()

					var2_1(var4_1)
				end
			})
		else
			var2_1(var4_1)
		end
	end
end

function var0_0.SetFuDaiTagMark()
	if var0_0.FudaiTime then
		PlayerPrefs.SetInt("Ever_Enter_Mall_", var0_0.FudaiTime)
		PlayerPrefs.Save()

		var0_0.FudaiTime = nil
	end
end

function var0_0.SkinTagTip(arg0_6)
	triggerToggle(arg0_6, false)

	local var0_6 = getProxy(ShipSkinProxy):GetAllSkins()
	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(var0_6) do
		if iter1_6.type == Goods.TYPE_SKIN and type(iter1_6:getConfig("time")) == "table" and iter1_6.genre ~= ShopArgs.SkinShopTimeLimit then
			table.insert(var1_6, pg.TimeMgr.GetInstance():parseTimeFromConfig(iter1_6:getConfig("time")[1]))
		end
	end

	if #var1_6 > 0 then
		table.sort(var1_6, function(arg0_7, arg1_7)
			return arg1_7 < arg0_7
		end)

		local var2_6 = var1_6[1]
		local var3_6 = var2_6 > PlayerPrefs.GetInt("Ever_Enter_Skin_Shop_", 0)

		if var3_6 then
			var0_0.SkinTime = var2_6
		end

		triggerToggle(arg0_6, var3_6)
	end
end

function var0_0.SetSkinTagMark()
	if var0_0.SkinTime then
		PlayerPrefs.SetInt("Ever_Enter_Skin_Shop_", var0_0.SkinTime)
		PlayerPrefs.Save()

		var0_0.SkinTime = nil
	end
end

function var0_0.MonthCardTagTip(arg0_9)
	local var0_9 = MonthCardOutDateTipPanel.GetShowMonthCardTag()

	triggerToggle(arg0_9, var0_9)
end

function var0_0.FreeGiftTag(arg0_10)
	local var0_10 = getProxy(ShopsProxy)

	if not var0_10:getChargedList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = function()
				if _.all(arg0_10, function(arg0_12)
					return not IsNil(arg0_12)
				end) then
					for iter0_11, iter1_11 in ipairs(arg0_10) do
						setActive(iter1_11, var0_10:checkHasFreeNormal())
					end
				end
			end
		})
	else
		for iter0_10, iter1_10 in ipairs(arg0_10) do
			setActive(iter1_10, var0_10:checkHasFreeNormal())
		end
	end
end

function var0_0.FreeBuildTicketTip(arg0_13, arg1_13)
	local var0_13 = getProxy(ActivityProxy):IsShowFreeBuildMark(false)

	if var0_13 then
		setActive(arg0_13, true)
		LoadImageSpriteAtlasAsync(Drop.New({
			type = DROP_TYPE_VITEM,
			id = var0_13:getConfig("config_client")[1]
		}):getIcon(), "", arg0_13:Find("Image"))

		local var1_13 = tostring(var0_13.data1)

		if var0_13.data1 < 10 then
			var1_13 = var1_13 .. " "
		end

		setText(arg0_13:Find("Text"), i18n("build_ticket_expire_warning", var1_13))

		var0_0.BuildMark = true
	else
		setActive(arg0_13, false)
	end
end

function var0_0.TecShipGiftTip(arg0_14)
	local var0_14 = {
		2001,
		2002,
		2003,
		2004,
		2005,
		2006,
		2007,
		2008
	}
	local var1_14 = 30 <= getProxy(PlayerProxy):getData().level
	local var2_14 = PlayerPrefs.GetInt("Tec_Ship_Gift_Enter_Tag", 0) > 0
	local var3_14 = false

	for iter0_14, iter1_14 in ipairs(pg.pay_data_display.all) do
		if table.contains(var0_14, iter1_14) then
			var3_14 = true

			break
		end
	end

	if var3_14 and var1_14 and not var2_14 then
		triggerToggle(arg0_14, true)
	else
		triggerToggle(arg0_14, false)
	end
end

function var0_0.SetFreeBuildMark()
	if var0_0.BuildMark then
		local var0_15 = getProxy(ActivityProxy):IsShowFreeBuildMark(false)

		if var0_15 then
			PlayerPrefs.SetString("Free_Build_Ticket_" .. var0_15.id, pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
			PlayerPrefs.Save()
		end

		var0_0.BuildMark = nil
	end
end

return var0_0
