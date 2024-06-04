local var0 = class("TagTipHelper")

function var0.FuDaiTagTip(arg0)
	triggerToggle(arg0, false)

	local var0 = {}
	local var1 = pg.pay_data_display

	for iter0, iter1 in ipairs(var1.all) do
		if var1[iter1].type == 1 and pg.TimeMgr.GetInstance():inTime(var1[iter1].time) and type(var1[iter1].time) == "table" then
			table.insert(var0, var1[iter1])
		end
	end

	if #var0 > 0 then
		local function var2(arg0)
			table.sort(var0, function(arg0, arg1)
				return pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0.time[1]) > pg.TimeMgr.GetInstance():parseTimeFromConfig(arg1.time[1])
			end)

			local var0 = var0[1]
			local var1 = arg0[var0.id] ~= nil
			local var2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.time[1])
			local var3 = PlayerPrefs.GetInt("Ever_Enter_Mall_", 0)

			if not var1 and var3 < var2 then
				var0.FudaiTime = var2

				triggerToggle(arg0, true)
			end
		end

		local var3 = getProxy(ShopsProxy)
		local var4 = var3:getChargedList()

		if not var4 then
			pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
				callback = function()
					var4 = var3:getChargedList()

					var2(var4)
				end
			})
		else
			var2(var4)
		end
	end
end

function var0.SetFuDaiTagMark()
	if var0.FudaiTime then
		PlayerPrefs.SetInt("Ever_Enter_Mall_", var0.FudaiTime)
		PlayerPrefs.Save()

		var0.FudaiTime = nil
	end
end

function var0.SkinTagTip(arg0)
	triggerToggle(arg0, false)

	local var0 = getProxy(ShipSkinProxy):GetAllSkins()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		if iter1.type == Goods.TYPE_SKIN and type(iter1:getConfig("time")) == "table" and iter1.genre ~= ShopArgs.SkinShopTimeLimit then
			table.insert(var1, pg.TimeMgr.GetInstance():parseTimeFromConfig(iter1:getConfig("time")[1]))
		end
	end

	if #var1 > 0 then
		table.sort(var1, function(arg0, arg1)
			return arg1 < arg0
		end)

		local var2 = var1[1]
		local var3 = var2 > PlayerPrefs.GetInt("Ever_Enter_Skin_Shop_", 0)

		if var3 then
			var0.SkinTime = var2
		end

		triggerToggle(arg0, var3)
	end
end

function var0.SetSkinTagMark()
	if var0.SkinTime then
		PlayerPrefs.SetInt("Ever_Enter_Skin_Shop_", var0.SkinTime)
		PlayerPrefs.Save()

		var0.SkinTime = nil
	end
end

function var0.MonthCardTagTip(arg0)
	local var0 = MonthCardOutDateTipPanel.GetShowMonthCardTag()

	triggerToggle(arg0, var0)
end

function var0.FreeGiftTag(arg0)
	local var0 = getProxy(ShopsProxy)

	if not var0:getChargedList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = function()
				if _.all(arg0, function(arg0)
					return not IsNil(arg0)
				end) then
					for iter0, iter1 in ipairs(arg0) do
						setActive(iter1, var0:checkHasFreeNormal())
					end
				end
			end
		})
	else
		for iter0, iter1 in ipairs(arg0) do
			setActive(iter1, var0:checkHasFreeNormal())
		end
	end
end

function var0.FreeBuildTicketTip(arg0, arg1)
	local var0 = getProxy(ActivityProxy):IsShowFreeBuildMark(false)

	if var0 then
		setActive(arg0, true)
		LoadImageSpriteAtlasAsync(Drop.New({
			type = DROP_TYPE_VITEM,
			id = var0:getConfig("config_client")[1]
		}):getIcon(), "", arg0:Find("Image"))

		local var1 = tostring(var0.data1)

		if var0.data1 < 10 then
			var1 = var1 .. " "
		end

		setText(arg0:Find("Text"), i18n("build_ticket_expire_warning", var1))

		var0.BuildMark = true
	else
		setActive(arg0, false)
	end
end

function var0.TecShipGiftTip(arg0)
	local var0 = {
		2001,
		2002,
		2003,
		2004,
		2005,
		2006,
		2007,
		2008
	}
	local var1 = 30 <= getProxy(PlayerProxy):getData().level
	local var2 = PlayerPrefs.GetInt("Tec_Ship_Gift_Enter_Tag", 0) > 0
	local var3 = false

	for iter0, iter1 in ipairs(pg.pay_data_display.all) do
		if table.contains(var0, iter1) then
			var3 = true

			break
		end
	end

	if var3 and var1 and not var2 then
		triggerToggle(arg0, true)
	else
		triggerToggle(arg0, false)
	end
end

function var0.SetFreeBuildMark()
	if var0.BuildMark then
		local var0 = getProxy(ActivityProxy):IsShowFreeBuildMark(false)

		if var0 then
			PlayerPrefs.SetString("Free_Build_Ticket_" .. var0.id, pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
			PlayerPrefs.Save()
		end

		var0.BuildMark = nil
	end
end

return var0
