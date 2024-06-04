local var0 = class("BackYardShipCard", import(".BackYardBaseCard"))

function var0.OnInit(arg0)
	arg0.info = BackYardFormationCard.New(arg0._go)

	onButton(arg0, arg0._content, function()
		arg0:emit(NewBackYardShipInfoMediator.OPEN_CHUANWU, arg0.type, arg0.ship)
	end, SFX_PANEL)

	arg0.press = GetOrAddComponent(arg0._content, typeof(UILongPressTrigger))

	arg0.press.onLongPressed:RemoveAllListeners()
	arg0.press.onLongPressed:AddListener(function()
		if not arg0.ship then
			return
		end

		arg0:emit(NewBackYardShipInfoMediator.LOOG_PRESS_SHIP, arg0.type, arg0.ship)
	end)
end

function var0.OnFlush(arg0)
	local var0 = arg0.ship
	local var1 = arg0.info

	if not arg0.targteShipId or arg0.targteShipId ~= var0.id then
		var1:update(var0)

		arg0.targteShipId = var0.id
	end

	local var2 = var0:getLevelExpConfig()
	local var3 = arg0:CalcShipAddExpSpeed()
	local var4 = {}
	local var5 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	table.Foreach(var5, function(arg0, arg1)
		if arg1 and not arg1:isEnd() then
			local var0 = arg1:getConfig("config_data")[1][4]

			_.each(arg1:getData1List(), function(arg0)
				var4[arg0] = (var4[arg0] or 0) + var0
			end)
		end
	end)

	local var6 = 0
	local var7 = 0

	for iter0, iter1 in ipairs(getProxy(ActivityProxy):getBackyardEnergyActivityBuffs()) do
		var7 = var7 + tonumber(iter1:getConfig("benefit_effect"))
	end

	if arg0.type == Ship.STATE_TRAIN then
		local var8 = var0:getRecoverEnergyPoint() + Ship.BACKYARD_1F_ENERGY_ADDITION + (var4[var0.id] or 0)

		var1:updateProps({
			{
				i18n("word_lv"),
				var0.level
			},
			{
				i18n("word_next_level"),
				math.max(var2.exp - var0.exp, 0)
			},
			{
				i18n("word_exp_chinese") .. i18n("word_get"),
				var3
			},
			{
				i18n("word_nowenergy"),
				var0.energy
			},
			{
				i18n("word_energy_recov_speed"),
				10 * var8 .. (var7 > 0 and setColorStr("+" .. 10 * var7, COLOR_GREEN) or "") .. "/h"
			}
		})
	elseif arg0.type == Ship.STATE_REST then
		local var9 = var0:getRecoverEnergyPoint() + Ship.BACKYARD_2F_ENERGY_ADDITION + (var4[var0.id] or 0)

		var1:updateProps1({
			{
				i18n("word_lv"),
				var0.level
			},
			{
				i18n("word_nowenergy"),
				var0.energy
			},
			{
				i18n("word_energy_recov_speed"),
				10 * var9 .. (var7 > 0 and setColorStr("+" .. 10 * var7, COLOR_GREEN) or "") .. "/h"
			}
		})
	end

	setActive(var1.propsTr, arg0.type == Ship.STATE_TRAIN)
	setActive(var1.propsTr1, arg0.type == Ship.STATE_REST)
end

function var0.CalcShipAddExpSpeed(arg0)
	local var0 = 0
	local var1 = getProxy(DormProxy):getRawData()
	local var2 = arg0:GetBaseExp(var1)

	return (math.floor(var2 * 3600 / pg.dorm_data_template[var1.id].time))
end

function var0.GetBaseExp(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = arg1:GetStateShipCnt(Ship.STATE_TRAIN)

	if var1 <= 0 then
		return 0
	end

	local var2 = pg.dorm_data_template[arg1.id]
	local var3 = BuffHelper.GetBackYardExpBuffs()
	local var4 = 1

	for iter0, iter1 in pairs(var3) do
		if iter1:isActivate() then
			local var5 = iter1:getConfig("benefit_effect")

			var4 = tonumber(var5) / 100 + var4
		end
	end

	local var6 = pg.gameset.dorm_exp_base.key_value
	local var7 = pg.gameset.dorm_exp_ratio_comfort_degree.key_value
	local var8 = pg.gameset["dorm_exp_ratio_by_" .. var1].key_value / 100
	local var9 = arg1:getComfortable()

	return var8 * (var6 + var2.exp * (var9 / (var9 + var7))) * var4 * (1 + 0.05 * var0.level)
end

function var0.OnDispose(arg0)
	arg0.press.onLongPressed:RemoveAllListeners()
	arg0.press.onLongPressed:AddListener(nil)

	if arg0.info then
		arg0.info:clear()
	end
end

return var0
